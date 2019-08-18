ArkadiusTradeTools = ZO_CallbackObject:New()
ArkadiusTradeTools.NAME = "ArkadiusTradeTools"
ArkadiusTradeTools.TITLE = "Arkadius Trade Tools"
ArkadiusTradeTools.VERSION = "1.1.1"
ArkadiusTradeTools.AUTHOR = "@Arkadius1"
ArkadiusTradeTools.Localization = {}
ArkadiusTradeTools.SavedVariables = {}
ArkadiusTradeTools.Modules = {}
ArkadiusTradeTools.EVENTS =
{
    ON_MAILBOX_OPEN           = 1,
    ON_MAILBOX_CLOSE          = 2,
    ON_GUILDSTORE_OPEN        = 3,
    ON_GUILDSTORE_CLOSE       = 4,
    ON_CRAFTING_STATION_OPEN  = 5,
    ON_CRAFTING_STATION_CLOSE = 6,
    ON_GUILDSTORE_ITEM_BOUGHT = 7,
    ON_GUILDHISTORY_STORE     = 8,
}

local L = ArkadiusTradeTools.Localization
local EVENTS = ArkadiusTradeTools.EVENTS
local Settings

local SECONDS_IN_HOUR = 60 * 60
local SECONDS_IN_DAY = SECONDS_IN_HOUR * 24
local SECONDS_IN_WEEK = SECONDS_IN_DAY * 7

--local LGH = LibStub("LibGuildHistory-2.0")
local LGH = LibGuildHistory2
---------------------------------

function math.attRound(num, numDecimals)
    return tonumber(string.format("%." .. (numDecimals or 0) .. "f", num))
end

local function RequestGuildHistoryCategoryOlderLocal(guildIndex, category, numGuilds)
    if (RequestGuildHistoryCategoryOlder(GetGuildId(guildIndex), category)) then
        ArkadiusTradeTools.guildStatus:SetBusy(guildIndex)

        if (guildIndex < numGuilds) then
            ArkadiusTradeTools.nextScanGuild = guildIndex + 1
        else
            ArkadiusTradeTools.nextScanGuild = 1
        end

        return true
    end

    ArkadiusTradeTools.guildStatus:SetDone(guildIndex)

    return false
end

local function ScanGuildHistoryEvents()
    if (((Settings.scanDuringCombat) and (ArkadiusTradeTools.isInCombat)) or (not ArkadiusTradeTools.isInCombat)) then
        local numGuilds = GetNumGuilds()
        local guildId

        --- Scan for new events ---
        for i = 1, numGuilds do
            guildId = GetGuildId(i)

            if (RequestGuildHistoryCategoryNewest(guildId, GUILD_HISTORY_STORE)) then
                ArkadiusTradeTools.guildStatus:SetBusy(i)
		        zo_callLater(ScanGuildHistoryEvents, Settings.shortScanInterval)

                return
            end
        end

        --- No new events, so scan for older events ---
        for i = ArkadiusTradeTools.nextScanGuild, numGuilds do
            if (RequestGuildHistoryCategoryOlderLocal(i, GUILD_HISTORY_STORE, numGuilds)) then
                zo_callLater(ScanGuildHistoryEvents, Settings.shortScanInterval)

                return
            end
        end

        for i = 1, ArkadiusTradeTools.nextScanGuild - 1 do
            if (RequestGuildHistoryCategoryOlderLocal(i, GUILD_HISTORY_STORE, numGuilds)) then
                zo_callLater(ScanGuildHistoryEvents, Settings.shortScanInterval)

                return
            end
        end

        ArkadiusTradeTools.guildStatus:SetBusy(0)
        ArkadiusTradeTools.nextScanGuild = 1

        zo_callLater(ScanGuildHistoryEvents, Settings.longScanInterval * 1000)
    else
        zo_callLater(ScanGuildHistoryEvents, Settings.shortScanInterval)
    end
end

