ArkadiusTradeTools.Modules.Statistics = ArkadiusTradeTools.Templates.Module:New(ArkadiusTradeTools.NAME .. "Statistics", ArkadiusTradeTools.TITLE .. " - Statistics", ArkadiusTradeTools.VERSION, ArkadiusTradeTools.AUTHOR)
local ArkadiusTradeToolsStatistics = ArkadiusTradeTools.Modules.Statistics
ArkadiusTradeToolsStatistics.Localization = {}
ArkadiusTradeToolsStatistics.SavedVariables = {}

local L = ArkadiusTradeToolsStatistics.Localization
local Settings

--------------------------------------------------------
-------------------- List functions --------------------
--------------------------------------------------------
local ArkadiusTradeToolsStatisticsList = ArkadiusTradeToolsSortFilterList:Subclass()

function ArkadiusTradeToolsStatisticsList:Initialize(control)
    ArkadiusTradeToolsSortFilterList.Initialize(self, control)

    self.SORT_KEYS = {["displayName"] = {},
                      ["guildName"]  = {tiebreaker = "displayName"},
                      ["salesVolume"]  = {tiebreaker = "displayName"},
                      ["taxes"]  = {tiebreaker = "displayName"},
                      ["internalSalesVolumePercentage"] = {tiebreaker = "displayName"},
                      ["itemCount"]  = {tiebreaker = "displayName"}}

    ZO_ScrollList_AddDataType(self.list, 1, "ArkadiusTradeToolsStatisticsRow", 32,
        function(control, data)
            self:SetupStatisticRow(control, data)
        end
    )

    self.sortHeaderGroup.headerContainer.sortHeaderGroup = self.sortHeaderGroup
    self.sortHeaderGroup:SelectHeaderByKey("salesVolume")
    self.currentSortKey = "salesVolume"
end

function ArkadiusTradeToolsStatisticsList:BuildMasterList()
    local item = ArkadiusTradeToolsStatistics.frame.filterBar.Time:GetSelectedItem()
    newerThanTimeStamp = item.NewerThanTimeStamp()
    olderThanTimestamp = item.OlderThanTimeStamp()

    if (ArkadiusTradeTools.Modules.Sales) then
        local statistics = ArkadiusTradeTools.Modules.Sales:GetStatistics(newerThanTimeStamp, olderThanTimestamp)

        local scrollData = ZO_ScrollList_GetDataList(self.list)
        ZO_ClearNumericallyIndexedTable(scrollData)

        self.masterList = {}
        for i = 1, #statistics do
            self:UpdateMasterList(statistics[i])
        end
    end
end

function ArkadiusTradeToolsStatisticsList:SetupFilters()
    local useSubStrings = ArkadiusTradeToolsStatistics.frame.filterBar.SubStrings:IsPressed()

    local CompareStringsFuncs = {}
    CompareStringsFuncs[true] = function(string1, string2) return (string.find(string1:lower(), string2) ~= nil) end
    CompareStringsFuncs[false] = function(string1, string2) return (string1:lower() == string2) end

    self.Filter:SetKeywords(ArkadiusTradeToolsStatistics.frame.filterBar.Text:GetStrings())
    self.Filter:SetKeyFunc(1, "displayName", CompareStringsFuncs[useSubStrings])
    self.Filter:SetKeyFunc(1, "guildName", CompareStringsFuncs[useSubStrings])
end

function ArkadiusTradeToolsStatisticsList:MatchFilter(data, filter)
    return (string.find(data.displayName:lower(), filter) ~= nil) or
           (string.find(data.guildName:lower(), filter) ~= nil)
end

