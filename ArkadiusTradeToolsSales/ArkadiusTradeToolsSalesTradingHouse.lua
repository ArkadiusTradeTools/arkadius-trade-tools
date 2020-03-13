local ArkadiusTradeToolsSales = ArkadiusTradeTools.Modules.Sales
ArkadiusTradeToolsSales.TradingHouse = {}
local L = ArkadiusTradeToolsSales.Localization
local Settings

local SECONDS_IN_DAY = 60 * 60 * 24
local TRADING_HOUSE_OnPurchaseSuccess

--- Prevent the search result list to reset to top on purchase ---
local function OnPurchaseSuccess(self)
  local list = self.searchResultsList
  local value = list.scrollbar:GetValue()

  TRADING_HOUSE_OnPurchaseSuccess(self)

  list.scrollbar:SetValue(value)
end

local function GetControlsForSearchResults(rowControl)
  local profitMarginControl = rowControl:GetNamedChild('ProfitMargin')
  local averagePricePerUnitControl = rowControl:GetNamedChild('AveragePricePerUnit')
  local averagePriceControl = rowControl:GetNamedChild('AveragePrice')
  local nameControl = rowControl:GetNamedChild('Name')
  local sellPricePerUnitControl = rowControl:GetNamedChild('SellPricePerUnit')
  local sellPriceControl = rowControl:GetNamedChild('SellPrice')
  local timeRemainingControl = rowControl:GetNamedChild('TimeRemaining')
  local purchasePricePerUnit = rowControl.dataEntry.data.purchasePricePerUnit
  local averagePrice = rowControl.dataEntry.data.averagePrice or 0
  local averagePricePerUnit = rowControl.dataEntry.data.averagePricePerUnit or 0

  return profitMarginControl, averagePricePerUnitControl, averagePriceControl, nameControl, sellPricePerUnitControl, sellPriceControl, timeRemainingControl, purchasePricePerUnit, averagePrice, averagePricePerUnit
end