--------------------------------------------------------
------------------- Global functions -------------------
--------------------------------------------------------
function ArkadiusTradeTools:Initialize()
    self.frame = ArkadiusTradeToolsWindow
    self.TabWindow = GetControl(self.frame, "TabWindow")

    self.frame:ClearAnchors()
    self.frame:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, Settings.windowLeft or 100, Settings.windowTop or 100)
    self.frame:SetWidth(Settings.windowWidth or 1000)
    self.frame:SetHeight(Settings.windowHeight or 700)

    local serverName = GetWorldName()
    local displayName = GetDisplayName()

    --- Temporary workaround for fixed tab positions ---
    if (self.Modules["Sales"]) then
        self.Modules["Sales"]:Initialize(serverName, displayName)
    end

    if (self.Modules["Purchases"]) then
        self.Modules["Purchases"]:Initialize(serverName, displayName)
    end

    if (self.Modules["Statistics"]) then
        self.Modules["Statistics"]:Initialize(serverName, displayName)
    end

--    for moduleName, moduleObject in pairs(self.Modules) do
--        moduleObject:Initialize()
--    end

    self:CreateSettingsMenu()

    local header = GetControl(self.frame, "Header")
    local buttonClose = GetControl(header, "Close")
    local buttonDrawTier = GetControl(header, "DrawTier")
    buttonClose.tooltip:SetContent(L["ATT_STR_BUTTON_CLOSE_TOOLTIP"])
    buttonDrawTier.tooltip:SetContent(L["ATT_STR_BUTTON_DRAWTIER_TOOLTIP"])
    buttonDrawTier.OnToggle = function(switch, pressed)
        local drawTier
        if (pressed) then
            drawTier = DT_MEDIUM
        else
            drawTier = DT_HIGH
        end
        self.frame:SetDrawTier(drawTier)
        Settings.drawTier = drawTier
    end
    buttonDrawTier:SetPressed(Settings.drawTier == DT_MEDIUM)


    local statusBar = GetControl(self.frame, "StatusBar")
    self.guildStatus = GetControl(statusBar, "GuildStatus")
    self.guildStatus:SetText(1, L["ATT_STR_GUILDSTATUS_TOOLTIP_LINE1"])
    self.guildStatus:SetText(2, L["ATT_STR_GUILDSTATUS_TOOLTIP_LINE2"])
    self.guildStatus:SetText(3, L["ATT_STR_GUILDSTATUS_TOOLTIP_LINE3"])
    local guildStatusText = GetControl(self.guildStatus, "Text")
    guildStatusText:SetText(L["ATT_STR_GUILDSTATUS_TEXT"])

    --local buttonDonate = GetControl(statusBar, "Donate")
    --buttonDonate:SetText(L["ATT_STR_DONATE"])
    --buttonDonate.tooltip:SetContent(L["ATT_STR_DONATE_TOOLTIP"])

    self.nextScanGuild = 1
end

function ArkadiusTradeTools:Finalize()
    for moduleName, moduleObject in pairs(self.Modules) do
        moduleObject:Finalize()
    end

    local _, _, _, _, offsetX, offsetY = self.frame:GetAnchor(0)

    Settings.windowLeft = self.frame:GetLeft()
    Settings.windowTop = self.frame:GetTop()
    Settings.windowWidth = self.frame:GetWidth()
    Settings.windowHeight = self.frame:GetHeight()
end

