local ArkadiusTradeToolsSalesData = {}
local ArkadiusTradeToolsSales = ArkadiusTradeTools.Modules.Sales
ArkadiusTradeToolsSalesData.NAME = ArkadiusTradeToolsSales.NAME .. "Data08"
ArkadiusTradeToolsSalesData.VERSION = ArkadiusTradeToolsSales.VERSION
ArkadiusTradeToolsSalesData.AUTHOR = ArkadiusTradeToolsSales.AUTHOR

local function onAddOnLoaded(eventCode, addonName)
    if (addonName ~= ArkadiusTradeToolsSalesData.NAME) then
        return
    end

    local serverName = GetWorldName()
    ArkadiusTradeToolsSalesData08 = ArkadiusTradeToolsSalesData08 or {}
    ArkadiusTradeToolsSalesData08[serverName] = ArkadiusTradeToolsSalesData08[serverName] or {sales = {}}
    ArkadiusTradeToolsSales.SalesTables[8] = ArkadiusTradeToolsSalesData08

    EVENT_MANAGER:UnregisterForEvent(ArkadiusTradeToolsSalesData.NAME, EVENT_ADD_ON_LOADED)
end

EVENT_MANAGER:RegisterForEvent(ArkadiusTradeToolsSalesData.NAME, EVENT_ADD_ON_LOADED, onAddOnLoaded)
