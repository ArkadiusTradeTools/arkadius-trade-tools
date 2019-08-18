local ArkadiusTradeToolsSales = ArkadiusTradeTools.Modules.Sales
ArkadiusTradeToolsSales.TradingHouse = {}
local L = ArkadiusTradeToolsSales.Localization
local Settings

local SECONDS_IN_DAY = 60 * 60 *24
local TRADING_HOUSE_OnPurchaseSuccess

--- Prevent the search result list to reset to top on purchase ---
local function OnPurchaseSuccess(self)
    local list = self.searchResultsList
    local value = list.scrollbar:GetValue()

    TRADING_HOUSE_OnPurchaseSuccess(self)

    list.scrollbar:SetValue(value)
end


local function TradingHouseSearchResultsSetupRow(rowControl, ...)
    if (rowControl.dataEntry) then
        local profitMarginControl = rowControl:GetNamedChild("ProfitMargin")
        local averagePriceControl = rowControl:GetNamedChild("AveragePrice")
        local nameControl = rowControl:GetNamedChild("Name")
        local itemLink = GetTradingHouseSearchResultItemLink(rowControl.dataEntry.data.slotIndex)
        local price = rowControl.dataEntry.data.purchasePrice / rowControl.dataEntry.data.stackCount
        local averagePrice = rowControl.dataEntry.data.averagePrice or 0

        if (not profitMarginControl) then
            local h = nameControl:GetHeight()

            nameControl:SetWidth(100)        -- original 342

            profitMarginControl = CreateControlFromVirtual(rowControl:GetName() .. "ProfitMargin", rowControl, "ZO_KeyboardGuildRosterRowLabel")
            profitMarginControl:SetDimensions(42, h)
            profitMarginControl:ClearAnchors()
            profitMarginControl:SetAnchor(LEFT, nameControl, RIGHT, 10)
            profitMarginControl:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)
            profitMarginControl:SetVerticalAlignment(TEXT_ALIGN_CENTER)
            profitMarginControl:SetFont("ZoFontGameShadow")

            averagePriceControl = CreateControlFromVirtual(rowControl:GetName() .. "AveragePrice", rowControl, "ZO_KeyboardGuildRosterRowLabel")
            averagePriceControl:SetDimensions(64, h)
            averagePriceControl:ClearAnchors()
            averagePriceControl:SetAnchor(LEFT, profitMarginControl, RIGHT, 10)
            averagePriceControl:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)
            averagePriceControl:SetVerticalAlignment(TEXT_ALIGN_CENTER)
            averagePriceControl:SetFont("ZoFontGameShadow")
        end

        local color = ZO_ColorDef:New(GetItemQualityColor(5))
        local margin

        if (averagePrice == 0) then
            margin = 0
        else
            margin = math.attRound((100 / averagePrice * price - 100) * (-1))
        end

        if (margin < -1.5) then color = ZO_ColorDef:New(1, 0, 0)
        elseif (margin < 20) then color = ZO_ColorDef:New(GetItemQualityColor(1))
        elseif (margin < 35) then color = ZO_ColorDef:New(GetItemQualityColor(2))
        elseif (margin < 50) then color = ZO_ColorDef:New(GetItemQualityColor(3))
        elseif (margin < 65) then color = ZO_ColorDef:New(GetItemQualityColor(4)) end

        profitMarginControl:SetText(margin .. "%")
        profitMarginControl:SetColor(color:UnpackRGBA())
        averagePriceControl:SetText(ZO_LocalizeDecimalNumber(math.attRound(averagePrice * rowControl.dataEntry.data.stackCount)))
        averagePriceControl:SetColor(color:UnpackRGBA())
    end

    --- Important to return false, so that the hooked function gets called ---
    return false
end

local function OnEvent(eventCode, responseType, result)
--    if (eventCode == EVENT_TRADING_HOUSE_SEARCH_RESULTS_RECEIVED) then
    if (eventCode == EVENT_TRADING_HOUSE_RESPONSE_RECEIVED) and
       (responseType == TRADING_HOUSE_RESULT_SEARCH_PENDING) and
       (result == TRADING_HOUSE_RESULT_SUCCESS) then

        local dataType = TRADING_HOUSE.searchResultsList.dataTypes[1]
        ZO_PreHook(dataType, "setupCallback", TradingHouseSearchResultsSetupRow)

        --EVENT_MANAGER:UnregisterForEvent(ArkadiusTradeToolsSales.NAME, EVENT_TRADING_HOUSE_SEARCH_RESULTS_RECEIVED)
        EVENT_MANAGER:UnregisterForEvent(ArkadiusTradeToolsSales.NAME, EVENT_TRADING_HOUSE_RESPONSE_RECEIVED)

        -- Small hack to refreh the list
        ZO_ScrollList_Commit(ZO_TradingHouseBrowseItemsRightPaneSearchResults)
    end
