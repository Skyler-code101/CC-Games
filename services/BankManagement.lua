
local myURL = "wss://stargate-payment-server-839ace3f26f9.herokuapp.com"
peripheral.find("modem", rednet.open)

local highscoreServer = rednet.lookup("highscore","highscoreService")
local completion = require "cc.completion"

local ChatClient = require("ChatClient")
function messageRecive()
    while true do
    local id, message = rednet.receive("PaymentServer")
    local datar = {}
    if message.coms == 3210 then
        datar = message.message or nil
    local dataw = {}
    if datar ~= nil then
        if datar.status == "create" then
            dataw.playername = datar.playername
            dataw.pin = datar.pin
            repeat  
                dataw.fulllink = math.random(10000000,99999999)
            until not fs.exists("Accounts/"..dataw.fulllink)
            dataw.bal = 10

            local accountr = fs.open("Accounts/"..dataw.fulllink,"w")
            accountr.write(textutils.serialise(dataw))
            accountr.close()
            local l = {}
            l.status = "Created"
            l.handler = datar.computer
            l.fulllink = dataw.fulllink
            rednet.send(id,l,"PaymentServer")
            rednet.send(highscoreServer,{category = "chips", player = datar.playername, score = 10}, "highscore")
            ChatClient.sendMessageToPlayer(datar.playername, 1,{senderName = "&5Star &bArcade&r",message = "Your Account Has Been Created"})
        elseif datar.status == "charge"  then
            local datae = {}
            local accountr = fs.open("Accounts/"..datar.id,"r")
            local accountfile = textutils.unserialise(accountr.readAll())
            accountr.close()
            local l = {}
            if accountfile.pin == datar.pin or datar.pin == nil then
                if accountfile.bal >= datar.charge and datar.charge >= 0 then
                    accountfile.bal = accountfile.bal - datar.charge
                    local accountw = fs.open("Accounts/"..datar.id,"w")
                    accountw.write(textutils.serialise(accountfile))
                    accountw.close()
                    l.status = "ReplyAuth"
                    l.handler = datar.computer
                    l.ReplyMessage = "Accepted Payment"
                    rednet.send(id,l,"PaymentServer")
                    rednet.send(highscoreServer,{category = "chips", player = accountfile.playername, score = accountfile.bal}, "highscore")
                    ChatClient.sendMessageToPlayer(accountfile.playername, 1,{senderName = "&5Star &bArcade&r",message = "You Have Been Charged &2"..tostring(datar.charge).."&r Chips"})
                else
                    l.status = "ReplyAuth"
                    l.handler = datar.computer
                    l.ReplyMessage = "Insufficient Funds"
                    rednet.send(id,l,"PaymentServer")
                end
                
            else 
                l.status = "ReplyAuth"
                l.handler = datar.computer
                l.ReplyMessage = "Invalid Pin"
                rednet.send(id,l,"PaymentServer")
            end
        elseif datar.status == "sell" then
            local datae = {}
            local sellerAccount = fs.open("Accounts/"..datar.id,"r")
            local datasa = textutils.unserialise(sellerAccount.readAll())
            sellerAccount.close()
            local l = {}
                if datar.charge >= 0 then
                        l.status = "ReplyAuth"
                        l.handler = datar.computer
                        l.ReplyMessage = "Accepted Payment"
                        local array = {}
                        local returnAmt  = datar.charge
                        array.playername = datasa.playername 
                        array.fulllink = datasa.fulllink
                        array.pin = datasa.pin
                        array.bal = datasa.bal+returnAmt
                        rednet.send(id,l,"PaymentServer")
                        rednet.send(highscoreServer,{category = "chips", player = array.playername, score = array.bal}, "highscore")
                        local accountw = fs.open("Accounts/"..datar.id,"w")
                        accountw.write(textutils.serialise(array))
                        accountw.close()
                        ChatClient.sendMessageToPlayer(datasa.playername, 1,{senderName = "&5Star &bArcade&r",message = "You Have Given &2"..tostring(datar.charge).."&r Chips"})

                    
                else
                    l.status = "ReplyAuth"
                    l.handler = datar.computer
                    l.ReplyMessage = "InvalidAmt"
                    rednet.send(id,l,"PaymentServer")
                end
        elseif datar.status== "lookup" then
            local accountr = fs.open("Accounts/"..datar.id,"r")
            local data = textutils.unserialise(accountr.readAll()) or nil
            if data == nil then
                local l = {}
                l.status = "NonExistent"
                l.handler = datar.computer
                rednet.send(id,l,"PaymentServer")
            else
                local datam = {}
                datam.status = "Reply"
                datam.handler = datar.computer
                datam.playername = data.playername
                datam.balance = data.bal
                rednet.send(id,datam,"PaymentServer")
            end
        end
    end
end
    end
    
end

parallel.waitForAll(messageRecive)
