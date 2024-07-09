local chessAlgorithm = require("chessAlgorithm")
local gamemonitor = peripheral.wrap("top")
local SimStarted = false
local pieceLayout = {}
local SimFile = {}
local frame = 0
AccountIDS ={}
Validizeable = false
peripheral.find("modem",rednet.open)

if not fs.exists("pieceLayout") then
    print("No Board File Found")
else 
    local file = fs.open("pieceLayout", "r")
    pieceLayout = textutils.unserialise(file.readAll())
    file.close()
end
function display()
    --display
    while true do
        if SimStarted == true then
            gamemonitor.setBackgroundColor(colors.purple)
        gamemonitor.clear()
        gamemonitor.setTextScale(.5)
        gamemonitor.setCursorPos(1,1)
        for index, value in pairs(pieceLayout) do
            gamemonitor.setCursorPos(value.x,value.y)
            local c,pi = chessAlgorithm.Identify(value)
            gamemonitor.setTextColor(c)
            gamemonitor.write(pi)
        end
        
        gamemonitor.setTextColor(colors.red)
        gamemonitor.setCursorPos(1,10)
        gamemonitor.write(frame)
        if SimFile.BetAmount ~= nil then
            gamemonitor.setTextColor(colors.green)
            gamemonitor.setCursorPos(10,2)
            gamemonitor.write(SimFile.BetAmount.B)
            gamemonitor.setCursorPos(10,7)
            gamemonitor.write(SimFile.BetAmount.W)
        end

        else
            gamemonitor.clear()
            gamemonitor.setTextScale(.5)
            gamemonitor.setCursorPos(1,1)
            gamemonitor.setTextColor(colors.red)
            gamemonitor.setBackgroundColor(colors.black)
            gamemonitor.write("Waiting For Sim")
            gamemonitor.setCursorPos(1,2)
            gamemonitor.write("To Start")

        end
        sleep(.1)
    end
end


function startup()
    while true do
        if SimStarted == false and Validizeable == false then
            term.clear()
            term.setCursorPos(1,1)
            print("Record ID")
            local ID = tonumber(read())
            local sender = {}
            sender.method = "Read"
            sender.game = "Chess"
            sender.RecordID = ID
            rednet.send(rednet.lookup("RecordService","RecordService"),sender,"RecordService")
            local id, message
            repeat
                id, message = rednet.receive("RecordService")
            until message.reply == "Chess" and message.success == true
            SimFile = message.record

            AccountIDS = message.record.AccountIDS
            print("Grabed Record")
            SimStarted = true
            
        elseif Validizeable == true then
            print("Ready To Validize")
            print("Enter Winner")
            print("(B/W/D)")
            local promt
            repeat
                promt = read()
            until promt == "B" or promt == "W" or promt == "D"
            if promt == "B" then
                local sender = {}
                sender.coms = 3210
                local sendmsg = {}
                sendmsg.status = "sell"
                sendmsg.id = AccountIDS.Black
                sendmsg.charge = SimFile.BetAmount.Total
                sender.message = sendmsg
                rednet.send(575,sender,"PaymentServer") 
                local id, message = rednet.receive("PaymentServer")
                if message.status =="ReplyAuth" and message.ReplyMessage == "InvalidAmt" then
                    print("Error InvalidAmt")
                elseif message.status =="ReplyAuth" and message.ReplyMessage == "Accepted Payment" then
                    print("Winner successfully Given Winnings")
                end
                SimStarted = false
                Validizeable = false
            elseif promt == "W" then
                local sender = {}
                sender.coms = 3210
                local sendmsg = {}
                sendmsg.status = "sell"
                sendmsg.id = AccountIDS.White
                sendmsg.charge = SimFile.BetAmount.Total
                sender.message = sendmsg
                rednet.send(575,sender,"PaymentServer") 
                local id, message = rednet.receive("PaymentServer")
                if message.status =="ReplyAuth" and message.ReplyMessage == "InvalidAmt" then
                    print("Error InvalidAmt")
                elseif message.status =="ReplyAuth" and message.ReplyMessage == "Accepted Payment" then
                    print("Winner successfully Given Winnings")
                end
                SimStarted = false
                Validizeable = false
            elseif promt == "D" then
                local sender = {}
                sender.coms = 3210
                local sendmsg = {}
                sendmsg.status = "sell"
                sendmsg.id = AccountIDS.White
                sendmsg.charge = SimFile.BetAmount.W
                sender.message = sendmsg
                rednet.send(575,sender,"PaymentServer") 
                local id, message = rednet.receive("PaymentServer")
                if message.status =="ReplyAuth" and message.ReplyMessage == "InvalidAmt" then
                    print("Error InvalidAmt")
                elseif message.status =="ReplyAuth" and message.ReplyMessage == "Accepted Payment" then
                    print("White successfully Given Draw")
                end
                local sender = {}
                sender.coms = 3210
                local sendmsg = {}
                sendmsg.status = "sell"
                sendmsg.id = AccountIDS.Black
                sendmsg.charge = SimFile.BetAmount.B
                sender.message = sendmsg
                rednet.send(575,sender,"PaymentServer") 
                local id, message = rednet.receive("PaymentServer")
                if message.status =="ReplyAuth" and message.ReplyMessage == "InvalidAmt" then
                    print("Error InvalidAmt")
                elseif message.status =="ReplyAuth" and message.ReplyMessage == "Accepted Payment" then
                    print("Black successfully Given Draw")
                end
                term.clear()
                SimStarted = false
                Validizeable = false
            end
        end
        sleep(.1)
    end
end

function Sim()
    while true do
        if SimStarted == true then
            frame = "0".."/"..#SimFile.record
            print("Sim Ready Click The Screen For Next Frame")
            for key, value in pairs(SimFile.record) do
                os.pullEvent("monitor_touch")
                frame = key.."/"..#SimFile.record
                local oldPiece, oldIndex = chessAlgorithm.getPieceAt(value.originalSpaceX,value.originalSpaceY, pieceLayout)
                local newPiece, newIndex = chessAlgorithm.getPieceAt(value.newSpaceX, value.newSpaceY, pieceLayout)
                
                --Get the captured piece position
                local cx,cy
                if value.captures  then
                    cx = value.captures.x
                    cy = value.captures.y

                else
                    cx = value.newSpaceX
                    cy = value.newSpaceY
                end

                local cPiece = chessAlgorithm.getPieceAt(cx,cy,pieceLayout)
                --Swap piece positions
                newPiece.x = oldPiece.x
                newPiece.y = oldPiece.y
                oldPiece.x = value.newSpaceX
                oldPiece.y = value.newSpaceY
                if cPiece.pieceName ~= "none" then
                    cPiece.pieceName = "none"
                    cPiece.init = 0
                end
                local queenPiece = chessAlgorithm.PawnReachedOtherSide(oldPiece,pieceLayout)
                if queenPiece ~= nil then
                    oldPiece = queenPiece
                end
                if key >= #SimFile.record and Validizeable == false then
                    Validizeable = true
                    SimStarted = false
                end
            end
        end
        sleep(.1)
    end
end

parallel.waitForAll(startup,Sim,display)