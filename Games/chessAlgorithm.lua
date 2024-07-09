local Chess = {}

---@alias PieceName "none"|"pawn"|"rook"|"king"|"bishop"|"knight"|"queen"
---@alias PieceMove {newSpaceInit: integer, newSpacePieceName: PieceName, newSpaceX: integer, newSpaceY: integer, originalSpaceX: integer, originalSpaceY: integer}

function Chess.trueLocation(x, y)
    local output = ""
    if x == 1 then
        output = "A" .. y
    elseif x == 2 then
        output = "B" .. y
    elseif x == 3 then
        output = "C" .. y
    elseif x == 4 then
        output = "D" .. y
    elseif x == 5 then
        output = "E" .. y
    elseif x == 6 then
        output = "F" .. y
    elseif x == 7 then
        output = "G" .. y
    elseif x == 8 then
        output = "H" .. y
    end
    return output
end

function Chess.Identify(piece)
    local color
    local pieceIcon
    if piece.pieceName == "pawn" then
        if piece.color == "W" then
            color = colors.white
        elseif piece.color == "B" then
            color = colors.gray
        else
            color = colors.green
        end
        pieceIcon = "P"
    elseif piece.pieceName == "rook" then
        if piece.color == "W" then
            color = colors.white
        elseif piece.color == "B" then
            color = colors.gray
        else
            color = colors.green
        end
        pieceIcon = "R"
    elseif piece.pieceName == "knight" then
        if piece.color == "W" then
            color = colors.white
        elseif piece.color == "B" then
            color = colors.gray
        else
            color = colors.green
        end
        pieceIcon = "N"
    elseif piece.pieceName == "bishop" then
        if piece.color == "W" then
            color = colors.white
        elseif piece.color == "B" then
            color = colors.gray
        else
            color = colors.green
        end
        pieceIcon = "B"
    elseif piece.pieceName == "queen" then
        if piece.color == "W" then
            color = colors.white
        elseif piece.color == "B" then
            color = colors.gray
        else
            color = colors.green
        end
        pieceIcon = "Q"
    elseif piece.pieceName == "king" then
        if piece.color == "W" then
            color = colors.white
        elseif piece.color == "B" then
            color = colors.gray
        else
            color = colors.green
        end
        pieceIcon = "K"
    elseif piece.pieceName == "none" then
        color = colors.red
        pieceIcon = "#"
    else
        color = colors.green
        pieceIcon = "@"
    end
    return color, pieceIcon
end

---@param x integer
---@param y integer
---@return table piece
---@return string index
function Chess.getPieceAt(x, y, Layout)
    for i, v in pairs(Layout) do
        if v.x == x and v.y == y then
            return v, i
        end
    end
end

---Checks if a given move was a double advance by a pawn.
---@param move PieceMove
---@param name PieceName
---@return boolean
function Chess.isMoveDoubleAdvance(move, name)
    if name ~= "pawn" then
        return false
    end
    if math.abs(move.newSpaceY - move.originalSpaceY) == 2 then
        return true
    end
    return false
end

