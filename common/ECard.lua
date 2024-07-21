local ECardFile = fs.open("ECard/Data","r")
local data = textutils.unserialise(ECardFile.readAll())

while true do    
    term.setCursorPos(1,1)
    term.clear()
    print("Hello "..data.playername.." I Am Your ECard\n  Your Account # is "..data.fulllink)
    sleep(1)
end
