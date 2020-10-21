ArkadiusTradeTools.Modules.Exports =
    ArkadiusTradeTools.Templates.Module:New(
    ArkadiusTradeTools.NAME .. "Exports",
    ArkadiusTradeTools.TITLE .. " - Exports",
    ArkadiusTradeTools.VERSION,
    ArkadiusTradeTools.AUTHOR
)
local ArkadiusTradeToolsExports = ArkadiusTradeTools.Modules.Exports
ArkadiusTradeToolsExports.Localization = {}

local L = ArkadiusTradeToolsExports.Localization
local Utilities = ArkadiusTradeTools.Utilities
local ArkadiusTradeToolsSales = ArkadiusTradeTools.Modules.Sales
local Settings
local Exports

local SECONDS_IN_HOUR = 60 * 60
local SECONDS_IN_DAY = SECONDS_IN_HOUR * 24

---------------------------------------------------------------------------------------
function ArkadiusTradeToolsExports:Initialize(serverName, displayName)
    self.serverName = serverName
    self.displayName = displayName

    --- Setup exports frame ---
    -- self.frame = ArkadiusTradeToolsExportsFrame

    --- Setup FilterBar ---
    local function callback(...)
        self.list.Filter:SetNeedsRefilter()
        self.list:RefreshData()
        Settings.filters.timeSelection = self.frame.filterBar.Time:GetSelectedIndex()
    end

    SLASH_COMMANDS['/attexport'] = function(args)
        local guildIndex, week = zo_strsplit(' ', args)
        guildIndex = tonumber(guildIndex) or 1
        week = tonumber(week) or 0
        local from = ArkadiusTradeTools:GetStartOfWeek(week, true)
        local to = week < 0 and ArkadiusTradeTools:GetStartOfWeek(week + 1, true) or nil
        self:SaveGuildStats(GetGuildId(guildIndex), from, to)
    end

    -- self.frame.filterBar.Time:AddItem({name = L["ATT_STR_TODAY"], callback = callback, NewerThanTimeStamp = function() return ArkadiusTradeTools:GetStartOfDay(0) end, OlderThanTimeStamp = function() return GetTimeStamp() end})
    -- self.frame.filterBar.Time:AddItem({name = L["ATT_STR_YESTERDAY"], callback = callback, NewerThanTimeStamp = function() return ArkadiusTradeTools:GetStartOfDay(-1) end, OlderThanTimeStamp = function() return ArkadiusTradeTools:GetStartOfDay(0) - 1 end})
    -- self.frame.filterBar.Time:AddItem({name = L["ATT_STR_TWO_DAYS_AGO"], callback = callback, NewerThanTimeStamp = function() return ArkadiusTradeTools:GetStartOfDay(-2) end, OlderThanTimeStamp = function() return ArkadiusTradeTools:GetStartOfDay(-1) - 1 end})
    -- self.frame.filterBar.Time:AddItem({name = L["ATT_STR_THIS_WEEK"], callback = callback, NewerThanTimeStamp = function() return ArkadiusTradeTools:GetStartOfWeek(0, true) end, OlderThanTimeStamp = function() return GetTimeStamp() end})
    -- self.frame.filterBar.Time:AddItem({name = L["ATT_STR_LAST_WEEK"], callback = callback, NewerThanTimeStamp = function() return ArkadiusTradeTools:GetStartOfWeek(-1, true) end, OlderThanTimeStamp = function() return ArkadiusTradeTools:GetStartOfWeek(0, true) - 1 end})
    -- self.frame.filterBar.Time:AddItem({name = L["ATT_STR_PRIOR_WEEK"], callback = callback, NewerThanTimeStamp = function() return ArkadiusTradeTools:GetStartOfWeek(-2, true) end, OlderThanTimeStamp = function() return ArkadiusTradeTools:GetStartOfWeek(-1, true) - 1 end})
    -- self.frame.filterBar.Time:AddItem({name = L["ATT_STR_7_DAYS"], callback = callback, NewerThanTimeStamp = function() return ArkadiusTradeTools:GetStartOfDay(-7) end, OlderThanTimeStamp = function() return GetTimeStamp() end})
    -- self.frame.filterBar.Time:AddItem({name = L["ATT_STR_10_DAYS"], callback = callback, NewerThanTimeStamp = function() return ArkadiusTradeTools:GetStartOfDay(-10) end, OlderThanTimeStamp = function() return GetTimeStamp() end})
    -- self.frame.filterBar.Time:AddItem({name = L["ATT_STR_14_DAYS"], callback = callback, NewerThanTimeStamp = function() return ArkadiusTradeTools:GetStartOfDay(-14) end, OlderThanTimeStamp = function() return GetTimeStamp() end})
    -- self.frame.filterBar.Time:AddItem({name = L["ATT_STR_30_DAYS"], callback = callback, NewerThanTimeStamp = function() return 0 end, OlderThanTimeStamp = function() return GetTimeStamp() end})
    -- self.frame.filterBar.Time:SelectByIndex(Settings.filters.timeSelection)
    -- self.frame.filterBar.Text.OnChanged = function(text) self.list:RefreshFilters() end
    -- self.frame.filterBar.Text:SetText(displayName:lower())
    -- self.frame.filterBar.Text.tooltip:SetContent(L["ATT_STR_FILTER_TEXT_TOOLTIP"])
    -- self.frame.filterBar.SubStrings.OnToggle = function(switch, pressed) self.list.Filter:SetNeedsRefilter() self.list:RefreshFilters() Settings.filters.useSubStrings = pressed end
    -- self.frame.filterBar.SubStrings:SetPressed(Settings.filters.useSubStrings)
    -- self.frame.filterBar.SubStrings.tooltip:SetContent(L["ATT_STR_FILTER_SUBSTRING_TOOLTIP"])
    ---------------------------------------------
