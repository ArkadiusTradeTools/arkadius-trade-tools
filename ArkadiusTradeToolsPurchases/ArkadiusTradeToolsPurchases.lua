ArkadiusTradeTools.Modules.Purchases = ArkadiusTradeTools.Templates.Module:New(ArkadiusTradeTools.NAME .. "Purchases", ArkadiusTradeTools.TITLE .. " - Purchases", ArkadiusTradeTools.VERSION, ArkadiusTradeTools.AUTHOR)
local ArkadiusTradeToolsPurchases = ArkadiusTradeTools.Modules.Purchases
ArkadiusTradeToolsPurchases.Localization = {}

local L = ArkadiusTradeToolsPurchases.Localization
local Utilities = ArkadiusTradeTools.Utilities
local Settings
local Purchases

local SECONDS_IN_HOUR = 60 * 60
local SECONDS_IN_DAY = SECONDS_IN_HOUR * 24

--------------------------------------------------------
-------------------- List functions --------------------
--------------------------------------------------------
local ArkadiusTradeToolsPurchasesList = ArkadiusTradeToolsSortFilterList:Subclass()

function ArkadiusTradeToolsPurchasesList:Initialize(control)
    ArkadiusTradeToolsSortFilterList.Initialize(self, control)

    self.SORT_KEYS = {["sellerName"] = {tiebreaker = "timeStamp"},
                      ["buyerName"]  = {tiebreaker = "timeStamp"},
                      ["guildName"]  = {tiebreaker = "timeStamp"},
--                    ["itemName"]   = {tiebreaker = "timeStamp"},
                    --   ["unitPrice"]    = {tiebreaker = "timeStamp"},
                      ["price"]      = {tiebreaker = "timeStamp"},					
                      ["timeStamp"]  = {}}

    ZO_ScrollList_AddDataType(self.list, 1, "ArkadiusTradeToolsPurchasesRow", 32,
        function(control, data)
            self:SetupPurchaseRow(control, data)
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
	
    self.buyerNameSwitch = Settings.filters.buyerName
    self.sellerNameSwitch = Settings.filters.sellerName
    self.guildNameSwitch = Settings.filters.guildName
    self.itemNameSwitch = Settings.filters.itemName
    self.timeStampSwitch = Settings.filters.timeStamp
	self.eapriceSwitch = Settings.filters.unitPrice
	self.priceSwitch = Settings.filters.price

    self.sortHeaderGroup.headerContainer.sortHeaderGroup = self.sortHeaderGroup
    self.sortHeaderGroup:HeaderForKey("buyerName").switch:SetPressed(self.buyerNameSwitch)
    self.sortHeaderGroup:HeaderForKey("buyerName").switch.tooltip:SetContent(L["ATT_STR_FILTER_COLUMN_TOOLTIP"])
    self.sortHeaderGroup:HeaderForKey("buyerName").switch.OnToggle = OnHeaderFilterToggle
    self.sortHeaderGroup:HeaderForKey("sellerName").switch:SetPressed(self.sellerNameSwitch)
    self.sortHeaderGroup:HeaderForKey("sellerName").switch.tooltip:SetContent(L["ATT_STR_FILTER_COLUMN_TOOLTIP"])
    self.sortHeaderGroup:HeaderForKey("sellerName").switch.OnToggle = OnHeaderFilterToggle
    self.sortHeaderGroup:HeaderForKey("guildName").switch:SetPressed(self.guildNameSwitch)
    self.sortHeaderGroup:HeaderForKey("guildName").switch.tooltip:SetContent(L["ATT_STR_FILTER_COLUMN_TOOLTIP"])
    self.sortHeaderGroup:HeaderForKey("guildName").switch.OnToggle = OnHeaderFilterToggle
    self.sortHeaderGroup:HeaderForKey("itemName").switch:SetPressed(self.itemNameSwitch)
    self.sortHeaderGroup:HeaderForKey("itemName").switch.tooltip:SetContent(L["ATT_STR_FILTER_COLUMN_TOOLTIP"])
    self.sortHeaderGroup:HeaderForKey("itemName").switch.OnToggle = OnHeaderFilterToggle
    self.sortHeaderGroup:HeaderForKey("timeStamp").switch:SetPressed(self.timeStampSwitch)
    self.sortHeaderGroup:HeaderForKey("timeStamp").switch.OnToggle = OnHeaderToggle
	-- self.sortHeaderGroup:HeaderForKey("unitPrice").switch:SetPressed(self.eapriceSwitch)
    -- self.sortHeaderGroup:HeaderForKey("unitPrice").switch.OnToggle = OnHeaderToggle
	--self.sortHeaderGroup:HeaderForKey("price").switch:SetPressed(self.priceSwitch)
    --self.sortHeaderGroup:HeaderForKey("price").switch.OnToggle = OnHeaderToggle	
    self.sortHeaderGroup:SelectHeaderByKey("timeStamp", true)
    self.sortHeaderGroup:SelectHeaderByKey("timeStamp", true)
    self.currentSortKey = "timeStamp"
end

function ArkadiusTradeToolsPurchasesList:SetupFilters()
    local useSubStrings = ArkadiusTradeToolsPurchases.frame.filterBar.SubStrings:IsPressed()

    local CompareStringsFuncs = {}
    CompareStringsFuncs[true] = function(string1, string2) string2 = string2:gsub("-", "--") return (string.find(string1:lower(), string2) ~= nil) end
    CompareStringsFuncs[false] = function(string1, string2) return (string1:lower() == string2) end

    local item = ArkadiusTradeToolsPurchases.frame.filterBar.Time:GetSelectedItem()
    local newerThanTimeStamp = item.NewerThanTimeStamp()
    local olderThanTimestamp = item.OlderThanTimeStamp()

    local function CompareTimestamp(timeStamp)
        return ((timeStamp >= newerThanTimeStamp) and (timeStamp < olderThanTimestamp))
    end

    local function CompareItemNames(itemLink, itemName)
        return CompareStringsFuncs[useSubStrings](GetItemLinkName(itemLink):lower(), itemName)
    end

    self.Filter:SetKeywords(ArkadiusTradeToolsPurchases.frame.filterBar.Text:GetStrings())
    self.Filter:SetKeyFunc(1, "timeStamp", CompareTimestamp)

    if (self["buyerNameSwitch"])
        then self.Filter:SetKeyFunc(2, "buyerName", CompareStringsFuncs[useSubStrings])
    else
        self.Filter:SetKeyFunc(2, "buyerName", nil)
    end

    if (self["sellerNameSwitch"])
        then self.Filter:SetKeyFunc(2, "sellerName", CompareStringsFuncs[useSubStrings])
    else
        self.Filter:SetKeyFunc(2, "sellerName", nil)
    end

    if (self["guildNameSwitch"])
        then self.Filter:SetKeyFunc(2, "guildName", CompareStringsFuncs[useSubStrings])
    else
        self.Filter:SetKeyFunc(2, "guildName", nil)
    end

    if (self["itemNameSwitch"])
        then self.Filter:SetKeyFunc(2, "itemLink", CompareItemNames)
    else
        self.Filter:SetKeyFunc(2, "itemLink", nil)
    end
end

function ArkadiusTradeToolsPurchasesList:SetupPurchaseRow(rowControl, rowData)
    rowControl.data = rowData
    local data = rowData.rawData
    local buyerName = GetControl(rowControl, "BuyerName")
    local sellerName = GetControl(rowControl, "SellerName")
    local guildName = GetControl(rowControl, "GuildName")
    local itemLink = GetControl(rowControl, "ItemLink")
	local unitPrice = GetControl(rowControl, "unitPrice")
    local price = GetControl(rowControl, "Price")
    local timeStamp = GetControl(rowControl, "TimeStamp")
    local icon = GetItemLinkInfo(data.itemLink)

    buyerName:SetText(data.buyerName)
    buyerName:SetWidth(buyerName.header:GetWidth() - 10)
    buyerName:SetHidden(buyerName.header:IsHidden())
    buyerName:SetColor(ArkadiusTradeTools:GetDisplayNameColor(data.buyerName):UnpackRGBA())

    sellerName:SetText(data.sellerName)
    sellerName:SetWidth(sellerName.header:GetWidth() - 10)
    sellerName:SetHidden(sellerName.header:IsHidden())
    sellerName:SetColor(ArkadiusTradeTools:GetDisplayNameColor(data.sellerName):UnpackRGBA())

    guildName:SetText(data.guildName)
    guildName:SetWidth(guildName.header:GetWidth() - 10)
    guildName:SetHidden(guildName.header:IsHidden())
    guildName:SetColor(ArkadiusTradeTools:GetGuildColor(data.guildName):UnpackRGBA())

    itemLink:SetText(data.itemLink)
    itemLink:SetWidth(itemLink.header:GetWidth() - 10)
    itemLink:SetHidden(itemLink.header:IsHidden())
    itemLink:SetIcon(icon)

    if (data.quantity == 1) then
        data.unitPrice = data.price
    else
        data.unitPrice = math.attRound(data.price/data.quantity, 2)            
    end

	unitPrice:SetText(ArkadiusTradeTools:LocalizeDezimalNumber(data.unitPrice) .. " |t16:16:EsoUI/Art/currency/currency_gold.dds|t")
    unitPrice:SetWidth(unitPrice.header:GetWidth() - 10)
    unitPrice:SetHidden(unitPrice.header:IsHidden())
	
    price:SetText(ArkadiusTradeTools:LocalizeDezimalNumber(data.price) .. " |t16:16:EsoUI/Art/currency/currency_gold.dds|t")
    price:SetWidth(price.header:GetWidth() - 10)
    price:SetHidden(price.header:IsHidden())

    if (self.timeStampSwitch) then
        timeStamp:SetText(ArkadiusTradeTools:TimeStampToDateTimeString(data.timeStamp + ArkadiusTradeTools:GetLocalTimeShift()))
    else
        timeStamp:SetText(ArkadiusTradeTools:TimeStampToAgoString(data.timeStamp))
    end

    timeStamp:SetWidth(timeStamp.header:GetWidth() - 10)
    timeStamp:SetHidden(timeStamp.header:IsHidden())
	
	
    if (data.quantity == 1) then
        itemLink:SetQuantity("")
    else
        itemLink:SetQuantity(data.quantity)
    end

    ArkadiusTradeToolsSortFilterList.SetupRow(self, rowControl, rowData)
end

---------------------------------------------------------------------------------------

function ArkadiusTradeToolsPurchases:Initialize()
    self.frame = ArkadiusTradeToolsPurchasesFrame
    ArkadiusTradeTools.TabWindow:AddTab(self.frame, L["ATT_STR_PURCHASES"], "/esoui/art/vendor/vendor_tabicon_buy_up.dds", "/esoui/art/vendor/vendor_tabicon_buy_up.dds", {left = 0.15, top = 0.15, right = 0.85, bottom = 0.85})

    self.list = ArkadiusTradeToolsPurchasesList:New(self, self.frame)
    self.frame.list = self.frame:GetNamedChild("List")
    self.frame.filterBar = self.frame:GetNamedChild("FilterBar")
    self.frame.headers = self.frame:GetNamedChild("Headers")
--    self.frame.headers.OnHeaderShow = function(header, hidden) self:OnHeaderVisibilityChanged(header, hidden) end
--    self.frame.headers.OnHeaderHide = function(header, hidden) self:OnHeaderVisibilityChanged(header, hidden) end
    self.frame.headers.buyerName = self.frame.headers:GetNamedChild("BuyerName")
    self.frame.headers.sellerName = self.frame.headers:GetNamedChild("SellerName")
    self.frame.headers.guildName = self.frame.headers:GetNamedChild("GuildName")
    self.frame.headers.itemLink = self.frame.headers:GetNamedChild("ItemLink")
	self.frame.headers.unitPrice = self.frame.headers:GetNamedChild("unitPrice")
    self.frame.headers.price = self.frame.headers:GetNamedChild("Price")
    self.frame.headers.timeStamp = self.frame.headers:GetNamedChild("TimeStamp")
    self.frame.OnResize = self.OnResize
    self.frame:SetHandler("OnEffectivelyShown", function(_, hidden) if (hidden == false) then self.list:RefreshData() end end)

    self:LoadSettings()
    self:LoadPurchases()

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
    -----------------------
    ArkadiusTradeTools:RegisterCallback(ArkadiusTradeTools.EVENTS.ON_GUILDSTORE_ITEM_BOUGHT, function(...) self:OnItemBought(...) end)
end

function ArkadiusTradeToolsPurchases:Finalize()
    self:CleanupSavedVariables()
    self:SaveSettings()
end

function ArkadiusTradeToolsPurchases:GetSettingsMenu()
    local settingsMenu = {}

    table.insert(settingsMenu, {type = "header", name = L["ATT_STR_PURCHASES"]})
    table.insert(settingsMenu, {type = "slider", name = L["ATT_STR_KEEP_PURCHASES_FOR_DAYS"], min = 1, max = 30, getFunc = function() return Settings.keepDataDays end, setFunc = function(value) Settings.keepDataDays = value end})
    table.insert(settingsMenu, {type = "custom"})

    return settingsMenu
end

function ArkadiusTradeToolsPurchases:LoadSettings()
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

function ArkadiusTradeToolsPurchases:SaveSettings()
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

function ArkadiusTradeToolsPurchases:CleanupSavedVariables()
    local timeStamp = GetTimeStamp() - Settings.keepDataDays * SECONDS_IN_DAY

    --- Delete old purchases ---
    for i, purchase in pairs(Purchases) do
        if purchase.timeStamp <= timeStamp then
            Purchases[i] = nil
        end
	end
end

function ArkadiusTradeToolsPurchases:LoadPurchases()
    for _, purchase in pairs(Purchases) do
        -- local entry = Utilities.EnsureUnitPrice(purchase)
        self.list:UpdateMasterList(purchase)
    end
end

function ArkadiusTradeToolsPurchases:OnItemBought(guildName, sellerName, itemLink, quantity, price, timeStamp)
    --- Save purchase ---
    local purchase = {}
    purchase.timeStamp = timeStamp
    purchase.guildName = guildName
    purchase.sellerName = sellerName
    purchase.buyerName = GetDisplayName()
    purchase.itemLink = itemLink
    purchase.quantity = quantity
    purchase.price = price

    table.insert(Purchases, purchase)

    --- Update list ---
    -- local entry = Utilities.EnsureUnitPrice(purchase)
    self.list:UpdateMasterList(purchase)
    self.list:RefreshData()
end

function ArkadiusTradeToolsPurchases.OnResize(frame, width, height)
    frame.headers:Update()
    ZO_ScrollList_Commit(frame.list)
end

--------------------------------------------------------
------------------- Local functions --------------------
--------------------------------------------------------

local function onAddOnLoaded(eventCode, addonName)
    if (addonName ~= ArkadiusTradeToolsPurchases.NAME) then
        return
    end

    local serverName = GetWorldName()

    ArkadiusTradeToolsPurchasesData = ArkadiusTradeToolsPurchasesData or {}
    ArkadiusTradeToolsPurchasesData.purchases = ArkadiusTradeToolsPurchasesData.purchases or {}
    ArkadiusTradeToolsPurchasesData.purchases[serverName] = ArkadiusTradeToolsPurchasesData.purchases[serverName] or {}
    ArkadiusTradeToolsPurchasesData.settings = ArkadiusTradeToolsPurchasesData.settings or {}

    Settings = ArkadiusTradeToolsPurchasesData.settings
    Purchases = ArkadiusTradeToolsPurchasesData.purchases[serverName]

    --- Deprecated ---
    --- Conversion from old format ---
    for i, purchase in pairs(ArkadiusTradeToolsPurchasesData.purchases) do
        if (type(i) == "number") then
            table.insert(Purchases, purchase)
            ArkadiusTradeToolsPurchasesData.purchases[i] = nil
        end
    end
    ----------------------------------

    --- Create default settings ---
    Settings.keepDataDays = Settings.keepDataDays or 30
    Settings.filters = Settings.filters or {}
    Settings.filters.timeSelection = Settings.filters.timeSelection or 4
    if (Settings.filters.buyerName == nil) then Settings.filters.buyerName = true end
    if (Settings.filters.sellerName == nil) then Settings.filters.sellerName = true end
    if (Settings.filters.guildName == nil) then Settings.filters.guildName = true end
    if (Settings.filters.itemName == nil) then Settings.filters.itemName = true end
    if (Settings.filters.timeStamp == nil) then Settings.filters.timeStamp = false end
    if (Settings.filters.price == nil) then Settings.filters.price = false end
    if (Settings.filters.useSubStrings == nil) then Settings.filters.useSubStrings = true end

    EVENT_MANAGER:UnregisterForEvent(ArkadiusTradeToolsPurchases.NAME, EVENT_ADD_ON_LOADED)
end

EVENT_MANAGER:RegisterForEvent(ArkadiusTradeToolsPurchases.NAME, EVENT_ADD_ON_LOADED, onAddOnLoaded)