function ArkadiusTradeTools:CreateSettingsMenu()
	local LAM = LibStub("LibAddonMenu-2.0")

    LAM:RegisterAddonPanel(self.TITLE,
    {
        type = "panel",
        name = self.TITLE,
        displayName = self.TITLE,
        author = self.AUTHOR,
        version = self.VERSION,
        registerForRefresh = true,
    })

    local settingsMenu = {}

    table.insert(settingsMenu, {type = "header", name = L["ATT_STR_GENERAL"]})
    table.insert(settingsMenu, {type = "checkbox", name = L["ATT_STR_SHOW_WINDOW_ON_MAIL"], getFunc = function() return Settings.showOnMailbox end, setFunc = function(bool) Settings.showOnMailbox = bool end})
    table.insert(settingsMenu, {type = "checkbox", name = L["ATT_STR_SHOW_WINDOW_ON_GUILDSTORE"], getFunc = function() return Settings.showOnGuildStore end, setFunc = function(bool) Settings.showOnGuildStore = bool end})
    table.insert(settingsMenu, {type = "checkbox", name = L["ATT_STR_SHOW_WINDOW_ON_CRAFTINGSTATION"], getFunc = function() return Settings.showOnCraftingStation end, setFunc = function(bool) Settings.showOnCraftingStation = bool end})

    table.insert(settingsMenu, {type = "checkbox", name = L["ATT_STR_SHOW_NOTIFICATIONS"], getFunc = function() return Settings.showNotifications end, setFunc = function(bool) Settings.showNotifications = bool end})
    table.insert(settingsMenu, {type = "checkbox", name = L["ATT_STR_SHOW_NOTIFICATIONS_DURING_COMBAT"], getFunc = function() return Settings.showNotificationsDuringCombat end, setFunc = function(bool) Settings.showNotificationsDuringCombat = bool end, disabled = function() return not Settings.showNotifications end})
    table.insert(settingsMenu, {type = "checkbox", name = L["ATT_STR_HIGHLIGHT_OWN_NAME_BY_COLOR"], getFunc = function() return Settings.highlightUserDisplayName end, setFunc = function(bool) Settings.highlightUserDisplayName = bool end})
    table.insert(settingsMenu, {type = "colorpicker", name = L["ATT_STR_COLOR"], getFunc = function() return Settings.userDisplayNameColor.r, Settings.userDisplayNameColor.g, Settings.userDisplayNameColor.b end, setFunc = function(r, g, b) Settings.userDisplayNameColor.r = r Settings.userDisplayNameColor.g = g Settings.userDisplayNameColor.b = b end, disabled = function() return not Settings.highlightUserDisplayName end})
    table.insert(settingsMenu, {type = "checkbox", name = L["ATT_STR_HIGHLIGHT_OWN_GUILDNAMES_BY_CHAT_COLOR"], getFunc = function() return Settings.highlightGuildNames end, setFunc = function(bool) Settings.highlightGuildNames = bool end})
    table.insert(settingsMenu, {type = "custom"})

    table.insert(settingsMenu, {type = "header", name = L["ATT_STR_EXTENDED"]})
    table.insert(settingsMenu, {type = "checkbox", name = L["ATT_STR_SCAN_DURING_COMBAT"], getFunc = function() return Settings.scanDuringCombat end, setFunc = function(bool) Settings.scanDuringCombat = bool end})
    table.insert(settingsMenu, {type = "slider", name = L["ATT_STR_SCAN_LONG_INTERVAL"], min = 5, max = 600, getFunc = function() return Settings.longScanInterval end, setFunc = function(value) Settings.longScanInterval = value end})
    table.insert(settingsMenu, {type = "slider", name = L["ATT_STR_SCAN_SHORT_INTERVAL"], min = 1000, max = 5000, getFunc = function() return Settings.shortScanInterval end, setFunc = function(value) Settings.shortScanInterval = value end})
    table.insert(settingsMenu, {type = "custom"})

    for moduleName, moduleObject in pairs(self.Modules) do
        local settingsSubMenu = moduleObject:GetSettingsMenu()

        if (settingsSubMenu ~= nil) then
--            table.insert(settingsMenu, {type = "submenu", name = moduleName, controls = settingsSubMenu})
            for i = 1, #settingsSubMenu do
                table.insert(settingsMenu, settingsSubMenu[i])
            end
        end
    end

    LAM:RegisterOptionControls(self.TITLE, settingsMenu)
end

function ArkadiusTradeTools:GetLocalTimeShift()
    local timeShift = GetSecondsSinceMidnight() - (GetTimeStamp() % 86400)

    if (timeShift < -12 * 60 * 60) then 
        timeShift = timeShift + 86400
    end

    return timeShift
