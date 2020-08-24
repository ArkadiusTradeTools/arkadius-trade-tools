local ArkadiusTradeToolsSales = ArkadiusTradeTools.Modules.Sales
local L = ArkadiusTradeToolsSales.Localization
local Settings
local SECONDS_IN_DAY = 86400

ArkadiusTradeToolsSales.InventoryExtensions = {
    sortByControls = {
        [ZO_CraftBagSortBy] = INVENTORY_CRAFT_BAG,
        [ZO_PlayerInventorySortBy] = INVENTORY_BACKPACK,
        [ZO_PlayerBankSortBy] = INVENTORY_BANK,
        [ZO_GuildBankSortBy] = INVENTORY_GUILD_BANK,
        [ZO_HouseBankSortBy] = INVENTORY_HOUSE_BANK
    },
    craftingInventories = {
        ["ZO_SmithingTopLevelDeconstructionPanelInventory"] = true,
        ["ZO_SmithingTopLevelImprovementPanelInventory"] = true,
        ["ZO_SmithingTopLevelRefinementPanelInventory"] = true,
        ["ZO_EnchantingTopLevelInventory"] = true
    },
    inventoryLists = {
        [ZO_PlayerInventoryList] = true,
        [ZO_PlayerBankBackpack] = true,
        [ZO_HouseBankBackpack] = true,
        [ZO_GuildBankBackpack] = true,
        [ZO_CraftBagList] = true,
        [ZO_SmithingTopLevelDeconstructionPanelInventoryBackpack] = true,
        [ZO_SmithingTopLevelImprovementPanelInventoryBackpack] = true,
        [ZO_SmithingTopLevelRefinementPanelInventoryBackpack] = true,
        [ZO_EnchantingTopLevelInventoryBackpack] = true
    }
}


function ArkadiusTradeToolsSales.InventoryExtensions:Initialize(settings)
    Settings = settings
    if (Settings.enabled == nil) then
        Settings.enabled = false
    end

    self:Enable(Settings.enabled)
end

local function ATT_ZO_ScrollList_Commit_Hook(list)
    if (ArkadiusTradeToolsSales.InventoryExtensions.inventoryLists[list]) then
        local scrollData = ZO_ScrollList_GetDataList(list)
        for i = 1, #scrollData do
            local data = scrollData[i].data
            local bagId = data.bagId
            local slotIndex = data.slotIndex
            local itemLink = bagId and GetItemLink(bagId, slotIndex) or GetItemLink(slotIndex)
            if not (data.marketValue and data.marketValueStackCount == data.stackCount and data.marketValueItemLink == itemLink) then
                if itemLink then
                    local avgPrice = ArkadiusTradeToolsSales.InventoryExtensions:GetPrice(itemLink)
                    if avgPrice > 0 then
                        data.marketValue = math.floor(avgPrice * data.stackCount + 0.5)
                        data.marketValueStackCount = data.stackCount
                        data.marketValueItemLink = itemLink
                        data.ATT_PRICE = true
                    else
                        data.marketValue = (data.stackCount or 0) * (data.sellPrice or 0)
                    end
                end
            end
        end
    end

    return false
end

function ArkadiusTradeToolsSales.InventoryExtensions:Enable(enable)
    if (enable) then
        ZO_PreHook("ZO_ScrollList_Commit", ATT_ZO_ScrollList_Commit_Hook)
        self:EnableMarketValue()
    end

    Settings.enabled = enable
end

function ArkadiusTradeToolsSales.InventoryExtensions:IsEnabled()
    return Settings.enabled
end

function ArkadiusTradeToolsSales.InventoryExtensions:GetPrice(itemLink)
    itemLink = ArkadiusTradeToolsSales:NormalizeItemLink(itemLink)
    local days = ArkadiusTradeToolsSalesData.settings.tooltips.days
    local startingDate = GetTimeStamp() - (SECONDS_IN_DAY * days)
    local itemPrice = ArkadiusTradeToolsSales:GetAveragePricePerItem(itemLink, startingDate)
    return itemPrice
end

function ArkadiusTradeToolsSales.InventoryExtensions:HookCraftingInventory(panelInventoryKey)
    local backpackKey = panelInventoryKey .. "Backpack"
    local originalCall = _G[backpackKey].dataTypes[1].setupCallback
    _G[backpackKey].dataTypes[1].setupCallback = function(control, slot)
        originalCall(control, slot)
        self:ShowMarketValue(control, slot)
    end
end

