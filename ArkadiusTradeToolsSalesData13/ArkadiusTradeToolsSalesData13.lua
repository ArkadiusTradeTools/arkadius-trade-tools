local ArkadiusTradeToolsSalesData = {}
local ArkadiusTradeToolsSales = ArkadiusTradeTools.Modules.Sales
ArkadiusTradeToolsSalesData.NAME = ArkadiusTradeToolsSales.NAME .. "Data13"
ArkadiusTradeToolsSalesData.VERSION = ArkadiusTradeToolsSales.VERSION
ArkadiusTradeToolsSalesData.AUTHOR = ArkadiusTradeToolsSales.AUTHOR

local function onAddOnLoaded(eventCode, addonName)
    if addonName ~= ArkadiusTradeToolsSalesData.NAME then
        return
    end

    local serverName = GetWorldName()
    ArkadiusTradeToolsSalesData13 = ArkadiusTradeToolsSalesData13 or {}
    ArkadiusTradeToolsSalesData13[serverName] = ArkadiusTradeToolsSalesData13[serverName] or { sales = {} }
    ArkadiusTradeToolsSales.SalesTables[13] = ArkadiusTradeToolsSalesData13

    EVENT_MANAGER:UnregisterForEvent(ArkadiusTradeToolsSalesData.NAME, EVENT_ADD_ON_LOADED)
end

EVENT_MANAGER:RegisterForEvent(ArkadiusTradeToolsSalesData.NAME, EVENT_ADD_ON_LOADED, onAddOnLoaded)
