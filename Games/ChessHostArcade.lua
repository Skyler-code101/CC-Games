local chessAlgorithm = require("chessAlgorithm")

local gamemonitor = peripheral.wrap("monitor_156")
local movemonitor = peripheral.wrap("monitor_162")
local pieceLayout = {}
if not fs.exists("pieceLayout") then
    print("No Board File Found")
else 
    local file = fs.open("pieceLayout", "r")
    pieceLayout = textutils.unserialise(file.readAll())
    file.close()
end
local speaker = peripheral.find("speaker")
local redstoneIntegrator = peripheral.find("redstoneIntegrator")
local printer = peripheral.find("printer")
local WDiskraw = peripheral.wrap("drive_39")
local BDiskraw = peripheral.wrap("drive_40")
peripheral.find("modem",rednet.open)
local playersturn = "W"
local selectedpiece = ""
local selectedpieceobj = nil
local takeablepieces = {}
local pieceValidMoves ={}
local GameStarted = false
local Config = {}
Config.Shield = true
Config.Sound = true
Config.Timer = false
Config.TimerTime = 60

local AccountIDS = {}

local Record = {}

function a()
    --display
    while true do
        if GameStarted == true then
            gamemonitor.setBackgroundColor(colors.blue)
        gamemonitor.clear()
        gamemonitor.setTextScale(5)
        gamemonitor.setCursorPos(1,1)
        for index, value in pairs(pieceLayout) do
            gamemonitor.setCursorPos(value.x,value.y)
            local c,pi = chessAlgorithm.Identify(value)
            if selectedpiece == index then
                gamemonitor.setTextColor(colors.purple)
            elseif takeablepieces[index] then
                gamemonitor.setTextColor(colors.blue)
            elseif pieceValidMoves[index] then
                gamemonitor.setTextColor(colors.orange)
            else
                gamemonitor.setTextColor(c)
            end
            gamemonitor.write(pi)
        end
        
        else
            gamemonitor.clear()
            gamemonitor.setTextScale(2)
            gamemonitor.setCursorPos(3,8)
            gamemonitor.setTextColor(colors.red)
            gamemonitor.setBackgroundColor(colors.black)
            gamemonitor.write("Waiting To Start")

        end
        
        sleep(.1)
    end
end
local line = 1
function printOnPrinter(data)
    printer.setCursorPos(1, line)
    printer.write(data)
    line = line+1
    local w,h = printer.getPageSize()
    if h == line then
        printer.endPage()
        line = 1
        printer.newPage()
    end
end

local Moves = {}