local function SetUpSearchResultsWithoutAGS(rowControl)
  local profitMarginControl,
    averagePricePerUnitControl,
    averagePriceControl,
    nameControl,
    sellPricePerUnitControl,
    sellPriceControl,
    timeRemainingControl,
    purchasePricePerUnit,
    averagePrice,
    averagePricePerUnit = GetControlsForSearchResults(rowControl)

  if (not profitMarginControl) then
    local h = nameControl:GetHeight()

    nameControl:SetWidth(220) -- original 198
    timeRemainingControl:SetWidth(50) -- original 60
    sellPricePerUnitControl:SetWidth(100) -- original 120
    sellPricePerUnitControl:SetHeight(20) -- original 23.02
    sellPriceControl:SetWidth(100) -- original 130
    sellPriceControl:SetHeight(20) -- original 23.02

    timeRemainingControl:ClearAnchors()
    timeRemainingControl:SetAnchor(LEFT, nameControl, RIGHT, 20)

    profitMarginControl = CreateControlFromVirtual(rowControl:GetName() .. 'ProfitMargin', rowControl, 'ZO_KeyboardGuildRosterRowLabel')
    profitMarginControl:SetDimensions(42, h)
    profitMarginControl:ClearAnchors()
    profitMarginControl:SetAnchor(LEFT, timeRemainingControl, RIGHT, 10)
    profitMarginControl:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)
    profitMarginControl:SetVerticalAlignment(TEXT_ALIGN_CENTER)
    profitMarginControl:SetFont('ZoFontGameShadow')

    sellPricePerUnitControl:ClearAnchors()
    sellPricePerUnitControl:SetAnchor(BOTTOMLEFT, profitMarginControl, RIGHT, 10)

    sellPriceControl:ClearAnchors()
    sellPriceControl:SetAnchor(LEFT, sellPricePerUnitControl, RIGHT, 0)

    averagePricePerUnitControl = CreateControlFromVirtual(rowControl:GetName() .. 'AveragePricePerUnit', rowControl, 'ZO_KeyboardGuildRosterRowLabel')
    averagePricePerUnitControl:SetDimensions(99, 20)
    averagePricePerUnitControl:ClearAnchors()
    averagePricePerUnitControl:SetAnchor(TOPLEFT, profitMarginControl, RIGHT, 10)
    averagePricePerUnitControl:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)
    averagePricePerUnitControl:SetVerticalAlignment(TEXT_ALIGN_CENTER)
    averagePricePerUnitControl:SetFont('ZoFontGameShadow')

    averagePriceControl = CreateControlFromVirtual(rowControl:GetName() .. 'AveragePrice', rowControl, 'ZO_KeyboardGuildRosterRowLabel')
    averagePriceControl:SetDimensions(100, 20)
    averagePriceControl:ClearAnchors()
    averagePriceControl:SetAnchor(LEFT, averagePricePerUnitControl, RIGHT, 0)
    averagePriceControl:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)
    averagePriceControl:SetVerticalAlignment(TEXT_ALIGN_CENTER)
    averagePriceControl:SetFont('ZoFontGameShadow')
  end

  if (averagePrice == 0) then
    local color = ZO_ColorDef:New(1.0, 1.0, 1.0)
    profitMarginControl:SetText('----')
    profitMarginControl:SetColor(color:UnpackRGBA())
    averagePriceControl:SetText('- |t18:18:EsoUI/Art/currency/currency_gold.dds|t')
    averagePriceControl:SetColor(color:UnpackRGBA())
    averagePricePerUnitControl:SetText('- |t18:18:EsoUI/Art/currency/currency_gold.dds|t')
    averagePricePerUnitControl:SetColor(color:UnpackRGBA())
  else
    local margin = math.attRound((100 / averagePricePerUnit * purchasePricePerUnit - 100) * (-1))
    local color = ArkadiusTradeToolsSales.TradingHouse.GetMarginColor(margin)

    profitMarginControl:SetText(margin .. '%')
    profitMarginControl:SetColor(color:UnpackRGBA())
    --ZO_CurrencyControl_SetSimpleCurrency(averagePriceControl, currencyType, math.attRound(averagePrice), ITEM_RESULT_CURRENCY_OPTIONS, nil, false)
    averagePriceControl:SetText(ArkadiusTradeTools:LocalizeDezimalNumber(math.attRound(averagePrice) .. ' |t18:18:EsoUI/Art/currency/currency_gold.dds|t'))
    averagePriceControl:SetColor(color:UnpackRGBA())
    --ZO_CurrencyControl_SetSimpleCurrency(averagePricePerUnitControl, currencyType, math.attRound(averagePricePerUnit, 2), ITEM_RESULT_CURRENCY_OPTIONS, nil, false)
    averagePricePerUnitControl:SetText(
      ArkadiusTradeTools:LocalizeDezimalNumber(math.attRound(averagePricePerUnit, 2) .. ' |t18:18:EsoUI/Art/currency/currency_gold.dds|t')
    )
    averagePricePerUnitControl:SetColor(color:UnpackRGBA())
  end
end

