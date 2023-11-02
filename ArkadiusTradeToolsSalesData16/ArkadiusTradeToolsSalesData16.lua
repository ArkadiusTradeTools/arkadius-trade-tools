local ArkadiusTradeToolsSalesData = {}
local ArkadiusTradeToolsSales = ArkadiusTradeTools.Modules.Sales
ArkadiusTradeToolsSalesData.NAME = ArkadiusTradeToolsSales.NAME .. "Data16"
ArkadiusTradeToolsSalesData.VERSION = ArkadiusTradeToolsSales.VERSION
ArkadiusTradeToolsSalesData.AUTHOR = ArkadiusTradeToolsSales.AUTHOR

local function onAddOnLoaded(eventCode, addonName)
    if addonName ~= ArkadiusTradeToolsSalesData.NAME then
        return
    end

    local serverName = GetWorldName()
    ArkadiusTradeToolsSalesData16 = ArkadiusTradeToolsSalesData16 or {}
    ArkadiusTradeToolsSalesData16[serverName] = ArkadiusTradeToolsSalesData16[serverName] or { sales = {} }
    ArkadiusTradeToolsSales.SalesTables[16] = ArkadiusTradeToolsSalesData16

    EVENT_MANAGER:UnregisterForEvent(ArkadiusTradeToolsSalesData.NAME, EVENT_ADD_ON_LOADED)
end

EVENT_MANAGER:RegisterForEvent(ArkadiusTradeToolsSalesData.NAME, EVENT_ADD_ON_LOADED, onAddOnLoaded)