function ArkadiusTradeToolsSales.InventoryExtensions:EnableMarketValue()
    self.SetUpCustomSortKeys()
    for _sortByControl, inventoryKey in pairs(self.sortByControls) do
        self.AddSortByMarketValue(inventoryKey)
    end

    for k, item in pairs(PLAYER_INVENTORY.inventories) do
        local listView = item.listView
        if listView and listView.dataTypes and listView.dataTypes[1] then
            local originalCall = listView.dataTypes[1].setupCallback
            listView.dataTypes[1].setupCallback = function(control, slot)
                originalCall(control, slot)
                self:ShowMarketValue(control, slot)
            end
        end
    end

    for key, enabled in pairs(self.craftingInventories) do
        if enabled then
            self:HookCraftingInventory(key)
            self.AddCraftingSortByMarketValue(_G[key])
        end
    end
end

local options = ZO_ShallowTableCopy(ITEM_SLOT_CURRENCY_OPTIONS)
options.color = ZO_ColorDef:New(238, 238, 51)

function ArkadiusTradeToolsSales.InventoryExtensions:ShowMarketValue(control, slot)
    local bagId = control.dataEntry.data.bagId
    local slotIndex = control.dataEntry.data.slotIndex
    -- Maybe use SetSortColumnHidden?
    local sellPriceControl = control:GetNamedChild("SellPrice")
    sellPriceControl:SetHidden(true)
    local marketValueControl =
        control:GetNamedChild("MarketValue") or
        CreateControlFromVirtual("$(parent)MarketValue", control, "ZO_CurrencyTemplate")
    local _, point, relTo, relPoint, offsetX, offsetY = sellPriceControl:GetAnchor()

    marketValueControl:SetAnchor(point, relTo, relPoint, offsetX, offsetY)
    marketValueControl:SetHidden(false)
    sellPriceControl:SetHidden(true)
    if control.dataEntry.data.marketValue and control.dataEntry.data.ATT_PRICE then
        local delimitedAmount = ZO_CurrencyControl_FormatCurrency(control.dataEntry.data.marketValue, false, false)
        local formattedAmount = ZO_FastFormatDecimalNumber(delimitedAmount)
        local currencyMarkup =
            "|cffdc33|u0:4:currency:" .. formattedAmount .. "|u|r|t80%:80%:/esoui/art/currency/gold_mipmap.dds|t"
        marketValueControl:SetText(currencyMarkup)
        marketValueControl:SetFont("ZoFontGameShadow")
    elseif control.dataEntry.data.marketValue then
        ZO_CurrencyControl_SetSimpleCurrency(
            marketValueControl,
            CURT_MONEY,
            control.dataEntry.data.marketValue,
            options
        )
    else
        ZO_CurrencyControl_SetSimpleCurrency(
            marketValueControl,
            CURT_MONEY,
            control.dataEntry.data.stackCount * control.dataEntry.data.sellPrice,
            options
        )
    end
end

local customSortKeys = {}

function ArkadiusTradeToolsSales.InventoryExtensions.SetUpCustomSortKeys()
    customSortKeys = ZO_Inventory_GetDefaultHeaderSortKeys()
    customSortKeys.marketValue = {tiebreaker = "stackSellPrice", tieBreakerSortOrder = ZO_SORT_ORDER_UP}
end

function ArkadiusTradeToolsSales.InventoryExtensions.AddSortByMarketValue(inventoryKey)
    local inventory = PLAYER_INVENTORY.inventories[inventoryKey]
    if inventory then
        inventory.sortHeaders:ReplaceKey("stackSellPrice", "marketValue")
        inventory.sortFunction = function(entry1, entry2)
            if entry1.typeId == entry2.typeId then
                return ZO_TableOrderingFunction(
                    entry1.data,
                    entry2.data,
                    inventory.currentSortKey,
                    customSortKeys,
                    inventory.currentSortOrder
                )
            end
            return entry1.typeId < entry2.typeId
        end
    end
end

function ArkadiusTradeToolsSales.InventoryExtensions.AddCraftingSortByMarketValue(inventory)
    local inventory = inventory.owner
    if inventory then
        inventory.sortHeaders:ReplaceKey("stackSellPrice", "marketValue")
        inventory.sortHeaders:HeaderForKey("marketValue").initialDirection = ZO_SORT_ORDER_DOWN
        inventory.sortFunction = function(entry1, entry2)
            if entry1.typeId == entry2.typeId then
                return ZO_TableOrderingFunction(
                    entry1.data,
                    entry2.data,
                    inventory.sortKey,
                    customSortKeys,
                    inventory.sortOrder
                )
            end
            return entry1.typeId < entry2.typeId
        end
    end
end
