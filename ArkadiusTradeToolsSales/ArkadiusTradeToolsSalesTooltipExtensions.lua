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

function ArkadiusTradeToolsSales.TooltipExtensions:Install(settings)
    if (self.isInstalled) then
        return
    end

    Settings = settings
    Settings.days = Settings.days or 10

    self.itemTooltip = CreateControlFromVirtual("ArkadiusTradeToolsSalesItemTooltip", GuiRoot, "ArkadiusTradeToolsSalesItemTooltip")
    self.popupTooltip = CreateControlFromVirtual("ArkadiusTradeToolsSalesPopupTooltip", GuiRoot, "ArkadiusTradeToolsSalesPopupTooltip")

    self.isInstalled = true

    self:SetDays(Settings.days)
end

function ArkadiusTradeToolsSales.TooltipExtensions:SetDays(days)
    if (not self.isInstalled) then
        return
    end

    self.itemTooltip:SetDays(days)
    self.popupTooltip:SetDays(days)
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
    self.itemListControl = GetControl(control, "ItemList")

    local function UpdateTooltip(tooltip, itemLink)
        if ((itemLink) and (itemLink ~= "")) then
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
    if (not itemLink) then
        return
    end

local mss = GetGameTimeMilliseconds()
    itemLink = itemLink:gsub("H1:", "H0:")

    --- Clear crafted flag ---
    local subString1 = itemLink:match("|H%d:item:%d+:%d+:%d+:%d+:%d+:%d+:%d+:%d+:%d+:%d+:%d+:%d+:%d+:%d+:%d+:%d+:")
    local subString2 = itemLink:match(":%d+:%d+:%d+:%d+|h|h")
    itemLink = subString1 .. "0" .. subString2

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

            self.graphControl.object:SetRange(GetTimeStamp() - self.days * self.SECONDS_IN_DAY, GetTimeStamp(), minPrice, maxPrice)
            self.graphControl.object:SetXLabels(-self.days .. " " .. L["ATT_STR_DAYS"], -self.days / 2 .. " " .. L["ATT_STR_DAYS"], L["ATT_STR_NOW"])
            self.graphControl.object:SetYLabels(ZO_LocalizeDecimalNumber(math.attRound(maxPrice, 2)) .. " |t16:16:EsoUI/Art/currency/currency_gold.dds|t", "", ZO_LocalizeDecimalNumber(math.attRound(minPrice, 2)) .. " |t16:16:EsoUI/Art/currency/currency_gold.dds|t")
        end

        for _, sale in pairs(sales) do
            averagePrice = averagePrice + sale.price
            quantity = quantity + sale.quantity
if (link == itemLink) then
    if (not guildColors[sale.guildName]) then
        guildColors[sale.guildName] = ArkadiusTradeTools:GetGuildColor(sale.guildName)
    end

    self.graphControl.object:AddDot(sale.timeStamp, sale.price / sale.quantity, guildColors[sale.guildName])
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

    if (#masterList == 0) then
        self.itemListControl:SetHeight(47)
	else
        self.itemListControl:SetHeight(31 + #masterList * 16)
    end

    self.list:SetMasterList(masterList)
    self.list:RefreshData()
local mse = GetGameTimeMilliseconds()
--d("UpdateStatistics: " .. mse - mss .. " ms")
end
