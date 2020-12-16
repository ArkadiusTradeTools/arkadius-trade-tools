ArkadiusTradeTools.Modules.Exports = ArkadiusTradeTools.Templates.Module:New(ArkadiusTradeTools.NAME .. "Exports", ArkadiusTradeTools.TITLE .. " - Exports", ArkadiusTradeTools.VERSION, ArkadiusTradeTools.AUTHOR)
local ArkadiusTradeToolsExports = ArkadiusTradeTools.Modules.Exports
local ArkadiusTradeToolsSales = ArkadiusTradeTools.Modules.Sales
ArkadiusTradeToolsExports.Localization = {}

local attRound = math.attRound
local L = ArkadiusTradeToolsExports.Localization
local Utilities = ArkadiusTradeTools.Utilities
local Settings
local Exports

local SECONDS_IN_HOUR = 60 * 60
local SECONDS_IN_DAY = SECONDS_IN_HOUR * 24

--------------------------------------------------------
-------------------- List functions --------------------
--------------------------------------------------------
local ArkadiusTradeToolsExportsList = ArkadiusTradeToolsSortFilterList:Subclass()

function ArkadiusTradeToolsExportsList:Initialize(control)
    ArkadiusTradeToolsSortFilterList.Initialize(self, control)

    self.SORT_KEYS = {["guildName"]  = {tiebreaker = "startTimeStamp"},
                      ["startTimeStamp"]  = {tiebreaker = "endTimeStamp"},
                      ["endTimeStamp"]  = {tiebreaker = "guildName"}}

    ZO_ScrollList_AddDataType(self.list, 1, "ArkadiusTradeToolsExportsRow", 32,
        function(control, data)
            self:SetupExportRow(control, data)
        end
    )

    local function OnHeaderToggle(switch, pressed)
        self[switch:GetParent().key.."Switch"] = pressed
        self:CommitScrollList()
        Settings.filters[switch:GetParent().key] = pressed
    end

    local function OnHeaderFilterToggle(switch, pressed)
        self[switch:GetParent().key.."Switch"] = pressed
        self.Filter:SetNeedsRefilter()
        self:RefreshFilters()
        Settings.filters[switch:GetParent().key] = pressed
    end

	--- +/- toggle ---	
    self.guildNameSwitch = Settings.filters.guildName
    self.startTimeStampSwitch = Settings.filters.startTimeStamp
    self.endTimeStampSwitch = Settings.filters.endTimeStamp

    self.sortHeaderGroup.headerContainer.sortHeaderGroup = self.sortHeaderGroup
    self.sortHeaderGroup:HeaderForKey("startTimeStamp").switch:SetPressed(self.startTimeStampSwitch)
    self.sortHeaderGroup:HeaderForKey("startTimeStamp").switch.OnToggle = OnHeaderToggle
    self.sortHeaderGroup:HeaderForKey("endTimeStamp").switch:SetPressed(self.endTimeStampSwitch)
    self.sortHeaderGroup:HeaderForKey("endTimeStamp").switch.OnToggle = OnHeaderToggle
    self.sortHeaderGroup:SelectHeaderByKey("startTimeStamp", true)
    self.currentSortKey = "startTimeStamp"
end

function ArkadiusTradeToolsExportsList:SetupFilters()
    local useSubStrings = ArkadiusTradeToolsExports.frame.filterBar.SubStrings:IsPressed()

    local CompareStringsFuncs = {}
    CompareStringsFuncs[true] = function(string1, string2) string2 = string2:gsub("-", "--") return (string.find(string1:lower(), string2) ~= nil) end
    CompareStringsFuncs[false] = function(string1, string2) return (string1:lower() == string2) end

    local item = ArkadiusTradeToolsExports.frame.filterBar.Time:GetSelectedItem()
    local newerThanTimeStamp = item.NewerThanTimeStamp()
    local olderThanTimestamp = item.OlderThanTimeStamp()

    local function CompareTimestamp(timeStamp)
        return true
        -- return ((timeStamp >= newerThanTimeStamp) and (timeStamp < olderThanTimestamp))
    end

    self.Filter:SetKeywords(ArkadiusTradeToolsExports.frame.filterBar.Text:GetStrings())
    self.Filter:SetKeyFunc(1, "startTimeStamp", CompareTimestamp)
    self.Filter:SetKeyFunc(1, "endTimeStamp", CompareTimestamp)

    if (self["guildNameSwitch"])
        then self.Filter:SetKeyFunc(2, "guildName", CompareStringsFuncs[useSubStrings])
    else
        self.Filter:SetKeyFunc(2, "guildName", nil)
    end
