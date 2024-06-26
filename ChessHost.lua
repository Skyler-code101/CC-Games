local monitor = peripheral.find("monitor")
local pieceLayout = {}
if fs.exists("pieceLayout") then
    local piece1 = {}
    piece1.pieceName = "rook"
    piece1.init = 1
    piece1.x = 1
    piece1.y = 1
    piece1.color = "B"
    pieceLayout.rook1b = piece1
    local piece2 = {}
    piece2.pieceName = "knight"
    piece2.init = 1
    piece2.x = 2
    piece2.y = 1
    piece2.color = "B"
    pieceLayout.knights1b = piece2
    local piece3 = {}
    piece3.pieceName = "bishop"
    piece3.init = 1
    piece3.x = 3
    piece3.y = 1
    piece3.color = "B"
    pieceLayout.bishops1b = piece3
    local piece4 = {}
    piece4.pieceName = "queen"
    piece4.init = 0
    piece4.x = 4
    piece4.y = 1
    piece4.color = "B"
    pieceLayout.queenb = piece4
    local piece5 = {}
    piece5.pieceName = "king"
    piece5.init = 0
    piece5.x = 5
    piece5.y = 1
    piece5.color = "B"
    pieceLayout.kingb = piece5
    local piece6 = {}
    piece6.pieceName = "bishop"
    piece6.init = 2
    piece6.x = 6
    piece6.y = 1
    piece6.color = "B"
    pieceLayout.bishops2b = piece6    
    local piece7 = {}
    piece7.pieceName = "knight"
    piece7.init = 2
    piece7.x = 7
    piece7.y = 1
    piece7.color = "B"
    pieceLayout.knights2b = piece7    
    local piece8 = {}

    piece8.pieceName = "rook"
    piece8.init = 2
    piece8.x = 8
    piece8.y = 1
    piece8.color = "B"
    pieceLayout.rook2b = piece8    
    local piece9 = {}

    piece9.pieceName = "pawn"
    piece9.init = 1
    piece9.x = 1
    piece9.y = 2
    piece9.color = "B"
    pieceLayout.pawnab = piece9    
    local piece10 = {}

    piece10.pieceName = "pawn"
    piece10.init = 2
    piece10.x = 2
    piece10.y = 2
    piece10.color = "B"
    pieceLayout.pawnbb = piece10    
    local piece11 = {}
    
    piece11.pieceName = "pawn"
    piece11.init = 3
    piece11.x = 3
    piece11.y = 2
    piece11.color = "B"
    pieceLayout.pawncb = piece11    
    local piece12 = {}
    
    piece12.pieceName = "pawn"
    piece12.init = 4
    piece12.x = 4
    piece12.y = 2
    piece12.color = "B"
    pieceLayout.pawndb = piece12    
    local piece13 = {}
    
    piece13.pieceName = "pawn"
    piece13.init = 5
    piece13.x = 5
    piece13.y = 2
    piece13.color = "B"
    pieceLayout.pawneb = piece13    
    local piece14 = {}
    
    piece14.pieceName = "pawn"
    piece14.init = 6
    piece14.x = 6
    piece14.y = 2
    piece14.color = "B"
    pieceLayout.pawnfb = piece14    
    local piece15 = {}
    
    piece15.pieceName = "pawn"
    piece15.init = 7
    piece15.x = 7
    piece15.y = 2
    piece15.color = "B"
    pieceLayout.pawngb = piece15    
    local piece16 = {}
    
    
    piece16.pieceName = "pawn"
    piece16.init = 8
    piece16.x = 8
    piece16.y = 2
    piece16.color = "B"
    pieceLayout.pawnhb = piece16    
    local piece17 = {}

    piece17.pieceName = "rook"
    piece17.init = 1
    piece17.x = 1
    piece17.y = 8
    piece17.color = "W"
    pieceLayout.rookaw = piece17    
    local piece18 = {}

    piece18.pieceName = "knight"
    piece18.init = 1
    piece18.x = 2
    piece18.y = 8
    piece18.color = "W"
    pieceLayout.knightsaw = piece18    
    local piece19 = {}

    piece19.pieceName = "bishop"
    piece19.init = 1
    piece19.x = 3
    piece19.y = 8
    piece19.color = "W"
    pieceLayout.bishopsaw = piece19    
    local piece20 = {}

    piece20.pieceName = "queen"
    piece20.init = 0
    piece20.x = 4
    piece20.y = 8
    piece20.color = "W"
    pieceLayout.queenw = piece20    
    local piece21 = {}
    
    piece21.pieceName = "king"
    piece21.init = 0
    piece21.x = 5
    piece21.y = 8
    piece21.color = "W"
    pieceLayout.kingw = piece21    
    local piece22 = {}

    piece22.pieceName = "bishop"
    piece22.init = 2
    piece22.x = 6
    piece22.y = 8
    piece22.color = "W"
    pieceLayout.bishopsbw = piece22    
    local piece23 = {}

    piece23.pieceName = "knight"
    piece23.init = 2
    piece23.x = 7
    piece23.y = 8
    piece23.color = "W"
    pieceLayout.knightsbw = piece23    
    local piece24 = {}

    piece24.pieceName = "rook"
    piece24.init = 2
    piece24.x = 8
    piece24.y = 8
    piece24.color = "W"
    pieceLayout.rookbw = piece24    
    local piece25 = {}

    piece25.pieceName = "pawn"
    piece25.init = 1
    piece25.x = 1
    piece25.y = 7
    piece25.color = "W"
    pieceLayout.pawnaw = piece25    
    local piece26 = {}

    piece26.pieceName = "pawn"
    piece26.init = 2
    piece26.x = 2
    piece26.y = 7
    piece26.color = "W"
    pieceLayout.pawnbw = piece26    
    local piece27 = {}
    
    piece27.pieceName = "pawn"
    piece27.init = 3
    piece27.x = 3
    piece27.y = 7
    piece27.color = "W"
    pieceLayout.pawncw = piece27    
    local piece28 = {}
    
    piece28.pieceName = "pawn"
    piece28.init = 4
    piece28.x = 4
    piece28.y = 7
    piece28.color = "W"
    pieceLayout.pawndw = piece28    
    local piece29 = {}
    
    piece29.pieceName = "pawn"
    piece29.init = 5
    piece29.x = 5
    piece29.y = 7
    piece29.color = "W"
    pieceLayout.pawnew = piece29    
    local piece30 = {}
    
    piece30.pieceName = "pawn"
    piece30.init = 6
    piece30.x = 6
    piece30.y = 7
    piece30.color = "W"
    pieceLayout.pawnfw = piece30    
    local piece31 = {}
    
    piece31.pieceName = "pawn"
    piece31.init = 7
    piece31.x = 7
    piece31.y = 7
    piece31.color = "W"
    pieceLayout.pawngw = piece31    
    local piece32 = {}
    
    
    piece32.pieceName = "pawn"
    piece32.init = 8
    piece32.x = 8
    piece32.y = 7
    piece32.color = "W"
    pieceLayout.pawnhw = piece32    
    local piece33 = {}

    piece33.pieceName = "none"
    piece33.init = 0
    piece33.x = 1
    piece33.y = 6
    pieceLayout.nonefa = piece33    
    local piece34 = {}
    piece34.pieceName = "none"
    piece34.init = 0
    piece34.x = 2
    piece34.y = 6
    pieceLayout.nonefb = piece34    
    local piece35 = {}
    piece35.pieceName = "none"
    piece35.init = 0
    piece35.x = 3
    piece35.y = 6
    pieceLayout.nonefc = piece35    
    local piece36 = {}
    piece36.pieceName = "none"
    piece36.init = 0
    piece36.x = 4
    piece36.y = 6
    pieceLayout.nonefd = piece36    
    local piece37 = {}
    piece37.pieceName = "none"
    piece37.init = 0
    piece37.x = 5
    piece37.y = 6
    pieceLayout.nonefe = piece37    
    local piece38 = {}
    piece38.pieceName = "none"
    piece38.init = 0
    piece38.x = 6
    piece38.y = 6
    pieceLayout.noneff = piece38    
    local piece39 = {}
    piece39.pieceName = "none"
    piece39.init = 0
    piece39.x = 7
    piece39.y = 6
    pieceLayout.nonefg = piece39    
    local piece40 = {}
    piece40.pieceName = "none"
    piece40.init = 0
    piece40.x = 8
    piece40.y = 6
    pieceLayout.nonefh = piece40    
    local piece41 = {}

    piece41.pieceName = "none"
    piece41.init = 0
    piece41.x = 1
    piece41.y = 5
    pieceLayout.noneea = piece41    
    local piece42 = {}
    piece42.pieceName = "none"
    piece42.init = 0
    piece42.x = 2
    piece42.y = 5
    pieceLayout.noneeb = piece42    
    local piece43 = {}
    piece43.pieceName = "none"
    piece43.init = 0
    piece43.x = 3
    piece43.y = 5
    pieceLayout.noneec = piece43    
    local piece44 = {}
    piece44.pieceName = "none"
    piece44.init = 0
    piece44.x = 4
    piece44.y = 5
    pieceLayout.noneed = piece44    
    local piece45 = {}
    piece45.pieceName = "none"
    piece45.init = 0
    piece45.x = 5
    piece45.y = 5
    pieceLayout.noneee = piece45    
    local piece46 = {}
    piece46.pieceName = "none"
    piece46.init = 0
    piece46.x = 6
    piece46.y = 5
    pieceLayout.noneef = piece46    
    local piece47 = {}
    piece47.pieceName = "none"
    piece47.init = 0
    piece47.x = 7
    piece47.y = 5
    pieceLayout.noneeg = piece47    
    local piece48 = {}
    piece48.pieceName = "none"
    piece48.init = 0
    piece48.x = 8
    piece48.y = 5
    pieceLayout.noneeh = piece48    
    local piece49 = {}

    piece49.pieceName = "none"
    piece49.init = 0
    piece49.x = 1
    piece49.y = 4
    pieceLayout.noneda = piece49    
    local piece50 = {}
    piece50.pieceName = "none"
    piece50.init = 0
    piece50.x = 2
    piece50.y = 4
    pieceLayout.nonedb = piece50    
    local piece51 = {}
    piece51.pieceName = "none"
    piece51.init = 0
    piece51.x = 3
    piece51.y = 4
    pieceLayout.nonedc = piece51    
    local piece52 = {}
    piece52.pieceName = "none"
    piece52.init = 0
    piece52.x = 4
    piece52.y = 4
    pieceLayout.nonedd = piece52    
    local piece53 = {}
    piece53.pieceName = "none"
    piece53.init = 0
    piece53.x = 5
    piece53.y = 4
    pieceLayout.nonede = piece53    
    local piece54 = {}
    piece54.pieceName = "none"
    piece54.init = 0
    piece54.x = 6
    piece54.y = 4
    pieceLayout.nonedf = piece54    
    local piece55 = {}
    piece55.pieceName = "none"
    piece55.init = 0
    piece55.x = 7
    piece55.y = 4
    pieceLayout.nonedg = piece55    
    local piece56 = {}
    piece56.pieceName = "none"
    piece56.init = 0
    piece56.x = 8
    piece56.y = 4
    pieceLayout.nonedh = piece56    
    local piece57 = {}

    piece57.pieceName = "none"
    piece57.init = 0
    piece57.x = 1
    piece57.y = 3
    pieceLayout.noneca = piece57    
    local piece58 = {}
    piece58.pieceName = "none"
    piece58.init = 0
    piece58.x = 2
    piece58.y = 3
    pieceLayout.nonecb = piece58    
    local piece59 = {}
    piece59.pieceName = "none"
    piece59.init = 0
    piece59.x = 3
    piece59.y = 3
    pieceLayout.nonecc = piece59    
    local piece60 = {}
    piece60.pieceName = "none"
    piece60.init = 0
    piece60.x = 4
    piece60.y = 3
    pieceLayout.nonecd = piece60    
    local piece61 = {}
    piece61.pieceName = "none"
    piece61.init = 0
    piece61.x = 5
    piece61.y = 3
    pieceLayout.nonece = piece61    
    local piece62 = {}
    piece62.pieceName = "none"
    piece62.init = 0
    piece62.x = 6
    piece62.y = 3
    pieceLayout.nonecf = piece62    
    local piece63 = {}
    piece63.pieceName = "none"
    piece63.init = 0
    piece63.x = 7
    piece63.y = 3
    pieceLayout.nonecg = piece63    
    local piece64 = {}
    piece64.pieceName = "none"
    piece64.init = 0
    piece64.x = 8
    piece64.y = 3
    pieceLayout.nonech = piece64
    local file = fs.open("pieceLayout", "w")
    file.write(textutils.serialise(pieceLayout))
    file.close()
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
                    print("move 1 found")
                    for indexl, valuel in pairs(pieceLayout) do
                        if valuel.x == Moves[#Moves].originalSpaceX and valuel.y == Moves[#Moves].originalSpaceY then
                            print("move 2 found")
                            value.x = valuel.x
                            value.y = valuel.y
                            valuel.x = Moves[#Moves].newSpaceX
                            valuel.y = Moves[#Moves].newSpaceY
                            valuel.pieceName = Moves[#Moves].newSpacePieceName
                            valuel.init = Moves[#Moves].newSpaceInit
                            table.remove(Moves,#Moves)
                            if playersturn == "W" then
                                playersturn = "B"
                                break
                            elseif playersturn == "B" then
                                playersturn = "W"
                                break
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

