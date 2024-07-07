--TODO: Add manual computer id input
--TODO: Implement a way for the RemoteManagementService to send data to the pocket
----TODO: Implement fetching of computer config values from the network
----TODO: Implement getting the positions of the computers
------TODO: Add browsing
--TODO: Make a better way for inputting data in the Computer screen


local aead = require("ccryptolib.aead")
local random = require "ccryptolib.random"
local key
local user

do
    local rh = fs.open(".key", "r")
    local data = rh.readAll()
    rh.close()
    local u, keyStart = string.match(data, "([^:]+):()")
    user = u
    rawkey = string.sub(data, keyStart, keyStart + 63)
    local out = ""
    for byte in string.gmatch(rawkey, "..") do
        out = out .. string.char(tonumber(byte, 16))
    end
    key = out
end
random.initWithTiming()

peripheral.find("modem", rednet.open)
local remoteManagementServer = rednet.lookup("arcadeRemoteManagement", "arcadeRemoteManagementService") or
error("unable to locate management service", 0)

local function sendMessage(message)
    local nonce = random.random(12)
    local ciphertext, tag = aead.encrypt(key, nonce, textutils.serialise(message, { compact = true }), user, 20)
    rednet.send(remoteManagementServer, { nonce = nonce, ciphertext = ciphertext, tag = tag, user = user },
        "arcadeRemoteManagement")
end

local function sendMessageToComputer(id, message)
    sendMessage({ t = "c", i = id, m = message, ts = os.epoch("utc") })
end


local function setMachineConfigValue(id, key, value)
    sendMessageToComputer(id, { type = "setMachineConfigValue", key = key, value = value })
end
local States = {
    OVERVIEW = "overview",
    COMPUTER_VIEW = "computer",
    BROWSE = "browse",
    INPUT = "input"
}

local headerWindow = window.create(term.current(), 1, 1, 26, 2)

headerWindow.setCursorPos(1, 2)
headerWindow.setTextColor(colors.black)
headerWindow.setBackgroundColor(colors.orange)
headerWindow.write("Bk | Near | Input | Browse")

local function setHeaderText(text)
    headerWindow.setCursorPos(1, 1)
    headerWindow.setBackgroundColor(colors.yellow)
    headerWindow.setTextColor(colors.black)
    local padding = (26 - string.len(text)) / 2
    headerWindow.write(string.rep(" ", math.floor(padding)) .. text .. string.rep(" ", math.ceil(padding)))
end
---An array of options to print
---@param win Window
---@param options ({type: "yesno", yes: string, no: string, key: string, name: string, value: string})[]
local function printOptions(win, options)
    for i, v in pairs(options) do
        if v.type == "yesno" then
            win.setCursorPos(1, i)
            win.setBackgroundColor(colors.black)
            win.setTextColor(colors.white)
            win.write(v.name)
            local w, h = win.getSize()
            local keyLength = string.len(v.name)
            local padLength = w - keyLength - string.len(v.yes) - string.len(v.no)
            local pad = math.floor(padLength / 4)
            if padLength % 4 >= 2 then
                win.setBackgroundColor(colors.black)
                win.write(" ")
            end
            win.setBackgroundColor(colors.green)
            win.write(string.rep(" ", pad))
            win.write(v.yes)
            win.write(string.rep(" ", pad))
            if padLength % 2 == 1 then
                win.setBackgroundColor(colors.black)
                win.write(" ")
            end
            win.setBackgroundColor(colors.red)
            win.write(string.rep(" ", pad))
            win.write(v.no)
            win.write(string.rep(" ", pad))
            if padLength % 4 >= 2 then
                win.setBackgroundColor(colors.black)
                win.write(" ")
            end
        end
    end