---@param piece {x: integer, y: integer, color: "W" | "B", pieceName: PieceName}
---@param moveHistory PieceMove[]
---@return {x: integer, y:integer, captures: nil | {x:integer, y:integer}}[]
function Chess.GetMoves(piece, Layout, moveHistory)
    ValidMoves = {}
    local Movespaces = 0
    if piece.pieceName == "pawn" then
        if piece.color == "W" then
            local MoveDistance = piece.y == 7 and 2 or 1
            for _, value in pairs(Layout) do
                if value.pieceName ~= "none" then
                    if value.x == piece.x then
                        if value.y == piece.y - 2 then
                            MoveDistance = math.min(MoveDistance, 1)
                        elseif value.y == piece.y - 1 then
                            MoveDistance = 0
                        end
                    end
                    if value.y == piece.y - 1 and value.color == "B" then
                        if value.x - 1 == piece.x then
                            table.insert(ValidMoves, { x = value.x, y = value.y })
                        elseif value.x + 1 == piece.x then
                            table.insert(ValidMoves, { x = value.x, y = value.y })
                        end
                    end
                end
            end
            MoveDistance = math.min(piece.y - 1, MoveDistance)
            if MoveDistance > 0 then
                table.insert(ValidMoves, { x = piece.x, y = piece.y - 1 })
                if MoveDistance == 2 then
                    table.insert(ValidMoves, { x = piece.x, y = piece.y - 2 })
                end
            end
            local lastMove = moveHistory[#moveHistory]
            if lastMove and Chess.isMoveDoubleAdvance(lastMove, Chess.getPieceAt(lastMove.newSpaceX, lastMove.newSpaceY, Layout).pieceName) then
                if lastMove.newSpaceY == piece.y then
                    if lastMove.newSpaceX - 1 == piece.x then
                        table.insert(ValidMoves,
                            { x = lastMove.newSpaceX, y = lastMove.newSpaceY - 1, captures = { x = lastMove.newSpaceX, y = lastMove.newSpaceY } })
                    elseif lastMove.newSpaceX + 1 == piece.x then
                        table.insert(ValidMoves,
                            { x = lastMove.newSpaceX, y = lastMove.newSpaceY - 1, captures = { x = lastMove.newSpaceX, y = lastMove.newSpaceY } })
                    end
                end
            end
        else
            local MoveDistance = piece.y == 2 and 2 or 1
            for _, value in pairs(Layout) do
                if value.pieceName ~= "none" then
                    if value.x == piece.x then
                        if value.y == piece.y + 2 then
                            MoveDistance = math.min(MoveDistance, 1)
                        elseif value.y == piece.y + 1 then
                            MoveDistance = 0
                        end
                    end
                    if value.y == piece.y + 1 and value.color == "W" then
                        if value.x - 1 == piece.x then
                            table.insert(ValidMoves, { x = value.x, y = value.y })
                        elseif value.x + 1 == piece.x then
                            table.insert(ValidMoves, { x = value.x, y = value.y })
                        end
                    end
                end
            end
            MoveDistance = math.min(8 - piece.y, MoveDistance)
            if MoveDistance > 0 then
                table.insert(ValidMoves, { x = piece.x, y = piece.y + 1 })
                if MoveDistance == 2 then
                    table.insert(ValidMoves, { x = piece.x, y = piece.y + 2 })
                end
            end
            local lastMove = moveHistory[#moveHistory]
            if lastMove and Chess.isMoveDoubleAdvance(lastMove, Chess.getPieceAt(lastMove.newSpaceX, lastMove.newSpaceY, Layout).pieceName) then
                if lastMove.newSpaceY == piece.y then
                    if lastMove.newSpaceX - 1 == piece.x then
                        table.insert(ValidMoves,
                            { x = lastMove.newSpaceX, y = lastMove.newSpaceY + 1, captures = { x = lastMove.newSpaceX, y = lastMove.newSpaceY } })
                    elseif lastMove.newSpaceX + 1 == piece.x then
                        table.insert(ValidMoves,
                            { x = lastMove.newSpaceX, y = lastMove.newSpaceY + 1, captures = { x = lastMove.newSpaceX, y = lastMove.newSpaceY } })
                    end
                end
            end
        end
    elseif piece.pieceName == "rook" then
        X = 0
        Y = 0
        local Movespaces = 7

        for index, value in pairs(Layout) do
            if value.x == piece.x + 7 and value.y == piece.y then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 7)
                    else
                        Movespaces = math.min(Movespaces, 6)
                    end
                end
            elseif value.x == piece.x + 6 and value.y == piece.y then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 6)
                    else
                        Movespaces = math.min(Movespaces, 5)
                    end
                end
            elseif value.x == piece.x + 5 and value.y == piece.y then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 5)
                    else
                        Movespaces = math.min(Movespaces, 4)
                    end
                end
            elseif value.x == piece.x + 4 and value.y == piece.y then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 4)
                    else
                        Movespaces = math.min(Movespaces, 3)
                    end
                end
            elseif value.x == piece.x + 3 and value.y == piece.y then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 3)
                    else
                        Movespaces = math.min(Movespaces, 2)
                    end
                end
            elseif value.x == piece.x + 2 and value.y == piece.y then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 2)
                    else
                        Movespaces = math.min(Movespaces, 1)
                    end
                end
            elseif value.x == piece.x + 1 and value.y == piece.y then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 1)
                    else
                        Movespaces = math.min(Movespaces, 0)
                    end
                end
            end
        end
        if Movespaces >= 1 then
            for i = 1, Movespaces do
                local changing = piece.x + i
                if changing >= 1 and changing <= 8 then
                    local move = { x = changing, y = piece.y }
                    table.insert(ValidMoves, move)
                end
            end
        end
        local Movespaces = 7

        for index, value in pairs(Layout) do
            if value.x == piece.x - 7 and value.y == piece.y then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 7)
                    else
                        Movespaces = math.min(Movespaces, 6)
                    end
                end
            elseif value.x == piece.x - 6 and value.y == piece.y then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 6)
                    else
                        Movespaces = math.min(Movespaces, 5)
                    end
                end
            elseif value.x == piece.x - 5 and value.y == piece.y then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 5)
                    else
                        Movespaces = math.min(Movespaces, 4)
                    end
                end
            elseif value.x == piece.x - 4 and value.y == piece.y then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 4)
                    else
                        Movespaces = math.min(Movespaces, 3)
                    end
                end
            elseif value.x == piece.x - 3 and value.y == piece.y then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 3)
                    else
                        Movespaces = math.min(Movespaces, 2)
                    end
                end
            elseif value.x == piece.x - 2 and value.y == piece.y then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 2)
                    else
                        Movespaces = math.min(Movespaces, 1)
                    end
                end
            elseif value.x == piece.x - 1 and value.y == piece.y then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 1)
                    else
                        Movespaces = math.min(Movespaces, 0)
                    end
                end
            end
        end
        if Movespaces >= 1 then
            for i = 1, Movespaces do
                local changing = piece.x - i
                if changing >= 1 and changing <= 8 then
                    local move = { x = changing, y = piece.y }
                    table.insert(ValidMoves, move)
                end
            end
        end
        local Movespaces = 7

        for index, value in pairs(Layout) do
            if value.x == piece.x and value.y == piece.y + 7 then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 7)
                    else
                        Movespaces = math.min(Movespaces, 6)
                    end
                end
            elseif value.x == piece.x and value.y == piece.y + 6 then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 6)
                    else
                        Movespaces = math.min(Movespaces, 5)
                    end
                end
            elseif value.x == piece.x and value.y == piece.y + 5 then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 5)
                    else
                        Movespaces = math.min(Movespaces, 4)
                    end
                end
            elseif value.x == piece.x and value.y == piece.y + 4 then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 4)
                    else
                        Movespaces = math.min(Movespaces, 3)
                    end
                end
            elseif value.x == piece.x and value.y == piece.y + 3 then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 3)
                    else
                        Movespaces = math.min(Movespaces, 2)
                    end
                end
            elseif value.x == piece.x and value.y == piece.y + 2 then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 2)
                    else
                        Movespaces = math.min(Movespaces, 1)
                    end
                end
            elseif value.x == piece.x and value.y == piece.y + 1 then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 1)
                    else
                        Movespaces = math.min(Movespaces, 0)
                    end
                end
            end
        end
        if Movespaces >= 1 then
            for i = 1, Movespaces do
                local changing = piece.y + i
                if changing >= 1 and changing <= 8 then
                    local move = { x = piece.x, y = changing }
                    table.insert(ValidMoves, move)
                end
            end
        end
        local Movespaces = 7

        for index, value in pairs(Layout) do
            if value.x == piece.x and value.y == piece.y - 7 then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 7)
                    else
                        Movespaces = math.min(Movespaces, 6)
                    end
                end
            elseif value.x == piece.x and value.y == piece.y - 6 then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 6)
                    else
                        Movespaces = math.min(Movespaces, 5)
                    end
                end
            elseif value.x == piece.x and value.y == piece.y - 5 then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 5)
                    else
                        Movespaces = math.min(Movespaces, 4)
                    end
                end
            elseif value.x == piece.x and value.y == piece.y - 4 then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 4)
                    else
                        Movespaces = math.min(Movespaces, 3)
                    end
                end
            elseif value.x == piece.x and value.y == piece.y - 3 then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 3)
                    else
                        Movespaces = math.min(Movespaces, 2)
                    end
                end
            elseif value.x == piece.x and value.y == piece.y - 2 then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 2)
                    else
                        Movespaces = math.min(Movespaces, 1)
                    end
                end
            elseif value.x == piece.x and value.y == piece.y - 1 then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 1)
                    else
                        Movespaces = math.min(Movespaces, 0)
                    end
                end
            end
        end
        if Movespaces >= 1 then
            for i = 1, Movespaces do
                local changing = piece.y - i
                if changing >= 1 and changing <= 8 then
                    local move = { x = piece.x, y = changing }
                    table.insert(ValidMoves, move)
                end
            end
        end
    elseif piece.pieceName == "knight" then
        for index, value in pairs(Layout) do
            if value.x == piece.x + 2 and value.y == piece.y + 1 and value.color ~= piece.color then
                local Move = {}
                Move.x = piece.x + 2
                Move.y = piece.y + 1
                ValidMoves[#ValidMoves + 1] = Move
            end
            if value.x == piece.x + 1 and value.y == piece.y + 2 and value.color ~= piece.color then
                local Move = {}
                Move.x = piece.x + 1
                Move.y = piece.y + 2
                ValidMoves[#ValidMoves + 1] = Move
            end
            if value.x == piece.x + 2 and value.y == piece.y - 1 and value.color ~= piece.color then
                Movespaces = 6
                local Move = {}
                Move.x = piece.x + 2
                Move.y = piece.y - 1
                ValidMoves[#ValidMoves + 1] = Move
            end
            if value.x == piece.x - 2 and value.y == piece.y + 1 and value.color ~= piece.color then
                Movespaces = 5
                local Move = {}
                Move.x = piece.x - 2
                Move.y = piece.y + 1
                ValidMoves[#ValidMoves + 1] = Move
            end
            if value.x == piece.x - 2 and value.y == piece.y - 1 and value.color ~= piece.color then
                Movespaces = 4
                local Move = {}
                Move.x = piece.x - 2
                Move.y = piece.y - 1
                ValidMoves[#ValidMoves + 1] = Move
            end
            if value.x == piece.x - 1 and value.y == piece.y - 2 and value.color ~= piece.color then
                local Move = {}
                Move.x = piece.x - 1
                Move.y = piece.y - 2
                ValidMoves[#ValidMoves + 1] = Move
            end
            if value.x == piece.x + 1 and value.y == piece.y - 2 and value.color ~= piece.color then
                local Move = {}
                Move.x = piece.x + 1
                Move.y = piece.y - 2
                ValidMoves[#ValidMoves + 1] = Move
            end
            if value.x == piece.x - 1 and value.y == piece.y + 2 and value.color ~= piece.color then
                local Move = {}
                Move.x = piece.x - 1
                Move.y = piece.y + 2
                ValidMoves[#ValidMoves + 1] = Move
            end
        end
    elseif piece.pieceName == "bishop" then
        local Movespaces = 7

        for index, value in pairs(Layout) do
            if value.x == piece.x + 7 and value.y == piece.y + 7 then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 7)
                    else
                        Movespaces = math.min(Movespaces, 6)
                    end
                end
            elseif value.x == piece.x + 6 and value.y == piece.y + 6 then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 6)
                    else
                        Movespaces = math.min(Movespaces, 5)
                    end
                end
            elseif value.x == piece.x + 5 and value.y == piece.y + 5 then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 5)
                    else
                        Movespaces = math.min(Movespaces, 4)
                    end
                end
            elseif value.x == piece.x + 4 and value.y == piece.y + 4 then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 4)
                    else
                        Movespaces = math.min(Movespaces, 3)
                    end
                end
            elseif value.x == piece.x + 3 and value.y == piece.y + 3 then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 3)
                    else
                        Movespaces = math.min(Movespaces, 2)
                    end
                end
            elseif value.x == piece.x + 2 and value.y == piece.y + 2 then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 2)
                    else
                        Movespaces = math.min(Movespaces, 1)
                    end
                end
            elseif value.x == piece.x + 1 and value.y == piece.y + 1 then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 1)
                    else
                        Movespaces = math.min(Movespaces, 0)
                    end
                end
            end
        end
        if Movespaces >= 1 then
            for i = 1, Movespaces do
                local changingX = piece.x + i
                local changingY = piece.y + i
                if changingX >= 1 and changingX <= 8 and changingY >= 1 and changingY <= 8 then
                    local move = { x = changingX, y = changingY }
                    table.insert(ValidMoves, move)
                end
            end
        end
        local Movespaces = 7

        for index, value in pairs(Layout) do
            if value.x == piece.x - 7 and value.y == piece.y + 7 then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 7)
                    else
                        Movespaces = math.min(Movespaces, 6)
                    end
                end
            elseif value.x == piece.x - 6 and value.y == piece.y + 6 then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 6)
                    else
                        Movespaces = math.min(Movespaces, 5)
                    end
                end
            elseif value.x == piece.x - 5 and value.y == piece.y + 5 then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 5)
                    else
                        Movespaces = math.min(Movespaces, 4)
                    end
                end
            elseif value.x == piece.x - 4 and value.y == piece.y + 4 then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 4)
                    else
                        Movespaces = math.min(Movespaces, 3)
                    end
                end
            elseif value.x == piece.x - 3 and value.y == piece.y + 3 then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 3)
                    else
                        Movespaces = math.min(Movespaces, 2)
                    end
                end
            elseif value.x == piece.x - 2 and value.y == piece.y + 2 then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 2)
                    else
                        Movespaces = math.min(Movespaces, 1)
                    end
                end
            elseif value.x == piece.x - 1 and value.y == piece.y + 1 then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 1)
                    else
                        Movespaces = math.min(Movespaces, 0)
                    end
                end
            end
        end
        if Movespaces >= 1 then
            for i = 1, Movespaces do
                local changingX = piece.x - i
                local changingY = piece.y + i
                if changingX >= 1 and changingX <= 8 and changingY >= 1 and changingY <= 8 then
                    local move = { x = changingX, y = changingY }
                    table.insert(ValidMoves, move)
                end
            end
        end
        local Movespaces = 7

        for index, value in pairs(Layout) do
            if value.x == piece.x - 7 and value.y == piece.y - 7 then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 7)
                    else
                        Movespaces = math.min(Movespaces, 6)
                    end
                end
            elseif value.x == piece.x - 6 and value.y == piece.y - 6 then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 6)
                    else
                        Movespaces = math.min(Movespaces, 5)
                    end
                end
            elseif value.x == piece.x - 5 and value.y == piece.y - 5 then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 5)
                    else
                        Movespaces = math.min(Movespaces, 4)
                    end
                end
            elseif value.x == piece.x - 4 and value.y == piece.y - 4 then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 4)
                    else
                        Movespaces = math.min(Movespaces, 3)
                    end
                end
            elseif value.x == piece.x - 3 and value.y == piece.y - 3 then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 3)
                    else
                        Movespaces = math.min(Movespaces, 2)
                    end
                end
            elseif value.x == piece.x - 2 and value.y == piece.y - 2 then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 2)
                    else
                        Movespaces = math.min(Movespaces, 1)
                    end
                end
            elseif value.x == piece.x - 1 and value.y == piece.y - 1 then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 1)
                    else
                        Movespaces = math.min(Movespaces, 0)
                    end
                end
            end
        end
        if Movespaces >= 1 then
            for i = 1, Movespaces do
                local changingX = piece.x - i
                local changingY = piece.y - i
                if changingX >= 1 and changingX <= 8 and changingY >= 1 and changingY <= 8 then
                    local move = { x = changingX, y = changingY }
                    table.insert(ValidMoves, move)
                end
            end
        end
        local Movespaces = 7

        for index, value in pairs(Layout) do
            if value.x == piece.x + 7 and value.y == piece.y - 7 then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 7)
                    else
                        Movespaces = math.min(Movespaces, 6)
                    end
                end
            elseif value.x == piece.x + 6 and value.y == piece.y - 6 then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 6)
                    else
                        Movespaces = math.min(Movespaces, 5)
                    end
                end
            elseif value.x == piece.x + 5 and value.y == piece.y - 5 then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 5)
                    else
                        Movespaces = math.min(Movespaces, 4)
                    end
                end
            elseif value.x == piece.x + 4 and value.y == piece.y - 4 then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 4)
                    else
                        Movespaces = math.min(Movespaces, 3)
                    end
                end
            elseif value.x == piece.x + 3 and value.y == piece.y - 3 then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 3)
                    else
                        Movespaces = math.min(Movespaces, 2)
                    end
                end
            elseif value.x == piece.x + 2 and value.y == piece.y - 2 then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 2)
                    else
                        Movespaces = math.min(Movespaces, 1)
                    end
                end
            elseif value.x == piece.x + 1 and value.y == piece.y - 1 then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 1)
                    else
                        Movespaces = math.min(Movespaces, 0)
                    end
                end
            end
        end
        if Movespaces >= 1 then
            for i = 1, Movespaces do
                local changingX = piece.x + i
                local changingY = piece.y - i
                if changingX >= 1 and changingX <= 8 and changingY >= 1 and changingY <= 8 then
                    local move = { x = changingX, y = changingY }
                    table.insert(ValidMoves, move)
                end
            end
        end
    elseif piece.pieceName == "queen" then
        X = 0
        Y = 0
        local Movespaces = 7

        for index, value in pairs(Layout) do
            if value.x == piece.x + 7 and value.y == piece.y then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 7)
                    else
                        Movespaces = math.min(Movespaces, 6)
                    end
                end
            elseif value.x == piece.x + 6 and value.y == piece.y then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 6)
                    else
                        Movespaces = math.min(Movespaces, 5)
                    end
                end
            elseif value.x == piece.x + 5 and value.y == piece.y then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 5)
                    else
                        Movespaces = math.min(Movespaces, 4)
                    end
                end
            elseif value.x == piece.x + 4 and value.y == piece.y then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 4)
                    else
                        Movespaces = math.min(Movespaces, 3)
                    end
                end
            elseif value.x == piece.x + 3 and value.y == piece.y then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 3)
                    else
                        Movespaces = math.min(Movespaces, 2)
                    end
                end
            elseif value.x == piece.x + 2 and value.y == piece.y then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 2)
                    else
                        Movespaces = math.min(Movespaces, 1)
                    end
                end
            elseif value.x == piece.x + 1 and value.y == piece.y then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 1)
                    else
                        Movespaces = math.min(Movespaces, 0)
                    end
                end
            end
        end
        if Movespaces >= 1 then
            for i = 1, Movespaces do
                local changing = piece.x + i
                if changing >= 1 and changing <= 8 then
                    local move = { x = changing, y = piece.y }
                    table.insert(ValidMoves, move)
                end
            end
        end
        local Movespaces = 7

        for index, value in pairs(Layout) do
            if value.x == piece.x - 7 and value.y == piece.y then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 7)
                    else
                        Movespaces = math.min(Movespaces, 6)
                    end
                end
            elseif value.x == piece.x - 6 and value.y == piece.y then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 6)
                    else
                        Movespaces = math.min(Movespaces, 5)
                    end
                end
            elseif value.x == piece.x - 5 and value.y == piece.y then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 5)
                    else
                        Movespaces = math.min(Movespaces, 4)
                    end
                end
            elseif value.x == piece.x - 4 and value.y == piece.y then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 4)
                    else
                        Movespaces = math.min(Movespaces, 3)
                    end
                end
            elseif value.x == piece.x - 3 and value.y == piece.y then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 3)
                    else
                        Movespaces = math.min(Movespaces, 2)
                    end
                end
            elseif value.x == piece.x - 2 and value.y == piece.y then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 2)
                    else
                        Movespaces = math.min(Movespaces, 1)
                    end
                end
            elseif value.x == piece.x - 1 and value.y == piece.y then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 1)
                    else
                        Movespaces = math.min(Movespaces, 0)
                    end
                end
            end
        end
        if Movespaces >= 1 then
            for i = 1, Movespaces do
                local changing = piece.x - i
                if changing >= 1 and changing <= 8 then
                    local move = { x = changing, y = piece.y }
                    table.insert(ValidMoves, move)
                end
            end
        end
        local Movespaces = 7

        for index, value in pairs(Layout) do
            if value.x == piece.x and value.y == piece.y + 7 then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 7)
                    else
                        Movespaces = math.min(Movespaces, 6)
                    end
                end
            elseif value.x == piece.x and value.y == piece.y + 6 then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 6)
                    else
                        Movespaces = math.min(Movespaces, 5)
                    end
                end
            elseif value.x == piece.x and value.y == piece.y + 5 then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 5)
                    else
                        Movespaces = math.min(Movespaces, 4)
                    end
                end
            elseif value.x == piece.x and value.y == piece.y + 4 then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 4)
                    else
                        Movespaces = math.min(Movespaces, 3)
                    end
                end
            elseif value.x == piece.x and value.y == piece.y + 3 then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 3)
                    else
                        Movespaces = math.min(Movespaces, 2)
                    end
                end
            elseif value.x == piece.x and value.y == piece.y + 2 then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 2)
                    else
                        Movespaces = math.min(Movespaces, 1)
                    end
                end
            elseif value.x == piece.x and value.y == piece.y + 1 then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 1)
                    else
                        Movespaces = math.min(Movespaces, 0)
                    end
                end
            end
        end
        if Movespaces >= 1 then
            for i = 1, Movespaces do
                local changing = piece.y + i
                if changing >= 1 and changing <= 8 then
                    local move = { x = piece.x, y = changing }
                    table.insert(ValidMoves, move)
                end
            end
        end
        local Movespaces = 7

        for index, value in pairs(Layout) do
            if value.x == piece.x and value.y == piece.y - 7 then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 7)
                    else
                        Movespaces = math.min(Movespaces, 6)
                    end
                end
            elseif value.x == piece.x and value.y == piece.y - 6 then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 6)
                    else
                        Movespaces = math.min(Movespaces, 5)
                    end
                end
            elseif value.x == piece.x and value.y == piece.y - 5 then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 5)
                    else
                        Movespaces = math.min(Movespaces, 4)
                    end
                end
            elseif value.x == piece.x and value.y == piece.y - 4 then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 4)
                    else
                        Movespaces = math.min(Movespaces, 3)
                    end
                end
            elseif value.x == piece.x and value.y == piece.y - 3 then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 3)
                    else
                        Movespaces = math.min(Movespaces, 2)
                    end
                end
            elseif value.x == piece.x and value.y == piece.y - 2 then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 2)
                    else
                        Movespaces = math.min(Movespaces, 1)
                    end
                end
            elseif value.x == piece.x and value.y == piece.y - 1 then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 1)
                    else
                        Movespaces = math.min(Movespaces, 0)
                    end
                end
            end
        end
        if Movespaces >= 1 then
            for i = 1, Movespaces do
                local changing = piece.y - i
                if changing >= 1 and changing <= 8 then
                    local move = { x = piece.x, y = changing }
                    table.insert(ValidMoves, move)
                end
            end
        end
        local Movespaces = 7

        for index, value in pairs(Layout) do
            if value.x == piece.x + 7 and value.y == piece.y + 7 then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 7)
                    else
                        Movespaces = math.min(Movespaces, 6)
                    end
                end
            elseif value.x == piece.x + 6 and value.y == piece.y + 6 then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 6)
                    else
                        Movespaces = math.min(Movespaces, 5)
                    end
                end
            elseif value.x == piece.x + 5 and value.y == piece.y + 5 then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 5)
                    else
                        Movespaces = math.min(Movespaces, 4)
                    end
                end
            elseif value.x == piece.x + 4 and value.y == piece.y + 4 then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 4)
                    else
                        Movespaces = math.min(Movespaces, 3)
                    end
                end
            elseif value.x == piece.x + 3 and value.y == piece.y + 3 then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 3)
                    else
                        Movespaces = math.min(Movespaces, 2)
                    end
                end
            elseif value.x == piece.x + 2 and value.y == piece.y + 2 then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 2)
                    else
                        Movespaces = math.min(Movespaces, 1)
                    end
                end
            elseif value.x == piece.x + 1 and value.y == piece.y + 1 then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 1)
                    else
                        Movespaces = math.min(Movespaces, 0)
                    end
                end
            end
        end
        if Movespaces >= 1 then
            for i = 1, Movespaces do
                local changingX = piece.x + i
                local changingY = piece.y + i
                if changingX >= 1 and changingX <= 8 and changingY >= 1 and changingY <= 8 then
                    local move = { x = changingX, y = changingY }
                    table.insert(ValidMoves, move)
                end
            end
        end
        local Movespaces = 7

        for index, value in pairs(Layout) do
            if value.x == piece.x - 7 and value.y == piece.y + 7 then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 7)
                    else
                        Movespaces = math.min(Movespaces, 6)
                    end
                end
            elseif value.x == piece.x - 6 and value.y == piece.y + 6 then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 6)
                    else
                        Movespaces = math.min(Movespaces, 5)
                    end
                end
            elseif value.x == piece.x - 5 and value.y == piece.y + 5 then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 5)
                    else
                        Movespaces = math.min(Movespaces, 4)
                    end
                end
            elseif value.x == piece.x - 4 and value.y == piece.y + 4 then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 4)
                    else
                        Movespaces = math.min(Movespaces, 3)
                    end
                end
            elseif value.x == piece.x - 3 and value.y == piece.y + 3 then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 3)
                    else
                        Movespaces = math.min(Movespaces, 2)
                    end
                end
            elseif value.x == piece.x - 2 and value.y == piece.y + 2 then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 2)
                    else
                        Movespaces = math.min(Movespaces, 1)
                    end
                end
            elseif value.x == piece.x - 1 and value.y == piece.y + 1 then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 1)
                    else
                        Movespaces = math.min(Movespaces, 0)
                    end
                end
            end
        end
        if Movespaces >= 1 then
            for i = 1, Movespaces do
                local changingX = piece.x - i
                local changingY = piece.y + i
                if changingX >= 1 and changingX <= 8 and changingY >= 1 and changingY <= 8 then
                    local move = { x = changingX, y = changingY }
                    table.insert(ValidMoves, move)
                end
            end
        end
        local Movespaces = 7

        for index, value in pairs(Layout) do
            if value.x == piece.x - 7 and value.y == piece.y - 7 then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 7)
                    else
                        Movespaces = math.min(Movespaces, 6)
                    end
                end
            elseif value.x == piece.x - 6 and value.y == piece.y - 6 then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 6)
                    else
                        Movespaces = math.min(Movespaces, 5)
                    end
                end
            elseif value.x == piece.x - 5 and value.y == piece.y - 5 then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 5)
                    else
                        Movespaces = math.min(Movespaces, 4)
                    end
                end
            elseif value.x == piece.x - 4 and value.y == piece.y - 4 then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 4)
                    else
                        Movespaces = math.min(Movespaces, 3)
                    end
                end
            elseif value.x == piece.x - 3 and value.y == piece.y - 3 then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 3)
                    else
                        Movespaces = math.min(Movespaces, 2)
                    end
                end
            elseif value.x == piece.x - 2 and value.y == piece.y - 2 then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 2)
                    else
                        Movespaces = math.min(Movespaces, 1)
                    end
                end
            elseif value.x == piece.x - 1 and value.y == piece.y - 1 then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 1)
                    else
                        Movespaces = math.min(Movespaces, 0)
                    end
                end
            end
        end
        if Movespaces >= 1 then
            for i = 1, Movespaces do
                local changingX = piece.x - i
                local changingY = piece.y - i
                if changingX >= 1 and changingX <= 8 and changingY >= 1 and changingY <= 8 then
                    local move = { x = changingX, y = changingY }
                    table.insert(ValidMoves, move)
                end
            end
        end
        local Movespaces = 7

        for index, value in pairs(Layout) do
            if value.x == piece.x + 7 and value.y == piece.y - 7 then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 7)
                    else
                        Movespaces = math.min(Movespaces, 6)
                    end
                end
            elseif value.x == piece.x + 6 and value.y == piece.y - 6 then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 6)
                    else
                        Movespaces = math.min(Movespaces, 5)
                    end
                end
            elseif value.x == piece.x + 5 and value.y == piece.y - 5 then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 5)
                    else
                        Movespaces = math.min(Movespaces, 4)
                    end
                end
            elseif value.x == piece.x + 4 and value.y == piece.y - 4 then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 4)
                    else
                        Movespaces = math.min(Movespaces, 3)
                    end
                end
            elseif value.x == piece.x + 3 and value.y == piece.y - 3 then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 3)
                    else
                        Movespaces = math.min(Movespaces, 2)
                    end
                end
            elseif value.x == piece.x + 2 and value.y == piece.y - 2 then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 2)
                    else
                        Movespaces = math.min(Movespaces, 1)
                    end
                end
            elseif value.x == piece.x + 1 and value.y == piece.y - 1 then
                if value.pieceName ~= "none" then
                    if piece.color ~= value.color then
                        Movespaces = math.min(Movespaces, 1)
                    else
                        Movespaces = math.min(Movespaces, 0)
                    end
                end
            end
            if Movespaces >= 1 then
                for i = 1, Movespaces do
                    local changingX = piece.x + i
                    local changingY = piece.y - i
                    if changingX >= 1 and changingX <= 8 and changingY >= 1 and changingY <= 8 then
                        local move = { x = changingX, y = changingY }
                        table.insert(ValidMoves, move)
                    end
                end
            end
        end
    elseif piece.pieceName == "king" then
        for key, value in pairs(Layout) do
            if piece.x + 1 == value.x and piece.y == value.y and piece.color ~= value.color then
                local Move = {}
                Move.x = piece.x + 1
                Move.y = piece.y
                ValidMoves[#ValidMoves + 1] = Move
            end
            if piece.x == value.x and piece.y + 1 == value.y and piece.color ~= value.color then
                local Move = {}
                Move.x = piece.x
                Move.y = piece.y + 1
                ValidMoves[#ValidMoves + 1] = Move
            end
            if piece.x - 1 == value.x and piece.y == value.y and piece.color ~= value.color then
                local Move = {}
                Move.x = piece.x - 1
                Move.y = piece.y
                ValidMoves[#ValidMoves + 1] = Move
            end
            if piece.x == value.x and piece.y - 1 == value.y and piece.color ~= value.color then
                local Move = {}
                Move.x = piece.x
                Move.y = piece.y - 1
                ValidMoves[#ValidMoves + 1] = Move
            end
            if piece.x + 1 == value.x and piece.y - 1 == value.y and piece.color ~= value.color then
                local Move = {}
                Move.x = piece.x + 1
                Move.y = piece.y - 1
                ValidMoves[#ValidMoves + 1] = Move
            end
            if piece.x - 1 == value.x and piece.y - 1 == value.y and piece.color ~= value.color then
                local Move = {}
                Move.x = piece.x - 1
                Move.y = piece.y - 1
                ValidMoves[#ValidMoves + 1] = Move
            end
            if piece.x + 1 == value.x and piece.y + 1 == value.y and piece.color ~= value.color then
                local Move = {}
                Move.x = piece.x + 1
                Move.y = piece.y + 1
                ValidMoves[#ValidMoves + 1] = Move
            end
            if piece.x - 1 == value.x and piece.y + 1 == value.y and piece.color ~= value.color then
                local Move = {}
                Move.x = piece.x - 1
                Move.y = piece.y + 1
                ValidMoves[#ValidMoves + 1] = Move
            end
        end
    end
    return ValidMoves
end

function Chess.PawnReachedOtherSide(piece,Layout)
    if piece.color == "W" and piece.y == 1 and piece.pieceName == "pawn" then
        local init = 0
        for key, value in pairs(Layout) do
            if value.pieceName == "queen" and piece.color == value.color then
                init = math.max(init,value.init)
            end
        end
        piece.pieceName = "queen"
        piece.init = init
    elseif piece.color == "B" and piece.y == 8  and piece.pieceName == "pawn" then
        local init = 0
        for key, value in pairs(Layout) do
            if value.pieceName == "queen" and piece.color == value.color then
                init = math.max(init,value.init)
            end
        end
        piece.pieceName = "queen"
        piece.init = init
    else
        piece = nil
    end
    return piece
end



return Chess
