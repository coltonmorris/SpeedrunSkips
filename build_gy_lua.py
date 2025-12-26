#!/usr/bin/env python3
"""
Build Lua graveyard lookup data from:
  1) MaNGOS game_graveyard_zone SQL dump
  2) WorldSafeLocs CSV
  3) AreaTable CSV (exact header provided)

Output Lua:
  - SAFELOC[id] = {map, x, y, z, name}
  - PARENT[areaID] = parentAreaID
  - ZONENAME[areaID] = "ZoneName"
  - AREANAME[areaID] = "AreaName_lang"
  - GY_BY_ZONE[ghost_zone] = { {id=..., f=..., pmin=..., pmax=...}, ... }

Usage:
  python build_gy_lua.py \
    --gy-sql game_graveyard_zone.sql \
    --safelocs WorldSafeLocs.csv \
    --areatable AreaTable.csv \
    --out graveyard_data.lua
"""

from __future__ import annotations

import argparse
import csv
import re
from pathlib import Path
from typing import Any, Dict, List, Tuple


# ----------------------------
# Helpers
# ----------------------------

def lua_escape(s: str) -> str:
    return s.replace("\\", "\\\\").replace('"', '\\"')

def try_int(s: str, default: int = 0) -> int:
    try:
        return int(str(s).strip())
    except Exception:
        return default

def try_float(s: str, default: float = 0.0) -> float:
    try:
        return float(str(s).strip())
    except Exception:
        return default

def read_text(path: Path) -> str:
    return path.read_text(encoding="utf-8", errors="ignore")


# ----------------------------
# Parse game_graveyard_zone SQL
# ----------------------------

GY_TUPLE_RE = re.compile(r"\(([^()]+)\)")

def parse_gy_sql(sql_path: Path) -> List[Tuple[int, int, int, int, int]]:
    """
    Returns list of (id, ghost_zone, faction, patch_min, patch_max)
    Parses INSERT, UPDATE, and DELETE statements to build final state
    """
    txt = read_text(sql_path)

    # First pass: collect all INSERT statements (handle multi-line)
    inserts = []
    lines = txt.splitlines()
    i = 0
    while i < len(lines):
        line = lines[i]
        if "INSERT INTO" in line and "game_graveyard_zone" in line:
            # Collect the INSERT statement (may span multiple lines)
            insert_chunk = [line]
            i += 1
            # Continue until we hit a semicolon or next SQL statement
            while i < len(lines):
                next_line = lines[i]
                # Stop at semicolon (end of statement)
                if next_line.strip().endswith(";"):
                    insert_chunk.append(next_line)
                    i += 1
                    break
                # Stop at next SQL statement (but not comments)
                if not next_line.strip().startswith("--") and \
                   (("INSERT INTO" in next_line and "game_graveyard_zone" in next_line) or
                    "UPDATE" in next_line or "DELETE" in next_line or "ALTER" in next_line):
                    break
                insert_chunk.append(next_line)
                i += 1
            inserts.append("\n".join(insert_chunk))
        else:
            i += 1

    # Build initial data from INSERTs
    tuples_dict: Dict[Tuple[int, int], Tuple[int, int, int]] = {}  # (id, ghost_zone) -> (faction, patch_min, patch_max)
    
    for chunk in inserts:
        for m in GY_TUPLE_RE.finditer(chunk):
            raw = m.group(1)
            parts = [p.strip() for p in raw.split(",")]
            if len(parts) < 4:
                continue
            gid = try_int(parts[0])
            ghost_zone = try_int(parts[1])
            faction = try_int(parts[2])
            patch_min = try_int(parts[3])
            # Handle both 4-column (build_min) and 5-column (patch_min, patch_max) formats
            if len(parts) >= 5:
                patch_max = try_int(parts[4])
            else:
                # Default patch_max to 15 for Classic Era if not specified
                patch_max = 15
            # If entry already exists (from a previous INSERT), overwrite it
            # Later INSERTs take precedence over earlier ones
            tuples_dict[(gid, ghost_zone)] = (faction, patch_min, patch_max)

    # Second pass: apply UPDATE statements
    # Pattern: UPDATE `game_graveyard_zone` SET `field`=value WHERE `id`=X AND `ghost_zone`=Y
    # Note: Need to handle WHERE clauses that might have additional conditions
    update_pattern = re.compile(
        r"UPDATE\s+`?game_graveyard_zone`?\s+SET\s+(.+?)\s+WHERE\s+`?id`?\s*=\s*(\d+)\s+AND\s+`?ghost_zone`?\s*=\s*(\d+)",
        re.IGNORECASE
    )
    
    for line in txt.splitlines():
        m = update_pattern.search(line)
        if m:
            set_clause = m.group(1).strip()
            gid = try_int(m.group(2))
            old_ghost_zone = try_int(m.group(3))
            key = (gid, old_ghost_zone)
            
            if key in tuples_dict:
                faction, patch_min, patch_max = tuples_dict[key]
                
                # Parse SET clause: `field`=value or field=value
                # Handle ghost_zone changes (moves entry to new zone)
                ghost_zone_match = re.search(r"`?ghost_zone`?\s*=\s*(\d+)", set_clause, re.IGNORECASE)
                if ghost_zone_match:
                    new_ghost_zone = try_int(ghost_zone_match.group(1))
                    # Move entry to new zone
                    tuples_dict[(gid, new_ghost_zone)] = tuples_dict.pop(key)
                    key = (gid, new_ghost_zone)
                    faction, patch_min, patch_max = tuples_dict[key]
                
                # Update other fields (only update if specified in SET clause)
                # Check each field separately to avoid partial matches
                if "faction" in set_clause.lower():
                    faction_match = re.search(r"`?faction`?\s*=\s*['\"]?(\d+)['\"]?", set_clause, re.IGNORECASE)
                    if faction_match:
                        faction = try_int(faction_match.group(1))
                
                if "patch_min" in set_clause.lower():
                    patch_min_match = re.search(r"`?patch_min`?\s*=\s*['\"]?(\d+)['\"]?", set_clause, re.IGNORECASE)
                    if patch_min_match:
                        patch_min = try_int(patch_min_match.group(1))
                
                if "patch_max" in set_clause.lower():
                    patch_max_match = re.search(r"`?patch_max`?\s*=\s*['\"]?(\d+)['\"]?", set_clause, re.IGNORECASE)
                    if patch_max_match:
                        patch_max = try_int(patch_max_match.group(1))
                
                tuples_dict[key] = (faction, patch_min, patch_max)
            else:
                # Entry doesn't exist yet - might be created by a later INSERT
                # For now, skip (we'll handle this if needed)
                pass

    # Third pass: apply DELETE statements
    delete_pattern = re.compile(
        r"DELETE\s+FROM\s+`?game_graveyard_zone`?\s+WHERE\s+`?id`?\s*=\s*(\d+)\s+AND\s+`?ghost_zone`?\s*=\s*(\d+)",
        re.IGNORECASE
    )
    
    for line in txt.splitlines():
        m = delete_pattern.search(line)
        if m:
            gid = try_int(m.group(1))
            ghost_zone = try_int(m.group(2))
            key = (gid, ghost_zone)
            if key in tuples_dict:
                del tuples_dict[key]

    # Convert to list of tuples and validate
    tuples = []
    for (gid, ghost_zone), (faction, patch_min, patch_max) in tuples_dict.items():
        # Validate and fix patch range
        if patch_min > patch_max:
            print(f"Warning: Invalid patch range for graveyard {gid} in zone {ghost_zone}: pmin={patch_min}, pmax={patch_max}. Fixing by setting pmax={patch_min}.")
            # If pmin > pmax, this is invalid. Set pmax to at least pmin (or use a reasonable default)
            # For Classic Era, if pmax < pmin, assume pmax should be 15 (current patch)
            patch_max = max(patch_min, 15)
        tuples.append((gid, ghost_zone, faction, patch_min, patch_max))

    return sorted(set(tuples))