end
---@param win Window
---@param options ({type: "yesno", yes: string, no: string, key: string, name: string, value: string})[]
---@return string? key
---@return any value
local function handleOptionClick(win, options, x, y)
    local w, h = win.getSize()
    local option = options[y]
    if option then
        if option.type == "yesno" then
            local keyLength = string.len(option.name)
            local valueLength = w - keyLength
            local padLength = valueLength - string.len(option.yes) - string.len(option.no)
            local left = keyLength + 1
            local right = w
            if padLength % 4 >= 2 then
                left = left + 1
                right = right - 1
            end
            if x> left and x < left+string.len(option.yes) then
                return option.key, true
            elseif x < right and x > right - string.len(option.no) then
                return option.key, false
            end
        end
    else
        return nil
    end
end

---@type {state: string, history: [string, table][] , states: table<string, ApplicationState>}
local application = { history = {}, states = {} }

local function registerState(name, state)
    application.states[name] = state
end
local function getCurrentState()
    return application.states[application.state]
end
local function saveState()
    local oldName = application.state
    local oldState = application.states[oldName]
    local saved = oldState.saveState(oldState)
    table.insert(application.history, { oldName, saved })
end
local function overwriteState(name)
    application.state = name
    local state = getCurrentState()
    state.window.setVisible(true)
    state.onOpen(state)
    setHeaderText(state.getTitle(state))
