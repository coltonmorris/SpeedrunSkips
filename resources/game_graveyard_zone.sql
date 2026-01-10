-- Dumping structure for table mangos.game_graveyard_zone
DROP TABLE IF EXISTS `game_graveyard_zone`;
CREATE TABLE IF NOT EXISTS `game_graveyard_zone` (
  `id` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `ghost_zone` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `faction` smallint(5) unsigned NOT NULL DEFAULT '0',
  `build_min` smallint(4) unsigned NOT NULL DEFAULT '0' COMMENT 'Minimum game client build to load this entry',
  PRIMARY KEY (`id`,`ghost_zone`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Trigger System';

-- Dumping data for table mangos.game_graveyard_zone: 175 rows
/*!40000 ALTER TABLE `game_graveyard_zone` DISABLE KEYS */;
INSERT INTO `game_graveyard_zone` (`id`, `ghost_zone`, `faction`, `build_min`) VALUES
	(100, 1, 469, 0),
	(101, 1, 0, 0),
	(103, 3, 67, 0),
	(104, 10, 67, 0),
	(854, 1519, 67, 0),
	(104, 44, 0, 0),
	(105, 12, 469, 0),
	(106, 12, 469, 0),
	(569, 28, 67, 0),
	(106, 1519, 469, 0),
	(108, 8, 67, 0),
	(109, 33, 0, 0),
	(149, 130, 469, 0),
	(149, 267, 469, 0),
	(149, 36, 469, 0),
	(39, 722, 0, 0),
	(189, 15, 469, 0),
	(97, 209, 0, 0),
	(909, 139, 0, 0),
	(209, 440, 0, 0),
	(209, 1941, 0, 0),
	(229, 406, 0, 0),
	(429, 796, 0, 0),
	(869, 2057, 0, 0),
	(89, 1638, 469, 0),
	(249, 17, 0, 0),
	(249, 215, 0, 0),
	(289, 85, 67, 0),
	(3, 10, 469, 0),
	(309, 357, 469, 0),
	(189, 2159, 469, 0),
	(310, 357, 67, 0),
	(32, 14, 0, 0),
	(329, 400, 0, 0),
	(850, 2917, 67, 0),
	(34, 215, 67, 0),
	(349, 47, 0, 0),
	(35, 148, 469, 0),
	(36, 41, 0, 0),
	(369, 16, 0, 0),
	(370, 4, 0, 0),
	(370, 8, 469, 0),
	(389, 33, 0, 0),
	(469, 719, 0, 0),
	(850, 2437, 0, 0),
	(39, 400, 0, 0),
	(4, 40, 0, 0),
	(512, 719, 0, 0),
	(409, 406, 0, 0),
	(429, 2057, 0, 0),
	(449, 361, 0, 0),
	(450, 490, 0, 0),
	(469, 406, 0, 0),
	(91, 1657, 67, 0),
	(489, 11, 0, 0),
	(510, 139, 0, 0),
	(511, 618, 0, 0),
	(850, 1637, 67, 0),
	(512, 17, 469, 0),
	(512, 331, 0, 0),
	(569, 85, 67, 0),
	(6, 38, 469, 0),
	(609, 16, 0, 0),
	(509, 28, 469, 0),
	(429, 85, 469, 0),
	(629, 2057, 0, 0),
	(630, 16, 0, 0),
	(631, 15, 67, 0),
	(632, 46, 0, 0),
	(633, 493, 0, 0),
	(635, 361, 0, 0),
	(649, 14, 67, 0),
	(854, 2257, 67, 0),
	(7, 11, 0, 0),
	(7, 38, 67, 0),
	(789, 47, 0, 0),
	(8, 3, 0, 0),
	(8, 38, 67, 0),
	(829, 28, 0, 0),
	(849, 357, 0, 0),
	(92, 331, 0, 0),
	(850, 14, 67, 0),
	(851, 1638, 67, 0),
	(851, 215, 67, 0),
	(852, 1, 469, 0),
	(631, 2159, 67, 0),
	(89, 215, 0, 0),
	(90, 1657, 469, 0),
	(91, 141, 469, 0),
	(911, 10, 0, 4878),
	(93, 141, 469, 0),
	(94, 85, 67, 0),
	(853, 85, 67, 0),
	(97, 130, 67, 0),
	(39, 491, 0, 0),
	(98, 267, 67, 0),
	(98, 36, 67, 0),
	(99, 45, 0, 0),
	(669, 22, 0, 0),
	(670, 22, 0, 0),
	(671, 22, 0, 0),
	(529, 22, 0, 0),
	(751, 2597, 469, 0),
	(749, 2597, 67, 0),
	(750, 2597, 67, 0),
	(610, 2597, 67, 0),
	(611, 2597, 469, 0),
	(689, 2597, 0, 0),
	(729, 2597, 469, 0),
	(829, 2597, 0, 0),
	(830, 2597, 0, 0),
	(169, 2597, 0, 0),
	(769, 3277, 469, 0),
	(770, 3277, 67, 0),
	(771, 3277, 469, 0),
	(772, 3277, 67, 0),
	(809, 3277, 0, 0),
	(810, 3277, 0, 0),
	(889, 3358, 67, 0),
	(890, 3358, 469, 0),
	(891, 3358, 0, 0),
	(892, 3358, 0, 0),
	(893, 3358, 67, 0),
	(894, 3358, 0, 0),
	(895, 3358, 469, 0),
	(896, 3358, 0, 0),
	(897, 3358, 0, 0),
	(898, 3358, 469, 0),
	(899, 3358, 67, 0),
	(10, 718, 0, 0),
	(709, 14, 67, 0),
	(106, 717, 0, 0),
	(10, 17, 67, 0),
	(209, 1176, 0, 0),
	(8, 1337, 0, 0),
	(70, 1377, 0, 0),
	(910, 1377, 0, 4878),
	(149, 209, 0, 0),
	(108, 1417, 0, 0),
	(849, 2557, 0, 0),
	(31, 405, 0, 0),
	(31, 2100, 0, 0),
	(636, 1583, 0, 0),
	(636, 2717, 0, 0),
	(636, 2677, 0, 0),
	(634, 139, 0, 0),
	(108, 1477, 0, 0),
	(309, 1477, 0, 0),
	(4, 1581, 0, 0),
	(389, 1581, 0, 0),
	(389, 1977, 0, 0),
	(636, 51, 0, 0),
	(909, 2017, 0, 0),
	(107, 2918, 0, 0),
	(854, 12, 0, 0),
	(101, 721, 0, 0),
	(90, 141, 469, 0),
	(927, 139, 0, 5875),
	(913, 3478, 0, 5086),
	(913, 1377, 0, 5086),
	(636, 1584, 0, 0),
	(32, 1637, 469, 0),
	(852, 1537, 469, 0),
	(101, 1537, 67, 0),
	(429, 1497, 469, 0),
	(853, 1497, 67, 0),
	(636, 25, 0, 0),
	(229, 17, 67, 0),
	(106, 2257, 469, 0),
	(913, 3429, 0, 5086),
	(913, 3428, 0, 5086),
	(469, 148, 0, 0),
	(469, 141, 67, 0),
	(469, 1657, 67, 0),
	(909, 3456, 0, 0);
/*!40000 ALTER TABLE `game_graveyard_zone` ENABLE KEYS */;


-- Duskwood, Darkshire GY is neutral
UPDATE `game_graveyard_zone` SET `faction`='0' WHERE  `id`=3 AND `ghost_zone`=10;
-- Loch Modan, Thelsamar GY is neutral
UPDATE `game_graveyard_zone` SET `faction`='0' WHERE  `id`=6 AND `ghost_zone`=38;
-- Delete Horde Badlands, Graveyard NE GY for Loch Modan
DELETE FROM `game_graveyard_zone` WHERE  `id`=8 AND `ghost_zone`=38;
-- The Barrens, The Crossroads GY is neutral
UPDATE `game_graveyard_zone` SET `faction`='0' WHERE  `id`=10 AND `ghost_zone`=17;
-- Darkshore, Auberdine GY is neutral
UPDATE `game_graveyard_zone` SET `faction`='0' WHERE  `id`=35 AND `ghost_zone`=148;
-- Badlands, Kargath GY is neutral
UPDATE `game_graveyard_zone` SET `faction`='0' WHERE  `id`=103 AND `ghost_zone`=3;
-- Delete invalid Horde Redridge Mountains, Lakeshire GY for Duskwood
DELETE FROM `game_graveyard_zone` WHERE  `id`=104 AND `ghost_zone`=10;
-- Elwynn Forest, Goldshire GY for The Stockades is Alliance only
UPDATE `game_graveyard_zone` SET `faction`='469' WHERE  `id`=106 AND `ghost_zone`=717;
INSERT INTO `game_graveyard_zone` (`id`, `ghost_zone`, `faction`, `build_min`) VALUES ('854', '717', '67', '0');
-- Delete invalid GY for Champions' Hall, use Elwynn Forest, Goldshire GY instead
DELETE FROM `game_graveyard_zone` WHERE  `id`=107 AND `ghost_zone`=2918;
INSERT INTO `game_graveyard_zone` (`id`, `ghost_zone`, `faction`, `build_min`) VALUES ('106', '2918', '469', '0');
-- Swamp of Sorrows, Stonard GY is neutral
UPDATE `game_graveyard_zone` SET `faction`='0' WHERE  `id`=108 AND `ghost_zone`=8;
-- Hillsbrad Foothills, Southshore GY is Alliance only, even for SFK
UPDATE `game_graveyard_zone` SET `faction`='469' WHERE  `id`=149 AND `ghost_zone`=209;
-- The Barrens, Camp Taurajo GY is neutral
UPDATE `game_graveyard_zone` SET `faction`='0' WHERE  `id`=229 AND `ghost_zone`=17;
-- Feralas, Camp Mojache GY is neutral
UPDATE `game_graveyard_zone` SET `faction`='0' WHERE  `id`=310 AND `ghost_zone`=357;
-- Delete Feralas, Feathermoon Stronghold GY for The Temple of Atal'Hakkar
DELETE FROM `game_graveyard_zone` WHERE  `id`=309 AND `ghost_zone`=1477;
-- Feralas, Feathermoon Stronghold GY is neutral
UPDATE `game_graveyard_zone` SET `faction`='0' WHERE  `id`=309 AND `ghost_zone`=357;
-- Thousand Needles, Shimmering Flats GY is Horde only
UPDATE `game_graveyard_zone` SET `faction`='67' WHERE  `id`=329 AND `ghost_zone`=400;
-- Delete Alliance Blasted Lands, Dreadmaul Hold GY for Swamp of Sorrows
DELETE FROM `game_graveyard_zone` WHERE  `id`=370 AND `ghost_zone`=8;
-- Delete invalid Horde Darkshore, Twilight Vale GY for Teldrassil and Darnassus
DELETE FROM `game_graveyard_zone` WHERE  `id`=469 AND `ghost_zone`=141;
DELETE FROM `game_graveyard_zone` WHERE  `id`=469 AND `ghost_zone`=1657;
-- Wetlands, Baradin Bay GY is Alliance only
UPDATE `game_graveyard_zone` SET `faction`='469' WHERE  `id`=489 AND `ghost_zone`=11;
-- Delete invalid Alliance Ashenvale, Kargathia GY for The Barrens
DELETE FROM `game_graveyard_zone` WHERE  `id`=512 AND `ghost_zone`=17;

-- Dolanaar, Teldrassil GY is neutral.
UPDATE `game_graveyard_zone` SET `faction`='0' WHERE  `id`=91 AND `ghost_zone`=141;

-- Red Cloud Mesa Graveyard can only be accessed while in Red Cloud Mesa
UPDATE `game_graveyard_zone` SET `ghost_zone`=220 WHERE `id`=34 AND `ghost_zone`=215;

-- Coldridge Valley Graveyard can only be accessed while in Coldridge Valley
UPDATE `game_graveyard_zone` SET `ghost_zone`=132 WHERE `id`=100 AND `ghost_zone`=1;

-- Shadowglen Graveyard can only be accessed while in Shadowglen
UPDATE `game_graveyard_zone` SET `ghost_zone`=188 WHERE `id`=93 AND `ghost_zone`=141;

-- Northshire Valley Graveyard can only be accessed while in Northshire Valley
UPDATE `game_graveyard_zone` SET `ghost_zone`=9 WHERE `id`=105 AND `ghost_zone`=12;

-- Valley of Trials Graveyard can only be accessed while in Valley of Trials
UPDATE `game_graveyard_zone` SET `ghost_zone`=363 WHERE `id`=709 AND `ghost_zone`=14;

-- Deathknell Graveyard can only be accessed while in Deathknell
UPDATE `game_graveyard_zone` SET `ghost_zone`=154 WHERE `id`=94 AND `ghost_zone`=85;

-- Gates of Ironforge Graveyard can only be accessed while in Gates of Ironforge
UPDATE `game_graveyard_zone` SET `ghost_zone`=809 WHERE `id`=852 AND `ghost_zone`=1;

-- Set Dun Morogh, Anvilmar GY for Coldridge Pass
INSERT INTO `game_graveyard_zone` (`id`, `ghost_zone`, `faction`, `build_min`) VALUES (100, 800, 469, 0);

-- Set Eastern Plaguelands, Darrowshire GY for The Fungal Vale
INSERT INTO `game_graveyard_zone` (`id`, `ghost_zone`, `faction`, `build_min`) VALUES (634, 2258, 0, 0);

-- Caer Darrow Graveyard can be accessed while in Caer Darrow
INSERT INTO `game_graveyard_zone` (`id`, `ghost_zone`, `faction`, `build_min`) VALUES (869, 2298, 0, 0);

-- Delete invalid neutral Darkshore Graveyard for Stonetalon Mountains
DELETE FROM `game_graveyard_zone` WHERE  `id`=469 AND `ghost_zone`=406;

-- Delete invalid Ratchet Graveyard for Mulgore 
DELETE FROM `game_graveyard_zone` WHERE  `id`=249 AND `ghost_zone`=215;

-- Add The Fungal Vale to Eastern Plaguelands, Graveyard CG Tower GY
INSERT INTO `game_graveyard_zone` (`id`, `ghost_zone`, `faction`, `build_min`) VALUES (927, 2258, 0, 5875);

-- Change build_min to patch_min
ALTER TABLE `game_graveyard_zone`
	CHANGE COLUMN `build_min` `patch_min` SMALLINT(5) UNSIGNED NOT NULL DEFAULT '0' COMMENT 'Minimum content patch to load this entry' AFTER `faction`;

-- Set Silithus, Cenarion Hold GY to patch 1.8
UPDATE `game_graveyard_zone` SET `patch_min`='6' WHERE  `id`=910 AND `ghost_zone`=1377;

-- Delete incorrect zone Silithus for Silithus, Scarab Wall (AQ Only) GY
DELETE FROM `game_graveyard_zone` WHERE  `id`=913 AND `ghost_zone`=1377;
-- Delete incorrect zone Gates of Ahn'Qiraj for Silithus, Scarab Wall (AQ Only) GY
DELETE FROM `game_graveyard_zone` WHERE  `id`=913 AND `ghost_zone`=3478;
-- Add correct Silithus, Cenarion Hold GY for Gates of Ahn'Qiraj
INSERT INTO `game_graveyard_zone` (`id`, `ghost_zone`, `faction`, `patch_min`) VALUES (910, 3478, 0, 6);
-- Add Silithus, Valor's Rest GY for Gates of Ahn'Qiraj pre patch 1.8
INSERT INTO `game_graveyard_zone` (`id`, `ghost_zone`, `faction`, `patch_min`) VALUES (70, 3478, 0, 0);
-- Set Silithus, Scarab Wall (AQ Only) GY to patch 1.9
UPDATE `game_graveyard_zone` SET `patch_min`='7' WHERE  `id`=913;
-- Set Silithus, Scarab Wall (AQ Only) GY Spirit healer to patch 1.9
UPDATE `creature` SET `patch_min`='7' WHERE  `guid`=7716;

-- Set Duskwood, Ravenhill GY to patch patch 1.8
UPDATE `game_graveyard_zone` SET `patch_min`='6' WHERE  `id`=911 AND `ghost_zone`=10;

-- Set Eastern Plaguelands, Graveyard CG Tower GY to patch 1.12
UPDATE `game_graveyard_zone` SET `patch_min`='10' WHERE  `id`=927;
-- Set Eastern Plaguelands, Graveyard CG Tower GY Spirit Healer to patch 1.12
UPDATE `creature` SET `patch_min`='10' WHERE  `guid`=9386;

-- Set Durotar, Northern Durotar GY to patch 1.6
UPDATE `game_graveyard_zone` SET `patch_min`='4' WHERE  `id`=850;
UPDATE `game_graveyard_zone` SET `faction`='0' WHERE  `id`=32 AND `ghost_zone`=1637;
-- Set Durotar, Northern Durotar GY Spirit Healer to patch 1.6
UPDATE `creature` SET `patch_min`='4' WHERE  `guid`=40576;
-- Don't use Durotar, Northern Durotar GY for Alliance Ragefire Chasm
UPDATE `game_graveyard_zone` SET `faction`='67' WHERE  `id`=850 AND `ghost_zone`=2437;
-- Add Ragefire Chasm to Durotar, Razor Hill GY
INSERT INTO `game_graveyard_zone` (`id`, `ghost_zone`, `faction`, `patch_min`) VALUES (32, 2437, 0, 0);
-- Add Hall of Legends to Durotar, Razor Hill GY
INSERT INTO `game_graveyard_zone` (`id`, `ghost_zone`, `faction`, `patch_min`) VALUES (32, 2917, 0, 0);

-- Set Mulgore, Thunder Bluff GY to 1.6
UPDATE `game_graveyard_zone` SET `patch_min`='4' WHERE  `id`=851;
-- Set Mulgore, Thunder Bluff GY Spirit Healer to patch 1.6
UPDATE `creature` SET `patch_min`='4' WHERE  `guid`=40570;
-- Use Mulgore, Bloodhoof Village GY for Thunderbluff pre patch 1.6
UPDATE `game_graveyard_zone` SET `faction`='0' WHERE  `id`=89 AND `ghost_zone`=1638;

-- Set Teldrassil, Darnassus GY to patch 1.6
UPDATE `game_graveyard_zone` SET `patch_min`='4' WHERE  `id`=90;
-- Set Teldrassil, Darnassus GY Spirit Healer to patch 1.6
UPDATE `creature` SET `patch_min`='4' WHERE  `guid`=87049;
-- Use Teldrassil, Dolanaar GY for Darnassus pre patch 1.6
UPDATE `game_graveyard_zone` SET `faction`='0' WHERE  `id`=91 AND `ghost_zone`=1657;

-- Set Dun Morogh, Gates of Ironforge GY to patch 1.6
UPDATE `game_graveyard_zone` SET `patch_min`='4' WHERE  `id`=852;
-- Set Dun Morogh, Gates of Ironforge GY Spirit Healer to patch 1.6
UPDATE `creature` SET `patch_min`='4' WHERE  `guid`=87044;
-- Use Dun Morogh, Kharanos GY for Ironforge pre patch 1.6
UPDATE `game_graveyard_zone` SET `faction`='0' WHERE  `id`=101 AND `ghost_zone`=1537;

-- Set Tirisfal Glades, Ruins of Lordaeron GY to patch 1.6
UPDATE `game_graveyard_zone` SET `patch_min`='4' WHERE  `id`=853;
-- Set Tirisfal Glades, Ruins of Lordaeron GY Spirit Healer to patch 1.6
UPDATE `creature` SET `patch_min`='4' WHERE  `guid`=2065;
-- Use Tirisfal Glades, Brill GY for Undercity pre patch 1.6
INSERT INTO `game_graveyard_zone` (`id`, `ghost_zone`, `faction`, `patch_min`) VALUES (289, 1497, 0, 0);

-- Set Western Plaguelands, Caer Darrow GY to patch 1.6
UPDATE `game_graveyard_zone` SET `patch_min`='4' WHERE  `id`=869;
-- Set Western Plaguelands, Caer Darrow GY Spirit Healer to patch 1.6
UPDATE `creature` SET `patch_min`='4' WHERE  `guid`=40544;
-- Delete invalid graveyards for Caer Darrow
DELETE FROM `game_graveyard_zone` WHERE  `id`=429 AND `ghost_zone`=2057;
DELETE FROM `game_graveyard_zone` WHERE  `id`=629 AND `ghost_zone`=2057;
-- Set correct graveyards for Caer Darrow pre patch 1.6
INSERT INTO `game_graveyard_zone` (`id`, `ghost_zone`, `faction`, `patch_min`) VALUES (569, 2057, 67, 0);
INSERT INTO `game_graveyard_zone` (`id`, `ghost_zone`, `faction`, `patch_min`) VALUES (509, 2057, 469, 0);

-- Set Eastern Plaguelands, Blackwood Lake GY to patch 1.6
UPDATE `game_graveyard_zone` SET `patch_min`='4' WHERE  `id`=909;
-- Set Eastern Plaguelands, Blackwood Lake GY Spirit Healer to patch 1.6
UPDATE `creature` SET `patch_min`='4' WHERE  `guid`=40551;
-- Use Eastern Plaguelands, Light's Hope Chapel GY for Stratholm pre patch 1.6
INSERT INTO `game_graveyard_zone` (`id`, `ghost_zone`) VALUES ('510', '2017');

-- Set Feralas, Dire Maul GY to patch 1.6
UPDATE `game_graveyard_zone` SET `patch_min`='4' WHERE  `id`=849;
-- Set Feralas, Dire Maul GY Spirit Healer to patch 1.6
UPDATE `creature` SET `patch_min`='4' WHERE  `guid`=40561;
-- Use Feralas, Camp Mojache for Dire Maul GY pre patch 1.6
INSERT INTO `game_graveyard_zone` (`id`, `ghost_zone`) VALUES ('310', '2557');

-- Set The Hinterlands, The Overlook Cliffs GY to patch 1.5
UPDATE `game_graveyard_zone` SET `patch_min`='3' WHERE  `id`=789 AND `ghost_zone`=47;

-- Set Elwynn Forest, Eastvale Logging Camp GY to patch 1.6
UPDATE `game_graveyard_zone` SET `patch_min`='4' WHERE  `id`=854;
-- Set Elwynn Forest, Eastvale Logging Camp GY Spirit Healer to patch 1.6
UPDATE `creature` SET `patch_min`='4' WHERE  `guid`=17650;

-- Set min patch for Badlands, Graveyard NE GY
UPDATE `game_graveyard_zone` SET `patch_min`='10' WHERE  `id`=8;
-- Add Uldaman to Kargath, Badlands GY
INSERT INTO `game_graveyard_zone` (`id`, `ghost_zone`, `faction`, `patch_min`) VALUES ('103', '1337', '0', '0');
-- Set Badlands, Graveyard NE GY Spirit Healer to patch 1.12
UPDATE `creature` SET `patch_min`='10' WHERE  `guid`=40593;

-- Add patch_max to game_graveyard_zone
ALTER TABLE `game_graveyard_zone`
	ADD COLUMN `patch_max` TINYINT(2) UNSIGNED NOT NULL DEFAULT '0' COMMENT 'Maximum content patch to load this entry' AFTER `patch_min`;
-- Add primary key to patch_max
ALTER TABLE `game_graveyard_zone`
	DROP PRIMARY KEY,
	ADD PRIMARY KEY (`id`, `ghost_zone`, `patch_max`) USING BTREE;
-- Set max 1.12 patch to all GYs
UPDATE `game_graveyard_zone` SET `patch_max`='10' WHERE `patch_max`=0;

-- Set patch 1.6 for Alliance Deeprun Tram to Elwynn Forest, Goldshire GY
UPDATE `game_graveyard_zone` SET `patch_min`='4' WHERE  `id`=106 AND `ghost_zone`=2257 AND `patch_max`=10;
-- Set patch 1.6 for Alliance Stormwind City to Elwynn Forest, Goldshire GY
UPDATE `game_graveyard_zone` SET `patch_min`='4' WHERE  `id`=106 AND `ghost_zone`=1519 AND `patch_max`=10;
-- Set patch 1.6 patch for Alliance The Stockade to Elwynn Forest, Goldshire GY
UPDATE `game_graveyard_zone` SET `patch_min`='4' WHERE  `id`=106 AND `ghost_zone`=717 AND `patch_max`=10;
-- Set patch 1.6 patch for Alliance Elwynn Forest to Elwynn Forest, Goldshire GY
UPDATE `game_graveyard_zone` SET `patch_min`='4' WHERE  `id`=106 AND `ghost_zone`=12 AND `patch_max`=10;
-- Add neutral Elwynn Forest, Goldshire GY for pre patch 1.6
INSERT INTO `game_graveyard_zone` (`id`, `ghost_zone`, `patch_max`) VALUES ('106', '2257', '3');
INSERT INTO `game_graveyard_zone` (`id`, `ghost_zone`, `patch_max`) VALUES ('106', '1519', '3');
INSERT INTO `game_graveyard_zone` (`id`, `ghost_zone`, `patch_max`) VALUES ('106', '717', '3');
INSERT INTO `game_graveyard_zone` (`id`, `ghost_zone`, `patch_max`) VALUES ('106', '12', '3');

-- Don't use Durotar, Razor Hill GY for Hall of Legends after patch 1.6
UPDATE `game_graveyard_zone` SET `patch_max`='3' WHERE  `id`=32 AND `ghost_zone`=2917 AND `patch_max`=10;

-- Thousand Needles, Shimmering Flats GY should only be used for area Shimmering Flats
-- Should be neutral
UPDATE `game_graveyard_zone` SET `faction`=0, `ghost_zone`=439 WHERE `id`=329 AND `ghost_zone`=400 AND `patch_max`=10;
-- Add subareas in Shimmering Flats to Thousand Needles, Shimmering Flats GY 
INSERT INTO `game_graveyard_zone` (`id`, `ghost_zone`, `faction`, `patch_min`, `patch_max`) VALUES
(329, 479, 0, 0, 10),
(329, 2240, 0, 0, 10),
(329, 3038, 0, 0, 10),
(329, 3039, 0, 0, 10);

ALTER TABLE `game_graveyard_zone`
	CHANGE COLUMN `patch_min` `patch_min` TINYINT(2) UNSIGNED NOT NULL DEFAULT '0' COMMENT 'Minimum content patch to load this entry' AFTER `faction`,
	CHANGE COLUMN `patch_max` `patch_max` TINYINT(2) UNSIGNED NOT NULL DEFAULT '10' COMMENT 'Maximum content patch to load this entry' AFTER `patch_min`;

INSERT INTO `game_graveyard_zone` (`id`, `ghost_zone`, `faction`, `patch_min`, `patch_max`) VALUES 
-- Set Mulgore, Red Cloud Mesa GY for Brambleblade Ravine, Kodo Rock, Campe Narache
(34, 358, 67, 0, 10),
(34, 637, 67, 0, 10),
(34, 221, 67, 0, 10),
-- Set Durotar, Valley of Trials for Spirit Rock, The Den, Hidden Path, Burning Blade Coven until patch 1.6
(709, 639, 67, 0, 3),
(709, 364, 67, 0, 3),
(709, 638, 67, 0, 3),
(709, 365, 67, 0, 3),
-- Set Durotar, Valley of Trials graveyard for Durotar from patch 1.6 onward
(709, 14, 67, 4, 10),
-- Set Tirisfal Glades, Deathknell GY for Shadow Grave, Night Web's Hollow
(94, 2117, 67, 0, 10),
(94, 155, 67, 0, 10),
-- Set Aldrassil, Teldrassil GY for Aldrassil, Shadowthread Cave
(93, 256, 469, 0, 10),
(93, 257, 469, 0, 10),
-- Set Anvilmar, Dun Morogh GY for Anvilmar
(100, 77, 469, 0, 10),
-- Set Northshire, Elwynn Forest GY for Northshire Abbey, Echo Ridge Mine, Northshire Vineyards
(105, 24, 469, 0, 10),
(105, 34, 469, 0, 10),
(105, 59, 469, 0, 10);

-- Remove invalid Camp Taurajo graveyard for Stonetalon Mountains
DELETE FROM `game_graveyard_zone` WHERE `id`=229 AND `ghost_zone`=406;

-- Remove invalid Horde-only Wetlands graveyard for Loch Modan
DELETE FROM `game_graveyard_zone` WHERE `id`=7 AND `faction`=67 AND `ghost_zone`=38;

-- Set Durotar, Valley of Trials for Valley of Trials until patch 1.6
UPDATE `game_graveyard_zone` SET `patch_max`=3 WHERE `id`=709 AND `ghost_zone`=363;


--------------------------------------
--------------------------------------
--------------------------------------
-- NOW THE OLD MIGRATIONS BELOW
--------------------------------------
--------------------------------------
--------------------------------------

INSERT INTO `game_graveyard_zone` (`id`, `ghost_zone`, `faction`) VALUES ('909', '3456', '0');

-- All graveyards in the Hinterlands should be cross-faction.
UPDATE `game_graveyard_zone` SET `faction` = 0 WHERE `id` = 789;
UPDATE `game_graveyard_zone` SET `faction` = 0 WHERE `id` = 349;

-- Fix graveyard at Bloodhoof Village in Mulgore for the Alliance.
-- Before this fix Alliance died at Bloodhoof Village and were teleported to Ratchet.
UPDATE `game_graveyard_zone` SET `faction` = 0 WHERE `id` = 89 AND `ghost_zone` = 215;


-- Enable Graveyard at Darkshore, Twilight Vale. It should be cross-faction.
INSERT INTO `game_graveyard_zone` VALUES (469, 148, 0);
INSERT INTO `game_graveyard_zone` VALUES (469, 141, 67);
INSERT INTO `game_graveyard_zone` VALUES (469, 1657, 67);
DELETE FROM `game_graveyard_zone` WHERE `id` = 512 AND `ghost_zone` = 148;

-- Enable Undercity graveyard.
DELETE FROM `game_graveyard_zone` WHERE `id` = 429 AND `ghost_zone` = 1497;
INSERT INTO `game_graveyard_zone` VALUES (853, 1497, 469);


-- ERROR:Table `game_graveyard_zone` has record for not existing graveyard (WorldSafeLocs.dbc id) 230, skipped.
DELETE FROM `game_graveyard_zone` WHERE `id`=230;

-- https://github.com/LightsHope/server/issues/541
UPDATE `game_graveyard_zone` SET `id`=429 WHERE `id`=853 AND `ghost_zone`=1497;
UPDATE `game_graveyard_zone` SET `id`=429 WHERE `id`=629 AND `ghost_zone`=85;


-- The graveyard near Crown Guard Tower in EPL was added in 1.12.
ALTER TABLE `game_graveyard_zone`
	ADD COLUMN `build_min` SMALLINT(4) UNSIGNED NOT NULL DEFAULT '0' COMMENT 'Minimum game client build' AFTER `faction`;
UPDATE `game_graveyard_zone` SET `build_min`=5875 WHERE `id`=927;


-- ERROR:Table `game_graveyard_zone` has record for not existing graveyard (WorldSafeLocs.dbc id) 913, skipped.
UPDATE `game_graveyard_zone` SET `build_min`=5086 WHERE `id`=913;


-- These graveyards were added in 1.8.
UPDATE `game_graveyard_zone` SET `build_min`=4878 WHERE `id`=910;
UPDATE `game_graveyard_zone` SET `build_min`=4878 WHERE `id`=911;

-- Use the real undercity graveyard
UPDATE `game_graveyard_zone` SET `id`='853' WHERE  `id`=96 AND `ghost_zone`=1497;
UPDATE `game_graveyard_zone` SET `id`='853' WHERE  `id`=96 AND `ghost_zone`=85;


-- Delete non blizzlike graveyards for Deeprun Tram
DELETE FROM `game_graveyard_zone` WHERE  `id`=852 AND `ghost_zone`=2257;
DELETE FROM `game_graveyard_zone` WHERE  `id`=101 AND `ghost_zone`=2257;
