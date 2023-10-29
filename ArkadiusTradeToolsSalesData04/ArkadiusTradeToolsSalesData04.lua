local ArkadiusTradeToolsSalesData = {}
local ArkadiusTradeToolsSales = ArkadiusTradeTools.Modules.Sales
ArkadiusTradeToolsSalesData.NAME = ArkadiusTradeToolsSales.NAME .. "Data04"
ArkadiusTradeToolsSalesData.VERSION = ArkadiusTradeToolsSales.VERSION
ArkadiusTradeToolsSalesData.AUTHOR = ArkadiusTradeToolsSales.AUTHOR

local function onAddOnLoaded(eventCode, addonName)
    if addonName ~= ArkadiusTradeToolsSalesData.NAME then
        return
    end

    local serverName = GetWorldName()
    ArkadiusTradeToolsSalesData04 = ArkadiusTradeToolsSalesData04 or {}
    ArkadiusTradeToolsSalesData04[serverName] = ArkadiusTradeToolsSalesData04[serverName] or { sales = {} }
    ArkadiusTradeToolsSales.SalesTables[4] = ArkadiusTradeToolsSalesData04

    EVENT_MANAGER:UnregisterForEvent(ArkadiusTradeToolsSalesData.NAME, EVENT_ADD_ON_LOADED)
end

EVENT_MANAGER:RegisterForEvent(ArkadiusTradeToolsSalesData.NAME, EVENT_ADD_ON_LOADED, onAddOnLoaded)
