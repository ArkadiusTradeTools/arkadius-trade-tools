local ArkadiusTradeToolsSales = ArkadiusTradeTools.Modules.Sales
local L = ArkadiusTradeToolsSales.Localization
local Settings

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
    local itemLinkControl = GetControl(control, "ItemLink")
    itemLinkControl:SetText(data.itemLink)

    local averagePriceControl = GetControl(control, "AveragePrice")
    averagePriceControl:SetText(ZO_LocalizeDecimalNumber(data.averagePrice) .. " |t16:16:EsoUI/Art/currency/currency_gold.dds|t")
    averagePriceControl.normalColor = ZO_ColorDef:New(1, 1, 1)

    local numberSalesControl = GetControl(control, "NumberSales")
    numberSalesControl:SetText(ZO_LocalizeDecimalNumber(data.numberSales))
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

    self:Enable(Settings.enabled)
end

function ArkadiusTradeToolsSales.TooltipExtensions:Enable(enable)
    if (enable) then
        if (self.itemTooltip == nil) then
            self.itemTooltip = CreateControlFromVirtual("ArkadiusTradeToolsSalesItemTooltip", GuiRoot, "ArkadiusTradeToolsSalesItemTooltip")
        end

        if (self.popupTooltip == nil) then
            self.popupTooltip = CreateControlFromVirtual("ArkadiusTradeToolsSalesPopupTooltip", GuiRoot, "ArkadiusTradeToolsSalesPopupTooltip")
        end

        self:EnableGraph(Settings.graphEnabled)
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

        local graph = GetControl(tooltip, "Graph")

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

    Settings.graphEnabled = enable
end

function ArkadiusTradeToolsSales.TooltipExtensions:IsGraphEnabled()
    return Settings.graphEnabled
end

function ArkadiusTradeToolsSales.TooltipExtensions:SetDays(days)
    if (self.itemTooltip) then
        self.itemTooltip:SetDays(days)
    end

    if (self.popupTooltip) then
        self.popupTooltip:SetDays(days)
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

    self.list = TooltipExtensionList:New(GetControl(control, "ItemList"), self.tooltip)
    self.statsControl = GetControl(control, "Stats")
    self.graphControl = GetControl(control, "Graph")
    self.priceControl = GetControl(control, "Price")

    local function UpdateTooltip(tooltip, itemLink)
        if ((Settings.enabled) and (ArkadiusTradeToolsSales:IsItemLink(itemLink))) then
            tooltip:AddControl(control, 0, false)
            control:SetAnchor(CENTER)
            control:SetHidden(false)
            self.currentItemLink = itemLink
            self:UpdateStatistics(itemLink)
        end
    end

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

    --ZO_Menus:SetDrawLayer(4)
    ZO_Menus:SetDrawLevel(PopupTooltipTopLevel:GetDrawLevel() + 1)
end

function ArkadiusTradeToolsSales.TooltipExtension:GetItemSalesInformation(itemLink, fromTimeStamp)
    return ArkadiusTradeToolsSales:GetItemSalesInformation(itemLink, fromTimeStamp, true)
end

function ArkadiusTradeToolsSales.TooltipExtension:SetDays(days)
    local daysControl = GetControl(self.control, "Days")
    daysControl.slider:SetValue(days)

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
    if (not ArkadiusTradeToolsSales:IsItemLink(itemLink)) then
        return
    end

    itemLink = ArkadiusTradeToolsSales:NormalizeItemLink(itemLink)

    local itemSales = self:GetItemSalesInformation(itemLink, GetTimeStamp() - self.days * self.SECONDS_IN_DAY)
    local itemQuality = GetItemLinkQuality(itemLink)
    local itemType = GetItemLinkItemType(itemLink)
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
                if (price > maxPrice) then maxPrice = price end
            end

            if (Settings.graphEnabled) then
                self.graphControl.object:SetRange(GetTimeStamp() - self.days * self.SECONDS_IN_DAY, GetTimeStamp(), minPrice, maxPrice)
                self.graphControl.object:SetXLabels(-self.days .. " " .. L["ATT_STR_DAYS"], -self.days / 2 .. " " .. L["ATT_STR_DAYS"], L["ATT_STR_NOW"])
                self.graphControl.object:SetYLabels(ZO_LocalizeDecimalNumber(math.attRound(maxPrice, 2)) .. " |t16:16:EsoUI/Art/currency/currency_gold.dds|t", "", ZO_LocalizeDecimalNumber(math.attRound(minPrice, 2)) .. " |t16:16:EsoUI/Art/currency/currency_gold.dds|t")
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
            averagePrice = math.attRound(averagePrice / quantity, 2)
        else
            averagePrice = 0
        end

--        if (itemType == ITEMTYPE_MASTER_WRIT) then
--            local vouchers = tonumber(GenerateMasterWritRewardText(link):match("%d+"))
--            averagePrice = averagePrice * vouchers
--        end

        if (link == itemLink) then
            if (quantity > 0) then
                if (itemType == ITEMTYPE_MASTER_WRIT) then
                    local vouchers = tonumber(GenerateMasterWritRewardText(link):match("%d+"))

                    priceString = string.format(L["ATT_FMTSTR_TOOLTIP_PRICE_MASTER_WRIT"], ZO_LocalizeDecimalNumber(averagePrice * vouchers) .. " |t16:16:EsoUI/Art/currency/currency_gold.dds|t", ZO_LocalizeDecimalNumber(averagePrice) .. " |t16:16:EsoUI/Art/currency/currency_gold.dds|t")
                    statsString = string.format(L["ATT_FMTSTR_TOOLTIP_STATS_MASTER_WRIT"], ZO_LocalizeDecimalNumber(#sales), ZO_LocalizeDecimalNumber(quantity))
                else
                    priceString = string.format(L["ATT_FMTSTR_TOOLTIP_PRICE_ITEM"], ZO_LocalizeDecimalNumber(averagePrice) .. " |t16:16:EsoUI/Art/currency/currency_gold.dds|t")
                    statsString = string.format(L["ATT_FMTSTR_TOOLTIP_STATS_ITEM"], ZO_LocalizeDecimalNumber(#sales), ZO_LocalizeDecimalNumber(quantity))
                end
            end
        else
            table.insert(masterList, {itemLink = link, averagePrice = averagePrice, numberSales = #sales})
        end
    end

    self.statsControl:SetText(statsString)
    self.priceControl:SetText(priceString)
    --self.priceControl:SetText(ZO_LocalizeDecimalNumber(averagePrice) .. " |t16:16:EsoUI/Art/currency/currency_gold.dds|t")

    local h = 320
    if (#masterList > 0) then
        h = 304 + #masterList * 16
    end

    if (not Settings.graphEnabled) then
        h = h - 150
	end

    self.control:SetHeight(h)
    self.list:SetMasterList(masterList)
    self.list:RefreshData()
end