# ----------------------------
# Parse WorldSafeLocs CSV
# ----------------------------

def parse_safelocs_csv(csv_path: Path) -> Dict[int, Dict[str, Any]]:
    """
    Expected columns like your sample:
      "ID","Continent","LocationX","LocationY","LocationZ","AreaName_enUS",...

    Returns:
      { id: {map,x,y,z,name} }
    """
    with csv_path.open("r", encoding="utf-8", newline="") as f:
        r = csv.DictReader(f)
        safelocs: Dict[int, Dict[str, Any]] = {}

        for row in r:
            sid = try_int(row.get("ID", "0"))
            if sid == 0:
                continue

            cont = try_int(row.get("Continent", "-1"), default=-1)
            x = try_float(row.get("LocationX", "0"), 0.0)
            y = try_float(row.get("LocationY", "0"), 0.0)
            z = try_float(row.get("LocationZ", "0"), 0.0)

            name = row.get("AreaName_enUS") or row.get("AreaName_enGB") or ""
            safelocs[sid] = {"map": cont, "x": x, "y": y, "z": z, "name": name}

        return safelocs


# ----------------------------
# Parse AreaTable CSV (exact header)
# ----------------------------

def parse_areatable_csv(csv_path: Path) -> Tuple[Dict[int, int], Dict[int, str], Dict[int, str]]:
    """
    Header:
      ID,ZoneName,AreaName_lang,ContinentID,ParentAreaID,...

    Returns:
      parent_map: { areaID: parentAreaID }
      zonename_map: { areaID: ZoneName }
      areaname_map: { areaID: AreaName_lang }
    """
    with csv_path.open("r", encoding="utf-8", newline="") as f:
        r = csv.DictReader(f)

        parent_map: Dict[int, int] = {}
        zonename_map: Dict[int, str] = {}
        areaname_map: Dict[int, str] = {}

        for row in r:
            aid = try_int(row.get("ID", "0"))
            if aid == 0:
                continue

            parent_map[aid] = try_int(row.get("ParentAreaID", "0"), 0)

            zn = (row.get("ZoneName") or "").strip()
            an = (row.get("AreaName_lang") or "").strip()

            if zn:
                zonename_map[aid] = zn
            if an:
                areaname_map[aid] = an

        return parent_map, zonename_map, areaname_map