end

function ArkadiusTradeTools:TimeStampToDateTimeString(timeStamp)
    local timeShift = self:GetLocalTimeShift()
    -- It looks like GetDateStringFromTimestamp already uses local time zones, so we substract it here --
    local dateString = GetDateStringFromTimestamp(timeStamp - timeShift)
    local timeString = ZO_FormatTime(timeStamp % 86400, TIME_FORMAT_STYLE_CLOCK_TIME, TIME_FORMAT_PRECISION_TWENTY_FOUR_HOUR)

    return dateString .. " " .. timeString
end

function ArkadiusTradeTools:TimeStampToAgoString(timeStamp)
    return ZO_FormatDurationAgo(GetTimeStamp() - timeStamp)
end

function ArkadiusTradeTools:GetStartOfDayFromTimeStamp(timeStamp)
    timeStamp = timeStamp or GetTimeStamp()
    timeStamp = math.floor(timeStamp / SECONDS_IN_DAY) * SECONDS_IN_DAY

    return timeStamp
end

function ArkadiusTradeTools:GetStartOfHourFromTimeStamp(timeStamp)
    timeStamp = timeStamp or GetTimeStamp()
    timeStamp = math.floor(timeStamp / SECONDS_IN_HOUR) * SECONDS_IN_HOUR

    return timeStamp
end

--- Returns the UTC timestamp for last midnight ---
function ArkadiusTradeTools:GetStartOfDay(relativeDay)
    relativeDay = relativeDay or 0

    local timeStamp = GetTimeStamp()
    local days = math.floor(timeStamp / SECONDS_IN_DAY)

    timeStamp = days * SECONDS_IN_DAY
    timeStamp = timeStamp + relativeDay * SECONDS_IN_DAY

    return timeStamp
end

--- Returns the UTC timestamp for last Monday midnight ---
function ArkadiusTradeTools:GetStartOfWeek(relativeWeek, useTradeWeek)
    relativeWeek = relativeWeek or 0

    local currentTimeStamp = GetTimeStamp()
    local days = math.floor(currentTimeStamp / SECONDS_IN_DAY)
    local today = days % 7

    local result = days * SECONDS_IN_DAY

    local goBack = {}
    goBack[0] = 3 * SECONDS_IN_DAY -- Thursday
    goBack[1] = 4 * SECONDS_IN_DAY -- Friday
    goBack[2] = 5 * SECONDS_IN_DAY -- Saturday
    goBack[3] = 6 * SECONDS_IN_DAY -- Sunday
    goBack[4] = 0                  -- Monday
    goBack[5] = 1 * SECONDS_IN_DAY -- Tuesday
    goBack[6] = 2 * SECONDS_IN_DAY -- Wednesday

    -- Monday midnight --
    result = result - goBack[today]
    result = result + relativeWeek * SECONDS_IN_WEEK

    if (useTradeWeek) then
        -- Adjust to server locations
        if (GetWorldName() == "EU Megaserver") then
            -- EU - Sundays 19:00 pm UTC
            local secondsLeftThisWeek = self:GetStartOfWeek(1) - currentTimeStamp
            local hoursLeftThisWeek = math.floor(secondsLeftThisWeek / SECONDS_IN_HOUR)

            if (hoursLeftThisWeek < 5) then
                result = result + SECONDS_IN_WEEK
            end

            result = result - 5 * SECONDS_IN_HOUR
        else
            -- NA/PTS - Mondays 01:00 am UTC
            local secondsGoneThisWeek = currentTimeStamp - self:GetStartOfWeek(0)
            local hoursGoneThisWeek = math.floor(secondsGoneThisWeek / SECONDS_IN_HOUR)

            if (hoursGoneThisWeek < 1) then
              result = result - SECONDS_IN_WEEK
            end

            result = result + 1 * SECONDS_IN_HOUR
        end
    end

    return result
end