function ArkadiusTradeToolsStatisticsList:SetupStatisticRow(rowControl, rowData)
    rowControl.data = rowData
    local data = rowData.rawData
    local displayName = GetControl(rowControl, "DisplayName")
    local guildName = GetControl(rowControl, "GuildName")
    local salesVolume = GetControl(rowControl, "SalesVolume")
    local taxes = GetControl(rowControl, "Taxes")
    local internalSalesVolumePercentage = GetControl(rowControl, "InternalSalesVolumePercentage")
    local itemCount = GetControl(rowControl, "ItemCount")

    displayName:SetText(data.displayName)
    displayName:SetWidth(displayName.header:GetWidth() - 10)
    displayName:SetHidden(displayName.header:IsHidden())
    displayName:SetColor(ArkadiusTradeTools:GetDisplayNameColor(data.displayName):UnpackRGBA())

    guildName:SetText(data.guildName)
    guildName:SetWidth(guildName.header:GetWidth() - 10)
    guildName:SetHidden(guildName.header:IsHidden())
    guildName:SetColor(ArkadiusTradeTools:GetGuildColor(data.guildName):UnpackRGBA())

    salesVolume:SetText(ZO_LocalizeDecimalNumber(data.salesVolume) .. " |t16:16:EsoUI/Art/currency/currency_gold.dds|t")
    salesVolume:SetWidth(salesVolume.header:GetWidth() - 10)
    salesVolume:SetHidden(salesVolume.header:IsHidden())

    taxes:SetText(ZO_LocalizeDecimalNumber(data.taxes) .. " |t16:16:EsoUI/Art/currency/currency_gold.dds|t")
    taxes:SetWidth(taxes.header:GetWidth() - 10)
    taxes:SetHidden(taxes.header:IsHidden())

    internalSalesVolumePercentage:SetText(ZO_LocalizeDecimalNumber(data.internalSalesVolumePercentage) .. "%")
    internalSalesVolumePercentage:SetWidth(internalSalesVolumePercentage.header:GetWidth() - 10)
    internalSalesVolumePercentage:SetHidden(internalSalesVolumePercentage.header:IsHidden())

    itemCount:SetText(data.itemCount)
    itemCount:SetWidth(itemCount.header:GetWidth() - 10)
    itemCount:SetHidden(itemCount.header:IsHidden())

    ArkadiusTradeToolsSortFilterList.SetupRow(self, rowControl, rowData)
end

