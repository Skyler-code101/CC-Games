peripheral.find("modem",rednet.open)

rednet.host("RecordService","RecordService")

function listen()
    while true do
        local id, message = rednet.receive("RecordService")
        local RecordID = 0
        if message.method == "Input" then
            if message.game == "Chess" then
            repeat
                RecordID = math.random(1000000,9999999)
            until not fs.exists(fs.combine("Chess",tostring(RecordID)))
            local file = fs.open(fs.combine("Chess",tostring(RecordID)),"w")
            local fileData = {}
            fileData.record = message.record
            fileData.BetAmount = message.BetAmount
            fileData.AccountIDS = message.AccountIDS
            file.write(textutils.serialise(fileData))
            file.close()
            print("Input Received\nComputer: "..tostring(id).."\n"..tostring(#message.record).." Record Entrys\n\n Registered As Entry: "..tostring(RecordID).."\n")
            local sender = {}
            sender.reply = "Chess"
            sender.success = true
            sender.RecordID = RecordID
            rednet.send(id,sender,"RecordService")
        end
        elseif message.method == "Read" then
            if message.game == "Chess" then
                if fs.exists(fs.combine("Chess",tostring(message.RecordID))) then
                    local file = fs.open(fs.combine("Chess",tostring(message.RecordID)),"r")
                    local fileData = textutils.unserialise(file.readAll())
                    file.close()
                    local sender = {}
                    sender.reply = "Chess"
                    sender.success = true
                    sender.record = fileData
                    rednet.send(id,sender,"RecordService")
                    print("Read Received\nComputer: "..tostring(id).."\nAsked Record: "..tostring(message.RecordID).."\n\n Sent "..tostring(#fileData.record).." Record Entrys\n")
                else
                    local sender = {}
                    sender.reply = "Chess"
                    sender.success = false
                    rednet.send(id,sender,"RecordService")
                end
            end
        end
        
    end
end


parallel.waitForAll(listen)