function ArkadiusTradeTools:GetGuildColor(guildName)
    local color = ZO_ColorDef:New(1, 1, 1, 1)

    if ((guildName == nil) or (guildName == "") or (not Settings.highlightGuildNames)) then
        return color
	end

    local guildChatCategories = {}
    guildChatCategories[1] = CHAT_CATEGORY_GUILD_1
    guildChatCategories[2] = CHAT_CATEGORY_GUILD_2
    guildChatCategories[3] = CHAT_CATEGORY_GUILD_3
    guildChatCategories[4] = CHAT_CATEGORY_GUILD_4
    guildChatCategories[5] = CHAT_CATEGORY_GUILD_5


    for i = 1, GetNumGuilds() do
        local guildId = GetGuildId(i)

        if (GetGuildName(guildId) == guildName) then
            color:SetRGB(GetChatCategoryColor(guildChatCategories[i]))

            break
        end
    end

    return color
end

function ArkadiusTradeTools:GetDisplayNameColor(displayName)
    local color = ZO_ColorDef:New(1, 1, 1, 1)

    if ((displayName == GetDisplayName()) and (Settings.highlightUserDisplayName)) then
        color = ZO_ColorDef:New(Settings.userDisplayNameColor.r, Settings.userDisplayNameColor.g, Settings.userDisplayNameColor.b)
    end

    return color
end


function ArkadiusTradeTools:LocalizeDezimalNumber(number)
    local left,num,right = string.match(number, '^([^%d]*%d)(%d*)(.-)$')
    local numStr = left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right

    return ZO_FastFormatDecimalNumber(numStr)
end


function ArkadiusTradeTools:ShowNotification(notification)
    if ((not Settings.showNotifications) or ((not Settings.showNotificationsDuringCombat) and (self.isInCombat))) then
        return
    end

    if (type(notification) == "table") then
        for _, text in pairs(notification) do
            self:ShowNotification(text)
        end

        return
    end

    d(notification)
    CENTER_SCREEN_ANNOUNCE:AddMessage(nil, CSA_CATEGORY_SMALL_TEXT, SOUNDS.ITEM_MONEY_CHANGED, notification, nil, nil, nil, nil, nil, 5000, nil, QUEUE_IMMEDIATELY, SHOW_IMMEDIATELY, REINSERT_STOMPED_MESSAGE)
end

function ArkadiusTradeTools:CreateDefaultSettings(settings, defaultSettings)
    if (settings == nil) then
        return
    end

    for key, value in pairs(defaultSettings) do
        if (type(value) == "table") then
            if (type(settings[key]) ~= "table") then
                settings[key] = {}
            end

            self:CreateDefaultSettings(settings[key], value)
        else
            if ((type(settings[key]) == "table") or (settings[key] == nil))then
                settings[key] = value
            end
        end
    end
end

