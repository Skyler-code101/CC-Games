local aead = require("ccryptolib.aead")
local TimeoutMap = require("TimeoutMap")
local random     = require("ccryptolib.random")
local len = string.len

---@type table<string, string>
local keys = {}

do
    local rh = fs.open(".keys", "r")
    local unserialised = textutils.unserialiseJSON(rh.readAll())
    rh.close()

    for k,v in pairs(unserialised) do
        local out = ""
        for byte in string.gmatch(v, "..") do
            out = out..string.char(tonumber(byte,16))
        end
        keys[k] = out
    end
end

rednet.open("top")
rednet.host("arcadeRemoteManagement", "arcadeRemoteManagementService")
rednet.host("remoteManagement", "remoteManagementService")

local selfId = os.getComputerID()

random.initWithTiming()

local function sendMessage(id, user, message)
    local key = keys[user]
    if key then
        local nonce = random.random(12)
        local ciphertext, tag = aead.encrypt(key, nonce, textutils.serialise(message, { compact = true }), user..":frommanagement", 20)
        rednet.send(id, { nonce = nonce, ciphertext = ciphertext, tag = tag, user = user },
            "arcadeRemoteManagement")
    end
end

local function sendMessageToPocket(id, user, message)
    sendMessage(id, user, { m = message, ts = os.epoch("utc") })
end


local function sendMachineConfig(id, user, computerId, value)
    sendMessageToPocket(id, user, { type = "machineConfig", id=computerId, value = value })
end

local nonces = TimeoutMap:new(function (key,value)
    return value + 2000 < os.epoch("utc")
end)

while true do
    local sender, message, protocol = rednet.receive(nil,0.05)
    if type(message) == "table"then
        if protocol == "arcadeRemoteManagement" and type(message.ciphertext) == "string" and type(message.tag) == "string" and len(message.tag) == 16 and type(message.nonce) == "string" and len(message.nonce) == 12 and type(message.user) == "string" and keys[message.user] and not nonces:contains(message.nonce) then
            local key = keys[message.user]

            local plaintext = aead.decrypt(key, message.nonce, message.tag, message.ciphertext, message.user, 20)
            if plaintext then
                local decoded = textutils.unserialise(plaintext)
                if decoded then
                    if type(decoded) == "table" and type(decoded.ts) == "number" then
                        local now = os.epoch("utc")
                        if decoded.ts > now - 1000 and decoded.ts < now + 500 then
                            nonces:set(message.nonce, decoded.ts)
                            if decoded.t == "c" and type(decoded.i) == "number" and type(decoded.m) == "table" then
                                decoded.m.forId = sender
                                rednet.send(decoded.i, decoded.m, "remoteManagement")
                            end
                        end
                    end
                end
            end
        elseif protocol == "remoteManagement" then
            if message.type == "machineConfig" and type(message.forUser) == "string" and type(message.forId) == "number" and type(message.value) == "table" then
                sendMachineConfig(message.forId, message.forUser, sender, message.value)
            end
        end
    end
    nonces:cull()
end