# ----------------------------
# Build GyByZone structure
# ----------------------------

def build_gy_by_zone(rows: List[Tuple[int, int, int, int, int]]) -> Dict[int, List[Dict[str, int]]]:
    out: Dict[int, List[Dict[str, int]]] = {}
    for gid, ghost_zone, faction, pmin, pmax in rows:
        out.setdefault(ghost_zone, []).append({"id": gid, "f": faction, "pmin": pmin, "pmax": pmax})
    for gz in out:
        out[gz].sort(key=lambda e: (e["pmin"], e["pmax"], e["f"], e["id"]))
    return out


# ----------------------------
# Write Lua
# ----------------------------

def write_lua(
    out_path: Path,
    gy_by_zone: Dict[int, List[Dict[str, int]]],
    safelocs: Dict[int, Dict[str, Any]],
    parent_map: Dict[int, int],
    zonename_map: Dict[int, str],
    areaname_map: Dict[int, str],
) -> None:
    with out_path.open("w", encoding="utf-8", newline="\n") as f:
        f.write("-- Auto-generated graveyard data\n")
        f.write("-- SAFELOC[id] = {map, x, y, z, name}\n")
        f.write("-- PARENT[areaID] = parentAreaID\n")
        f.write("-- ZONENAME[areaID] = \"ZoneName\"\n")
        f.write("-- AREANAME[areaID] = \"AreaName_lang\"\n")
        f.write("-- GY_BY_ZONE[ghost_zone] = { {id=, f=, pmin=, pmax=}, ... }\n\n")
        f.write("local _, addon = ...\n\n")

        f.write("addon.GraveyardData = {}\n\n")

        f.write("addon.GraveyardData.SAFELOC = {\n")
        for sid in sorted(safelocs.keys()):
            sl = safelocs[sid]
            name = lua_escape(str(sl.get("name", "")))
            f.write(
                f'  [{sid}] = {{{int(sl.get("map", -1))}, {sl.get("x", 0.0):.6f}, {sl.get("y", 0.0):.6f}, {sl.get("z", 0.0):.6f}, "{name}"}},\n'
            )
        f.write("}\n\n")

        f.write("addon.GraveyardData.PARENT = {\n")
        for aid in sorted(parent_map.keys()):
            f.write(f"  [{aid}] = {parent_map[aid]},\n")
        f.write("}\n\n")

        f.write("addon.GraveyardData.ZONENAME = {\n")
        for aid in sorted(zonename_map.keys()):
            f.write(f'  [{aid}] = "{lua_escape(zonename_map[aid])}",\n')
        f.write("}\n\n")

        f.write("addon.GraveyardData.AREANAME = {\n")
        for aid in sorted(areaname_map.keys()):
            f.write(f'  [{aid}] = "{lua_escape(areaname_map[aid])}",\n')
        f.write("}\n\n")

        f.write("addon.GraveyardData.GY_BY_ZONE = {\n")
        for gz in sorted(gy_by_zone.keys()):
            f.write(f"  [{gz}] = {{\n")
            for e in gy_by_zone[gz]:
                f.write(f"    {{id={e['id']}, f={e['f']}, pmin={e['pmin']}, pmax={e['pmax']}}},\n")
            f.write("  },\n")
        f.write("}\n")


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--gy-sql", required=True, help="Path to game_graveyard_zone.sql dump")
    ap.add_argument("--safelocs", required=True, help="Path to WorldSafeLocs.csv")
    ap.add_argument("--areatable", required=True, help="Path to AreaTable.csv")
    ap.add_argument("--out", required=True, help="Output Lua file path (relative to Data/ directory)")
    args = ap.parse_args()

    gy_rows = parse_gy_sql(Path(args.gy_sql))
    safelocs = parse_safelocs_csv(Path(args.safelocs))
    parent_map, zonename_map, areaname_map = parse_areatable_csv(Path(args.areatable))
    gy_by_zone = build_gy_by_zone(gy_rows)

    # Resolve output path relative to Data/ directory
    script_dir = Path(__file__).parent
    data_dir = script_dir / "Data"
    out_path = data_dir / args.out if not Path(args.out).is_absolute() else Path(args.out)

    # Ensure Data directory exists
    out_path.parent.mkdir(parents=True, exist_ok=True)

    write_lua(out_path, gy_by_zone, safelocs, parent_map, zonename_map, areaname_map)

    print(f"Wrote: {out_path}")
    print(f"  graveyard_zone rows: {len(gy_rows)}")
    print(f"  unique ghost_zones:  {len(gy_by_zone)}")
    print(f"  safe locs:           {len(safelocs)}")
    print(f"  area parents:        {len(parent_map)}")
    print(f"  zone names:          {len(zonename_map)}")
    print(f"  area names:          {len(areaname_map)}")


if __name__ == "__main__":
    main()
