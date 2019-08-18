local ArkadiusTradeToolsSalesData = {}
local ArkadiusTradeToolsSales = ArkadiusTradeTools.Modules.Sales
ArkadiusTradeToolsSalesData.NAME = ArkadiusTradeToolsSales.NAME .. "Data10"
ArkadiusTradeToolsSalesData.VERSION = ArkadiusTradeToolsSales.VERSION
ArkadiusTradeToolsSalesData.AUTHOR = ArkadiusTradeToolsSales.AUTHOR

local function onAddOnLoaded(eventCode, addonName)
    if (addonName ~= ArkadiusTradeToolsSalesData.NAME) then
        return
    end

    local serverName = GetWorldName()
    ArkadiusTradeToolsSalesData10 = ArkadiusTradeToolsSalesData10 or {}
    ArkadiusTradeToolsSalesData10[serverName] = ArkadiusTradeToolsSalesData10[serverName] or {sales = {}}
    ArkadiusTradeToolsSales.SalesTables[10] = ArkadiusTradeToolsSalesData10

    EVENT_MANAGER:UnregisterForEvent(ArkadiusTradeToolsSalesData.NAME, EVENT_ADD_ON_LOADED)
end

EVENT_MANAGER:RegisterForEvent(ArkadiusTradeToolsSalesData.NAME, EVENT_ADD_ON_LOADED, onAddOnLoaded)