end

function ArkadiusTradeToolsExports:SaveGuildStats(guildId, startTimestamp, endTimestamp)
    startTimestamp = startTimestamp or 0
    endTimestamp = endTimestamp or GetTimeStamp()
    local guildName = GetGuildName(guildId)
    local _statsByUserName = {}
    local numGuildMembers = GetNumGuildMembers(guildId)
    for i = 1, numGuildMembers do
        local name, _, rankIndex = GetGuildMemberInfo(guildId, i)
        local rankName = GetGuildRankCustomName(guildId, rankIndex)
        _statsByUserName[name:lower()] = {
            displayName = name,
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
        _statsByUserName,
        startTimestamp,
        endTimestamp,
        guildName,
        nil,
        false
    )
    local _statsByUser = {}
    for name, userRecord in pairs(_statsByUserName) do
        userRecord.isMember = userRecord.isMember or false
        _statsByUser[#_statsByUser + 1] = userRecord
    end
    ArkadiusTradeToolsExportsData = ArkadiusTradeToolsExportsData or {}
    ArkadiusTradeToolsExportsData[guildName] = ArkadiusTradeToolsExportsData[guildName] or {}
    ArkadiusTradeToolsExportsData[guildName]['exports'] = ArkadiusTradeToolsExportsData[guildName]['exports'] or {}
    ArkadiusTradeToolsExportsData[guildName]['exports'][#ArkadiusTradeToolsExportsData[guildName]['exports'] + 1] = {
        startTimestamp = startTimestamp,
        endTimestamp = endTimestamp,
        data = _statsByUser
    }
end

-- function ArkadiusTradeToolsExports:GetSettingsMenu()
--     local settingsMenu = {}
--     local guildNames = {}

--     table.insert(settingsMenu, {type = "header", name = L["ATT_STR_EXPORTS"]})

--     for guildName, _ in pairs(TemporaryVariables.guildNamesLowered) do
--         table.insert(guildNames, guildName)
--     end

--     table.sort(guildNames)

--     table.insert(settingsMenu, {type = "description", text = L["ATT_STR_KEEP_SALES_FOR_DAYS"]})

--     for _, guildName in pairs(guildNames) do
--         table.insert(settingsMenu, {type = "slider", name = guildName, min = 1, max = 30, getFunc = function() return Settings.guilds[guildName].keepSalesForDays end, setFunc = function(value) Settings.guilds[guildName].keepSalesForDays = value end})
--     end

--     table.insert(settingsMenu, {type = "custom"})

--     return settingsMenu
-- end

function ArkadiusTradeToolsExports:Finalize()
end
