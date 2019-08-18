local ArkadiusTradeToolsSales = ArkadiusTradeTools.Modules.Sales

local MASTER_WRIT_TYPE_BLACKSMITHING = 1
local MASTER_WRIT_TYPE_TAILORING     = 2
local MASTER_WRIT_TYPE_WOODWORKING   = 3
local MASTER_WRIT_TYPE_ENCHANTING    = 4
local MASTER_WRIT_TYPE_ALCHEMY       = 5
local MASTER_WRIT_TYPE_PROVISIONING  = 6
local MASTER_WRIT_TYPE_JEWELRY       = 7


local MASTER_WRIT_TYPES =
{
    [119563] = MASTER_WRIT_TYPE_BLACKSMITHING,
    [119680] = MASTER_WRIT_TYPE_BLACKSMITHING,
    [121527] = MASTER_WRIT_TYPE_BLACKSMITHING,
    [121529] = MASTER_WRIT_TYPE_BLACKSMITHING,
    [119694] = MASTER_WRIT_TYPE_TAILORING,
    [119695] = MASTER_WRIT_TYPE_TAILORING,
    [121532] = MASTER_WRIT_TYPE_TAILORING,
    [121533] = MASTER_WRIT_TYPE_TAILORING,
    [119681] = MASTER_WRIT_TYPE_WOODWORKING,
    [119682] = MASTER_WRIT_TYPE_WOODWORKING,
    [121530] = MASTER_WRIT_TYPE_WOODWORKING,
    [121531] = MASTER_WRIT_TYPE_WOODWORKING,
    [119564] = MASTER_WRIT_TYPE_ENCHANTING,
    [121528] = MASTER_WRIT_TYPE_ENCHANTING,
    [119696] = MASTER_WRIT_TYPE_ALCHEMY,
    [119698] = MASTER_WRIT_TYPE_ALCHEMY,
    [119705] = MASTER_WRIT_TYPE_ALCHEMY,
    [119818] = MASTER_WRIT_TYPE_ALCHEMY,
    [119820] = MASTER_WRIT_TYPE_ALCHEMY,
    [119704] = MASTER_WRIT_TYPE_ALCHEMY,
    [119701] = MASTER_WRIT_TYPE_ALCHEMY,
    [119702] = MASTER_WRIT_TYPE_ALCHEMY,
    [119699] = MASTER_WRIT_TYPE_ALCHEMY,
    [119703] = MASTER_WRIT_TYPE_ALCHEMY,
    [119700] = MASTER_WRIT_TYPE_ALCHEMY,
    [119819] = MASTER_WRIT_TYPE_ALCHEMY,
    [119693] = MASTER_WRIT_TYPE_PROVISIONING,
    [138798] = MASTER_WRIT_TYPE_JEWELRY,
    [138799] = MASTER_WRIT_TYPE_JEWELRY,
}

local MASTER_WRIT_BASE_MATERIAL =
{
    [188] = "|H0:item:64489:30:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",  -- Rubedite Ignots
    [190] = "|H0:item:64506:30:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",  -- Rubedo Leather
    [192] = "|H0:item:64502:30:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",  -- Ruby Ash
    [194] = "|H0:item:64504:30:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",  -- Ancient Silk
    [255] = "|H0:item:135146:30:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h", -- Platinum
}

local MASTER_WRIT_BASE_MATERIAL_QUANTITY =
{
    [18] = 15, -- Neck
    [24] = 10, -- Ring
    [26] = 13, -- Helmet, Light
--  [27] =     -- Neck, Light
    [28] = 15, -- Chest, Light
    [29] = 13, -- Shoulder, Light
    [30] = 13, -- Belt, Light
    [31] = 14, -- Legs, Light
    [32] = 13, -- Feet, Light
--  [33] =     -- Ring, Light
    [34] = 13, -- Gloves, Light
    [35] = 13, -- Helmet, Medium
--  [36] =     -- Neck, Medium
    [37] = 15, -- Chest, Medium
    [38] = 13, -- Shoulder, Medium
    [39] = 13, -- Belt, Medium
    [40] = 14, -- Legs, Medium
    [41] = 13, -- Feet, Medium
--  [42] =     -- Ring, Medium
    [43] = 13, -- Gloves, Medium
    [44] = 13, -- Helmet, Heavy
--  [45] =     -- Neck, Heavy
    [46] = 15, -- Chest, Heavy
    [47] = 13, -- Shoulder, Heavy
    [48] = 13, -- Belt, Heavy
    [49] = 14, -- Legs, Heavy
    [50] = 13, -- Feet, Heavy
--  [51] =     -- Ring, Heavy
    [52] = 13, -- Gloves, Heavy
    [53] = 11, -- 1H Axe
    [56] = 11, -- 1H Mace
    [59] = 11, -- 1H Sword
    [62] = 11, -- Dagger
    [65] = 14, -- Shield
--  [66] =     -- Rune/Off-Hand
    [67] = 14, -- 2H Sword
    [68] = 14, -- 2H Axe
    [69] = 14, -- 2H Maul
    [70] = 12, -- Bow
    [71] = 12, -- Restoration Staff
    [72] = 12, -- Inferno Staff
    [73] = 12, -- Frost Staff
    [74] = 12, -- Lightning Staff
}