end

function ArkadiusTradeToolsExportsList:SetupExportRow(rowControl, rowData)
    rowControl.data = rowData
    local data = rowData.rawData
    local guildName = rowControl:GetNamedChild("GuildName")
    local startTimeStamp = rowControl:GetNamedChild("StartTimeStamp")
    local endTimeStamp = rowControl:GetNamedChild("EndTimeStamp")

    guildName:SetText(data.guildName)
    guildName:SetWidth(guildName.header:GetWidth() - 10)
    guildName:SetHidden(guildName.header:IsHidden())
    guildName:SetColor(ArkadiusTradeTools:GetGuildColor(data.guildName):UnpackRGBA())

    if (self.startTimeStampSwitch) then
        startTimeStamp:SetText(ArkadiusTradeTools:TimeStampToDateTimeString(data.startTimeStamp + ArkadiusTradeTools:GetLocalTimeShift()))
    else
        startTimeStamp:SetText(ArkadiusTradeTools:TimeStampToAgoString(data.startTimeStamp))
    end

    startTimeStamp:SetWidth(startTimeStamp.header:GetWidth() - 10)
    startTimeStamp:SetHidden(startTimeStamp.header:IsHidden())

    if (self.endTimeStampSwitch) then
        endTimeStamp:SetText(ArkadiusTradeTools:TimeStampToDateTimeString(data.endTimeStamp + ArkadiusTradeTools:GetLocalTimeShift()))
    else
        endTimeStamp:SetText(ArkadiusTradeTools:TimeStampToAgoString(data.endTimeStamp))
    end

    endTimeStamp:SetWidth(endTimeStamp.header:GetWidth() - 10)
    endTimeStamp:SetHidden(endTimeStamp.header:IsHidden())
	
	ArkadiusTradeToolsSortFilterList.SetupRow(self, rowControl, rowData)
end

---------------------------------------------------------------------------------------

local function GetSelectedIndex(combobox)
    local selectedItem = combobox:GetSelectedItemData()

    for i = 1, #combobox.m_sortedItems do
        local item = combobox.m_sortedItems[i]
        if (item == selectedItem) then
            return i
        end
    end

    return 0
end

local function SelectByIndex(combobox, index)
    if ((index) and (index > 0) and (index <= combobox.m_comboBox:GetNumItems())) then
        combobox.m_comboBox:SelectItemByIndex(index)
    end
end