function ArkadiusTradeTools:OnEvent(eventCode, arg1, arg2, ...)
    if ((eventCode == EVENT_MAIL_OPEN_MAILBOX) or (eventCode == EVENT_MAIL_CLOSE_MAILBOX)) then
        if (Settings.showOnMailbox) then
            self.frame:SetHidden(eventCode == EVENT_MAIL_CLOSE_MAILBOX)
        end

        if (eventCode == EVENT_MAIL_OPEN_MAILBOX) then
            self:FireCallbacks(EVENTS.ON_MAILBOX_OPEN)
        else
            self:FireCallbacks(EVENTS.ON_MAILBOX_CLOSE)
        end
    elseif ((eventCode == EVENT_OPEN_TRADING_HOUSE) or (eventCode == EVENT_CLOSE_TRADING_HOUSE)) then
        if (Settings.showOnGuildStore) then
            self.frame:SetHidden(eventCode == EVENT_CLOSE_TRADING_HOUSE)
        end

        if (eventCode == EVENT_OPEN_TRADING_HOUSE) then
            self:FireCallbacks(EVENTS.ON_GUILDSTORE_OPEN)
        else
            self:FireCallbacks(EVENTS.ON_GUILDSTORE_CLOSE)
        end
    elseif ((eventCode == EVENT_CRAFTING_STATION_INTERACT) or (eventCode == EVENT_END_CRAFTING_STATION_INTERACT)) then
        if (Settings.showOnCraftingStation) then
            self.frame:SetHidden(eventCode == EVENT_END_CRAFTING_STATION_INTERACT)
        end

        if (eventCode == EVENT_CRAFTING_STATION_INTERACT) then
            self:FireCallbacks(EVENTS.ON_CRAFTING_STATION_OPEN)
        else
            self:FireCallbacks(EVENTS.ON_CRAFTING_STATION_CLOSE)
        end
    elseif (eventCode == EVENT_GUILD_HISTORY_RESPONSE_RECEIVED) then
        if (arg2 == GUILD_HISTORY_STORE) then
            self:FireCallbacks(EVENTS.ON_GUILDHISTORY_STORE, arg1)
        end
    elseif (eventCode == EVENT_TRADING_HOUSE_CONFIRM_ITEM_PURCHASE) then
        local _, _, _, quantity, sellerName, _, price = GetTradingHouseSearchResultItemInfo(arg1) -- TODO check this again, may return empty vaules
        local _, guildName = GetCurrentTradingHouseGuildDetails()

        self.currentPurchase = {}
        self.currentPurchase.guildName = guildName
        self.currentPurchase.sellerName = sellerName:gsub("|c.-$", "")
        self.currentPurchase.itemLink = GetTradingHouseSearchResultItemLink(arg1)
        self.currentPurchase.quantity = quantity
        self.currentPurchase.price = price
    elseif (eventCode == EVENT_TRADING_HOUSE_RESPONSE_RECEIVED) then
        if (arg1 == TRADING_HOUSE_RESULT_PURCHASE_PENDING) and (arg2 == TRADING_HOUSE_RESULT_SUCCESS) then
            self:FireCallbacks(EVENTS.ON_GUILDSTORE_ITEM_BOUGHT, self.currentPurchase.guildName, self.currentPurchase.sellerName, self.currentPurchase.itemLink, self.currentPurchase.quantity, self.currentPurchase.price, GetTimeStamp())
        end
    elseif (eventCode == EVENT_PLAYER_COMBAT_STATE) then
        self.isInCombat = arg1
    end
end

--------------------------------------------------------
------------------- Local functions --------------------
--------------------------------------------------------
local function OnSlashCommand(option)
    if (option == "") then
        ArkadiusTradeToolsWindow:ToggleHidden()
    end
end

local function OnEvent(...)
    ArkadiusTradeTools:OnEvent(...)
end

