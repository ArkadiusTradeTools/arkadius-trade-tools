local ArkadiusTradeToolsSalesData = {}
local ArkadiusTradeToolsSales = ArkadiusTradeTools.Modules.Sales
ArkadiusTradeToolsSalesData.NAME = ArkadiusTradeToolsSales.NAME .. "Data05"
ArkadiusTradeToolsSalesData.VERSION = ArkadiusTradeToolsSales.VERSION
ArkadiusTradeToolsSalesData.AUTHOR = ArkadiusTradeToolsSales.AUTHOR

local function onAddOnLoaded(eventCode, addonName)
    if (addonName ~= ArkadiusTradeToolsSalesData.NAME) then
        return
    end

    local serverName = GetWorldName()
    ArkadiusTradeToolsSalesData05 = ArkadiusTradeToolsSalesData05 or {}
    ArkadiusTradeToolsSalesData05[serverName] = ArkadiusTradeToolsSalesData05[serverName] or {sales = {}}
    ArkadiusTradeToolsSales.SalesTables[5] = ArkadiusTradeToolsSalesData05

    EVENT_MANAGER:UnregisterForEvent(ArkadiusTradeToolsSalesData.NAME, EVENT_ADD_ON_LOADED)
end

EVENT_MANAGER:RegisterForEvent(ArkadiusTradeToolsSalesData.NAME, EVENT_ADD_ON_LOADED, onAddOnLoaded)