function ArkadiusTradeToolsExports:SetUpToolBar()
    SLASH_COMMANDS['/attexport'] = function(args)
        local guildIndex, week = zo_strsplit(' ', args)
        guildIndex = tonumber(guildIndex) or 1
        week = tonumber(week) or 0
        local from = ArkadiusTradeTools:GetStartOfWeek(week, true)
        local to = week < 0 and ArkadiusTradeTools:GetStartOfWeek(week + 1, true) or nil
        self:GenerateExport(GetGuildId(guildIndex), from, to)
    end

    -- These two selectors should be extracted and implemented as a dropdown control template
    self.frame.toolbar.GuildSelector = self.frame.toolbar:GetNamedChild('GuildSelector')
    self.frame.toolbar.GuildSelector.m_comboBox:SetSortsItems(false)

    --- Setup Toolbar ---
    local function guildSelectorCallback(...)
        Settings.toolbar.guildSelection = GetSelectedIndex(self.frame.toolbar.GuildSelector.m_comboBox)
    end
    
    for i = 1, GetNumGuilds() do
        local guildId = GetGuildId(i)
        local guildName = GetGuildName(guildId)
        self.frame.toolbar.GuildSelector.m_comboBox:AddItem({name = guildName, guildId = guildId, callback = guildSelectorCallback})
    end
    SelectByIndex(self.frame.toolbar.GuildSelector, Settings.toolbar.guildSelection)

    local function timeSelectorCallback(...)
        Settings.toolbar.timeSelection = GetSelectedIndex(self.frame.toolbar.TimeSelector.m_comboBox)
    end

    self.frame.toolbar.TimeSelector = self.frame.toolbar:GetNamedChild('TimeSelector')
    self.frame.toolbar.TimeSelector.m_comboBox:SetSortsItems(false)
    -- These date options don't use the timestamp minus 1 as the export function runs up to (but not including) the end time stamp
    -- Subtracting 1 would result in missing sales in the last second of the export timeframe
    self.frame.toolbar.TimeSelector.m_comboBox:AddItem({name = L["ATT_STR_TODAY"], callback = timeSelectorCallback, NewerThanTimeStamp = function() return ArkadiusTradeTools:GetStartOfDay(0) end, OlderThanTimeStamp = function() return GetTimeStamp() end})
    self.frame.toolbar.TimeSelector.m_comboBox:AddItem({name = L["ATT_STR_YESTERDAY"], callback = timeSelectorCallback, NewerThanTimeStamp = function() return ArkadiusTradeTools:GetStartOfDay(-1) end, OlderThanTimeStamp = function() return ArkadiusTradeTools:GetStartOfDay(0) end})
    self.frame.toolbar.TimeSelector.m_comboBox:AddItem({name = L["ATT_STR_TWO_DAYS_AGO"], callback = timeSelectorCallback, NewerThanTimeStamp = function() return ArkadiusTradeTools:GetStartOfDay(-2) end, OlderThanTimeStamp = function() return ArkadiusTradeTools:GetStartOfDay(-1) end})
    self.frame.toolbar.TimeSelector.m_comboBox:AddItem({name = L["ATT_STR_THIS_WEEK"], callback = timeSelectorCallback, NewerThanTimeStamp = function() return ArkadiusTradeTools:GetStartOfWeek(0, true) end, OlderThanTimeStamp = function() return GetTimeStamp() end})
    self.frame.toolbar.TimeSelector.m_comboBox:AddItem({name = L["ATT_STR_LAST_WEEK"], callback = timeSelectorCallback, NewerThanTimeStamp = function() return ArkadiusTradeTools:GetStartOfWeek(-1, true) end, OlderThanTimeStamp = function() return ArkadiusTradeTools:GetStartOfWeek(0, true) end})
    self.frame.toolbar.TimeSelector.m_comboBox:AddItem({name = L["ATT_STR_PRIOR_WEEK"], callback = timeSelectorCallback, NewerThanTimeStamp = function() return ArkadiusTradeTools:GetStartOfWeek(-2, true) end, OlderThanTimeStamp = function() return ArkadiusTradeTools:GetStartOfWeek(-1, true) end})
    self.frame.toolbar.TimeSelector.m_comboBox:AddItem({name = L["ATT_STR_7_DAYS"], callback = timeSelectorCallback, NewerThanTimeStamp = function() return ArkadiusTradeTools:GetStartOfDay(-7) end, OlderThanTimeStamp = function() return GetTimeStamp() end})
    self.frame.toolbar.TimeSelector.m_comboBox:AddItem({name = L["ATT_STR_10_DAYS"], callback = timeSelectorCallback, NewerThanTimeStamp = function() return ArkadiusTradeTools:GetStartOfDay(-10) end, OlderThanTimeStamp = function() return GetTimeStamp() end})
    self.frame.toolbar.TimeSelector.m_comboBox:AddItem({name = L["ATT_STR_14_DAYS"], callback = timeSelectorCallback, NewerThanTimeStamp = function() return ArkadiusTradeTools:GetStartOfDay(-14) end, OlderThanTimeStamp = function() return GetTimeStamp() end})
    self.frame.toolbar.TimeSelector.m_comboBox:AddItem({name = L["ATT_STR_30_DAYS"], callback = timeSelectorCallback, NewerThanTimeStamp = function() return 0 end, OlderThanTimeStamp = function() return GetTimeStamp() end})
    SelectByIndex(self.frame.toolbar.TimeSelector, Settings.toolbar.timeSelection)

    self.frame.toolbar.Export = self.frame.toolbar:GetNamedChild('Export')
    self.frame.toolbar.Export:SetText(L["ATT_STR_EXPORT"])
    self.frame.toolbar.Export:SetHandler("OnClicked", function() 
        local selectedGuildId = self.frame.toolbar.GuildSelector.m_comboBox:GetSelectedItemData().guildId
        local timeData = self.frame.toolbar.TimeSelector.m_comboBox:GetSelectedItemData()
        local startTime = timeData.NewerThanTimeStamp()
        local stopTime = timeData.OlderThanTimeStamp()
        self:GenerateExport(selectedGuildId, startTime, stopTime) 
    end)
