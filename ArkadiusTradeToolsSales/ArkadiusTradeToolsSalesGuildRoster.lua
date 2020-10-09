local ArkadiusTradeToolsSales = ArkadiusTradeTools.Modules.Sales
ArkadiusTradeToolsSales.GuildRoster = {}
local L = ArkadiusTradeToolsSales.Localization
local Settings

local LGR = LibGuildRoster

local GUILD_ROSTER_MANAGER_SetupEntry
local GUILD_ROSTER_MANAGER_BuildMasterList
local SetupEntry, BuildMasterList

if not LGR then
    SetupEntry = function(self, control, data, selected)
        GUILD_ROSTER_MANAGER_SetupEntry(self, control, data, selected)

        local purchasesControl = control:GetNamedChild("Purchases")
        local salesControl = control:GetNamedChild("Sales")

        if (not purchasesControl) then
            local levelControl = control:GetNamedChild("Level")
            local h = levelControl:GetHeight()

            purchasesControl =
                CreateControlFromVirtual(control:GetName() .. "Purchases", control, "ZO_KeyboardGuildRosterRowLabel")
            purchasesControl:SetDimensions(100, h)
            purchasesControl:SetAnchor(LEFT, levelControl, RIGHT, 35, 0)
            purchasesControl:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)
            purchasesControl:SetVerticalAlignment(TEXT_ALIGN_CENTER)

            salesControl =
                CreateControlFromVirtual(control:GetName() .. "Sales", control, "ZO_KeyboardGuildRosterRowLabel")
            salesControl:SetDimensions(100, h)
            salesControl:SetAnchor(LEFT, purchasesControl, RIGHT, 0, 0)
            salesControl:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)
            salesControl:SetVerticalAlignment(TEXT_ALIGN_CENTER)
        end

        purchasesControl:SetText(
            ArkadiusTradeTools:LocalizeDezimalNumber(data.purchases or 0) ..
                " |t16:16:EsoUI/Art/currency/currency_gold.dds|t"
        )
        salesControl:SetText(
            ArkadiusTradeTools:LocalizeDezimalNumber(data.sales or 0) ..
                " |t16:16:EsoUI/Art/currency/currency_gold.dds|t"
        )
    end

    BuildMasterList = function(self)
        GUILD_ROSTER_MANAGER_BuildMasterList(self)

        local data

        for i = 1, #self.masterList do
            data = self.masterList[i]
            data.purchases, data.sales =
                ArkadiusTradeToolsSales.GuildRoster:GetNumbers(self.guildName, data.displayName)
        end
    end

    --- Hook into roster functions ---
        GUILD_ROSTER_ENTRY_SORT_KEYS["purchases"] = {tiebreaker = "displayName"}
        GUILD_ROSTER_ENTRY_SORT_KEYS["sales"] = {tiebreaker = "displayName"}
        GUILD_ROSTER_MANAGER_SetupEntry = GUILD_ROSTER_MANAGER.SetupEntry
        GUILD_ROSTER_MANAGER_BuildMasterList = GUILD_ROSTER_MANAGER.BuildMasterList
        GUILD_ROSTER_MANAGER.SetupEntry = SetupEntry
        GUILD_ROSTER_MANAGER.BuildMasterList = BuildMasterList
    ---
end

function ArkadiusTradeToolsSales.GuildRoster:Initialize(settings)
    Settings = settings
    if (Settings.enabled == nil) then
        Settings.enabled = true
    end
    Settings.timeSelectionIndex = Settings.timeSelectionIndex or 1

    self:Enable(Settings.enabled)
end

