IN_FILE_PATH  = "../../SavedVariables/ArkadiusTradeToolsExports.lua"
OUT_FILE_PATH = "../../SavedVariables/ArkadiusTradeToolsExports.csv"
dofile(IN_FILE_PATH)
OUT_FILE = assert(io.open(OUT_FILE_PATH, "w"))

local guildName = arg[1]

local function escapeQuotes(s)
    local value = s:gsub("\"", "\"\"")
    return value
end

local function WriteLine(args)
    OUT_FILE:write(
        guildName
        .. ',' .. escapeQuotes(args.displayName)
        .. ',' .. tostring(args.member)
        .. ',' .. args.salesVolume
        .. ',' .. args.purchaseVolume
        .. ',' .. args.taxes
        .. ',' .. args.purchaseTaxes
        .. ',' .. args.salesCount
        .. ',' .. args.purchaseCount
        .. ',' .. args.internalSalesVolume
        .. ',' .. args.itemCount
        .. '\n'
    )
end

local headersMap = {
    'Guild',
    'Display Name',
    'Member',
    'Sales',
    "Purchases",
    "Taxes (Sales)",
    "Taxes (Purchases)",
    "Sales Count",
    "Purchase Count",
    "Internal Sales Volume",
    "Sold Items",
}
local headers = table.concat(headersMap, ',') .. '\n'

OUT_FILE:write(headers)
    
local export = ArkadiusTradeToolsExportsData[guildName].exports[#ArkadiusTradeToolsExportsData[guildName].exports]
local sortedExportsData = export.data
table.sort(
    sortedExportsData,
    function(a, b)
        if (a.stats.salesVolume == b.stats.salesVolume) then
            if a.isMember == b.isMember then
                if a.stats.purchaseVolume == b.stats.purchaseVolume then
                    return a.displayName < b.displayName
                end
                return a.stats.purchaseVolume > b.stats.purchaseVolume
            end
            return a.isMember
        end
        return a.stats.salesVolume > b.stats.salesVolume
    end
)

for key, data in ipairs(sortedExportsData) do
    local displayName = data.displayName
    local member = data.isMember
    local stats = data.stats
    local purchaseTaxes   = stats["purchaseTaxes"]
    local purchaseVolume   = stats["purchaseVolume"]
    local purchasedItemCount     = stats["purchasedItemCount"]
    local purchaseCount   = stats["purchaseCount"]
    local itemCount = stats["itemCount"]
    local taxes   = stats["taxes"]
    local salesCount   = stats["salesCount"]
    local internalSalesVolume   = stats["internalSalesVolume"]
    local salesVolume   = stats["salesVolume"]
    WriteLine({ 
        displayName = displayName
        , member = member
        , stats = stats
        , purchaseTaxes = purchaseTaxes
        , purchaseVolume = purchaseVolume
        , purchasedItemCount = purchasedItemCount
        , purchaseCount = purchaseCount
        , itemCount = itemCount
        , taxes = taxes
        , salesCount = salesCount
        , internalSalesVolume = internalSalesVolume
        , salesVolume = salesVolume
    })
end

OUT_FILE:close()
