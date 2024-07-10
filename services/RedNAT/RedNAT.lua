--Allows ingress and egress of permitted protocols from a network. 
--works kinda like real nat. Basically the way it works is
--rednet.send(rednatServerId + interalId*rednet.MAX_ID_CHANNELS, message).

local externalSide = "bottom"
local internalSide = "top"

---Modem with untrusted traffic
local ExternalModem = peripheral.wrap(externalSide)
---Modem with trusted traffic
local InternalModem = peripheral.wrap(internalSide)

if not ExternalModem or peripheral.getType(ExternalModem) ~= "modem" then
    error("Unable to find external modem")
end
if not InternalModem or peripheral.getType(InternalModem) ~= "modem" then
    error("Unable to find interior modem")
end

---@cast ExternalModem Modem
---@cast InternalModem Modem

---@type {allowedProtocols:string[], allowedComputers:string[], byId:table<number, string[]>}
local ingress = {byId={},allowedComputers={},allowedProtocols={}}
---@type {allowedProtocols:string[], allowedComputers:string[], byId:table<number, string[]>}
local egress = {byId={},allowedComputers={},allowedProtocols={}}

do
    local rh = fs.open("/ingress.cnf", "r")
    if not rh then
        error("unable to load ingress config")
    end
    local data = rh.readAll()
    rh.close()
    if not data then
        error("unable to read ingress config")
    end
    local parsed = textutils.unserialise(data)
    if type(parsed) ~= "table" or type(parsed.allowedComputers) ~= "table" or type(parsed.allowedProtocols) ~= "table" or type(parsed.byId) ~= "table" then
        error("ingress config is invalid")
    end
    for k,v in ipairs(parsed.allowedProtocols) do
        if type(v) == "string" and type(k) == "number" then
            table.insert(ingress.allowedProtocols,v)
        end
    end
    for k,v in ipairs(parsed.allowedComputers) do
        if type(v) == "string" and type(k) == "number" then
            table.insert(ingress.allowedComputers,v)
        end
    end
    for k,v in pairs(parsed.byId) do
        if type(k) == "number" and type(v) == "table" then
            local sanitized = {}
            for i, protocol in ipairs(v) do
                if type(i) == "number" and type(protocol) == "string" then
                    table.insert(sanitized, protocol)
                end
            end
            ingress.byId[k] = sanitized
        end
    end
end

do
    local rh = fs.open("/egress.cnf", "r")
    if not rh then
        error("unable to load egress config")
    end
    local data = rh.readAll()
    rh.close()
    if not data then
        error("unable to read egress config")
    end
    local parsed = textutils.unserialise(data)
    if type(parsed) ~= "table" or type(parsed.allowedComputers) ~= "table" or type(parsed.allowedProtocols) ~= "table" or type(parsed.byId) ~= "table" then
        error("egress config is invalid")
    end
    for k,v in ipairs(parsed.allowedProtocols) do
        if type(v) == "string" and type(k) == "number" then
            table.insert(egress.allowedProtocols,v)
        end
    end
    for k,v in ipairs(parsed.allowedComputers) do
        if type(v) == "string" and type(k) == "number" then
            table.insert(egress.allowedComputers,v)
        end
    end
    for k,v in pairs(parsed.byId) do
        if type(k) == "number" and type(v) == "table" then
            local sanitized = {}
            for i, protocol in ipairs(v) do
                if type(i) == "number" and type(protocol) == "string" then
                    table.insert(sanitized, protocol)
                end
            end
            egress.byId[k] = sanitized
        end
    end
end

ExternalModem.open(os.getComputerID())
InternalModem.open(os.getComputerID())

local allowedFields = {nMessageID=true,nSender=true,nRecipient=true,sHostname=true,sType=true,message=true,sProtocol=true}

while true do
    local event, side, channel, reply, message, dist = os.pullEvent("modem_message")
    if side == externalSide then
        if type(message) == "table" and type(message.nMessageID) == "number" and
            type(message.nSender) == "number" and type(message.nRecipient) == "number" and
            message.nRecipient%rednet.MAX_ID_CHANNELS == os.getComputerID() and
            (not message.sProtocol or type(message.sProtocol) == "string") then
            local continue = true
            for k,v in pairs(message) do
                if not allowedFields[k] then
                    continue = false
                    break
                end
            end
            ---@cast message {nSender: number, nRecipient:number, sHostname: string|nil, sProtocol:string|nil, message: any, sType: string|nil, nMessageID: number}
            if continue then
                local internalId = (message.nRecipient - os.getComputerID())/rednet.MAX_ID_CHANNELS
                if internalId >= 0 and internalId <= rednet.MAX_ID_CHANNELS then
                    local permitted = false
                    for index, value in ipairs(ingress.allowedComputers) do
                        if value == internalId then
                            permitted = true
                        end
                    end
                    for index, value in ipairs(ingress.allowedProtocols) do
                        if value == message.sProtocol then
                            permitted = true
                        end
                    end
                    local allowedProts = ingress.byId[internalId]
                    if allowedProts then
                        for k, prot in ipairs(allowedProts) do
                            if prot == message.sProtocol then
                                permitted = true
                            end
                        end 
                    end
                    if permitted then
                        InternalModem.transmit(internalId%rednet.MAX_ID_CHANNELS, os.getComputerID(), {
                            nMessageID = message.nMessageID,
                            nSender = os.getComputerID() + message.nSender * rednet.MAX_ID_CHANNELS,
                            nRecipient = internalId,
                            sHostname = message.sHostname,
                            sProtocol = message.sProtocol,
                            sType = message.sType,
                            message = message.message
                        })
                    end
                end
            end
        end
    elseif side == internalSide then
        if type(message) == "table" and type(message.nMessageID) == "number" and
            type(message.nSender) == "number" and type(message.nRecipient) == "number" and
            message.nRecipient%rednet.MAX_ID_CHANNELS == os.getComputerID() and
            (not message.sProtocol or type(message.sProtocol) == "string") then
            local continue = true
            for k,v in pairs(message) do
                if not allowedFields[k] then
                    continue = false
                    break
                end
            end
            ---@cast message {nSender: number, nRecipient:number, sHostname: string|nil, sProtocol:string|nil, message: any, sType: string|nil, nMessageID: number}
            if continue then
                local externalId = (message.nRecipient - os.getComputerID())/rednet.MAX_ID_CHANNELS
                if externalId >= 0 and externalId <= rednet.MAX_ID_CHANNELS then
                    local permitted = false
                    for index, value in ipairs(egress.allowedComputers) do
                        if value == externalId then
                            permitted = true
                        end
                    end
                    for index, value in ipairs(egress.allowedProtocols) do
                        if value == message.sProtocol then
                            permitted = true
                        end
                    end
                    local allowedProts = egress.byId[externalId]
                    if allowedProts then
                        for k, prot in ipairs(allowedProts) do
                            if prot == message.sProtocol then
                                permitted = true
                            end
                        end 
                    end
                    if permitted then
                        ExternalModem.transmit(externalId%rednet.MAX_ID_CHANNELS, os.getComputerID(), {
                            nMessageID = message.nMessageID,
                            nSender = os.getComputerID() + message.nSender * rednet.MAX_ID_CHANNELS,
                            nRecipient = externalId,
                            sHostname = message.sHostname,
                            sProtocol = message.sProtocol,
                            sType = message.sType,
                            message = message.message
                        })
                    end
                end
            end
        end
    end
end