local function SetUpSearchResultsWithAGS(rowControl)
  local profitMarginControl,
    averagePricePerUnitControl,
    averagePriceControl,
    nameControl,
    sellPricePerUnitControl,
    sellPriceControl,
    timeRemainingControl,
    purchasePricePerUnit,
    averagePrice,
    averagePricePerUnit = GetControlsForSearchResults(rowControl)

  if (not profitMarginControl) then
    local h = nameControl:GetHeight()

    timeRemainingControl:SetWidth(45) -- original 60

    timeRemainingControl:ClearAnchors()
    timeRemainingControl:SetAnchor(LEFT, nameControl, RIGHT, 15)

    profitMarginControl = CreateControlFromVirtual(rowControl:GetName() .. 'ProfitMargin', rowControl, 'ZO_KeyboardGuildRosterRowLabel')
    -- 55 is better for large sale prices, but 65 is better for items super overpriced or underpriced
    profitMarginControl:SetDimensions(55, h)
    profitMarginControl:ClearAnchors()
    profitMarginControl:SetAnchor(LEFT, timeRemainingControl, RIGHT, -5)
    profitMarginControl:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)
    profitMarginControl:SetVerticalAlignment(TEXT_ALIGN_CENTER) --Center and right look better, but left fits better
    profitMarginControl:SetFont('ZoFontGameShadow')
  end

  if (averagePrice == 0) then
    local color = ZO_ColorDef:New(1.0, 1.0, 1.0)
    profitMarginControl:SetText('------') --I would like to use 4 dashes and just change the alignment, but that seems to change all alignment
    profitMarginControl:SetColor(color:UnpackRGBA())
  else
    local margin = math.attRound((100 / averagePricePerUnit * purchasePricePerUnit - 100) * (-1))
    local color = ArkadiusTradeToolsSales.TradingHouse.GetMarginColor(margin)

    -- If I could make this layout work, that'd be ideal
    --           |  Percent Difference (total)  |   AGS Total Price
    -- Time Left |  Market price (total)        |
    --           |  Market price (individual)   |   AGS Individual Price
    profitMarginControl:SetText(margin .. '%')
    profitMarginControl:SetColor(color:UnpackRGBA())
  end
end

local function TradingHouseSearchResultsSetupRow(rowControl, ...)
  if (rowControl.dataEntry) then
    if not AwesomeGuildStore then
      SetUpSearchResultsWithoutAGS(rowControl)
    else
      SetUpSearchResultsWithAGS(rowControl)
    end
  end

  --- Important to return false, so that the hooked function gets called ---
  return false
end

local function OnEvent(eventCode, responseType, result)
  --    if (eventCode == EVENT_TRADING_HOUSE_SEARCH_RESULTS_RECEIVED) then
  if (eventCode == EVENT_TRADING_HOUSE_RESPONSE_RECEIVED) and (responseType == TRADING_HOUSE_RESULT_SEARCH_PENDING) and (result == TRADING_HOUSE_RESULT_SUCCESS) then
    local dataType = TRADING_HOUSE.searchResultsList.dataTypes[1]
    ZO_PreHook(dataType, 'setupCallback', TradingHouseSearchResultsSetupRow)

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
    local days = ArkadiusTradeToolsSales.TradingHouse:GetCalcDays()

    for i = 1, #scrollData do
      itemLink = GetTradingHouseSearchResultItemLink(scrollData[i].data.slotIndex)
      -- AGS appears to add an extra row at the bottom of the list (or override one)
      -- to render the Show More Results button, which causes parsing issues.
      -- We're gonna conditionally skip the last item if AGS is enabled so these errors aren't thrown.
      if scrollData[i].data.stackCount ~= nil then
        if (averagePrices[itemLink] == nil) then
          local itemType = GetItemLinkItemType(itemLink)
          averagePrices[itemLink] = {}

          if (itemType == ITEMTYPE_MASTER_WRIT) then
            local vouchers = tonumber(GenerateMasterWritRewardText(itemLink):match('[0-9]+'))
            averagePrices[itemLink].total = ArkadiusTradeToolsSales:GetAveragePricePerItem(itemLink, GetTimeStamp() - SECONDS_IN_DAY * days)
            averagePrices[itemLink].perUnit = averagePrices[itemLink].total / vouchers
          else
            averagePrices[itemLink].perUnit = ArkadiusTradeToolsSales:GetAveragePricePerItem(itemLink, GetTimeStamp() - SECONDS_IN_DAY * days)
            averagePrices[itemLink].total = averagePrices[itemLink].perUnit * scrollData[i].data.stackCount
          end
        end

        scrollData[i].data.averagePrice = averagePrices[itemLink].total
        scrollData[i].data.averagePricePerUnit = averagePrices[itemLink].perUnit
        scrollData[i].data.ATT_INIT = days
      end
    end
  end

  return false
end

function ArkadiusTradeToolsSales.TradingHouse:Initialize(settings)
  Settings = settings
  if (Settings.enabled == nil) then
    Settings.enabled = true
  end
  Settings.calcDays = Settings.calcDays or 10
  Settings.defaultDealLevel = Settings.defaultDealLevel or 1
  self:Enable(Settings.enabled)
