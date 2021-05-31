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
    [153737] = MASTER_WRIT_TYPE_JEWELRY,
    [153738] = MASTER_WRIT_TYPE_JEWELRY,
    [153739] = MASTER_WRIT_TYPE_JEWELRY,
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
        -- CHAT_ROUTER:AddSystemMessage("ATT: Unknown master writ item id " .. itemId)

        return {}
    end

    local components = {}
    local component

    if ((writType == MASTER_WRIT_TYPE_BLACKSMITHING) or (writType == MASTER_WRIT_TYPE_TAILORING) or (writType == MASTER_WRIT_TYPE_WOODWORKING) or (writType == MASTER_WRIT_TYPE_JEWELRY)) then
        --- writ1 = item type ---
        --- writ2 = item class ---
        component = { itemLink = MASTER_WRIT_BASE_MATERIAL[writ2], quantity = MASTER_WRIT_BASE_MATERIAL_QUANTITY[writ1] }
        table.insert(components, component)

        if (writType ~= MASTER_WRIT_TYPE_JEWELRY) then
            component = { itemLink = GetItemStyleMaterialLink(style), quantity = 1 }
            table.insert(components, component)
        end

        component = { itemLink = MASTER_WRIT_TRAITS[trait], quantity = 1 }
        table.insert(components, component)

        for i = 2, quality do
            component = { itemLink = MASTER_WRIT_TEMPERS[writType][i], quantity = MASTER_WRIT_TEMPERS_QUANTITY[writType][i] }
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
