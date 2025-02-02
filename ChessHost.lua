local monitor = peripheral.find("monitor")
local pieceLayout = {}
if not fs.exists("pieceLayout") then
    print("No Board File Found")
else 
    local file = fs.open("pieceLayout", "r")
    pieceLayout = textutils.unserialise(file.readAll())
    file.close()
end
    
    
local speaker = peripheral.find("speaker")
local playersturn = "W"
local selectedpiece = ""
function a()
    --display
    while true do
        monitor.setBackgroundColor(colors.blue)
        monitor.clear()
        monitor.setTextScale(4)
        if playersturn == "W" then  
            monitor.setTextColor(colors.green)
            monitor.setCursorPos(9,8)
            monitor.write("{}")
        elseif playersturn == "B" then
            monitor.setTextColor(colors.green)
            monitor.setCursorPos(9,1)
            monitor.write("{}")
        end
        monitor.setCursorPos(1,1)
        for index, value in pairs(pieceLayout) do
            monitor.setCursorPos(value.x,value.y)
            if value.pieceName == "pawn"then
                if value.color == "W" then
                    monitor.setTextColor(colors.lightGray)
                elseif value.color == "B" then
                    monitor.setTextColor(colors.black)
                end
                if selectedpiece == index then
                    monitor.setTextColor(colors.purple)
                end
                monitor.setCursorPos(value.x,value.y)
                monitor.write("P")
            elseif value.pieceName == "rook" then
                if value.color == "W" then
                    monitor.setTextColor(colors.lightGray)
                elseif value.color == "B" then
                    monitor.setTextColor(colors.black)
                end
                if selectedpiece == index then
                    monitor.setTextColor(colors.purple)
                end
                monitor.setCursorPos(value.x,value.y)
                monitor.write("R")
            elseif value.pieceName == "knight" then
                if value.color == "W" then
                    monitor.setTextColor(colors.lightGray)
                elseif value.color == "B" then
                    monitor.setTextColor(colors.black)
                end
                if selectedpiece == index then
                    monitor.setTextColor(colors.purple)
                end
                monitor.setCursorPos(value.x,value.y)
                monitor.write("N")
            elseif value.pieceName == "bishop" then
                if value.color == "W" then
                    monitor.setTextColor(colors.lightGray)
                elseif value.color == "B" then
                    monitor.setTextColor(colors.black)
                end
                if selectedpiece == index then
                    monitor.setTextColor(colors.purple)
                end
                monitor.setCursorPos(value.x,value.y)
                monitor.write("B")
            elseif value.pieceName == "queen" then
                if value.color == "W" then
                    monitor.setTextColor(colors.lightGray)
                elseif value.color == "B" then
                    monitor.setTextColor(colors.black)
                end
                if selectedpiece == index then
                    monitor.setTextColor(colors.purple)
                end
                monitor.setCursorPos(value.x,value.y)
                monitor.write("Q")
            elseif value.pieceName == "king" then
                if value.color == "W" then
                    monitor.setTextColor(colors.lightGray)
                elseif value.color == "B" then
                    monitor.setTextColor(colors.black)
                end
                if selectedpiece == index then
                    monitor.setTextColor(colors.purple)
                end
                monitor.setCursorPos(value.x,value.y)
                monitor.write("K")
            elseif value.pieceName == "none" then
                monitor.setTextColor(colors.red)
                monitor.setCursorPos(value.x,value.y)
                monitor.write("#")
            end
        end
        
        sleep(.1)
    end
end
local Moves = {}
function b()
    --reciving
    while true do
        local event, side, x, y = os.pullEvent("monitor_touch") 
        print("Monitor Touched At (" .. x .. ", " .. y .. ")")
        local SavedValues = {}
        SavedValues.originalSpaceX = x
        SavedValues.originalSpaceY = y
        for index, value in pairs(pieceLayout) do
        if value.color == playersturn then
            if value.x == x and value.y == y then
                print("Piece Interacted : "..value.pieceName..", "..value.color..", "..value.init)
                selectedpiece = index
                local eventt, sidet, xt, yt
                repeat
                    eventt, sidet, xt, yt = os.pullEvent("monitor_touch")
                until xt <=8 and yt <=8
                    print("Monitor Touched At (" .. xt .. ", " .. yt .. ")")
                    SavedValues.newSpaceX = xt
                    SavedValues.newSpaceY = yt
                    for indexl, valuel in pairs(pieceLayout) do
                        if valuel.x == xt and valuel.y == yt then
                            SavedValues.newSpacePieceName = valuel.pieceName
                            SavedValues.newSpaceInit = valuel.init
                            if value.x == xt and value.y == yt then
                                selectedpiece = ""
                                break
                            end
                            if valuel.color == playersturn then
                                selectedpiece = ""
                                break
                            end
                            valuel.x = value.x
                            valuel.y = value.y
                            value.x = xt
                            value.y = yt
                            Moves[#Moves+1] = SavedValues
                            print("move Saved as "..#Moves)
                            if valuel.pieceName ~= "none" then
                                valuel.pieceName = "none"
                                valuel.init = 0
                                if speaker then
                                    speaker.playSound("entity.generic.explode",.5)
                                end
                            end

                            selectedpiece = ""
                            if playersturn == "W" then
                                playersturn = "B"
                                print("Black's Turn")
                                break
                            elseif playersturn == "B" then
                                playersturn = "W"
                                print("White's Turn")
                                break
                            end
                        end
                    end
                    break
                end
            end
        end
    end
end    
function c()
    local bools = true
    while true do
        if redstone.getInput("right") and bools then
            print("rewinding turn "..#Moves)
            for index, value in pairs(pieceLayout) do
                if value.x == Moves[#Moves].newSpaceX and value.y == Moves[#Moves].newSpaceY then
                    for indexl, valuel in pairs(pieceLayout) do
                        if valuel.x == Moves[#Moves].originalSpaceX and valuel.y == Moves[#Moves].originalSpaceY then
                            value.x = valuel.x
                            value.y = valuel.y
                            valuel.x = Moves[#Moves].newSpaceX
                            valuel.y = Moves[#Moves].newSpaceY
                            valuel.pieceName = Moves[#Moves].newSpacePieceName
                            valuel.init = Moves[#Moves].newSpaceInit
                            table.remove(Moves,#Moves)
                            if playersturn == "W" then
                                playersturn = "B"
                            elseif playersturn == "B" then
                                playersturn = "W"
                            end
                            print("Rewound")
                            break
                        end
                    end
                    break
                end
            end
            bools = false
            
        elseif redstone.getInput("right") == false and bools == false then
            bools = true
        else

        end
        sleep(.1)
    end
end
parallel.waitForAll(a,b,c)