end

local function ZO_ScrollList_Commit_Hook(list)
    if (list == ZO_TradingHouseBrowseItemsRightPaneSearchResults) then
        local scrollData = ZO_ScrollList_GetDataList(list)
        local averagePrices = {}
        local itemLink

        for i = 1, #scrollData do
            itemLink = GetTradingHouseSearchResultItemLink(scrollData[i].data.slotIndex)

            if (not averagePrices[itemLink]) then
                local days = ArkadiusTradeToolsSales.TradingHouse:GetCalcDays()
                averagePrices[itemLink] = ArkadiusTradeToolsSales:GetAveragePricePerItem(itemLink, GetTimeStamp() - SECONDS_IN_DAY * days)
            end

            scrollData[i].data.averagePrice = averagePrices[itemLink]
        end
    end

    return false 
end


function ArkadiusTradeToolsSales.TradingHouse:Initialize(settings)
    Settings = settings
    if (Settings.enabled == nil) then Settings.enabled = true end
    Settings.calcDays = Settings.calcDays or 10

    self:Enable(Settings.enabled)
end

function ArkadiusTradeToolsSales.TradingHouse:Enable(enable)
    if ((enable) and (self.profitMarginDaysLabel == nil)) then
        ZO_PreHook("ZO_ScrollList_Commit", ZO_ScrollList_Commit_Hook)
        EVENT_MANAGER:RegisterForEvent(ArkadiusTradeToolsSales.NAME, EVENT_TRADING_HOUSE_RESPONSE_RECEIVED, OnEvent)


        --- Create Slider ---
        local controlName = ZO_TradingHouseBrowseItemsLeftPane:GetName()
        self.profitMarginDaysLabel = CreateControl(controlName .. "MarginDaysLabel", ZO_TradingHouseBrowseItemsLeftPane, CT_LABEL)
        self.profitMarginDaysLabel:SetAnchor(TOPLEFT, ZO_TradingHouseBrowseItemsLeftPane, BOTTOMLEFT, 0, 0)
        self.profitMarginDaysLabel:SetAnchor(BOTTOMRIGHT, ZO_TradingHouseBrowseItemsLeftPane, BOTTOMRIGHT, 0, 20)
        self.profitMarginDaysLabel:SetFont("esoui/common/fonts/univers67.otf|18||soft-shadow-thick")
        self.profitMarginDaysLabel:SetText(L["ATT_STR_BASE_PROFIT_MARGIN_CALC_ON"])

        self.profitMarginDaysSelection = CreateControlFromVirtual(controlName .. "MarginDaysSelection", ZO_TradingHouseBrowseItemsLeftPane, "ArkadiusTradeToolsSlider")
        self.profitMarginDaysSelection:SetAnchor(TOPLEFT, self.profitMarginDaysLabel, BOTTOMLEFT, 0, 5)
        self.profitMarginDaysSelection:SetAnchor(BOTTOMRIGHT, self.profitMarginDaysLabel, BOTTOMRIGHT, 0, 45)
        self.profitMarginDaysSelection.OnValueChanged = function(_, value) ZO_ScrollList_Commit(ZO_TradingHouseBrowseItemsRightPaneSearchResults) Settings.calcDays = self:GetCalcDays() end

        --- Hook into search result functions ---
        TRADING_HOUSE_OnPurchaseSuccess = TRADING_HOUSE.OnPurchaseSuccess
        TRADING_HOUSE.OnPurchaseSuccess = OnPurchaseSuccess

        self:SetCalcDays(Settings.calcDays or 10)
    end

    Settings.enabled = enable
end

function ArkadiusTradeToolsSales.TradingHouse:IsEnabled()
    return Settings.enabled
end

function ArkadiusTradeToolsSales.TradingHouse:GetCalcDays()
    if (self.profitMarginDaysSelection) then
        return self.profitMarginDaysSelection.slider:GetValue()
    end
end

function ArkadiusTradeToolsSales.TradingHouse:SetCalcDays(days)
    if (self.profitMarginDaysSelection) then
        return self.profitMarginDaysSelection.slider:SetValue(days)
    end
end