end

function ArkadiusTradeToolsExports:Initialize()
    self.frame = ArkadiusTradeToolsExportsFrame
    ArkadiusTradeTools.TabWindow:AddTab(self.frame, L["ATT_STR_EXPORTS"], "/esoui/art/vendor/vendor_tabicon_buy_up.dds", "/esoui/art/vendor/vendor_tabicon_buy_up.dds", {left = 0.15, top = 0.15, right = 0.85, bottom = 0.85})

    self.list = ArkadiusTradeToolsExportsList:New(self, self.frame)
    self.frame.list = self.frame:GetNamedChild("List")
    self.frame.toolbar = self.frame:GetNamedChild("ToolBar")
    self.frame.filterBar = self.frame:GetNamedChild("FilterBar")
    self.frame.headers = self.frame:GetNamedChild("Headers")
--    self.frame.headers.OnHeaderShow = function(header, hidden) self:OnHeaderVisibilityChanged(header, hidden) end
--    self.frame.headers.OnHeaderHide = function(header, hidden) self:OnHeaderVisibilityChanged(header, hidden) end
    self.frame.headers.guildName = self.frame.headers:GetNamedChild("GuildName")
    self.frame.headers.startTimeStamp = self.frame.headers:GetNamedChild("StartTimeStamp")
    self.frame.headers.endTimeStamp = self.frame.headers:GetNamedChild("EndTimeStamp")
    self.frame.OnResize = self.OnResize
    self.frame:SetHandler("OnEffectivelyShown", function(_, hidden) if (hidden == false) then self.list:RefreshData() end end)

    self:LoadSettings()
    self:LoadExports()
    self:SetUpToolBar()

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
    self.frame.filterBar.Text.tooltip:SetContent(L["ATT_STR_FILTER_TEXT_TOOLTIP"])
    self.frame.filterBar.SubStrings.OnToggle = function(switch, pressed) self.list.Filter:SetNeedsRefilter() self.list:RefreshFilters() Settings.filters.useSubStrings = pressed end
    self.frame.filterBar.SubStrings:SetPressed(Settings.filters.useSubStrings)
    self.frame.filterBar.SubStrings.tooltip:SetContent(L["ATT_STR_FILTER_SUBSTRING_TOOLTIP"])
    self.frame.filterBar:SetHidden(true)
    -----------------------
end

function ArkadiusTradeToolsExports:Finalize()
    -- self:CleanupSavedVariables()
    self:SaveSettings()
end

