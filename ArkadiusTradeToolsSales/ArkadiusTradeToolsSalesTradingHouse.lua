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
        local averagePricePerUnitControl = rowControl:GetNamedChild("AveragePricePerUnit")
        local averagePriceControl = rowControl:GetNamedChild("AveragePrice")
        local nameControl = rowControl:GetNamedChild("Name")
        local sellPricePerUnitControl = rowControl:GetNamedChild("SellPricePerUnit")
        local sellPriceControl = rowControl:GetNamedChild("SellPrice")
        local timeRemainingControl = rowControl:GetNamedChild("TimeRemaining")
        --local itemLink = GetTradingHouseSearchResultItemLink(rowControl.dataEntry.data.slotIndex)
        --local stackCount = rowControl.dataEntry.data.stackCount
        local purchasePricePerUnit = rowControl.dataEntry.data.purchasePricePerUnit
        local averagePrice = rowControl.dataEntry.data.averagePrice or 0
        local averagePricePerUnit = rowControl.dataEntry.data.averagePricePerUnit or 0
        --local currencyType = rowControl.dataEntry.data.currencyType

        if (not profitMarginControl) then
            local h = nameControl:GetHeight()

            nameControl:SetWidth(220)               -- original 198
            timeRemainingControl:SetWidth(50)       -- original 60
            sellPricePerUnitControl:SetWidth(100)   -- original 120
            sellPricePerUnitControl:SetHeight(20)   -- original 23.02
            sellPriceControl:SetWidth(100)          -- original 130
            sellPriceControl:SetHeight(20)          -- original 23.02

            timeRemainingControl:ClearAnchors()
            timeRemainingControl:SetAnchor(LEFT, nameControl, RIGHT, 20)

            profitMarginControl = CreateControlFromVirtual(rowControl:GetName() .. "ProfitMargin", rowControl, "ZO_KeyboardGuildRosterRowLabel")
            profitMarginControl:SetDimensions(42, h)
            profitMarginControl:ClearAnchors()
            profitMarginControl:SetAnchor(LEFT, timeRemainingControl, RIGHT, 10)
            profitMarginControl:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)
            profitMarginControl:SetVerticalAlignment(TEXT_ALIGN_CENTER)
            profitMarginControl:SetFont("ZoFontGameShadow")

            sellPricePerUnitControl:ClearAnchors()
            sellPricePerUnitControl:SetAnchor(BOTTOMLEFT, profitMarginControl, RIGHT, 10)

            sellPriceControl:ClearAnchors()
            sellPriceControl:SetAnchor(LEFT, sellPricePerUnitControl, RIGHT, 0)

            averagePricePerUnitControl = CreateControlFromVirtual(rowControl:GetName() .. "AveragePricePerUnit", rowControl, "ZO_KeyboardGuildRosterRowLabel")
            averagePricePerUnitControl:SetDimensions(99, 20)
            averagePricePerUnitControl:ClearAnchors()
            averagePricePerUnitControl:SetAnchor(TOPLEFT, profitMarginControl, RIGHT, 10)
            averagePricePerUnitControl:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)
            averagePricePerUnitControl:SetVerticalAlignment(TEXT_ALIGN_CENTER)
            averagePricePerUnitControl:SetFont("ZoFontGameShadow")

            averagePriceControl = CreateControlFromVirtual(rowControl:GetName() .. "AveragePrice", rowControl, "ZO_KeyboardGuildRosterRowLabel")
            averagePriceControl:SetDimensions(100, 20)
            averagePriceControl:ClearAnchors()
            averagePriceControl:SetAnchor(LEFT, averagePricePerUnitControl, RIGHT, 0)
            averagePriceControl:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)
            averagePriceControl:SetVerticalAlignment(TEXT_ALIGN_CENTER)
            averagePriceControl:SetFont("ZoFontGameShadow")
        end

        if (averagePrice == 0) then
            local color = ZO_ColorDef:New(1.0, 1.0, 1.0)
            profitMarginControl:SetText("----")
            profitMarginControl:SetColor(color:UnpackRGBA())
            averagePriceControl:SetText("- |t18:18:EsoUI/Art/currency/currency_gold.dds|t")
            averagePriceControl:SetColor(color:UnpackRGBA())
            averagePricePerUnitControl:SetText("- |t18:18:EsoUI/Art/currency/currency_gold.dds|t")
            averagePricePerUnitControl:SetColor(color:UnpackRGBA())
        else
            local color = ZO_ColorDef:New(GetItemQualityColor(5))
            local margin = math.attRound((100 / averagePricePerUnit * purchasePricePerUnit - 100) * (-1))

            if (margin < -1.5) then color = ZO_ColorDef:New(1, 0, 0)
            elseif (margin < 20) then color = ZO_ColorDef:New(0.6, 0.6, 0.6)
            elseif (margin < 35) then color = ZO_ColorDef:New(GetItemQualityColor(2))
            elseif (margin < 50) then color = ZO_ColorDef:New(GetItemQualityColor(3))
            elseif (margin < 65) then color = ZO_ColorDef:New(GetItemQualityColor(4)) end
    
            profitMarginControl:SetText(margin .. "%")
            profitMarginControl:SetColor(color:UnpackRGBA())
            --ZO_CurrencyControl_SetSimpleCurrency(averagePriceControl, currencyType, math.attRound(averagePrice), ITEM_RESULT_CURRENCY_OPTIONS, nil, false)
            averagePriceControl:SetText(ArkadiusTradeTools:LocalizeDezimalNumber(math.attRound(averagePrice) .. " |t18:18:EsoUI/Art/currency/currency_gold.dds|t"))
            averagePriceControl:SetColor(color:UnpackRGBA())
            --ZO_CurrencyControl_SetSimpleCurrency(averagePricePerUnitControl, currencyType, math.attRound(averagePricePerUnit, 2), ITEM_RESULT_CURRENCY_OPTIONS, nil, false)
            averagePricePerUnitControl:SetText(ArkadiusTradeTools:LocalizeDezimalNumber(math.attRound(averagePricePerUnit, 2) .. " |t18:18:EsoUI/Art/currency/currency_gold.dds|t"))
            averagePricePerUnitControl:SetColor(color:UnpackRGBA())
        end
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

            if (averagePrices[itemLink] == nil) then
                local days = ArkadiusTradeToolsSales.TradingHouse:GetCalcDays()
                local itemType = GetItemLinkItemType(itemLink)
                averagePrices[itemLink] = {}

                if (itemType == ITEMTYPE_MASTER_WRIT) then
                    local vouchers = tonumber(GenerateMasterWritRewardText(itemLink):match("[0-9]+"))
                    averagePrices[itemLink].total = ArkadiusTradeToolsSales:GetAveragePricePerItem(itemLink, GetTimeStamp() - SECONDS_IN_DAY * days)
                    averagePrices[itemLink].perUnit = averagePrices[itemLink].total / vouchers
                else
                    averagePrices[itemLink].perUnit = ArkadiusTradeToolsSales:GetAveragePricePerItem(itemLink, GetTimeStamp() - SECONDS_IN_DAY * days)
                    averagePrices[itemLink].total = averagePrices[itemLink].perUnit * scrollData[i].data.stackCount
                end
            end

            scrollData[i].data.averagePrice = averagePrices[itemLink].total
            scrollData[i].data.averagePricePerUnit = averagePrices[itemLink].perUnit
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
    --- Disable tradinghouse extensions for AwesomeGuildStore users for now ---
--    if ((enable) and (self.profitMarginDaysLabel == nil) and (not AwesomeGuildStore)) then
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