end
local function popState()
    if #application.history > 0 then
        local saved = table.remove(application.history, #application.history)
        local state = application.states[saved[1]]
        state.restoreState(state, saved[2])
        getCurrentState().window.setVisible(false)
        overwriteState(saved[1])
    end
end
local function switchState(name)
    if name ~= application.state then
        saveState()
        getCurrentState().window.setVisible(false)
        overwriteState(name)
    end
end
local function initializeStates()
    for k, state in pairs(application.states) do
        state.window = window.create(term.current(), 1, 3, 26, 18)
        state.window.setVisible(false)
        state.initialize(state)
    end
end

---@class ApplicationState
local OverviewState = {
    window = {},
    ---@type {}
    data = {},
    getTitle = function(state) return "Remote Management Terminal" end,
    initialize = function(state)
        local overviewWindow = state.window
        overviewWindow.write("Overview is a W.I.P.")
    end,
    onOpen = function(state)
        return
    end,
    handleClick = function(state, button, x, y)
        return
    end,
    handleKey = function (state, key, is_held)
        return true
    end,
    handleChar = function (state, char)
        
    end,
    saveState = function(state)
        return {}
    end,
    restoreState = function(state, data)
        return
    end,
}
registerState(States.OVERVIEW, OverviewState)
---@type ApplicationState
local ComputerViewState = {
    window = {},
    ---@type {id: integer}
    data = { id = 583 },
    getTitle = function(state)
        return "Managing Computer: " .. state.data.id
    end,
    initialize = function(state)
        local computerWindow = state.window
        printOptions(computerWindow,
            { { type = "yesno", yes = "true", no = "false", key = "isProduction", name = "isProduction:", value = true } })
    end,
    onOpen = function(state)
        return
    end,
    handleClick = function(state, button, x, y)
        local key, value = handleOptionClick(state.window, { { type = "yesno", yes = "true", no = "false", key = "isProduction", name = "isProduction:", value = true } }, x, y)
        if key then
            setMachineConfigValue(state.data.id, key, value)
        end
        return
    end,
    handleKey = function (state, key, is_held)
        return true
    end,
    handleChar = function (state, char)
        
    end,
    saveState = function(state)
        return { id = state.data.id }
    end,
    restoreState = function(state, data)
        state.data.id = data.id
    end
}
registerState(States.COMPUTER_VIEW, ComputerViewState)
---@type ApplicationState
local BrowseState = {
    window = {},
    data = {},
    getTitle = function(state)
        return "Browsing Computers"
    end,
    initialize = function(state)
        local browseWindow = state.window
        browseWindow.write("Browsing is a W.I.P.")
    end,
    onOpen = function(state)
        return
    end,
    handleClick = function(state, button, x, y)
        return
    end,
    handleKey = function (state, key, is_held)
        return true
    end,
    handleChar = function (state, char)
        
    end,
    saveState = function(state)
        return {}
    end,
    restoreState = function(state, data)
        return
    end
}
registerState(States.BROWSE, BrowseState)
---@type ApplicationState
local InputState = {
    window = {},
    data = { entered = "" },
    getTitle = function(state)
        return "Input Computer ID"
    end,
    initialize = function(state)
        local inputWindow = state.window
        local w, h = inputWindow.getSize()
        inputWindow.setCursorPos(1, math.floor(h / 2) - 1)
        inputWindow.setBackgroundColor(colors.gray)
        inputWindow.write(string.rep(" ", w))
        inputWindow.setCursorPos(1, math.floor(h / 2))
        inputWindow.setBackgroundColor(colors.lightGray)
        inputWindow.write(string.rep(" ", w))
        inputWindow.setCursorPos(1, math.floor(h / 2) + 1)
        inputWindow.setBackgroundColor(colors.gray)
        inputWindow.write(string.rep(" ", w))
    end,
    onOpen = function(state)
        return
    end,
    handleClick = function(state, button, x, y)
        return
    end,
    handleKey = function (state, key, is_held)
        local data = state.data
        if key == keys.backspace then
            data.entered = string.sub(data.entered,1,-2)
            local inputWindow = state.window
            local w, h = inputWindow.getSize()
            local pad = (w-string.len(data.entered))/2
            inputWindow.setCursorPos(1, math.floor(h / 2))
            inputWindow.setBackgroundColor(colors.lightGray)
            inputWindow.setTextColor(colors.black)
            inputWindow.write(string.rep(" ", math.floor(pad))..data.entered..string.rep(" ", math.ceil(pad)))
            return false
        elseif key == keys.enter then
            application.states[States.COMPUTER_VIEW].data.id = tonumber(data.entered)
            switchState(States.COMPUTER_VIEW)
        end
        return true
    end,
    handleChar = function (state, char)
        local data = state.data
        if true then
            data.entered = data.entered..char
            local inputWindow = state.window
            local w, h = inputWindow.getSize()
            local pad = (w-string.len(data.entered))/2
            inputWindow.setCursorPos(1, math.floor(h / 2))
            inputWindow.setBackgroundColor(colors.lightGray)
            inputWindow.setTextColor(colors.black)
            inputWindow.write(string.rep(" ", math.floor(pad))..data.entered..string.rep(" ", math.ceil(pad)))
        end
    end,
    saveState = function(state)
        return { state.data.entered }
    end,
    restoreState = function(state, data)
        state.data.entered = data.entered
    end
}
registerState(States.INPUT, InputState)

local function setComputerId(id)

end

---Handles a click on the header
---@param button 1|2|3
---@param x number
---@param y number
local function handleHeaderClick(button, x, y)
    if button == 1 then
        if y == 1 then
            switchState(States.OVERVIEW)
        else
            if x < 11 then
                if x < 4 then
                    popState()
                else
                    switchState(States.COMPUTER_VIEW)
                end
            else
                if x < 19 then
                    switchState(States.INPUT)
                else
                    switchState(States.BROWSE)
                end
            end
        end
    end
end
local function handleContentClick(button, x, y)
    local state = getCurrentState()
    state.handleClick(state, button, x, y)
end
---@param key integer
---@param is_held boolean
local function handleKeyPress(key, is_held)
    local state = getCurrentState()
    state.handleKey(state, key, is_held)
end

local function ApplicationThread()
    while true do
        local eventData = table.pack(os.pullEvent())
        if eventData[1] == "mouse_click" then
            ---@type number, number, number
            local button, x, y = table.unpack(eventData, 2)
            if y < 3 then
                handleHeaderClick(button, x, y)
            else
                handleContentClick(button, x, y - 2)
            end
        elseif eventData[1] == "key" then
            local key, is_held = table.unpack(eventData, 2)
            local continue = handleKeyPress(key, is_held)
        elseif eventData[1] == "char" then
            local state = getCurrentState()
            state.handleChar(state, eventData[2])
        end
    end
end

initializeStates()
overwriteState(States.OVERVIEW)

parallel.waitForAny(ApplicationThread)