local function OnPlayerActivated(eventCode)
    EVENT_MANAGER:UnregisterForEvent(ArkadiusTradeTools.NAME, eventCode)

    ArkadiusTradeTools:Initialize()

	EVENT_MANAGER:RegisterForEvent(ArkadiusTradeTools.NAME, EVENT_MAIL_OPEN_MAILBOX, OnEvent)
	EVENT_MANAGER:RegisterForEvent(ArkadiusTradeTools.NAME, EVENT_MAIL_CLOSE_MAILBOX, OnEvent)
	EVENT_MANAGER:RegisterForEvent(ArkadiusTradeTools.NAME, EVENT_OPEN_TRADING_HOUSE, OnEvent)
	EVENT_MANAGER:RegisterForEvent(ArkadiusTradeTools.NAME, EVENT_CLOSE_TRADING_HOUSE, OnEvent)
	EVENT_MANAGER:RegisterForEvent(ArkadiusTradeTools.NAME, EVENT_CRAFTING_STATION_INTERACT, OnEvent)
	EVENT_MANAGER:RegisterForEvent(ArkadiusTradeTools.NAME, EVENT_END_CRAFTING_STATION_INTERACT, OnEvent)
    EVENT_MANAGER:RegisterForEvent(ArkadiusTradeTools.NAME, EVENT_GUILD_HISTORY_RESPONSE_RECEIVED, OnEvent)
    EVENT_MANAGER:RegisterForEvent(ArkadiusTradeTools.NAME, EVENT_PLAYER_COMBAT_STATE, OnEvent)

    --- Workaround if AGS is active, as EVENT_TRADING_HOUSE_CONFIRM_ITEM_PURCHASE won't work as intended ---
    if (AwesomeGuildStore) then
        AwesomeGuildStore:RegisterCallback(AwesomeGuildStore.callback.ITEM_PURCHASED,
            function(itemData)
                ArkadiusTradeTools:FireCallbacks(ArkadiusTradeTools.EVENTS.ON_GUILDSTORE_ITEM_BOUGHT, itemData.guildName, itemData.sellerName, itemData.itemLink, itemData.stackCount, itemData.purchasePrice, GetTimeStamp())
            end)
        else
            EVENT_MANAGER:RegisterForEvent(ArkadiusTradeTools.NAME, EVENT_TRADING_HOUSE_CONFIRM_ITEM_PURCHASE, OnEvent)
            EVENT_MANAGER:RegisterForEvent(ArkadiusTradeTools.NAME, EVENT_TRADING_HOUSE_RESPONSE_RECEIVED, OnEvent)
        end

    ScanGuildHistoryEvents()
    --LGH.RegisterForEvent("ATT", 0, 0, 0, function(guildId, category) d(guildId .. " " .. category .. " " .. GetNumGuildEvents(guildId, category)) end)
end


local function OnPlayerDeactivated(eventCode)
    ArkadiusTradeTools:Finalize()
end

local function OnAddOnLoaded(eventCode, addonName)
    if (addonName ~= ArkadiusTradeTools.NAME) then
        return
    end

    ArkadiusTradeToolsData = ArkadiusTradeToolsData or {}
    ArkadiusTradeToolsData.settings = ArkadiusTradeToolsData.settings or {}

    --- Create default settings ---
    Settings = ArkadiusTradeToolsData.settings
    if (Settings.showOnMailbox == nil) then Settings.showOnMailbox = true end
    if (Settings.showOnGuildStore == nil) then Settings.showOnGuildStore = true end
    if (Settings.showOnCraftingStation == nil) then Settings.showOnCraftingStation = false end
    if (Settings.showNotifications == nil) then Settings.showNotifications = true end
    if (Settings.showNotificationsDuringCombat == nil) then Settings.showNotificationsDuringCombat = false end
    if (Settings.highlightUserDisplayName == nil) then Settings.highlightUserDisplayName = true end
    Settings.userDisplayNameColor = Settings.userDisplayNameColor or {r = 0, g = 0.7, b = 0}
    if (Settings.highlightGuildNames == nil) then Settings.highlightGuildNames = true end
    if (Settings.scanDuringCombat == nil) then Settings.scanDuringCombat = true end
    Settings.shortScanInterval = Settings.shortScanInterval or 2000
    Settings.longScanInterval = Settings.longScanInterval or 10
    Settings.drawTier = Settings.drawTier or DT_HIGH

    --- Register for events ---
    EVENT_MANAGER:RegisterForEvent(ArkadiusTradeTools.NAME, EVENT_PLAYER_ACTIVATED, OnPlayerActivated)
    EVENT_MANAGER:RegisterForEvent(ArkadiusTradeTools.NAME, EVENT_PLAYER_DEACTIVATED, OnPlayerDeactivated)
    EVENT_MANAGER:UnregisterForEvent(ArkadiusTradeTools.NAME, EVENT_ADD_ON_LOADED)

    --EVENT_MANAGER:RegisterForUpdate(ArkadiusTradeTools.NAME, 2000, function(millisecondsRunning) d(millisecondsRunning) end)

    SLASH_COMMANDS["/att"] = OnSlashCommand
end

EVENT_MANAGER:RegisterForEvent(ArkadiusTradeTools.NAME, EVENT_ADD_ON_LOADED, OnAddOnLoaded)