end

function ArkadiusTradeToolsSales.TradingHouse:GetDefaultDealLevel(level)
  return Settings.defaultDealLevel
end

function ArkadiusTradeToolsSales.TradingHouse:SetDefaultDealLevel(level)
  Settings.defaultDealLevel = level
end

function ArkadiusTradeToolsSales.TradingHouse:Enable(enable)
  if enable and self.profitMarginDaysLabel == nil then
    ZO_PreHook('ZO_ScrollList_Commit', ZO_ScrollList_Commit_Hook)
    EVENT_MANAGER:RegisterForEvent(ArkadiusTradeToolsSales.NAME, EVENT_TRADING_HOUSE_RESPONSE_RECEIVED, OnEvent)

    --- Create Slider ---
    local controlName = ZO_TradingHouseBrowseItemsLeftPane:GetName()
    self.profitMarginDaysLabel = CreateControl(controlName .. 'MarginDaysLabel', ZO_TradingHouseBrowseItemsLeftPane, CT_LABEL)
    self.profitMarginDaysLabel:SetAnchor(TOPLEFT, ZO_TradingHouseBrowseItemsLeftPane, BOTTOMLEFT, 0, 0)
    self.profitMarginDaysLabel:SetAnchor(BOTTOMRIGHT, ZO_TradingHouseBrowseItemsLeftPane, BOTTOMRIGHT, 0, 20)
    self.profitMarginDaysLabel:SetFont('esoui/common/fonts/univers67.otf|18||soft-shadow-thick')
    self.profitMarginDaysLabel:SetText(L['ATT_STR_BASE_PROFIT_MARGIN_CALC_ON'])

    self.profitMarginDaysSelection =
      CreateControlFromVirtual(controlName .. 'MarginDaysSelection', ZO_TradingHouseBrowseItemsLeftPane, 'ArkadiusTradeToolsSlider')
    self.profitMarginDaysSelection:SetAnchor(TOPLEFT, self.profitMarginDaysLabel, BOTTOMLEFT, 0, 5)
    self.profitMarginDaysSelection:SetAnchor(BOTTOMRIGHT, self.profitMarginDaysLabel, BOTTOMRIGHT, 0, 45)
    self.profitMarginDaysSelection.OnValueChanged = function(_, value)
      ZO_ScrollList_Commit(ZO_TradingHouseBrowseItemsRightPaneSearchResults)
      Settings.calcDays = self:GetCalcDays()
      if self.Filter then
        self.Filter:ForceUpdate()
      end
    end

    --- Hook into search result functions ---
    TRADING_HOUSE_OnPurchaseSuccess = TRADING_HOUSE.OnPurchaseSuccess
    TRADING_HOUSE.OnPurchaseSuccess = OnPurchaseSuccess

    self:SetCalcDays(Settings.calcDays or 10)
      
    if AwesomeGuildStore then
      self:RegisterAGSInitCallback()    
      EVENT_MANAGER:RegisterForEvent(ArkadiusTradeToolsSales.NAME, EVENT_CLOSE_TRADING_HOUSE, function() self.Filter:ResetCache() end)
    end

    -- Trying to hook in after AGS to avoid any conflicts
    local initialized = false
    ZO_PreHook(TRADING_HOUSE, 'SetCurrentMode', function()
      if initialized then
        return
      end
      self:InitializeListingMarginDisplay()
      initialized = true
    end)
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

