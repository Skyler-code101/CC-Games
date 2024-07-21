local machineConfig = {
    isProduction = false,
    allowRemoteManagement = true
}
local machineConfigRh = fs.open('/.machineconfig', "r")

peripheral.find("modem", rednet.open)

-- If any errors occur here it's not my problem :shrug:
if machineConfigRh then
    local conf = textutils.unserialise(machineConfigRh.readAll())
    machineConfigRh.close()
    for key, value in pairs(conf) do
        machineConfig[key] = value
    end
end

settings.set("shell.allow_disk_startup", false)
settings.save()

local function saveMachineConfig()
    wh = fs.open("/.machineConfig", "w")
    wh.write(textutils.serialise(machineConfig))
    wh.close()
end
if not machineConfig.startupFile then
    print("Please enter file to run (including.lua)")
    machineConfig.startupFile = read()
    saveMachineConfig()
end
if not machineConfig.errorReportingServiceId then
    machineConfig.errorReportingServiceId = rednet.lookup("errorReporting", "errorReportingService")
    if not machineConfig.errorReportingServiceId then
        term.setTextColor(colors.orange)
        print("unable to locate errorReportingService")
        term.setTextColor(colors.white)
    end
    saveMachineConfig()
end

local env = {}

for k,v in pairs(_G) do
    env[k]=v
end

env.require, env.package = require("cc.require").make(env, "/")

local startupChunk = loadfile(machineConfig.startupFile, "t", env)


if not startupChunk then
    error("unable to locate startup file")
else
    local function doStartupThread()
        local startupRoutine = coroutine.create(startupChunk)
        local startupFilter = nil
        local eventData = {n=0}
        while true do
            if eventData[1] == "terminate" and not machineConfig.isProduction then
                error("Terminated", 0)
            end
            if eventData[1] ~= "terminate" and (not startupFilter or startupFilter == eventData[1]) then
                local success, filter = coroutine.resume(startupRoutine, table.unpack(eventData,1,eventData.n))
                if success then
                    if filter == "terminate" then
                        print("You probably shouldn't listen for terminate as it is blocked in production")
                        startupFilter = nil
                    else
                        startupFilter = filter
                    end
                else
                    if machineConfig.isProduction then
                        ---@type TraceReport
                        local trace = {type="trace", computer=os.getComputerID(), isStartup = true, timestamp=os.epoch("utc"), traceback = filter}
                        rednet.send(machineConfig.errorReportingServiceId, trace, "errorReporting")
                        os.reboot()
                    else
                        error(filter, 0)
                    end
                end
                if coroutine.status(startupRoutine) == "dead" then
                    if machineConfig.isProduction then
                        ---@type EndedReport
                        local trace = {type="programEnded", computer=os.getComputerID(), timestamp=os.epoch("utc")}
                        rednet.send(machineConfig.errorReportingServiceId, trace, "errorReporting")
                        os.reboot()
                    else
                        error("The program exited without any error (probably should fix before putting into production)")
                    end
                end
            end
            eventData = table.pack(coroutine.yield())
        end
    end
    local function doManagementThread()
        while true do
            local event, sender, message, protocol = os.pullEventRaw("rednet_message")
            if event == "rednet_message" then
                if protocol == "remoteManagement" and type(message) == "table" then
                    if message.type == "setMachineConfigValue" and type(message.key) == "string" then
                        machineConfig[message.key] = message.value
                        saveMachineConfig()
                    elseif message.type == "reboot" then
                        os.reboot()
                    elseif message.type == "getMachineConfig" and type(message.forId) == "number" and type(message.forUser) == "string" then
                        rednet.send(sender, {type="machineConfig",value=machineConfig, forId = message.forId, forUser = message.forUser}, "remoteManagement")
                    end
                end
            end
        end
    end
    if machineConfig.allowRemoteManagement then
        parallel.waitForAny(doStartupThread, doManagementThread)
    else
        parallel.waitForAny(doStartupThread)
    end
end