local MASTER_WRIT_TEMPERS =
{
    [MASTER_WRIT_TYPE_BLACKSMITHING] =
    {
        [2] = "|H0:item:54170:31:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h", -- Honing Stone
        [3] = "|H0:item:54171:32:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h", -- Dwarven Oil
        [4] = "|H0:item:54172:33:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h", -- Grain Solvent
        [5] = "|H0:item:54173:34:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h", -- Tempering Alloy
    },
    [MASTER_WRIT_TYPE_TAILORING] =
    {
        [2] = "|H0:item:54174:31:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h", -- Hemming
        [3] = "|H0:item:54175:32:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h", -- Embroidery
        [4] = "|H0:item:54176:33:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h", -- Elegent Lining
        [5] = "|H0:item:54177:34:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h", -- Dreugh Wax
    },
    [MASTER_WRIT_TYPE_WOODWORKING] =
    {
        [2] = "|H0:item:54178:31:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h", -- Pitch
        [3] = "|H0:item:54179:32:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h", -- Turpen
        [4] = "|H0:item:54180:33:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h", -- Mastic
        [5] = "|H0:item:54181:34:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h", -- Rosin
    },
    [MASTER_WRIT_TYPE_JEWELRY] =
    {
        [2] = "|H0:item:135147:31:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h", -- Terne
        [3] = "|H0:item:135148:32:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h", -- Iridium
        [4] = "|H0:item:135149:33:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h", -- Zircon
        [5] = "|H0:item:135150:34:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h", -- Chromium
    },
}

local MASTER_WRIT_TEMPERS_QUANTITY =
{
    [MASTER_WRIT_TYPE_BLACKSMITHING] =
    {
        [2] = 2,
        [3] = 3,
        [4] = 4,
        [5] = 8,
    },
    [MASTER_WRIT_TYPE_TAILORING] =
    {
        [2] = 2,
        [3] = 3,
        [4] = 4,
        [5] = 8,
    },
    [MASTER_WRIT_TYPE_WOODWORKING] =
    {
        [2] = 2,
        [3] = 3,
        [4] = 4,
        [5] = 8,
    },
    [MASTER_WRIT_TYPE_JEWELRY] =
    {
        [2] = 1,
        [3] = 2,
        [4] = 3,
        [5] = 4,
    },
}

