local minPasswordLength = 8
local complexityRegex = "%w+%W+"
local passwordChangeInterval = 30 * 24 * 60 * 60

local whitelist = {
    "192.168.1.1",
    "10.0.0.1",
}

local failedLoginThreshold = 2
local blockDuration = 300

local failedLoginAttempts = {}

local function checkPasswordComplexity(password)
    return password:len() >= minPasswordLength and password:find(complexityRegex)
end

local function isIPWhitelisted(ip)
    for _, allowedIP in ipairs(whitelist) do
        if ip == allowedIP then
            return true
        end
    end
    return false
end

AddEventHandler('rconCommand', function(commandName, args)
    local srcIP = GetPlayerEndpoint(source)

    if srcIP then
        if not isIPWhitelisted(srcIP) then
            DropPlayer(source, "Your IP address is not authorized to use RCON commands.")
            CancelEvent()
            return
        end
    end

    local cmd = stringsplit(commandName, " ")
    if cmd[1] == "login" then
        local password = cmd[2]

        if not checkPasswordComplexity(password) then
            DropPlayer(source, "Your RCON password does not meet the complexity requirements.")
            CancelEvent()
            return
        end

        if failedLoginAttempts[source] == nil then
            failedLoginAttempts[source] = 0
        end

        failedLoginAttempts[source] = failedLoginAttempts[source] + 1

        if failedLoginAttempts[source] >= failedLoginThreshold then
            DropPlayer(source, ("You have exceeded the maximum number of failed login attempts. You are blocked for %d seconds."):format(blockDuration))
            SetTimeout(blockDuration * 1000, function()
                failedLoginAttempts[source] = nil
            end)
        end
    end
end)

function GetPlayerEndpoint(playerId)
    local identifiers = GetPlayerIdentifiers(playerId)
    for _, identifier in ipairs(identifiers) do
        if string.find(identifier, "ip") then
            return string.sub(identifier, 4)
        end
    end
    return nil
end

function stringsplit(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str)
    end
    return t
end