---------------------------------------------------------------------------------------
function ArkadiusTradeToolsStatistics:Initialize()
    self.frame = ArkadiusTradeTools:CreateTab({name = self.NAME .. "Frame",
                                               text = L["ATT_STR_STATISTICS"],
                                               --iconEnabled = "/esoui/art/tradinghouse/tradinghouse_listings_tabicon_up.dds",
                                               --iconDisabled = "/esoui/art/tradinghouse/tradinghouse_listings_tabicon_disabled.dds",
                                               iconActive = "/esoui/art/characterwindow/charsheet_statstab_icon.dds",
                                               iconInactive = "/esoui/art/characterwindow/charsheet_statstab_icon_inactive.dds",
                                               iconCoords = {left = 0.15, top = 0.15, right = 0.9, bottom = 0.85},
                                               template = "ArkadiusTradeToolsStatisticsFrame"})

    self.list = ArkadiusTradeToolsStatisticsList:New(self, self.frame)
    self.frame.list = self.frame:GetNamedChild("List")
    self.frame.filterBar = self.frame:GetNamedChild("FilterBar")
    self.frame.headers = self.frame:GetNamedChild("Headers")
    self.frame.headers.displayName = self.frame.headers:GetNamedChild("DisplayName")
    self.frame.headers.guildName = self.frame.headers:GetNamedChild("GuildName")
    self.frame.headers.salesVolume = self.frame.headers:GetNamedChild("SalesVolume")
    self.frame.headers.internalSalesVolumePercentage = self.frame.headers:GetNamedChild("InternalSalesVolumePercentage")
    self.frame.headers.numberItems = self.frame.headers:GetNamedChild("NumberItems")
    self.frame.OnResize = self.OnResize
    self.frame:SetHandler("OnEffectivelyShown", function(_, hidden) if (hidden == false) then self.list:RefreshData() end end)

    self:LoadSettings()

    --- Setup FilterBar ---
    local function callback(...)
        self.list.Filter:SetNeedsRefilter()
        self.list:RefreshData()
        Settings.filters.timeSelection = self.frame.filterBar.Time:GetSelectedIndex()
    end

    self.frame.filterBar.Time:AddItem({name = L["ATT_STR_TODAY"], callback = callback, NewerThanTimeStamp = function() return ArkadiusTradeTools:GetStartOfDay(0) end, OlderThanTimeStamp = function() return GetTimeStamp() end})
    self.frame.filterBar.Time:AddItem({name = L["ATT_STR_YESTERDAY"], callback = callback, NewerThanTimeStamp = function() return ArkadiusTradeTools:GetStartOfDay(-1) end, OlderThanTimeStamp = function() return ArkadiusTradeTools:GetStartOfDay(0) - 1 end})
    self.frame.filterBar.Time:AddItem({name = L["ATT_STR_TWO_DAYS_AGO"], callback = callback, NewerThanTimeStamp = function() return ArkadiusTradeTools:GetStartOfDay(-2) end, OlderThanTimeStamp = function() return ArkadiusTradeTools:GetStartOfDay(-1) - 1 end})
    self.frame.filterBar.Time:AddItem({name = L["ATT_STR_THIS_WEEK"], callback = callback, NewerThanTimeStamp = function() return ArkadiusTradeTools:GetStartOfWeek(0, true) end, OlderThanTimeStamp = function() return GetTimeStamp() end})
    self.frame.filterBar.Time:AddItem({name = L["ATT_STR_LAST_WEEK"], callback = callback, NewerThanTimeStamp = function() return ArkadiusTradeTools:GetStartOfWeek(-1, true) end, OlderThanTimeStamp = function() return ArkadiusTradeTools:GetStartOfWeek(0, true) - 1 end})
    self.frame.filterBar.Time:AddItem({name = L["ATT_STR_PRIOR_WEEK"], callback = callback, NewerThanTimeStamp = function() return ArkadiusTradeTools:GetStartOfWeek(-2, true) end, OlderThanTimeStamp = function() return ArkadiusTradeTools:GetStartOfWeek(-1, true) - 1 end})
    self.frame.filterBar.Time:AddItem({name = L["ATT_STR_7_DAYS"], callback = callback, NewerThanTimeStamp = function() return ArkadiusTradeTools:GetStartOfDay(-7) end, OlderThanTimeStamp = function() return GetTimeStamp() end})
    self.frame.filterBar.Time:AddItem({name = L["ATT_STR_10_DAYS"], callback = callback, NewerThanTimeStamp = function() return ArkadiusTradeTools:GetStartOfDay(-10) end, OlderThanTimeStamp = function() return GetTimeStamp() end})
    self.frame.filterBar.Time:AddItem({name = L["ATT_STR_14_DAYS"], callback = callback, NewerThanTimeStamp = function() return ArkadiusTradeTools:GetStartOfDay(-14) end, OlderThanTimeStamp = function() return GetTimeStamp() end})
    self.frame.filterBar.Time:AddItem({name = L["ATT_STR_30_DAYS"], callback = callback, NewerThanTimeStamp = function() return 0 end, OlderThanTimeStamp = function() return GetTimeStamp() end})
    self.frame.filterBar.Time:SelectByIndex(Settings.filters.timeSelection)
    self.frame.filterBar.Text.OnChanged = function(text) self.list:RefreshFilters() end
    self.frame.filterBar.Text:SetTooltipText(L["ATT_STR_FILTER_TEXT_TOOLTIP"])
    self.frame.filterBar.SubStrings.OnToggle = function(switch, pressed) self.list.Filter:SetNeedsRefilter() self.list:RefreshFilters() Settings.filters.useSubStrings = pressed end
    self.frame.filterBar.SubStrings:SetPressed(Settings.filters.useSubStrings)
    self.frame.filterBar.SubStrings:SetTooltipText(L["ATT_STR_FILTER_SUBSTRING_TOOLTIP"])
    -----------------------