function ArkadiusTradeToolsSales.GuildRoster:Enable(enable)
    if ((enable) and (self.timeSelect == nil)) then
        --- Create columns ---
        local guildRoster = ZO_GuildRoster
        local guildRosterHeaders = ZO_GuildRoster:GetNamedChild("Headers")
        local levelHeader = guildRosterHeaders:GetNamedChild("Level")
        local purchasesHeader
        local salesHeader

        --- Create time selection combobox ---
        local salesDays = CreateControlFromVirtual(guildRoster:GetName() .. "SalesDays", guildRoster, "ZO_ComboBox")
        salesDays:SetDimensions(150, 31)

        if not LGR then
            purchasesHeader =
                CreateControlFromVirtual(
                guildRosterHeaders:GetName() .. "Purchases",
                guildRosterHeaders,
                "ZO_SortHeader"
            )
            purchasesHeader:SetDimensions(100, 32)
            purchasesHeader:SetAnchor(LEFT, levelHeader, RIGHT, 50, 0)
            salesDays:SetAnchor(TOP, purchasesHeader, BOTTOMRIGHT, 0, 566)

            salesHeader =
                CreateControlFromVirtual(guildRosterHeaders:GetName() .. "Sales", guildRosterHeaders, "ZO_SortHeader")
            salesHeader:SetDimensions(100, 32)
            salesHeader:SetAnchor(LEFT, purchasesHeader, RIGHT, 0, 0)

            local w = ZO_GuildRoster:GetWidth()
            ZO_GuildRoster:SetWidth(w + 210)

            ZO_SortHeader_Initialize(
                purchasesHeader,
                L["ATT_STR_PURCHASES"],
                "purchases",
                ZO_SORT_ORDER_DOWN,
                TEXT_ALIGN_RIGHT,
                "ZoFontGameLargeBold"
            )
            ZO_SortHeader_Initialize(
                salesHeader,
                L["ATT_STR_SALES"],
                "sales",
                ZO_SORT_ORDER_DOWN,
                TEXT_ALIGN_RIGHT,
                "ZoFontGameLargeBold"
            )
            GUILD_ROSTER_KEYBOARD.sortHeaderGroup:AddHeader(purchasesHeader)
            GUILD_ROSTER_KEYBOARD.sortHeaderGroup:AddHeader(salesHeader)
        else
            local purchasesColumn =
                LGR:AddColumn(
                {
                    key = "ATT_Purchases",
                    header = {
                        title = L["ATT_STR_PURCHASES"],
                        align = TEXT_ALIGN_RIGHT
                    },
                    width = 100,
                    row = {
                        align = TEXT_ALIGN_RIGHT,
                        format = function(value)
                            return ArkadiusTradeTools:LocalizeDezimalNumber(tonumber(value) or 0) ..
                                " |t16:16:EsoUI/Art/currency/currency_gold.dds|t"
                        end
                    }
                }
            )

            local salesColumn =
                LGR:AddColumn(
                {
                    key = "ATT_Sales",
                    header = {
                        title = "Sales",
                        align = TEXT_ALIGN_RIGHT
                    },
                    width = 100,
                    row = {
                        align = TEXT_ALIGN_RIGHT,
                        format = function(value)
                            return ArkadiusTradeTools:LocalizeDezimalNumber(tonumber(value) or 0) ..
                                " |t16:16:EsoUI/Art/currency/currency_gold.dds|t"
                        end
                    },
                }
            )

            LGR:SetBulkData({ purchasesColumn, salesColumn }, function(guildId, data, index)
                local guildName = GetGuildName(guildId)
                local purchases, sales =
                    ArkadiusTradeToolsSales.GuildRoster:GetNumbers(
                        guildName,
                        data.displayName
                )
                data['ATT_Purchases'] = purchases
                data['ATT_Sales'] = sales
                return data            
            end)

            LGR:OnRosterReady(
                function()
                    salesDays:SetAnchor(TOP, purchasesColumn:GetHeader(), BOTTOMRIGHT, 0, 566)
                end
            )
        end

        local function callback(...)
            Settings.timeSelectionIndex = self:GetSelectedTimeIndex()
            if not LGR then
                local masterList = GUILD_ROSTER_MANAGER:GetMasterList()
                local data

                for i = 1, #masterList do
                    data = masterList[i]
                    data.purchases, data.sales = self:GetNumbers(GUILD_ROSTER_MANAGER.guildName, data.displayName)
                end
                GUILD_ROSTER_MANAGER:RefreshSort()
            else
                LGR:Refresh()
            end
        end

        local comboBox = ZO_ComboBox_ObjectFromContainer(salesDays)
        comboBox:SetSortsItems(false)

        comboBox:AddItem(
            {name = L["ATT_STR_TODAY"], callback = callback, NewerThanTimeStamp = function()
                    return ArkadiusTradeTools:GetStartOfDay(0)
                end, OlderThanTimeStamp = function()
                    return GetTimeStamp()
                end}
        )
        comboBox:AddItem(
            {name = L["ATT_STR_YESTERDAY"], callback = callback, NewerThanTimeStamp = function()
                    return ArkadiusTradeTools:GetStartOfDay(-1)
                end, OlderThanTimeStamp = function()
                    return ArkadiusTradeTools:GetStartOfDay(0) - 1
                end}
        )
        comboBox:AddItem(
            {name = L["ATT_STR_TWO_DAYS_AGO"], callback = callback, NewerThanTimeStamp = function()
                    return ArkadiusTradeTools:GetStartOfDay(-2)
                end, OlderThanTimeStamp = function()
                    return ArkadiusTradeTools:GetStartOfDay(-1) - 1
                end}
        )
        comboBox:AddItem(
            {name = L["ATT_STR_THIS_WEEK"], callback = callback, NewerThanTimeStamp = function()
                    return ArkadiusTradeTools:GetStartOfWeek(0, true)
                end, OlderThanTimeStamp = function()
                    return GetTimeStamp()
                end}
        )
        comboBox:AddItem(
            {name = L["ATT_STR_LAST_WEEK"], callback = callback, NewerThanTimeStamp = function()
                    return ArkadiusTradeTools:GetStartOfWeek(-1, true)
                end, OlderThanTimeStamp = function()
                    return ArkadiusTradeTools:GetStartOfWeek(0, true) - 1
                end}
        )
        comboBox:AddItem(
            {name = L["ATT_STR_PRIOR_WEEK"], callback = callback, NewerThanTimeStamp = function()
                    return ArkadiusTradeTools:GetStartOfWeek(-2, true)
                end, OlderThanTimeStamp = function()
                    return ArkadiusTradeTools:GetStartOfWeek(-1, true) - 1
                end}
        )
        comboBox:AddItem(
            {name = L["ATT_STR_7_DAYS"], callback = callback, NewerThanTimeStamp = function()
                    return ArkadiusTradeTools:GetStartOfDay(-7)
                end, OlderThanTimeStamp = function()
                    return GetTimeStamp()
                end}
        )
        comboBox:AddItem(
            {name = L["ATT_STR_10_DAYS"], callback = callback, NewerThanTimeStamp = function()
                    return ArkadiusTradeTools:GetStartOfDay(-10)
                end, OlderThanTimeStamp = function()
                    return GetTimeStamp()
                end}
        )
        comboBox:AddItem(
            {name = L["ATT_STR_14_DAYS"], callback = callback, NewerThanTimeStamp = function()
                    return ArkadiusTradeTools:GetStartOfDay(-14)
                end, OlderThanTimeStamp = function()
                    return GetTimeStamp()
                end}
        )
        comboBox:AddItem(
            {name = L["ATT_STR_30_DAYS"], callback = callback, NewerThanTimeStamp = function()
                    return 0
                end, OlderThanTimeStamp = function()
                    return GetTimeStamp()
                end}
        )

        self.timeSelect = comboBox

        comboBox:SelectItemByIndex(Settings.timeSelectionIndex or 1)
    end

    Settings.enabled = enable