movemonitor.setCursorPos(1,1)
movemonitor.setTextColor(colors.green)
movemonitor.write("Moves")
local mline = 1
function printMove(piece,color,ix,iy,nx,ny)
    if mline == 1 then
        movemonitor.setCursorPos(1,1)
        movemonitor.setTextColor(colors.green)
        movemonitor.write("Moves")
        mline = 2
    end
    movemonitor.setCursorPos(1,mline)
    if color == "W" then
        movemonitor.setTextColor(colors.white)
    elseif color == "B" then
        movemonitor.setTextColor(colors.gray)
    end
    movemonitor.write(#Moves..": "..piece.." ("..color..") "..chessAlgorithm.trueLocation(ix,iy)..">"..chessAlgorithm.trueLocation(nx,ny))
    local w,h = movemonitor.getSize()
    if mline == h then
        movemonitor.setCursorPos(1,1)
        movemonitor.setTextColor(colors.green)
        movemonitor.write("Moves")
        mline = 2
    else
        mline = mline+1
    end
end
function Mmoves()
    while true do
        
        if selectedpieceobj ~= nil then
            if #takeablepieces == 0 and #pieceValidMoves == 0 then
                local Moves = chessAlgorithm.GetMoves(selectedpieceobj,pieceLayout, Moves)
                for keym, valuem in pairs(Moves) do
                    for keyp, valuep in pairs(pieceLayout) do
                        if valuem.x == valuep.x and valuem.y == valuep.y then
                            if valuep.pieceName ~= "none"  then
                                if valuep.color ~= playersturn then
                                    takeablepieces[keyp] = valuem
                                    
                                end
                            else
                                pieceValidMoves[keyp] = valuem
                            end
                        end
                        
                    end
                end
            end
        else
            takeablepieces = {}
            pieceValidMoves = {}
        end
        sleep(.1)
        
    end
end
function b()
    --reciving
    while true do
        repeat
        if GameStarted == true then
            local event, side, x, y = os.pullEvent("monitor_touch") 
        print("Monitor Touched At (" .. x .. ", " .. y .. ")")
        local SavedValues = {}
        SavedValues.originalSpaceX = x
        SavedValues.originalSpaceY = y
        local oldPiece, oldIndex = chessAlgorithm.getPieceAt(x,y, pieceLayout)
        SavedValues.originalPieceName = oldPiece.pieceName
        SavedValues.originalPieceColor = oldPiece.color      
        if oldPiece.color == playersturn and oldPiece.pieceName ~= "none" then
            print("Piece Interacted : "..oldPiece.pieceName..", "..oldPiece.color..", "..oldPiece.init)
            selectedpieceobj = oldPiece
            selectedpiece = oldIndex
            --- Await a touch event
            local eventt, sidet, xt, yt
            repeat
                eventt, sidet, xt, yt = os.pullEvent("monitor_touch")
            until xt <=8 and yt <=8
                print("Monitor Touched At (" .. xt .. ", " .. yt .. ")")
                SavedValues.newSpaceX = xt
                SavedValues.newSpaceY = yt
                local newPiece, newIndex = chessAlgorithm.getPieceAt(xt, yt, pieceLayout)
                SavedValues.newSpacePieceName = newPiece.pieceName
                SavedValues.newSpaceInit = newPiece.init
                local move = pieceValidMoves[newIndex] or takeablepieces[newIndex]
                --Remove invalid moves
                if newPiece == oldPiece then
                    selectedpiece = ""
                    selectedpieceobj = nil
                    break
                end
                if newPiece.color == playersturn then
                    selectedpiece = ""
                    selectedpieceobj = nil
                    break
                end 
                if not move then
                    selectedpiece = ""
                    selectedpieceobj = nil
                    break
                end
                --Get the captured piece position
                local cx,cy
                if move.captures  then
                    cx = move.captures.x
                    cy = move.captures.y
                    SavedValues.captures.y = move.captures.y
                    SavedValues.captures.x = move.captures.x

                else
                    cx = xt
                    cy = yt
                end

                local cPiece = chessAlgorithm.getPieceAt(cx,cy,pieceLayout)
                --Swap piece positions
                newPiece.x = oldPiece.x
                newPiece.y = oldPiece.y
                oldPiece.x = xt
                oldPiece.y = yt
                Moves[#Moves+1] = SavedValues
                print("move Saved as "..#Moves)
                if cPiece.pieceName ~= "none" then
                    cPiece.pieceName = "none"
                    cPiece.init = 0
                    cPiece.color = nil
                    if speaker and Config.Sound == true then
                        speaker.playSound("entity.generic.explode",.5)
                    end
                end
                local queenPiece = chessAlgorithm.PawnReachedOtherSide(oldPiece,pieceLayout)
                if queenPiece ~= nil then
                    oldPiece = queenPiece
                    print("Pawn Premoted")
                    if speaker and Config.Sound == true then
                        speaker.playSound("entity.player.levelup",1)
                    end
                end
                selectedpiece = ""
                selectedpieceobj = nil
                pieceValidMoves = {}
                takeablepieces = {}
                
                printMove(oldPiece.pieceName,oldPiece.color,SavedValues.originalSpaceX,SavedValues.originalSpaceY,SavedValues.newSpaceX,SavedValues.newSpaceY)
                if playersturn == "W" then
                    playersturn = "B"
                    print("Black's Turn")
                    break
                elseif playersturn == "B" then
                    playersturn = "W"
                    print("White's Turn")
                    break
                end
            elseif oldPiece.color ~= playersturn and oldPiece.pieceName == "king" then
                if oldPiece.x == x and oldPiece.y == y then
                    print("CheckMate")
                    local filesend = {}
                    filesend.method = "Input"
                    filesend.game = "Chess"
                    filesend.record = Moves
                    if BetB then
                        filesend.BetAmount = {}
                        filesend.BetAmount.B = BetB
                        filesend.BetAmount.W = BetW
                        filesend.BetAmount.Total = BetW + BetB
                        filesend.AccountIDS = AccountIDS
                    end
                    printOnPrinter("Checkmate "..playersturn.." Wins")
                    rednet.send(rednet.lookup("RecordService","RecordService"),filesend,"RecordService")
                    local id, message
                    repeat
                        id, message = rednet.receive("RecordService")
                    until message.reply == "Chess" and message.success == true
                    printOnPrinter("Record ID = "..message.RecordID)
                    if BetB then
                        printOnPrinter("Chips To Winner = "..BetB + BetW.."C")
                    end
                    
                    Moves = {}
                    printer.endPage()
                    local file = fs.open("pieceLayout", "r")
                    pieceLayout = textutils.unserialise(file.readAll())
                    file.close()
                    sleep(1)
                    GameStarted = false
                    playersturn = "W"
                end
            end
        end
        sleep(.1)
            
    until 1==1
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
                            if BetB then
                                printOnPrinter("Rewound Move #"..#Moves)
                            end
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
        sleep(.5)
    end
end
function d()
    --shield
    while true do
        if GameStarted == true and Config.Shield == true then
            redstoneIntegrator.setOutput("front",true)
        else
            redstoneIntegrator.setOutput("front",false)
        end
        sleep(.1)
    end
end

function e()
    while true do
        if GameStarted == false then
            term.clear()
            movemonitor.clear()
        term.setCursorPos(1,1)
        print("Game Menu:\n  1 = Start Game Beting\n  2 = Start Game For Fun\n  3 = Config")
        local promt = read()
        if promt == "1" then
            term.clear()
            term.setCursorPos(1,1)
            local WDisk = WDiskraw.getMountPath()
            local BDisk = BDiskraw.getMountPath()
            print("Bet Value:\n  Black")
            BetB = tonumber(read())
            print("  White")
            BetW = tonumber(read())
            print("Pulling Bets")
            
            local file = fs.open(fs.combine(BDisk,"Ecard/Data"),"r")
            local dataB = textutils.unserialise(file.readAll())
            file.close()
            local file = fs.open(fs.combine(WDisk,"Ecard/Data"),"r")
            local dataW = textutils.unserialise(file.readAll())
            file.close()
            local sender = {}
            sender.coms = 3210
            local sendmsg = {}
            sendmsg.status = "charge"
            AccountIDS.White = dataW.fulllink
            sendmsg.id = dataW.fulllink
            sendmsg.charge = BetW
            sender.message = sendmsg
            rednet.send(575,sender,"PaymentServer")
            local id, message = rednet.receive("PaymentServer")
            if message.status =="ReplyAuth" and message.ReplyMessage == "Insufficient Funds" then
                print("Insufficient Chips, White")
                sleep(1)
            elseif message.status =="ReplyAuth" and message.ReplyMessage == "Accepted Payment" then
                print("White's Bet Recived")

                local sender = {}
                sender.coms = 3210
                local sendmsg = {}
                sendmsg.status = "charge"
                AccountIDS.Black = dataB.fulllink
                sendmsg.id = dataB.fulllink
                sendmsg.charge = BetB
                sender.message = sendmsg
                rednet.send(575,sender,"PaymentServer")
                local id, message = rednet.receive("PaymentServer")
                if message.status =="ReplyAuth" and message.ReplyMessage == "Insufficient Funds" then
                    print("Insufficient Chips, Black")
                    local sender = {}
                    sender.coms = 3210
                    local sendmsg = {}
                    sendmsg.status = "charge"
                    sendmsg.id = dataW.fulllink
                    sendmsg.charge = BetW
                    sender.message = sendmsg
                    rednet.send(575,sender,"PaymentServer")
                    local id, message = rednet.receive("PaymentServer")
                    if message.status =="ReplyAuth" and message.ReplyMessage == "Accepted Payment" then
                        print("Your Chips Have Been Returned White, Black's Chips Had No change")
                    else
                        print("ERROR With Returning White's Chips Go To Front Desk And Inform Them Of The Problem")
                    end
                    sleep(1)
                elseif message.status =="ReplyAuth" and message.ReplyMessage == "Accepted Payment" then
                    print("Black's Bet Recived")
                    
                print("Game Ready Press Any Button To start")
                os.pullEvent("key")
                print("Game Starting")
                printer.newPage()
                line = 1
                printer.setCursorPos(1,1)
                printOnPrinter("Bets: W:"..BetW.." B:"..BetB)
                GameStarted = true
                print("Game Running")
            end 
        else
            print("this should not happen")
            sleep(2)
        end
        elseif promt == "2" then
            term.clear()
            term.setCursorPos(1,1)
            print("Game Ready Press Any Button To start")
            os.pullEvent("key")
            printer.newPage()
            printer.setCursorPos(1,1)
            line = 1
            printOnPrinter("No Bets")
            print("Game Starting")
            GameStarted = true
            print("Game Running")
    
        elseif promt == "3" then
            term.clear()
            term.setCursorPos(1,1)
            print("Config: \n  1 = Shield: "..tostring(Config.Shield).."\n  2 = Sound: "..tostring(Config.Sound).."\n  3 = Timer: "..tostring(Config.Timer).."("..Config.TimerTime..")")
            local promt2 = read()
            if promt2 == "1" then
                term.clear()
                term.setCursorPos(1,1)
                print("Shield:\n (true/false)")
                local promt3 = read()
                if promt3 == "true" then
                    Config.Shield = true
                    print("Config Changed")
                    sleep(.5)
                elseif promt3 == "false" then
                    Config.Shield = false
                    print("Config Changed")
                    sleep(.5)
                end
            elseif promt2 == "2" then
                term.clear()
                term.setCursorPos(1,1)
                print("Sound:\n (true/false)")
                local promt3 = read()
                if promt3 == "true" then
                    Config.Sound = true
                    print("Config Changed")
                    sleep(.5)
                elseif promt3 == "false" then
                    Config.Sound = false
                    print("Config Changed")
                    sleep(.5)
                end
            elseif promt2 == "3" then
                    term.clear()
                    term.setCursorPos(1,1)
                    print("Timer:\n (true/false)")
                    local promt3 = read()
                    if promt3 == "true" then
                        Config.Timer = true
                        print("Time:\n (In Seconds)")
                        Config.TimerTime = tonumber(read())
                        print("Config Changed")
                        sleep(.5)
                    elseif promt3 == "false" then
                        Config.Timer = false
                        print("Config Changed")
                        sleep(.5)
                    end
                end
            end
        end
        sleep(.1)
    end
end
function f()
    while true do
        local timer = Config.TimerTime
        if Config.Timer == true then
            if playersturn == "W" then
                while true do
                    if timer ~= 0 then
                        if playersturn == "W" then
                        
                            sleep(1)
                            timer = timer-1 
                        else
                            break
                        end
                    else
                        if playersturn == "W" then
                            playersturn = "B"
                            break
                        elseif playersturn == "B" then
                            playersturn = "W"
                            break
                        end
                    end
                    
                end
            elseif playersturn == "B" then
                while true do
                    if timer ~= 0 then
                        if playersturn == "B" then
                        
                            sleep(1)
                            timer = timer-1 
                        else
                            break
                        end
                    else
                        if playersturn == "W" then
                            playersturn = "B"
                            break
                        elseif playersturn == "B" then
                            playersturn = "W"
                            break
                        end
                    end
                    
                end
            end
        end
        
    end
end

function terminateinfo()
    while true do
        local event, key, is_held = os.pullEvent("key")
        if key == keys.f4 and GameStarted == true then
            print("Ending Round As Draw")
            printOnPrinter("Draw")
            local filesend = {}
            filesend.method = "Input"
            filesend.game = "Chess"
            filesend.record = Moves
            if BetB then
                filesend.BetAmount = {}
                filesend.BetAmount.B = BetB
                filesend.BetAmount.W = BetW
                filesend.BetAmount.Total = BetW + BetB
                filesend.AccountIDS = AccountIDS
            end
            rednet.send(rednet.lookup("RecordService","RecordService"),filesend,"RecordService")
            local id, message
            repeat
                id, message = rednet.receive("RecordService")
            until message.reply == "Chess" and message.success == true
            printOnPrinter("Record ID = "..message.RecordID)
            if BetB then
                printOnPrinter("Chips To Black = "..BetB.."C")
                printOnPrinter("Chips To White = "..BetW.."C")
            end
            
            Moves = {}
            printer.endPage()
            local file = fs.open("pieceLayout", "r")
            pieceLayout = textutils.unserialise(file.readAll())
            file.close()
            sleep(1)
            GameStarted = false
            playersturn = "W"
        end
    end
end
parallel.waitForAll(a,b,c,d,e,Mmoves,terminateinfo)