local MASTER_WRIT_STYLES =
{
    [1]  = "|H0:item:33251:30:1:0:0:0:0:0:0:0:0:0:0:0:0:1:0:0:0:0:0|h|h",   -- Breton, Molybdenum
    [2]  = "|H0:item:33258:30:1:0:0:0:0:0:0:0:0:0:0:0:0:2:0:0:0:0:0|h|h",   -- Redguard, Starmetal
    [3]  = "|H0:item:33257:30:1:0:0:0:0:0:0:0:0:0:0:0:0:3:0:0:0:0:0|h|h",   -- Orc, Manganese
    [4]  = "|H0:item:33253:30:1:0:0:0:0:0:0:0:0:0:0:0:0:4:0:0:0:0:0|h|h",   -- Dunmer, Obisidian
    [5]  = "|H0:item:33256:30:1:0:0:0:0:0:0:0:0:0:0:0:0:5:0:0:0:0:0|h|h",   -- Nord, Corundum
    [6]  = "|H0:item:33150:30:1:0:0:0:0:0:0:0:0:0:0:0:0:6:0:0:0:0:0|h|h",   -- Argonian, Flint
    [7]  = "|H0:item:33252:30:1:0:0:0:0:0:0:0:0:0:0:0:0:7:0:0:0:0:0|h|h",   -- Altmer, Adamantite
    [8]  = "|H0:item:33252:30:1:0:0:0:0:0:0:0:0:0:0:0:0:7:0:0:0:0:0|h|h",   -- Bosmer, Bone
    [9]  = "|H0:item:33255:30:1:0:0:0:0:0:0:0:0:0:0:0:0:9:0:0:0:0:0|h|h",   -- Khajiit, Moonstone
--    [10] = "Not craftable",                                                 -- Unique
    [11] = "|H0:item:75370:30:1:0:0:0:0:0:0:0:0:0:0:0:0:11:0:0:0:0:0|h|h",  -- Thieves Guild, Fine Chalk
    [12] = "|H0:item:79304:30:1:0:0:0:0:0:0:0:0:0:0:0:0:12:0:0:0:0:0|h|h",  -- Dark Brotherhodd, Black Beeswax
    [13] = "|H0:item:71584:30:1:0:0:0:0:0:0:0:0:0:0:0:0:13:0:0:0:0:0|h|h",  -- Malacath, Potash
    [14] = "|H0:item:57587:30:1:0:0:0:0:0:0:0:0:0:0:0:0:14:0:0:0:0:0|h|h",  -- Dwemer, Dwemer Frame
    [15] = "|H0:item:46152:30:1:0:0:0:0:0:0:0:0:0:0:0:0:15:0:0:0:0:0|h|h",  -- Ancient Elf, Palladum
    [16] = "|H0:item:81996:30:1:0:0:0:0:0:0:0:0:0:0:0:0:16:0:0:0:0:0|h|h",  -- Order of the Hour, Pearl Sand
    [17] = "|H0:item:46149:30:1:0:0:0:0:0:0:0:0:0:0:0:0:17:0:0:0:0:0|h|h",  -- Barbaric, Bronze
--    [18] = "Not craftable",                                                 -- Bandit
    [19] = "|H0:item:46150:30:1:0:0:0:0:0:0:0:0:0:0:0:0:19:0:0:0:0:0|h|h",  -- Primal, Argentum
    [20] = "|H0:item:46151:30:1:0:0:0:0:0:0:0:0:0:0:0:0:20:0:0:0:0:0|h|h",  -- Daedric, Daedra Heart
    [21] = "|H0:item:71582:30:1:0:0:0:0:0:0:0:0:0:0:0:0:21:0:0:0:0:0|h|h",  -- Trinimac, Auric Tusk
    [22] = "|H0:item:69555:30:1:0:0:0:0:0:0:0:0:0:0:0:0:22:0:0:0:0:0|h|h",  -- Ancient Orc, Cassiterite
    [23] = "|H0:item:71742:30:1:0:0:0:0:0:0:0:0:0:0:0:0:23:0:0:0:0:0|h|h",  -- Daggerfall Covenant, Lion Fang
    [24] = "|H0:item:71740:30:1:0:0:0:0:0:0:0:0:0:0:0:0:24:0:0:0:0:0|h|h",  -- Ebonheart Pact, Dragon Scute
    [25] = "|H0:item:71738:30:1:0:0:0:0:0:0:0:0:0:0:0:0:25:0:0:0:0:0|h|h",  -- Aldermi Dominion, Eagle Feather
    [26] = "|H0:item:64713:30:1:0:0:0:0:0:0:0:0:0:0:0:0:26:0:0:0:0:0|h|h",  -- Mercenary, Laurel
    [27] = "|H0:item:81998:30:1:0:0:0:0:0:0:0:0:0:0:0:0:27:0:0:0:0:0|h|h",  -- Celestial, Star Sapphire
    [28] = "|H0:item:64689:30:1:0:0:0:0:0:0:0:0:0:0:0:0:28:0:0:0:0:0|h|h",  -- Glass, Malachite
    [29] = "|H0:item:59922:30:1:0:0:0:0:0:0:0:0:0:0:0:0:29:0:0:0:0:0|h|h",  -- Xivkyn, Charcoal of Remorse
    [30] = "|H0:item:71766:30:1:0:0:0:0:0:0:0:0:0:0:0:0:30:0:0:0:0:0|h|h",  -- Soul Shriven, Azure Plasm
    [31] = "|H0:item:75373:30:1:0:0:0:0:0:0:0:0:0:0:0:0:31:0:0:0:0:0|h|h",  -- Draugr, Pristine Shrouds
--    [32] = "Not craftable",                                                 -- Maormer
    [33] = "|H0:item:64687:30:1:0:0:0:0:0:0:0:0:0:0:0:0:33:0:0:0:0:0|h|h",  -- Akaviri, Goldscale
    [34] = "|H0:item:33254:30:1:0:0:0:0:0:0:0:0:0:0:0:0:34:0:0:0:0:0|h|h",  -- Imperial, Nickel
    [35] = "|H0:item:64685:30:1:0:0:0:0:0:0:0:0:0:0:0:0:35:0:0:0:0:0|h|h",  -- Yokudan, Ferrous Salts
--    [36] = "Not craftable",                                                 -- Universal
--    [37] = "Not craftable",                                                 -- Reach Winter
--    [38] = "Not craftable",                                                 -- Tsaesci
    [39] = "|H0:item:81994:30:1:0:0:0:0:0:0:0:0:0:0:0:0:39:0:0:0:0:0|h|h",  -- Minotaur, Oxblood Fungus
    [40] = "|H0:item:82004:30:1:0:0:0:0:0:0:0:0:0:0:0:0:40:0:0:0:0:0|h|h",  -- Ebony, Night Pumice
    [41] = "|H0:item:76914:30:1:0:0:0:0:0:0:0:0:0:0:0:0:41:0:0:0:0:0|h|h",  -- Abah's Watch, Polished Shilling
    [42] = "|H0:item:96388:30:1:0:0:0:0:0:0:0:0:0:0:0:0:42:0:0:0:0:0|h|h",  -- Skinchanger, Wolfbane Incense
    [43] = "|H0:item:79305:30:1:0:0:0:0:0:0:0:0:0:0:0:0:43:0:0:0:0:0|h|h",  -- Morag Tong, Boiled Carapace
    [44] = "|H0:item:71736:30:1:0:0:0:0:0:0:0:0:0:0:0:0:44:0:0:0:0:0|h|h",  -- Ra Gada, Ancient Sandstone
    [45] = "|H0:item:79672:30:1:0:0:0:0:0:0:0:0:0:0:0:0:45:0:0:0:0:0|h|h",  -- Dro-m'Athra, Defiled Whiskers
    [46] = "|H0:item:76910:30:1:0:0:0:0:0:0:0:0:0:0:0:0:46:0:0:0:0:0|h|h",  -- Assassins League, Tainted Blood
    [47] = "|H0:item:71538:30:1:0:0:0:0:0:0:0:0:0:0:0:0:47:0:0:0:0:0|h|h",  -- Outlaw, Rogue's Soot
    [48] = "|H0:item:130060:30:1:0:0:0:0:0:0:0:0:0:0:0:0:48:0:0:0:0:0|h|h", -- Redoran, Polished Scarab Elytra
    [49] = "|H0:item:130059:30:1:0:0:0:0:0:0:0:0:0:0:0:0:49:0:0:0:0:0|h|h", -- Hlaalu, Refined Bonemold Resin 
    [50] = "|H0:item:121520:30:1:0:0:0:0:0:0:0:0:0:0:0:0:50:0:0:0:0:0|h|h", -- Militant Ordinator, Lustrous Sphalerite
    [51] = "|H0:item:121519:30:1:0:0:0:0:0:0:0:0:0:0:0:0:51:0:0:0:0:0|h|h", -- Telvanni, Wrought Ferrofungus
    [52] = "|H0:item:121518:30:1:0:0:0:0:0:0:0:0:0:0:0:0:52:0:0:0:0:0|h|h", -- Buoyant Armiger, Volcanic Viridian
    [53] = "|H0:item:114283:30:1:0:0:0:0:0:0:0:0:0:0:0:0:53:0:0:0:0:0|h|h", -- Stahlrim frost caster. Stahlrim shard
    [54] = "|H0:item:125476:30:1:0:0:0:0:0:0:0:0:0:0:0:0:54:0:0:0:0:0|h|h", -- Ashlander, Ash Canvas
    [55] = "|H0:item:134798:30:1:0:0:0:0:0:0:0:0:0:0:0:0:55:0:0:0:0:0|h|h", -- Worm Cult, Desecrated Grave Soil
    [56] = "|H0:item:114983:30:1:0:0:0:0:0:0:0:0:0:0:0:0:56:0:0:0:0:0|h|h", -- Silken Ring, Distilled Slowsilver
    [57] = "|H0:item:114984:30:1:0:0:0:0:0:0:0:0:0:0:0:0:57:0:0:0:0:0|h|h", -- Mazzatun , Leviathan Scrimshaw
    [58] = "|H0:item:82002:30:1:0:0:0:0:0:0:0:0:0:0:0:0:58:0:0:0:0:0|h|h",  -- Grim Harlequin, Grinstone
    [59] = "|H0:item:82000:30:1:0:0:0:0:0:0:0:0:0:0:0:0:59:0:0:0:0:0|h|h",  -- Hollow Jack, Amber Marble
--    [60] = "Not craftable",                                                 -- Reconstruction
    [61] = "|H0:item:132620:30:1:0:0:0:0:0:0:0:0:0:0:0:0:61:0:0:0:0:0|h|h", -- Bloodforge, Bloodroot Flux
    [62] = "|H0:item:132619:30:1:0:0:0:0:0:0:0:0:0:0:0:0:62:0:0:0:0:0|h|h", -- Dreadhorn, Minotaur Bezoar
--    [63] = "Not craftable",                                                 -- none
--    [64] = "Not craftable",                                                 -- none
    [65] = "|H0:item:132617:30:1:0:0:0:0:0:0:0:0:0:0:0:0:65:0:0:0:0:0|h|h", -- Apostle, Polished Brass
    [66] = "|H0:item:132618:30:1:0:0:0:0:0:0:0:0:0:0:0:0:66:0:0:0:0:0|h|h", -- Ebonshadow, Tenebrous Cord
--    [67] = "Not craftable",                                                 -- Undaunted 
--    [68] = "Not craftable",                                                 -- none
    [69] = "|H0:item:137958:30:1:0:0:0:0:0:0:0:0:0:0:0:0:69:0:0:0:0:0|h|h", -- Fang Lair, Dragon Bone
    [70] = "|H0:item:137961:30:1:0:0:0:0:0:0:0:0:0:0:0:0:70:0:0:0:0:0|h|h", -- Scalecaller, Infected Flesh
    [71] = "|H0:item:137951:30:1:0:0:0:0:0:0:0:0:0:0:0:0:71:0:0:0:0:0|h|h", -- Psijic, Vitrified Malondo 
    [72] = "|H0:item:137953:30:1:0:0:0:0:0:0:0:0:0:0:0:0:72:0:0:0:0:0|h|h", -- Sapiarch, Culanda Lacquer
    [73] = "|H0:item:141740:30:1:0:0:0:0:0:0:0:0:0:0:0:0:73:0:0:0:0:0|h|h", -- Welkynar Style, Gryphon Plume
    [74] = "|H0:item:137957:30:1:0:0:0:0:0:0:0:0:0:0:0:0:74:0:0:0:0:0|h|h", -- Dremora, Warrior's Heart Ashes
    [75] = "|H0:item:140267:30:1:0:0:0:0:0:0:0:0:0:0:0:0:75:0:0:0:0:0|h|h", -- Pyandonean, Sea Serpent Hide
--    [76] = "Not craftable",                                                 -- Divine Prosecution
    [77] = "|H0:item:141820:30:1:0:0:0:0:0:0:0:0:0:0:0:0:77:0:0:0:0:0|h|h", -- Huntsman, Bloodscent Dew
    [78] = "|H0:item:141821:30:1:0:0:0:0:0:0:0:0:0:0:0:0:78:0:0:0:0:0|h|h", -- Silver Dawn, Argent Pelt
    [79] = "|H0:item:145532:30:1:0:0:0:0:0:0:0:0:0:0:0:0:79:0:0:0:0:0|h|h", -- Dead Water, Crocodile Leather
--    [80] = "Not craftable",                                                 -- Honor Guard
    [81] = "|H0:item:145533:30:1:0:0:0:0:0:0:0:0:0:0:0:0:81:0:0:0:0:0|h|h", -- Elder Argonian, Hackwing Plumage
--    [82] = "Not craftable",                                                 -- Coldsnap
--    [83] = "Not craftable",                                                 -- Meridia
}