end

function ArkadiusTradeToolsSales.GuildRoster:IsEnabled()
    return Settings.enabled
end

function ArkadiusTradeToolsSales.GuildRoster:Update(guildName, displayName)
--[=[
    if ((self.timeSelect == nil) or (ZO_GuildRoster:IsHidden()) or (GUILD_ROSTER_MANAGER.guildName ~= guildName)) then
        return
    end

    local data = GUILD_ROSTER_MANAGER:FindDataByDisplayName(displayName)

    if (data) then
        data.purchases, data.sales = self:GetNumbers(guildName, displayName)
        GUILD_ROSTER_MANAGER:RefreshSort()
	end
--]=]
end

function ArkadiusTradeToolsSales.GuildRoster:GetNumbers(guildName, displayName, newerThanTimeStamp, olderThanTimestamp)
    if (self.timeSelect == nil) then
        return
    end

    local item = self.timeSelect:GetSelectedItemData()
    newerThanTimeStamp = newerThanTimeStamp or item.NewerThanTimeStamp()
    olderThanTimestamp = olderThanTimestamp or item.OlderThanTimeStamp()

    return ArkadiusTradeToolsSales:GetPurchasesAndSalesVolumes(
        guildName,
        displayName,
        newerThanTimeStamp,
        olderThanTimestamp
    )
end

function ArkadiusTradeToolsSales.GuildRoster:GetSelectedTimeIndex()
    if (self.timeSelect == nil) then
        return
    end

    local selectedItem = self.timeSelect:GetSelectedItemData()

    for i, item in pairs(self.timeSelect.m_sortedItems) do
        if (item == selectedItem) then
            return i
        end
    end

    return
end

function ArkadiusTradeToolsSales.GuildRoster:SetSelectedTimeIndex(index)
    if (self.timeSelect == nil) then
        return
    end

    if ((index) and (index > 0) and (index <= self.timeSelect:GetNumItems())) then
        self.timeSelect:SelectItemByIndex(index)
    end
end
