local ArkadiusTradeToolsSalesData = {}
local ArkadiusTradeToolsSales = ArkadiusTradeTools.Modules.Sales
ArkadiusTradeToolsSalesData.NAME = ArkadiusTradeToolsSales.NAME .. "Data15"
ArkadiusTradeToolsSalesData.VERSION = ArkadiusTradeToolsSales.VERSION
ArkadiusTradeToolsSalesData.AUTHOR = ArkadiusTradeToolsSales.AUTHOR

local function onAddOnLoaded(eventCode, addonName)
    if addonName ~= ArkadiusTradeToolsSalesData.NAME then
        return
    end

    local serverName = GetWorldName()
    ArkadiusTradeToolsSalesData15 = ArkadiusTradeToolsSalesData15 or {}
    ArkadiusTradeToolsSalesData15[serverName] = ArkadiusTradeToolsSalesData15[serverName] or { sales = {} }
    ArkadiusTradeToolsSales.SalesTables[15] = ArkadiusTradeToolsSalesData15

    EVENT_MANAGER:UnregisterForEvent(ArkadiusTradeToolsSalesData.NAME, EVENT_ADD_ON_LOADED)
end

EVENT_MANAGER:RegisterForEvent(ArkadiusTradeToolsSalesData.NAME, EVENT_ADD_ON_LOADED, onAddOnLoaded)