---@return Number, String
local function GetMarginData(cache, data, itemLink, days)
  if data.ATT_INIT ~= days then
    -- We need to cache by days and item link in case the day slider is changed
    -- We clear the cache on leaving the trading house, so it shouldn't become a performance drag
    if cache[days] == nil then cache[days] = {} end
    if (cache[days][itemLink] == nil) then
      local itemType = GetItemLinkItemType(itemLink)
      cache[days][itemLink] = {}

      if (itemType == ITEMTYPE_MASTER_WRIT) then
        local vouchers = tonumber(GenerateMasterWritRewardText(itemLink):match('[0-9]+'))
        cache[days][itemLink].total = ArkadiusTradeToolsSales:GetAveragePricePerItem(itemLink, GetTimeStamp() - SECONDS_IN_DAY * days)
        cache[days][itemLink].perUnit = cache[days][itemLink].total / vouchers
      else
        cache[days][itemLink].perUnit = ArkadiusTradeToolsSales:GetAveragePricePerItem(itemLink, GetTimeStamp() - SECONDS_IN_DAY * days)
        cache[days][itemLink].total = cache[days][itemLink].perUnit * data.stackCount
      end
    end

    data.averagePrice = cache[days][itemLink].total
    data.averagePricePerUnit = cache[days][itemLink].perUnit
    data.ATT_INIT = days
  end

  local margin = math.attRound((100 / data.averagePricePerUnit * data.purchasePricePerUnit - 100) * (-1))
  local marginFormatted = (data.averagePricePerUnit == 0 and '----') or string.format('%d%%', margin)
  return margin, marginFormatted
end

function ArkadiusTradeToolsSales.TradingHouse:InitializeListingMarginDisplay()
  local LISTING_MARGIN_FONT = "/esoui/common/fonts/univers67.otf|18|soft-shadow-thin"
  local ITEM_LISTINGS_DATA_TYPE = 2

  local dataType = TRADING_HOUSE.postedItemsList.dataTypes[ITEM_LISTINGS_DATA_TYPE]
  local cache = {}

  ZO_PostHook(dataType, 'setupCallback', function(rowControl, item)
      local days = ArkadiusTradeToolsSalesData.settings.tooltips.days or 30
      local timeRemainingControl = rowControl:GetNamedChild("TimeRemaining")
      local listingMargin = rowControl:GetNamedChild("Margin")
      if(not listingMargin) then
          local controlName = rowControl:GetName() .. "Margin"
          listingMargin = rowControl:CreateControl(controlName, CT_LABEL)
          listingMargin:SetDimensionConstraints(48)
          listingMargin:SetAnchor(TOPLEFT, timeRemainingControl, TOPRIGHT, -20, 0)
          listingMargin:SetFont(LISTING_MARGIN_FONT)
      end
      local margin, formatted = GetMarginData(cache, item, item.itemLink, days)
      local color = self.GetMarginColor(margin)
      listingMargin:SetText(formatted)
      listingMargin:SetColor(color:UnpackRGBA())
      listingMargin:SetHorizontalAlignment(TEXT_ALIGN_CENTER)
  end)
end

---@param margin Number
function ArkadiusTradeToolsSales.TradingHouse.GetMarginColor(margin)
  local color = ZO_ColorDef:New(GetItemQualityColor(5))
  if (margin == -math.huge) then
    color = ZO_ColorDef:New(1, 1, 1)
  elseif (margin < -1.5) then
    color = ZO_ColorDef:New(1, 0, 0)
  elseif (margin < 20) then
    color = ZO_ColorDef:New(0.6, 0.6, 0.6)
  elseif (margin < 35) then
    color = ZO_ColorDef:New(GetItemQualityColor(2))
  elseif (margin < 50) then
    color = ZO_ColorDef:New(GetItemQualityColor(3))
  elseif (margin < 65) then
    color = ZO_ColorDef:New(GetItemQualityColor(4))
  end
  return color
end

local SUBFILTER_ATT = 104

local STEPS = {
  {id=1, value=-math.huge, icon="ArkadiusTradeToolsSales/img/baddeal_%s.dds"},
  {id=2, value=-1.5, icon="AwesomeGuildStore/images/qualitybuttons/normal_%s.dds"},
  {id=3, value=20, icon="AwesomeGuildStore/images/qualitybuttons/magic_%s.dds"},
  {id=4, value=35, icon="AwesomeGuildStore/images/qualitybuttons/arcane_%s.dds"},
  {id=5, value=50, icon="AwesomeGuildStore/images/qualitybuttons/artifact_%s.dds"},
  {id=6, value=65, icon="AwesomeGuildStore/images/qualitybuttons/legendary_%s.dds"}
}

