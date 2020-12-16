IN_FILE_PATH  = "../../SavedVariables/ArkadiusTradeToolsExports.lua"
dofile(IN_FILE_PATH)

local args = {
    ['--latest'] = 'useLatest',
    ['--members'] = 'useOnlyMembers'
}

-- Defining these as globals so setting them by name is easier
useLatest = false
useOnlyMembers = false

for idx, _arg in pairs(arg) do
    if args[_arg] then
        _G[args[_arg]] = true
    end
end

local useLatest = arg[1] and arg[1] == '--latest'

local function escapeQuotes(s)
    local value = s:gsub("\"", "\"\"")
    return value
end

local function WriteLine(args)
    OUT_FILE:write(
        args.guildName
        .. ',' .. args.startTimeStamp
        .. ',' .. args.endTimeStamp
        .. ',' .. escapeQuotes(args.displayName)
        .. ',' .. tostring(args.member)
        .. ',' .. args.salesVolume
        .. ',' .. args.purchaseVolume
        .. ',' .. (args.rankIndex or "")
        .. ',' .. (args.rankName or "")
        .. ',' .. args.taxes
        .. ',' .. args.purchaseTaxes
        .. ',' .. args.salesCount
        .. ',' .. args.purchaseCount
        .. ',' .. args.internalSalesVolume
        .. ',' .. args.itemCount
        .. '\n'
    )
end

local servers = {}
for k in pairs(ArkadiusTradeToolsExportsData.exports) do 
    servers[#servers + 1] = k
end

local function isValidServer(input)
    return servers[input] ~= nil
end

local input
if #servers == 1 then input = 1 end
while not isValidServer(input) do
    io.write('Available Servers:\n')
    for key, value in pairs(servers) do
        io.write(key .. ". " .. value .. "\n")
    end
    io.write("Which server would you like to use? ")
    io.flush()
    input = tonumber(io.read())
end

-- local guilds = {}
-- for k, v in pairs(ArkadiusTradeToolsExportsData.exports[servers[input]]) do
--     guilds[v.guildName] = true
-- end

-- local guildName
-- repeat
--     io.write('Available Servers:\n')
--     for key, value in pairs(servers) do
--         io.write(key .. ". " .. value .. "\n")
--     end
--     io.write("Which server would you like to use? ")
--     io.flush()
--     guildName = tonumber(io.read())
-- until isValidServer(guildName)

local exports = ArkadiusTradeToolsExportsData.exports[servers[input]]
table.sort(exports, function(a, b)
    if (a.startTimeStamp == b.startTimeStamp) then
        if a.endTimeStamp == b.endTimeStamp then
            return a.guildName < b.guildName
        end
        return a.endTimeStamp > b.endTimeStamp
    end
    return a.startTimeStamp > b.startTimeStamp
end)

local selectedExport
if not useLatest then
    io.write('Available Exports:\n')
    for idx, value in ipairs(exports) do
        io.write(idx .. ". " .. value.guildName .. "\n")
        io.write("   End Date:   ".. os.date('%Y-%m-%dT%H:%M:%S', value.endTimeStamp) .. '\n')
        io.write("   Start Date: ".. os.date('%Y-%m-%dT%H:%M:%S', value.startTimeStamp) .. '\n\n')
    end

    io.write("Which export would you like to use? ")
    io.flush()
    selectedExport = tonumber(io.read())
else
    selectedExport = 1
end
local sortedExportsData = exports[selectedExport]

table.sort(
    sortedExportsData.data,
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

local headersMap = {
    "Guild",
    "Start Timestamp",
    "End Timestamp",
    "Display Name",
    "Member",
    "Sales",
    "Purchases",
    "Rank Index",
    "Rank Name",
    "Taxes (Sales)",
    "Taxes (Purchases)",
    "Sales Count",
    "Purchase Count",
    "Internal Sales Volume",
    "Sold Items",
}
local headers = table.concat(headersMap, ',') .. '\n'

local startTimeStamp = os.date('%Y-%m-%dT%H.%M.%S', sortedExportsData.startTimeStamp)
local endTimeStamp = os.date('%Y-%m-%dT%H.%M.%S', sortedExportsData.endTimeStamp)
local isMembers = useOnlyMembers and "Members" or "All"
local newPath = string.format("../../SavedVariables/ArkadiusTradeToolsExports-%s %s %s-%s.csv", sortedExportsData.guildName, isMembers, startTimeStamp, endTimeStamp)

OUT_FILE_PATH = "../../SavedVariables/ArkadiusTradeToolsExports.csv"
OUT_FILE = assert(io.open(newPath, "w"))
OUT_FILE:write(headers)

startTimeStamp = os.date('%Y-%m-%dT%H:%M:%S', sortedExportsData.startTimeStamp)
endTimeStamp = os.date('%Y-%m-%dT%H:%M:%S', sortedExportsData.endTimeStamp)
for key, data in ipairs(sortedExportsData.data) do
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
    if data.isMember or not useOnlyMembers then
        WriteLine({
            guildName = sortedExportsData.guildName
            , startTimeStamp = startTimeStamp
            , endTimeStamp = endTimeStamp
            , displayName = displayName
            , member = member
            , stats = stats
            , rankIndex = data.rankIndex
            , rankName = data.rankName
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
end

OUT_FILE:close()
os.rename(OUT_FILE_PATH, newPath)
print(string.format("Saved to %s", newPath))