---@enum SortingOrder
---sorting order, also controls which score is kept
local SortingOrder = {
    ASCENDING = 1, ---Reverse leaderboard (golf)
    DESCENDING = 2 ---A normal leaderboard
}
---@alias HighscoreMessage {category: string, player: string, score: number}

---@type table<string, {order: SortingOrder, scores:{player:string, value: number}}[]

local insert = table.insert
local sort = table.sort

rednet.open("top")
rednet.host("highscore", "highscoreService")

local Categories = {}

if not fs.exists("/highscores") then
    fs.makeDir("/highscores")
end

do
    for _, name in pairs(fs.list("/highscores")) do
        local rh = fs.open("/highscores/"..name, "r")
        local board = textutils.unserialise(rh.readAll())
        rh.close()
        Categories[name] = board
    end
end

local function find(category, player)
    for k,v in pairs(category.scores) do
        if v.player == player then
            return v
        end
    end
    return nil
end
local function saveCategory(name, category)
    local wh = fs.open("/highscores/"..name, "w")
    wh.write(textutils.serialize(category))
    wh.close()
end


while true do
    local id, message = rednet.receive("highscore")
    ---@cast message HighscoreMessage
    local category = Categories[message.category]
    local scores = category.scores
    local found = find(category, message.player)
    if found then
        if found.score < message.score and category.order == 2 then
            found.score = message.score
        end
    else
        insert(scores, {player=message.player,score = message.score})
    end
    sort(scores,function (a, b)
        if a.score < b.score and category.order == 2 then
            return false
        end
        return true
    end)
    saveCategory(message.category,category)
end
