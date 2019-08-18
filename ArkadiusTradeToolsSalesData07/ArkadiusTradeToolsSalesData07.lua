local ArkadiusTradeToolsSalesData = {}
local ArkadiusTradeToolsSales = ArkadiusTradeTools.Modules.Sales
ArkadiusTradeToolsSalesData.NAME = ArkadiusTradeToolsSales.NAME .. "Data07"
ArkadiusTradeToolsSalesData.VERSION = ArkadiusTradeToolsSales.VERSION
ArkadiusTradeToolsSalesData.AUTHOR = ArkadiusTradeToolsSales.AUTHOR

local function onAddOnLoaded(eventCode, addonName)
    if (addonName ~= ArkadiusTradeToolsSalesData.NAME) then
        return
    end

    local serverName = GetWorldName()
    ArkadiusTradeToolsSalesData07 = ArkadiusTradeToolsSalesData07 or {}
    ArkadiusTradeToolsSalesData07[serverName] = ArkadiusTradeToolsSalesData07[serverName] or {sales = {}}
    ArkadiusTradeToolsSales.SalesTables[7] = ArkadiusTradeToolsSalesData07

    EVENT_MANAGER:UnregisterForEvent(ArkadiusTradeToolsSalesData.NAME, EVENT_ADD_ON_LOADED)
end

EVENT_MANAGER:RegisterForEvent(ArkadiusTradeToolsSalesData.NAME, EVENT_ADD_ON_LOADED, onAddOnLoaded)
