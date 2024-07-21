---A map that removes entries once they expire
---@class (exact) TimeoutMap
---@field entries {}
---@field private expireCheckCallback fun(key:any, value: any): boolean
---@field __index TimeoutMap
local TimeoutMap = {}
TimeoutMap.__index = TimeoutMap

---@param expireCheckCallback fun(key:any, value: any): boolean
---@return TimeoutMap
function TimeoutMap:new(expireCheckCallback)
    local newMap = {}
    newMap.expireCheckCallback = expireCheckCallback
    newMap.entries = {}
    setmetatable(newMap, TimeoutMap)

    return newMap
end
function TimeoutMap:set(key, value)
    self.entries[key] = value
end
function TimeoutMap:contains(key)
    if self.entries[key] then
        return true
    end
    return false
end
function TimeoutMap:cull()
    for k,v in pairs(self.entries) do
        if self.expireCheckCallback(k,v) then
            self.entries[k] = nil
        end
    end
end

return TimeoutMap