function ArkadiusTradeToolsSales.TradingHouse.InitAGSIntegration(tradingHouseWrapper)
    for _,value in ipairs(STEPS) do
      value.label = L['ATT_STR_DEAL_LEVEL_' .. value.id]
    end
    local AGS = AwesomeGuildStore
    local FilterBase            = AGS.class.FilterBase
    local ValueRangeFilterBase  = AGS.class.ValueRangeFilterBase
    local FILTER_ID             = AGS.data.FILTER_ID
    local SUB_CATEGORY_ID       = AGS.data.SUB_CATEGORY_ID
    local MIN_VALUE             = 1
    local MAX_VALUE             = 6
    local AGSFilter         = ValueRangeFilterBase:Subclass()

    function AGSFilter:New(...)
        return ValueRangeFilterBase.New(self, ...)
    end

    function AGSFilter:ResetCache()
      self.averagePrices = {}
    end

    function AGSFilter:Initialize()
        self.averagePrices = {}
        ValueRangeFilterBase.Initialize(
                      self
                    , SUBFILTER_ATT
                    , FilterBase.GROUP_LOCAL
                    , {
                          label     = 'Deal Finder'
                        , min       = MIN_VALUE
                        , max       = MAX_VALUE
                        , steps     = STEPS
                    }
        )
        local qualityById = {}
        for i = 1, #self.config.steps do
            local step = self.config.steps[i]
            local color = i == 1 and ZO_ColorDef:New(1, 0, 0) or GetItemQualityColor(step.id - 1)
            step.colorizedLabel = color:Colorize(step.label)
            qualityById[step.id] = step
        end
        self.qualityById = qualityById
    end

    function AGSFilter:CanFilter(...)
			return true
    end
    
    function AGSFilter:ForceUpdate()
      self:HandleChange(self.min, self.max)
    end

    function AGSFilter:IsDefaultDealLevel(margin)
      return (margin == -math.huge and Settings.defaultDealLevel >= self.min and Settings.defaultDealLevel <= self.max and Settings.defaultDealLevel >= self.min and Settings.defaultDealLevel <= self.max)
    end

    function AGSFilter:IsWithinDealRange(margin)
      return ((margin ~= -math.huge) and (margin >= STEPS[self.min].value) and (self.max == MAX_VALUE or margin < STEPS[self.max+1].value))
    end

    function AGSFilter:FilterLocalResult(data)
      local itemLink = GetTradingHouseSearchResultItemLink(data.slotIndex)
      local days = ArkadiusTradeToolsSales.TradingHouse:GetCalcDays()
      local margin = GetMarginData(self.averagePrices, data, itemLink, days)
      return self:IsWithinDealRange(margin) or self:IsDefaultDealLevel(margin)
    end

    function AGSFilter:IsLocal()
        return true
    end
    
    function AGSFilter:GetTooltipText(min, max)
      if(min ~= self.config.min or max ~= self.config.max) then
          local out = {}
          for id = min, max do
              local step = self.qualityById[id]
              out[#out + 1] = step.colorizedLabel
          end
          return table.concat(out, ", ")
      end
      return ""
    end

    ArkadiusTradeToolsSales.TradingHouse.Filter = AGSFilter:New()
    -- We need to register both the filter function and the actual UI fragment before it'll show up in AGS
    AGS:RegisterFilter(ArkadiusTradeToolsSales.TradingHouse.Filter)
    AGS:RegisterFilterFragment(AGS.class.QualityFilterFragment:New(SUBFILTER_ATT))
end

function ArkadiusTradeToolsSales.TradingHouse:RegisterAGSInitCallback()
  if self.AGSRegistered then return end
  self.AGSRegistered = true
  AwesomeGuildStore:RegisterCallback(AwesomeGuildStore.callback.AFTER_FILTER_SETUP
                        , self.InitAGSIntegration
                        )
end