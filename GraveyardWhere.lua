-- GraveyardWhere.lua
-- Predicts spirit healer graveyard from AreaID + graveyard_zone + WorldSafeLocs

local ADDON_NAME, addon = ...
-- In WoW addons, 'addon' is passed as the second parameter and is shared across all files
-- If it doesn't exist yet (first file), create it
if not addon then
  addon = {}
end
_G[ADDON_NAME] = addon

-- Initialize tile grids storage (must be done before Data files load)
addon.tileGrids = addon.tileGrids or {}
addon._tileCache = addon._tileCache or {}

-- ----------------------------
-- Register tile grids (called by Data files)
-- ----------------------------
function addon:RegisterTileGrid(name, grid)
  if not self.tileGrids then
    self.tileGrids = {}
  end
  self.tileGrids[name] = grid
  local count = 0
  if grid.tiles then for _ in pairs(grid.tiles) do count = count + 1 end end
  print(ADDON_NAME .. ": Registered tile grid " .. name .. " (" .. count .. " tiles)")
end

-- ----------------------------
-- Base64 decoder (from ZoneMap.lua)
-- ----------------------------
local _b64vals = {}
do
  local alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
  for i = 1, #alphabet do
    _b64vals[alphabet:byte(i)] = i - 1
  end
  _b64vals[string.byte("-")] = _b64vals[string.byte("+")]
  _b64vals[string.byte("_")] = _b64vals[string.byte("/")]
end

