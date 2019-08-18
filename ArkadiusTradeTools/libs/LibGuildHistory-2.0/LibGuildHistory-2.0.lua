local LIB_NAME = "LibGuildHistory-2.0"
local LIB_VERSION = "2.0.0"
local LibGuildHistory = LibStub:NewLibrary(LIB_NAME, LIB_VERSION)
if not LibGuildHistory then return end

local scanQueue = {}

------------------------------------------------------------------
------------------------ Local functions -------------------------
------------------------------------------------------------------
local function GetEventId(guildId, category, eventIndex)
    return LibGuildHistory:GetGuildEventId(guildId, category, eventIndex)
end

local function GetEventTimeStamp(guildId, category, eventIndex)
    local timestamp = GetTimeStamp()
    local _, secsSinceEvent = GetGuildEventInfo(guildId, category, eventIndex)

    return timestamp - secsSinceEvent
end

local function OnGuildHistoryEvent(eventCode, guildId, category)
    if (eventCode ~= EVENT_GUILD_HISTORY_RESPONSE_RECEIVED) then
        return
    end

    if (scanQueue[guildId] and scanQueue[guildId][category]) then
        local numEvents = GetNumGuildEvents(guildId, category)

        for queueId, queueInfo in pairs(scanQueue[guildId][category]) do
            if (numEvents > queueInfo.numProcessedEvents) then
                local newEventIndexFirst = queueInfo.numProcessedEvents + 1
                local newEventIndexLast = numEvents
                local callback = queueInfo.callback

                for i = newEventIndexFirst, newEventIndexLast do
                    local eventIdOrTimeStamp = queueInfo.GetEventIdOrTimeStamp(guildId, category, i)

                    if (eventIdOrTimeStamp > queueInfo.newerThan) then
                        callback(guildId, category, i, eventIdOrTimeStamp, false)
                    end
                end

                queueInfo.numProcessedEvents = newEventIndexLast
            end
        end
    end
end

------------------------------------------------------------------
----------------------- Exported functions -----------------------
------------------------------------------------------------------
function LibGuildHistory:RequestHistory(queueId, category, callback)
    for i = 1, GetNumGuilds() do
        self:requestHistoryByGuildId(queueId, GetGuildId(i), category, callback)
    end
end

function LibGuildHistory:RequestHistoryByGuildId(queueId, guildId, category, callback)
    self:requestHistoryNewerByGuildId(queueId, guildId, category, 0, true, callback)
end

function LibGuildHistory:RequestHistoryNewerByGuildId(queueId, guildId, category, newerThan, useTimestamps, callback)
    scanQueue[guildId] = scanQueue[guildId] or {}
    scanQueue[guildId][category] = scanQueue[guildId][category] or {}
    scanQueue[guildId][category][queueId] = scanQueue[guildId][category][queueId] or {}
    scanQueue[guildId][category][queueId].callback = callback
    scanQueue[guildId][category][queueId].newerThan = newerThan
    scanQueue[guildId][category][queueId].numProcessedEvents = 0

    if (useTimestamps) then
        scanQueue[guildId][category][queueId].GetEventIdOrTimeStamp = GetEventTimeStamp
    else
        scanQueue[guildId][category][queueId].GetEventIdOrTimeStamp = GetEventId
    end
end

--- Returns a guild events unique id ----
function LibGuildHistory:GetGuildEventId(guildId, category, eventIndex)
    local eventId = GetGuildEventId(guildId, category, eventIndex)
    return tonumber(Id64ToString(eventId))
end

EVENT_MANAGER:RegisterForEvent(LIB_NAME, EVENT_GUILD_HISTORY_RESPONSE_RECEIVED, OnGuildHistoryEvent)