local MASTER_WRIT_TRAITS =
{
    [1]  = "|H0:item:23203:30:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",  -- Powered, Chysolite
    [2]  = "|H0:item:23204:30:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",  -- Charged, Amethyst
    [3]  = "|H0:item:4486:30:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",   -- Precise, Ruby
    [4]  = "|H0:item:810:30:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",    -- Infused, Jade
    [5]  = "|H0:item:813:30:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",    -- Defending, Turquoise
    [6]  = "|H0:item:23165:30:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",  -- Training, Carnelian
    [7]  = "|H0:item:23149:30:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",  -- Sharpened, Fire Opal
    [8]  = "|H0:item:16291:30:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",  -- Decisive, Citrine
    [11] = "|H0:item:4456:30:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",   -- Sturdy, Quartz
    [12] = "|H0:item:23219:30:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",  -- Impenetrable, Diamond
    [13] = "|H0:item:30221:30:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",  -- Reinforced, Sardonyx
    [14] = "|H0:item:23221:30:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",  -- Well-Fitted, Almandine
    [15] = "|H0:item:4442:30:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",   -- Training, Emerald
    [16] = "|H0:item:30219:30:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",  -- Infused, Bloodstone
    [17] = "|H0:item:23171:30:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",  -- Invigorating, Garnet
    [18] = "|H0:item:23173:30:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",  -- Divines, Sapphire
    [21] = "|H0:item:135156:30:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h", -- Healthy, Antimony
    [22] = "|H0:item:135155:30:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h", -- Arcane, Cobalt
    [23] = "|H0:item:135157:30:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h", -- Robust, Zinc
    [25] = "|H0:item:56862:30:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",  -- Nirnhoned, Fortified Nirncrux
    [26] = "|H0:item:56863:30:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h",  -- Nirnhoned, Potent Nirncrux
    [28] = "|H0:item:139412:30:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h", -- Swift, Gilding Wax
    [29] = "|H0:item:139413:30:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h", -- Harmony, Dibellium
    [30] = "|H0:item:139409:30:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h", -- Triune, Dawn-Prism
    [31] = "|H0:item:139414:30:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h", -- Bloodthirsty, Slaughterstone
    [32] = "|H0:item:139410:30:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h", -- Protective, Titanium
    [33] = "|H0:item:139411:30:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h", -- Infused, Aurbic Amber
}