local function base64_decode(s)
  if not s then return nil end
  s = s:gsub("%s+", "")
  local out = {}
  local i, len = 1, #s
  while i <= len do
    local c1, c2, c3, c4 = s:byte(i, i + 3)
    i = i + 4
    if not c1 or not c2 then break end
    local v1, v2 = _b64vals[c1], _b64vals[c2]
    if v1 == nil or v2 == nil then return nil end
    local pad3 = (c3 == 61) or (c3 == nil)
    local pad4 = (c4 == 61) or (c4 == nil)
    local v3 = pad3 and 0 or _b64vals[c3]
    local v4 = pad4 and 0 or _b64vals[c4]
    if (not pad3 and v3 == nil) or (not pad4 and v4 == nil) then return nil end
    local n = v1 * 262144 + v2 * 4096 + v3 * 64 + v4
    out[#out + 1] = string.char(math.floor(n / 65536) % 256)
    if not pad3 then out[#out + 1] = string.char(math.floor(n / 256) % 256) end
    if not pad4 then out[#out + 1] = string.char(n % 256) end
  end
  return table.concat(out)
end

-- ----------------------------
-- u32 LE reader
-- ----------------------------
local function read_u32_le(s, i)
  local b1, b2, b3, b4 = s:byte(i, i + 3)
  if not b1 then return 0 end
  return b1 + b2 * 256 + b3 * 65536 + b4 * 16777216
end

-- ----------------------------
-- ADT tile/chunk calculation constants
-- ----------------------------
local ADT_TILE_SIZE = 533.33333
local ADT_HALF_SIZE = ADT_TILE_SIZE * 32  -- 17066.67
local ADT_CHUNK_SIZE = ADT_TILE_SIZE / 16  -- 33.33333

-- ----------------------------
-- Decode tile blob and get areaID for chunk
-- ----------------------------
local function decode_tile_blob(blob)
  if not blob then return nil end
  return base64_decode(blob)
end

local function area_id_from_raw(raw, chunkX, chunkY)
  local idx = chunkY * 16 + chunkX
  local offset = idx * 4 + 1
  return read_u32_le(raw, offset)
end

local function tile_key(tileX, tileY)
  return tileY * 64 + tileX
end

-- ----------------------------
-- Get areaID from player position
-- ----------------------------
local function get_area_id_from_position(mapID, x, y)
  -- Determine which tile grid to use
  local gridName
  if mapID == 1 then
    gridName = "Kalimdor"
  elseif mapID == 0 then
    gridName = "Azeroth"
  else
    return nil, "Unsupported map ID: " .. tostring(mapID)
  end

  -- Debug: check what grids are available
  if not addon.tileGrids then
    return nil, "addon.tileGrids is nil"
  end
  
  local availableGrids = {}
  for name in pairs(addon.tileGrids) do
    table.insert(availableGrids, name)
  end
  
  -- Get tile grid
  local grid = addon.tileGrids[gridName]
  if not grid then
    return nil, string.format("Tile grid '%s' not found. Available grids: %s", 
      gridName, table.concat(availableGrids, ", ") or "none")
  end
  
  if not grid.tiles then
    return nil, "Tile grid '" .. gridName .. "' has no tiles table"
  end

  -- Convert world coordinates to tile coordinates
  -- ADT coordinate system: tileX corresponds to world Y (north/south), tileY corresponds to world X (east/west)
  -- Based on ZoneMap.lua: chunkWorldY uses tileX, chunkWorldX uses tileY
  -- So: tileX = (ADT_HALF_SIZE - worldY) / ADT_TILE_SIZE
  --     tileY = (ADT_HALF_SIZE - worldX) / ADT_TILE_SIZE
  local tileX = math.floor((ADT_HALF_SIZE - y) / ADT_TILE_SIZE)
  local tileY = math.floor((ADT_HALF_SIZE - x) / ADT_TILE_SIZE)

  -- Clamp to valid range
  tileX = math.max(0, math.min(63, tileX))
  tileY = math.max(0, math.min(63, tileY))

  -- Get tile blob
  local key = tile_key(tileX, tileY)
  local blob = grid.tiles[key]
  if not blob then
    return nil, "Tile not found: " .. tostring(key) .. " (tileX=" .. tileX .. ", tileY=" .. tileY .. ")"
  end

  -- Decode tile blob
  local raw = decode_tile_blob(blob)
  if not raw then
    return nil, "Failed to decode tile blob"
  end

  -- Calculate chunk coordinates within tile
  -- Based on ZoneMap.lua reverse calculation:
  --   chunkWorldY = ADT_HALF_SIZE - (tileX + 0.5 + (chunkX - 7.5) / 16) * ADT_TILE_SIZE
  --   chunkWorldX = ADT_HALF_SIZE - (tileY + 0.5 + (chunkY - 7.5) / 16) * ADT_TILE_SIZE
  -- Solving for chunkX and chunkY:
  --   chunkX = ((ADT_HALF_SIZE - worldY) / ADT_TILE_SIZE - tileX - 0.5) * 16 + 7.5
  --   chunkY = ((ADT_HALF_SIZE - worldX) / ADT_TILE_SIZE - tileY - 0.5) * 16 + 7.5
  -- Note: chunkX corresponds to world Y, chunkY corresponds to world X
  local chunkX = math.floor(((ADT_HALF_SIZE - y) / ADT_TILE_SIZE - tileX - 0.5) * 16 + 7.5)
  local chunkY = math.floor(((ADT_HALF_SIZE - x) / ADT_TILE_SIZE - tileY - 0.5) * 16 + 7.5)

  -- Clamp chunk coordinates to valid range [0, 15]
  chunkX = math.max(0, math.min(15, chunkX))
  chunkY = math.max(0, math.min(15, chunkY))

  -- Get areaID from chunk
  local areaID = area_id_from_raw(raw, chunkX, chunkY)
  
  -- Debug: show area name if available
  local areaName = "Unknown"
  if addon.GraveyardData and addon.GraveyardData.AREANAME and addon.GraveyardData.AREANAME[areaID] then
    areaName = addon.GraveyardData.AREANAME[areaID]
  elseif addon.GraveyardData and addon.GraveyardData.ZONENAME and addon.GraveyardData.ZONENAME[areaID] then
    areaName = addon.GraveyardData.ZONENAME[areaID]
  end
  
  return areaID, nil, tileX, tileY, chunkX, chunkY, areaName
end

-- ----------------------------
-- Walk PARENT chain to find zone with graveyards
-- ----------------------------
local function find_ghost_zone(areaID)
  if not addon.GraveyardData or not addon.GraveyardData.PARENT then
    return nil, "GraveyardData.PARENT not loaded"
  end

  if not addon.GraveyardData.GY_BY_ZONE then
    return nil, "GraveyardData.GY_BY_ZONE not loaded"
  end

  local visited = {}
  local current = areaID
  local path = {}

  while current and current ~= 0 do
    table.insert(path, current)
    
    -- Check if this zone has graveyards
    if addon.GraveyardData.GY_BY_ZONE[current] then
      local entryCount = #addon.GraveyardData.GY_BY_ZONE[current]
      return current, nil, path, entryCount
    end

    -- Avoid infinite loops
    if visited[current] then
      break
    end
    visited[current] = true

    -- Move to parent
    current = addon.GraveyardData.PARENT[current]
  end

  -- Debug: show what zones have graveyards
  local zonesWithGY = {}
  local count = 0
  for zoneID, _ in pairs(addon.GraveyardData.GY_BY_ZONE) do
    if zoneID ~= 0 then
      table.insert(zonesWithGY, tostring(zoneID))
      count = count + 1
    end
  end
  
  local pathStr = table.concat(path, " -> ")
  local zonesStr = count > 0 and (" (zones with graveyards: " .. table.concat(zonesWithGY, ", ") .. ")") or " (no zones with graveyards found in data)"
  
  return nil, "No graveyard zone found for areaID " .. tostring(areaID) .. ". Path: " .. pathStr .. zonesStr
end

-- ----------------------------
-- Get player faction (0=Alliance, 1=Horde)
-- ----------------------------
local function get_player_faction()
  local _, race = UnitRace("player")
  local horde_races = {
    ["Orc"] = true,
    ["Troll"] = true,
    ["Tauren"] = true,
    ["Undead"] = true,
    ["Scourge"] = true,
  }
  return horde_races[race] and 1 or 0
end

-- ----------------------------
-- Get current patch version (hardcoded for Classic Era)
-- ----------------------------
local function get_current_patch()
  -- Classic Era is patch 1.15.x, use 15 as patch number
  -- You may want to make this configurable or detect from client
  return 15
end

-- ----------------------------
-- Filter graveyard entries by faction and patch
-- ----------------------------
local function filter_graveyards(entries, faction, patch)
  local filtered = {}
  for _, entry in ipairs(entries) do
    -- Normalize faction: WoW uses 0/469=Alliance, 67=Horde
    -- Convert to: 0=Alliance, 1=Horde, 2=Both/Neutral
    local entryFaction = entry.f or 0
    local normalizedEntryFaction
    if entryFaction == 0 or entryFaction == 469 then
      normalizedEntryFaction = 0  -- Alliance
    elseif entryFaction == 67 then
      normalizedEntryFaction = 1  -- Horde
    else
      normalizedEntryFaction = 2  -- Both/Neutral
    end
    
    -- Check faction match: 2 means both/all factions
    if normalizedEntryFaction == 2 or normalizedEntryFaction == faction then
      -- Check patch range: pmin <= patch <= pmax
      local pmin = entry.pmin or 0
      local pmax = entry.pmax or 999
      if patch >= pmin and patch <= pmax then
        table.insert(filtered, entry)
      end
    end
  end
  return filtered
end

-- ----------------------------
-- Calculate distance between two points
-- ----------------------------
local function distance(x1, y1, z1, x2, y2, z2)
  local dx = x2 - x1
  local dy = y2 - y1
  local dz = (z2 or 0) - (z1 or 0)
  return math.sqrt(dx * dx + dy * dy + dz * dz)
end

-- ----------------------------
-- Find nearest graveyard
-- ----------------------------
local function find_nearest_graveyard(entries, mapID, x, y, z)
  if not addon.GraveyardData or not addon.GraveyardData.SAFELOC then
    return nil, "GraveyardData.SAFELOC not loaded"
  end

  local nearest = nil
  local nearestDist = math.huge

  for _, entry in ipairs(entries) do
    local gyID = entry.id
    local safeloc = addon.GraveyardData.SAFELOC[gyID]
    if safeloc then
      -- Check if same map
      local gyMap = safeloc[1]
      if gyMap == mapID then
        local gyX, gyY, gyZ = safeloc[2], safeloc[3], safeloc[4]
        local dist = distance(x, y, z, gyX, gyY, gyZ)
        if dist < nearestDist then
          nearestDist = dist
          nearest = {
            id = gyID,
            x = gyX,
            y = gyY,
            z = gyZ,
            name = safeloc[5] or "Unknown",
            distance = dist,
          }
        end
      end
    end
  end

  return nearest
end

-- ----------------------------
-- Main command handler
-- ----------------------------
local function cmd_gywhere()
  -- Check if data is loaded
  if not addon.GraveyardData then
    print("|cffff0000Error: GraveyardData not loaded. Make sure Data/graveyard_data.lua is loaded.|r")
    return
  end

  if not addon.tileGrids then
    print("|cffff0000Error: Tile grids not loaded. Make sure Data/Azeroth_tiles.lua and Data/Kalimdor_tiles.lua are loaded.|r")
    return
  end
  
  -- Debug: show what grids are available
  local gridCount = 0
  for _ in pairs(addon.tileGrids) do gridCount = gridCount + 1 end
  if gridCount == 0 then
    print("|cffff0000Error: No tile grids registered. Found " .. gridCount .. " grids.|r")
    return
  end
  -- Get player world position
  -- In Classic Era, we need to get coordinates differently
  -- Try to get from current map
  local worldX, worldY, worldZ
  
  -- Method 1: Try UnitPosition (may not be available in Classic)
  if UnitPosition then
    worldX, worldY, worldZ = UnitPosition("player")
  end
  
  -- Method 2: Get from map coordinates and convert
  if not worldX or not worldY then
    local uiMapID = C_Map.GetBestMapForUnit("player")
    if uiMapID then
      local mapPos = C_Map.GetPlayerMapPosition(uiMapID, "player")
      if mapPos and C_Map.GetWorldPosFromMapPos then
        local pos = CreateVector2D(mapPos.x, mapPos.y)
        local success, worldPos = C_Map.GetWorldPosFromMapPos(uiMapID, pos)
        if success and worldPos then
          worldX, worldY = worldPos:GetXY()
          worldZ = worldPos.z or 0
        end
      end
    end
  end
  
  if not worldX or not worldY then
    print("|cffff0000Error: Could not get player world position. Make sure you're in the world map.|r")
    return
  end
  worldZ = worldZ or 0

  -- Determine map ID
  -- Try to get from GetCurrentMapContinent (Classic API)
  local mapID
  if GetCurrentMapContinent then
    local continent = GetCurrentMapContinent()
    if continent == 1 then
      mapID = 0  -- Eastern Kingdoms
    elseif continent == 2 then
      mapID = 1  -- Kalimdor
    end
  end
  
  -- Fallback: Try to determine from zone name or coordinates
  if not mapID then
    local zoneName = GetRealZoneText()
    -- Known Kalimdor zones
    local kalimdorZones = {
      ["Durotar"] = true, ["Mulgore"] = true, ["The Barrens"] = true,
      ["Darkshore"] = true, ["Ashenvale"] = true, ["Stonetalon Mountains"] = true,
      ["Desolace"] = true, ["Feralas"] = true, ["Dustwallow Marsh"] = true,
      ["Tanaris"] = true, ["Azshara"] = true, ["Felwood"] = true,
      ["Winterspring"] = true, ["Moonglade"] = true, ["Silithus"] = true,
      ["Teldrassil"] = true, ["Darnassus"] = true, ["Orgrimmar"] = true,
    }
    if kalimdorZones[zoneName] then
      mapID = 1  -- Kalimdor
    else
      -- Default: try coordinate-based detection (less reliable)
      -- Eastern Kingdoms typically has X < -2000 or X > 2000 in most areas
      -- Kalimdor has X roughly between -2000 and 2000 in many areas
      -- But Durotar is around -600, so this is unreliable
      -- Default to Kalimdor if uncertain
      mapID = 1
    end
  end
  
  if not mapID then
    print("|cffff0000Error: Could not determine map ID|r")
    return
  end

  -- Get areaID from ADT chunk
  -- Try the detected map first, then try the other map if it fails
  local areaID, err, tileX, tileY, chunkX, chunkY, areaName = get_area_id_from_position(mapID, worldX, worldY)
  if not areaID then
    -- Try the other map
    local otherMapID = (mapID == 0) and 1 or 0
    print(string.format("|cffffff00Warning: Failed on map %d, trying map %d...|r", mapID, otherMapID))
    local areaID2, err2, tileX2, tileY2, chunkX2, chunkY2, areaName2 = get_area_id_from_position(otherMapID, worldX, worldY)
    if areaID2 then
      areaID, err, tileX, tileY, chunkX, chunkY, areaName, mapID = areaID2, err2, tileX2, tileY2, chunkX2, chunkY2, areaName2, otherMapID
    else
      print("|cffff0000Error: " .. tostring(err) .. "|r")
      print("|cffff0000Also tried map " .. otherMapID .. ": " .. tostring(err2) .. "|r")
      return
    end
  end

  print(string.format("|cff00ff00Computed areaID: %d (%s)|r (tile %d,%d chunk %d,%d)", areaID, areaName, tileX, tileY, chunkX, chunkY))
  print(string.format("  World coords: %.2f, %.2f, %.2f (map %d)", worldX, worldY, worldZ, mapID))

  -- Walk PARENT chain to find ghost zone
  local ghostZone, zoneErr, path, entryCount = find_ghost_zone(areaID)
  if not ghostZone then
    print("|cffff0000Error: " .. tostring(zoneErr) .. "|r")
    return
  end

  print(string.format("|cff00ff00Matched ghost_zone: %d|r (%d entries)", ghostZone, entryCount or 0))

  -- Get graveyard entries for this zone
  local entries = addon.GraveyardData.GY_BY_ZONE[ghostZone]
  if not entries or #entries == 0 then
    print("|cffff0000Error: No graveyard entries found for zone " .. tostring(ghostZone) .. "|r")
    return
  end

  -- Filter by faction and patch
  local faction = get_player_faction()
  local patch = get_current_patch()
  
  -- Debug: show all entries before filtering
  print(string.format("  Checking %d entries (faction=%d, patch=%d)", #entries, faction, patch))
  for i, entry in ipairs(entries) do
    local entryFaction = entry.f or 0
    local pmin = entry.pmin or 0
    local pmax = entry.pmax or 999
    print(string.format("    Entry %d: id=%d, f=%d, pmin=%d, pmax=%d", i, entry.id, entryFaction, pmin, pmax))
  end
  
  local filtered = filter_graveyards(entries, faction, patch)

  if #filtered == 0 then
    print("|cffff0000Error: No graveyards match faction/patch filter (faction=" .. faction .. ", patch=" .. patch .. ")|r")
    return
  end
  
  print(string.format("  Filtered to %d matching entries:", #filtered))
  for i, entry in ipairs(filtered) do
    local gyID = entry.id
    local safeloc = addon.GraveyardData.SAFELOC[gyID]
    if safeloc then
      local gyMap = safeloc[1]
      local gyX, gyY, gyZ = safeloc[2], safeloc[3], safeloc[4]
      local gyName = safeloc[5] or "Unknown"
      print(string.format("    %d. ID=%d (%s): map=%d, coords=(%.2f, %.2f, %.2f)", 
        i, gyID, gyName, gyMap, gyX, gyY, gyZ))
    else
      print(string.format("    %d. ID=%d: (no SAFELOC data)", i, gyID))
    end
  end

  -- Find nearest graveyard
  local nearest, nearestErr = find_nearest_graveyard(filtered, mapID, worldX, worldY, worldZ)
  if not nearest then
    print("|cffff0000Error: " .. tostring(nearestErr) .. "|r")
    return
  end

  -- Print results
  print(string.format("|cff00ff00Chosen graveyard:|r"))
  print(string.format("  ID: %d", nearest.id))
  print(string.format("  Name: %s", nearest.name))
  print(string.format("  Coords: %.2f, %.2f, %.2f", nearest.x, nearest.y, nearest.z))
  print(string.format("  Distance: %.2f yards", nearest.distance))
end

-- ----------------------------
-- Register slash command
-- ----------------------------
SLASH_GRAVEYARDWHERE1 = "/gywhere"
SlashCmdList["GRAVEYARDWHERE"] = cmd_gywhere

print("|cff00ff00GraveyardWhere loaded. Use /gywhere to predict your graveyard.|r")