function ArkadiusTradeToolsExports:GenerateExport(guildId, startTimestamp, endTimestamp)
    startTimestamp = startTimestamp or 0
    endTimestamp = endTimestamp or GetTimeStamp()
    local guildName = GetGuildName(guildId)
    local statsByUserName = {}
    local numGuildMembers = GetNumGuildMembers(guildId)
    for i = 1, numGuildMembers do
        local name, _, rankIndex = GetGuildMemberInfo(guildId, i)
        local rankName = GetGuildRankCustomName(guildId, rankIndex)
        statsByUserName[name:lower()] = {
            displayName = ArkadiusTradeToolsSales:LookupDisplayName(name:lower()) or name,
            isMember = true,
            rankIndex = rankIndex,
            rankName = rankName,
            stats = {
                salesVolume = 0,
                salesCount = 0,
                itemCount = 0,
                taxes = 0,
                purchaseVolume = 0,
                purchaseCount = 0,
                purchasedItemCount = 0,
                purchaseTaxes = 0,
                internalSalesVolume = 0
            }
        }
    end
    ArkadiusTradeToolsSales:GetFullStatisticsForGuild(
        statsByUserName,
        startTimestamp,
        endTimestamp,
        guildName,
        nil,
        false
    )
    local statsByUser = {}
    for name, userRecord in pairs(statsByUserName) do
        userRecord.isMember = userRecord.isMember or false
        statsByUser[#statsByUser + 1] = userRecord
    end
    self:OnExportCreated(guildName, startTimestamp, endTimestamp, statsByUser)
end

function ArkadiusTradeToolsExports:GetSettingsMenu()
    local settingsMenu = {}

    table.insert(settingsMenu, {type = "header", name = L["ATT_STR_EXPORTS"]})
    table.insert(settingsMenu, {type = "slider", name = L["ATT_STR_KEEP_EXPORTS_FOR_DAYS"], min = 1, max = 365, getFunc = function() return Settings.keepDataDays end, setFunc = function(value) Settings.keepDataDays = value end})
    table.insert(settingsMenu, {type = "custom"})

    return settingsMenu
end

function ArkadiusTradeToolsExports:LoadSettings()
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

function ArkadiusTradeToolsExports:SaveSettings()
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

function ArkadiusTradeToolsExports:CleanupSavedVariables()
    local timeStamp = GetTimeStamp() - Settings.keepDataDays * SECONDS_IN_DAY

    --- Delete old exports ---
    for i, export in pairs(Exports) do
        if export.startTimeStamp <= timeStamp then
            Exports[i] = nil
        end
	end
end

function ArkadiusTradeToolsExports:LoadExports()
    for _, export in pairs(Exports) do
        self.list:UpdateMasterList(export)
    end
end

function ArkadiusTradeToolsExports:OnExportCreated(guildName, startTimeStamp, endTimeStamp, data)
    local export = {guildName = guildName, startTimeStamp = startTimeStamp, endTimeStamp = endTimeStamp, data = data}

    table.insert(Exports, export)

    --- Update list ---
    self.list:UpdateMasterList(export)
    self.list:RefreshData()
end

function ArkadiusTradeToolsExports.OnResize(frame, width, height)
    frame.headers:Update()
    ZO_ScrollList_Commit(frame.list)
end

--------------------------------------------------------
------------------- Local functions --------------------
--------------------------------------------------------

local function onAddOnLoaded(eventCode, addonName)
    if (addonName ~= ArkadiusTradeToolsExports.NAME) then
        return
    end

    local serverName = GetWorldName()

    ArkadiusTradeToolsExportsData = ArkadiusTradeToolsExportsData or {}
    ArkadiusTradeToolsExportsData.exports = ArkadiusTradeToolsExportsData.exports or {}
    ArkadiusTradeToolsExportsData.exports[serverName] = ArkadiusTradeToolsExportsData.exports[serverName] or {}
    ArkadiusTradeToolsExportsData.settings = ArkadiusTradeToolsExportsData.settings or {}

    Settings = ArkadiusTradeToolsExportsData.settings
    Exports = ArkadiusTradeToolsExportsData.exports[serverName]

    --- Create default settings ---
    Settings.keepDataDays = Settings.keepDataDays or 30
    Settings.filters = Settings.filters or {}
    Settings.filters.timeSelection = Settings.filters.timeSelection or 4
    if (Settings.filters.guildName == nil) then Settings.filters.guildName = true end
    if (Settings.filters.startTimeStamp == nil) then Settings.filters.startTimeStamp = false end
    if (Settings.filters.endTimeStamp == nil) then Settings.filters.endTimeStamp = false end
    if (Settings.filters.useSubStrings == nil) then Settings.filters.useSubStrings = true end
    Settings.toolbar = Settings.toolbar or {}
    Settings.toolbar.guildSelection = Settings.toolbar.guildSelection or 1
    Settings.toolbar.timeSelection = Settings.toolbar.timeSelection or 4
    EVENT_MANAGER:UnregisterForEvent(ArkadiusTradeToolsExports.NAME, EVENT_ADD_ON_LOADED)
end

EVENT_MANAGER:RegisterForEvent(ArkadiusTradeToolsExports.NAME, EVENT_ADD_ON_LOADED, onAddOnLoaded)
