local ArkadiusTradeToolsSales = ArkadiusTradeTools.Modules.Sales
local L = ArkadiusTradeToolsSales.Localization
local Settings
local attRound = math.attRound

--------------------------------------------------------
-------------------- List functions --------------------
--------------------------------------------------------
local TooltipExtensionList = ZO_SortFilterList:Subclass()

function TooltipExtensionList:New(control, tooltip)
    local object = ZO_SortFilterList.New(self, control)
    object.tooltip = tooltip

    return object
end

function TooltipExtensionList:Initialize(control)
    ZO_SortFilterList.Initialize(self, control)
    self.masterList = {}

    ZO_ScrollList_AddDataType(self.list, 1, "ArkadiusTradeToolsSalesTooltipExtensionItemListRow", 16, function(control, data) self:SetupItemRow(control, data) end)
    ZO_ScrollList_AddDataType(self.list, 2, "ArkadiusTradeToolsSalesTooltipExtensionItemListEmptyRow", 16, function(control, data) self:SetupEmptyRow(control, data) end)
end

function TooltipExtensionList:SetMasterList(masterList)
    self.masterList = masterList
end

function TooltipExtensionList:FilterScrollList()
    local scrollData = ZO_ScrollList_GetDataList(self.list)
    ZO_ClearNumericallyIndexedTable(scrollData)

    if (#self.masterList == 0) then
        table.insert(scrollData, ZO_ScrollList_CreateDataEntry(2, {}))
    else
        for i = 1, #self.masterList do
            table.insert(scrollData, ZO_ScrollList_CreateDataEntry(1, self.masterList[i]))
	    end
    end
end

function TooltipExtensionList:SortScrollList()
    local scrollData = ZO_ScrollList_GetDataList(self.list)

    local Sort = function(entry1, entry2)
        itemQuality1 = GetItemLinkQuality(entry1.data.itemLink)
        itemQuality2 = GetItemLinkQuality(entry2.data.itemLink)

        if (itemQuality1 < itemQuality2) then
            return true
		end

        return false
    end

    table.sort(scrollData, Sort)
end

function TooltipExtensionList:SetupItemRow(control, data)
    control.data = data
    local itemLinkControl = control:GetNamedChild("ItemLink")
    itemLinkControl:SetText(data.itemLink)

    local averagePriceControl = control:GetNamedChild("AveragePrice")
    averagePriceControl:SetText(ArkadiusTradeTools:LocalizeDezimalNumber(data.averagePrice) .. " |t16:16:EsoUI/Art/currency/currency_gold.dds|t")
    averagePriceControl.normalColor = ZO_ColorDef:New(1, 1, 1)

    local numberSalesControl = control:GetNamedChild("NumberSales")
    numberSalesControl:SetText(ArkadiusTradeTools:LocalizeDezimalNumber(data.numberSales))
    numberSalesControl.normalColor = ZO_ColorDef:New(1, 1, 1)

    if (self.tooltip ~= ItemTooltip) then
        control:GetNamedChild("ItemLink"):SetMouseEnabled(true)
    end

    ZO_SortFilterList.SetupRow(self, control, data)
end

function TooltipExtensionList:SetupEmptyRow(control, data)
    ZO_SortFilterList.SetupRow(self, control, data)
end

----------------------------------------------------------------------------
ArkadiusTradeToolsSales.TooltipExtensions = {}

function ArkadiusTradeToolsSales.TooltipExtensions:Initialize(settings)
    Settings = settings
    if (Settings.enabled == nil) then Settings.enabled = true end
    Settings.days = Settings.days or 10
    if (Settings.graphEnabled == nil) then Settings.graphEnabled = true end
    if (Settings.craftingEnabled == nil) then Settings.craftingEnabled = true end

    self:Enable(Settings.enabled)
end

function ArkadiusTradeToolsSales.TooltipExtensions:Enable(enable)
    if (enable) then
        -- When these tooltips are initialized, they hook into their respective ESOUI tooltips from their templates.
        -- This means any initialization changes need to be handled in the .xml file.
        if (self.itemTooltip == nil) then
            self.itemTooltip = CreateControlFromVirtual("ArkadiusTradeToolsSalesItemTooltip", GuiRoot, "ArkadiusTradeToolsSalesItemTooltip")
        end

        if (self.popupTooltip == nil) then
            self.popupTooltip = CreateControlFromVirtual("ArkadiusTradeToolsSalesPopupTooltip", GuiRoot, "ArkadiusTradeToolsSalesPopupTooltip")
        end

        if (self.provisionerTooltip == nil) then
            self.provisionerTooltip = CreateControlFromVirtual("ArkadiusTradeToolsSalesProvisionerTooltip", GuiRoot, "ArkadiusTradeToolsSalesProvisionerTooltip")
        end

        self:EnableGraph(Settings.graphEnabled)
        self:EnableCrafting(Settings.craftingEnabled)
        self:SetDays(Settings.days)
    end

    Settings.enabled = enable
end

function ArkadiusTradeToolsSales.TooltipExtensions:IsEnabled()
    return Settings.enabled
end

function ArkadiusTradeToolsSales.TooltipExtensions:EnableGraph(enable)
    local function SetGraphVisibility(tooltip, hidden)
        if (tooltip == nil) then
            return
        end

        local graph = tooltip:GetNamedChild("Graph")

        if (hidden) then
            tooltip:SetHeight(170)
            graph:SetHeight(1)
            graph:SetHidden(true)
        else
            tooltip:SetHeight(320)
            graph:SetHeight(150)
            graph:SetHidden(false)
        end
    end

    SetGraphVisibility(self.itemTooltip, not enable)
    SetGraphVisibility(self.popupTooltip, not enable)
    SetGraphVisibility(self.provisionerTooltip, not enable)

    Settings.graphEnabled = enable
end

function ArkadiusTradeToolsSales.TooltipExtensions:EnableCrafting(enable)
    --- Do more things? ---
    Settings.craftingEnabled = enable
end

function ArkadiusTradeToolsSales.TooltipExtensions:IsGraphEnabled()
    return Settings.graphEnabled
end

function ArkadiusTradeToolsSales.TooltipExtensions:IsCraftingEnabled()
    return Settings.craftingEnabled
end

function ArkadiusTradeToolsSales.TooltipExtensions:SetDays(days)
    if (self.itemTooltip) then
        self.itemTooltip:SetDays(days)
    end

    if (self.popupTooltip) then
        self.popupTooltip:SetDays(days)
    end

    if (self.provisionerTooltip) then
        self.provisionerTooltip:SetDays(days)
    end
end
----------------------------------------------------------------------------
ArkadiusTradeToolsSales.TooltipExtension = ZO_Object:Subclass()

function ArkadiusTradeToolsSales.TooltipExtension:New(control, tooltip, days)
    local object = ZO_Object.New(self)
    object.control = control
    object.tooltip = tooltip
    object.days = days or 10
    object.SECONDS_IN_DAY = 60 * 60 * 24
    object.days = days or 10

    object:Initialize()

    function control.SetDays(_, days)
        object:SetDays(days)
    end

    function control.GetDays()
        return object:GetDays()
    end

    return object
end

function ArkadiusTradeToolsSales.TooltipExtension:Initialize()
    local control = self.control
    self.daysControl = control:GetNamedChild("Days")
    self.listControl = control:GetNamedChild("ItemList")
    self.list = TooltipExtensionList:New(self.listControl, self.tooltip)
    self.statsControl = control:GetNamedChild("Stats")
    self.graphControl = control:GetNamedChild("Graph")
    self.priceControl = control:GetNamedChild("Price")
    self.craftingControl = control:GetNamedChild("CraftingInfo")

    local function UpdateTooltip(tooltip, itemLink)
        if ((Settings.enabled) and (ArkadiusTradeToolsSales:IsItemLink(itemLink))) then
            tooltip:AddControl(control, 0, false)
            control:SetAnchor(CENTER)
            control:SetHidden(false)
            self.currentItemLink = itemLink
            self:UpdateStatistics(itemLink)
        end
    end

    -- These are all of the handlers for the various different tooltip usages.
    ---
    local TooltipSetLink = self.tooltip.SetLink

    function self.tooltip.SetLink(tooltip, itemLink)
        TooltipSetLink(tooltip, itemLink)
        UpdateTooltip(tooltip, itemLink)
    end
    ---
    local TooltipSetBagItem = self.tooltip.SetBagItem

    function self.tooltip.SetBagItem(tooltip, bag, index)
        local itemLink = GetItemLink(bag, index)

        TooltipSetBagItem(tooltip, bag, index)
        UpdateTooltip(tooltip, itemLink)
    end
    ---
    local TooltipSetLootItem = self.tooltip.SetLootItem

    function self.tooltip.SetLootItem(tooltip, lootId)
        local itemLink = GetLootItemLink(lootId)

        TooltipSetLootItem(tooltip, lootId)
        UpdateTooltip(tooltip, itemLink)
    end
    ---
    local TooltipSetWornItem = self.tooltip.SetWornItem

    function self.tooltip.SetWornItem(tooltip, index)
        local itemLink = GetItemLink(BAG_WORN, index)

        TooltipSetWornItem(tooltip, index)
        UpdateTooltip(tooltip, itemLink)
    end
	---
    local TooltipSetAttachedMailItem = self.tooltip.SetAttachedMailItem

    function self.tooltip.SetAttachedMailItem(tooltip, id, index)
        local itemLink = GetAttachedItemLink(id, index)

        TooltipSetAttachedMailItem(tooltip, id, index)
        UpdateTooltip(tooltip, itemLink)
    end
    ---
    local TooltipSetStoreItem = self.tooltip.SetStoreItem

    function self.tooltip.SetStoreItem(tooltip, storeIndex)
        local itemLink = GetStoreItemLink(storeIndex)

        TooltipSetStoreItem(tooltip, storeIndex)
        UpdateTooltip(tooltip, itemLink)
    end
    ---
    local TooltipSetTradeItem = self.tooltip.SetTradeItem

    function self.tooltip.SetTradeItem(tooltip, tradeType, tradeIndex)
        local itemLink = GetTradeItemLink(tradeType, tradeIndex)

        TooltipSetTradeItem(tooltip, tradeType, tradeIndex)
        UpdateTooltip(tooltip, itemLink)
    end
    ---
    local TooltipSetTradingHouseItem = self.tooltip.SetTradingHouseItem

    function self.tooltip.SetTradingHouseItem(tooltip, tradingHouseIndex)
        local itemLink = GetTradingHouseSearchResultItemLink(tradingHouseIndex)

        TooltipSetTradingHouseItem(tooltip, tradingHouseIndex)
        UpdateTooltip(tooltip, itemLink)
    end
    ---
    local TooltipSetTradingHouseListing = self.tooltip.SetTradingHouseListing

    function self.tooltip.SetTradingHouseListing(tooltip, tradingHouseListingIndex)
        local itemLink =  GetTradingHouseListingItemLink(tradingHouseListingIndex)

        TooltipSetTradingHouseListing(tooltip, tradingHouseListingIndex)
        UpdateTooltip(tooltip, itemLink)
    end
    ---
    local TooltipSetProvisionerResultItem = self.tooltip.SetProvisionerResultItem

    function self.tooltip.SetProvisionerResultItem(tooltip, recipeListIndex, recipeIndex)
        TooltipSetProvisionerResultItem(tooltip, recipeListIndex, recipeIndex)
        local itemLink = GetRecipeResultItemLink(recipeListIndex, recipeIndex)
        UpdateTooltip(tooltip, itemLink)
        -- This is so the right-click menu works for furniture and provisioning.
        -- The UI doesn't set the link at all, so we're gonna set it here.
        self.tooltip.lastLink = itemLink
    end
    ---

    -- This allows us to force the context menu above the tooltip
    -- without screwing up the draw level for other menus
	ZO_PreHookHandler(PopupTooltip, 'OnShow', function(self, hidden)
        ZO_Menus:SetDrawLevel(PopupTooltipTopLevel:GetDrawLevel() + 1)
    end)
	ZO_PreHookHandler(PopupTooltip, 'OnHide', function(self, hidden)
        ZO_Menus:SetDrawLevel(PopupTooltipTopLevel:GetDrawLevel() - 1)
    end)
end

function ArkadiusTradeToolsSales.TooltipExtension:GetItemSalesInformation(itemLink, fromTimeStamp)
    return ArkadiusTradeToolsSales:GetItemSalesInformation(itemLink, fromTimeStamp, true)
end

function ArkadiusTradeToolsSales.TooltipExtension:SetDays(days)
    self.daysControl.slider:SetValue(days)

    self.days = days
    Settings.days = days

    if (self.tooltip:IsHidden() == false) then
        self:UpdateStatistics(self.currentItemLink)
    end
end

function ArkadiusTradeToolsSales.TooltipExtension:GetDays()
    return self.days
end

function ArkadiusTradeToolsSales.TooltipExtension:UpdateStatistics(itemLink)
    itemLink = ArkadiusTradeToolsSales:NormalizeItemLink(itemLink)
    if itemLink == nil then return end

    local itemSales = self:GetItemSalesInformation(itemLink, GetTimeStamp() - self.days * self.SECONDS_IN_DAY)
    local itemQuality = GetItemLinkQuality(itemLink)
    local itemType = GetItemLinkItemType(itemLink)
    local bindType = GetItemLinkBindType(itemLink)
    local priceString = L["ATT_STR_NO_PRICE"]
    local statsString = L["ATT_FMTSTR_TOOLTIP_NO_SALES"]
    local averagePrice = 0
    local quantity
    local vouchers = 0
    local masterList = {}
    local guildColors = {}

    self.graphControl.object:Clear()

    for link, sales in pairs(itemSales) do
        averagePrice = 0
        quantity = 0

        if (link == itemLink) then
            local minPrice = math.huge
            local maxPrice = 0
            local price

            for _, sale in pairs(sales) do
                price = sale.price / sale.quantity

                if (price < minPrice) then minPrice = price end
                if ((price > maxPrice) and (price ~= math.huge)) then maxPrice = price end
            end

            --- There are no sales for this item ---
            if (minPrice == math.huge) then
                minPrice = 0
            end

            if (Settings.graphEnabled) then
                self.graphControl.object:SetRange(GetTimeStamp() - self.days * self.SECONDS_IN_DAY, GetTimeStamp(), minPrice, maxPrice)
                self.graphControl.object:SetXLabels(-self.days .. " " .. L["ATT_STR_DAYS"], -self.days / 2 .. " " .. L["ATT_STR_DAYS"], L["ATT_STR_NOW"])
                self.graphControl.object:SetYLabels(ArkadiusTradeTools:LocalizeDezimalNumber(attRound(maxPrice, 2)) .. " |t16:16:EsoUI/Art/currency/currency_gold.dds|t", "", ArkadiusTradeTools:LocalizeDezimalNumber(attRound(minPrice, 2)) .. " |t16:16:EsoUI/Art/currency/currency_gold.dds|t")
            end
        end

        for _, sale in pairs(sales) do
            averagePrice = averagePrice + sale.price
            quantity = quantity + sale.quantity
            if (link == itemLink) then
                if (not guildColors[sale.guildName]) then
                    guildColors[sale.guildName] = ArkadiusTradeTools:GetGuildColor(sale.guildName)
                end

                if (Settings.graphEnabled) then
                    self.graphControl.object:AddDot(sale.timeStamp, sale.price / sale.quantity, guildColors[sale.guildName])
                end
            end
        end

        if (quantity > 0) then
            averagePrice = attRound(averagePrice / quantity, 2)
        else
            averagePrice = 0
        end

        if (link == itemLink) then
            if (quantity > 0) then
                if (itemType == ITEMTYPE_MASTER_WRIT) then
                    local vouchers = ArkadiusTradeToolsSales:GetVoucherCount(itemLink)

                    priceString = string.format(L["ATT_FMTSTR_TOOLTIP_PRICE_MASTER_WRIT"], ArkadiusTradeTools:LocalizeDezimalNumber(averagePrice * vouchers) .. " |t16:16:EsoUI/Art/currency/currency_gold.dds|t", ArkadiusTradeTools:LocalizeDezimalNumber(averagePrice) .. " |t16:16:EsoUI/Art/currency/currency_gold.dds|t")
                    statsString = string.format(L["ATT_FMTSTR_TOOLTIP_STATS_MASTER_WRIT"], ArkadiusTradeTools:LocalizeDezimalNumber(#sales), ArkadiusTradeTools:LocalizeDezimalNumber(quantity))
                else
                    priceString = string.format(L["ATT_FMTSTR_TOOLTIP_PRICE_ITEM"], ArkadiusTradeTools:LocalizeDezimalNumber(averagePrice) .. " |t16:16:EsoUI/Art/currency/currency_gold.dds|t")
                    statsString = string.format(L["ATT_FMTSTR_TOOLTIP_STATS_ITEM"], ArkadiusTradeTools:LocalizeDezimalNumber(#sales), ArkadiusTradeTools:LocalizeDezimalNumber(quantity))
                end
            end
        else
            table.insert(masterList, {itemLink = link, averagePrice = averagePrice, numberSales = #sales})
        end
    end

    self.statsControl:SetText(statsString)
    self.priceControl:SetText(priceString)
    --self.priceControl:SetText(ArkadiusTradeTools:LocalizeDezimalNumber(averagePrice) .. " |t16:16:EsoUI/Art/currency/currency_gold.dds|t")

    local height = 31
    if (#masterList > 0) then
        height = height + #masterList * 16
    end

    self.listControl:SetHeight(height)
    self.list:SetMasterList(masterList)
    self.list:RefreshData()

    local craftingComponentPrices = {}

    if (Settings.craftingEnabled) then
        craftingComponentPrices = ArkadiusTradeToolsSales:GetCrafingComponentPrices(itemLink, GetTimeStamp() - self.days * self.SECONDS_IN_DAY)
        self.craftingControl.SetItemPrices(craftingComponentPrices)
    end


    self.daysControl:SetHidden(false)
    self.listControl:SetHidden(false)
    self.statsControl:SetHidden(false)
    self.graphControl:SetHidden(not Settings.graphEnabled)
    self.priceControl:SetHidden(false)
    self.craftingControl:SetHidden(true)

    if ((bindType == BIND_TYPE_ON_PICKUP) or (bindType == BIND_TYPE_ON_PICKUP_BACKPACK)) then
        self.daysControl:SetHidden(true)
        self.listControl:SetHidden(true)
        self.statsControl:SetHidden(true)
        self.graphControl:SetHidden(true)
        self.priceControl:SetHidden(true)
    end

    if ((itemType == ITEMTYPE_MASTER_WRIT) and (#craftingComponentPrices > 0)) then
        self.daysControl:SetHidden(false)
        self.craftingControl:SetHidden(not Settings.craftingEnabled)
    end

    if (#masterList == 0) then
        self.listControl:SetHidden(true)
    end

    --- Rearrange tooltip elements based on their visibilities ---
    local anchorTo = self.control
    local anchorTopLeft = TOPLEFT
    local anchorTopRight = TOPRIGHT
    height = 0

    local elements = { 
        self.priceControl,
        self.graphControl,
        self.statsControl,
        self.listControl,
        self.craftingControl,
        self.daysControl
    }

    for i = 1, #elements do
        if (elements[i]:IsHidden() == false) then
            elements[i]:ClearAnchors()
            elements[i]:SetAnchor(TOPLEFT, anchorTo, anchorTopLeft, 0, 10)
            elements[i]:SetAnchor(TOPRIGHT, anchorTo, anchorTopRight, 0, 10)
            anchorTo = elements[i]
            anchorTopLeft = BOTTOMLEFT
            anchorTopRight = BOTTOMRIGHT
            height = height + elements[i]:GetHeight() + 10
        end
    end

    self.control:SetHeight(height)
end

--- Small hack to create text string for key bindings ---
ZO_CreateStringId("SI_BINDING_NAME_ATT_TOGGLE_POPUP_TOOLTIP", L["ATT_STR_OPEN_POPUP_TOOLTIP"])
ZO_CreateStringId("SI_BINDING_NAME_ATT_STR_ENABLE_TOOLTIP_EXTENSIONS", L["ATT_STR_ENABLE_TOOLTIP_EXTENSIONS"])
ZO_CreateStringId("SI_BINDING_NAME_ATT_STR_ENABLE_TOOLTIP_EXTENSIONS_GRAPH", L["ATT_STR_ENABLE_TOOLTIP_EXTENSIONS_GRAPH"])