function ArkadiusTradeToolsSales:GetMasterWritComponents(itemLink)
    if ((not self:IsItemLink(itemLink) or (GetItemLinkItemType(itemLink) ~= ITEMTYPE_MASTER_WRIT))) then
        return {}
    end

    local itemId, writ1, writ2, quality, writ4, trait, style = itemLink:match(".+:item:(%d+):%d+:%d+:%d+:%d+:%d+:(%d+):(%d+):(%d+):(%d+):(%d+):(%d+):")
    itemId = tonumber(itemId)
    writ1 = tonumber(writ1)
    writ2 = tonumber(writ2)
    quality = tonumber(quality)
    writ4 = tonumber(writ4)
    trait = tonumber(trait)
    style = tonumber(style)

    local writType = MASTER_WRIT_TYPES[itemId]

    if (writType == nil) then
        --d("ATT: Unknown master writ item id " .. itemId)

        return {}
    end

    local components = {}
    local component

    if ((writType == MASTER_WRIT_TYPE_BLACKSMITHING) or (writType == MASTER_WRIT_TYPE_TAILORING) or (writType == MASTER_WRIT_TYPE_WOODWORKING) or (writType == MASTER_WRIT_TYPE_JEWELRY)) then
        --- writ1 = item type ---
        --- writ2 = item class ---
        component = {}
        component.itemLink = MASTER_WRIT_BASE_MATERIAL[writ2]
        component.quantity = MASTER_WRIT_BASE_MATERIAL_QUANTITY[writ1]
        table.insert(components, component)

        if (writType ~= MASTER_WRIT_TYPE_JEWELRY) then
            component = {}
            component.itemLink = MASTER_WRIT_STYLES[style]
            component.quantity = 1
            table.insert(components, component)
        end

        component = {}
        component.itemLink = MASTER_WRIT_TRAITS[trait]
        component.quantity = 1
        table.insert(components, component)

        for i = 2, quality do
            component = {}
            component.itemLink = MASTER_WRIT_TEMPERS[writType][i]
            component.quantity = MASTER_WRIT_TEMPERS_QUANTITY[writType][i]
            table.insert(components, component)
        end
    end

    --- validate all components ---
    for i = 1, #components do
        if ((components[i].itemLink == nil) or (components[i].quantity == nil)) then
            return {}
        end
    end
    
    return components
end