--[[    ---------------------------------------------
    local function callback(_, name, item, _)
        self.list:RefreshData()
    end

    local comboBox = ZO_ComboBox_ObjectFromContainer(self.frame.timeSelect)
    comboBox:SetSortsItems(false)

    comboBox:AddItem({name = "Today", callback = callback, NewerThanTimeStamp = function() return ArkadiusTradeTools:GetStartOfDay(0) end, OlderThanTimeStamp = function() return GetTimeStamp() end})
    comboBox:AddItem({name = "Yesterday", callback = callback, NewerThanTimeStamp = function() return ArkadiusTradeTools:GetStartOfDay(-1) end, OlderThanTimeStamp = function() return ArkadiusTradeTools:GetStartOfDay(0) - 1 end})
    comboBox:AddItem({name = "2 days ago", callback = callback, NewerThanTimeStamp = function() return ArkadiusTradeTools:GetStartOfDay(-2) end, OlderThanTimeStamp = function() return ArkadiusTradeTools:GetStartOfDay(-1) - 1 end})
    comboBox:AddItem({name = "This week", callback = callback, NewerThanTimeStamp = function() return ArkadiusTradeTools:GetStartOfWeek(0, true) end, OlderThanTimeStamp = function() return GetTimeStamp() end})
    comboBox:AddItem({name = "Last week", callback = callback, NewerThanTimeStamp = function() return ArkadiusTradeTools:GetStartOfWeek(-1, true) end, OlderThanTimeStamp = function() return ArkadiusTradeTools:GetStartOfWeek(0, true) - 1 end})
    comboBox:AddItem({name = "7 days", callback = callback, NewerThanTimeStamp = function() return ArkadiusTradeTools:GetStartOfDay(-7) end, OlderThanTimeStamp = function() return GetTimeStamp() end})
    comboBox:AddItem({name = "10 days", callback = callback, NewerThanTimeStamp = function() return ArkadiusTradeTools:GetStartOfDay(-10) end, OlderThanTimeStamp = function() return GetTimeStamp() end})
    comboBox:AddItem({name = "14 days", callback = callback, NewerThanTimeStamp = function() return ArkadiusTradeTools:GetStartOfDay(-14) end, OlderThanTimeStamp = function() return GetTimeStamp() end})
    comboBox:AddItem({name = "30 days", callback = callback, NewerThanTimeStamp = function() return 0 end, OlderThanTimeStamp = function() return GetTimeStamp() end})

    self.timeSelect = comboBox

    comboBox:SelectItemByIndex(4)
    ----------------------------------------------
	--]]

    self.list:RefreshData()
end

function ArkadiusTradeToolsStatistics:Finalize()
    self:SaveSettings()
end

function ArkadiusTradeToolsStatistics:LoadSettings()
    --- Apply list header visibilites ---
    if (Settings.hiddenHeaders) then
        local headers = self.frame.headers

        for _, headerKey in pairs(Settings.hiddenHeaders) do
            for i = 1, headers:GetNumChildren() do
                local header = headers:GetChild(i)

                if ((header.key) and (header.key == headerKey)) then
                    header:SetHidden(true)

                    break
                end
            end
        end
    end
end

function ArkadiusTradeToolsStatistics:SaveSettings()
    --- Save list header visibilites ---
    Settings.hiddenHeaders = {}

    if ((self.frame) and (self.frame.headers)) then
        local headers = self.frame.headers

        for i = 1, headers:GetNumChildren() do
            local header = headers:GetChild(i)

            if ((header.key) and (header:IsControlHidden())) then
                table.insert(Settings.hiddenHeaders, header.key)
            end
        end
    end
end

function ArkadiusTradeToolsStatistics.OnResize(frame, width, height)
    frame.headers:Update()
    ZO_ScrollList_Commit(frame.list)
end

local function onAddOnLoaded(eventCode, addonName)
    if (addonName ~= ArkadiusTradeToolsStatistics.NAME) then
        return
    end

    ArkadiusTradeToolsStatisticsData = ArkadiusTradeToolsStatisticsData or {}
    ArkadiusTradeToolsStatisticsData.settings = ArkadiusTradeToolsStatisticsData.settings or {}

    Settings = ArkadiusTradeToolsStatisticsData.settings

    --- Create default settings ---
--    Settings.keepDataDays = Settings.keepDataDays or 30
    Settings.filters = Settings.filters or {}
    Settings.filters.timeSelection = Settings.filters.timeSelection or 4
    if (Settings.filters.useSubStrings == nil) then Settings.filters.useSubStrings = true end

    EVENT_MANAGER:UnregisterForEvent(ArkadiusTradeToolsStatistics.NAME, EVENT_ADD_ON_LOADED)
end

EVENT_MANAGER:RegisterForEvent(ArkadiusTradeToolsStatistics.NAME, EVENT_ADD_ON_LOADED, onAddOnLoaded)
