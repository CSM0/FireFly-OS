local lstSides = {"left","right","top","bottom","front","back"}
local DHCP = {}
local PacketLog = {}
local RouterPassword = "pass1"
local exitting = false
function OpenAll()
    for i, side in pairs(lstSides) do
        if (peripheral.isPresent(side)) then
           if (peripheral.getType(side) == string.lower("modem")) then
                if not rednet.isOpen(side) then
                    rednet.open(side)
                else
                end
           end
        end
    end
end
function AutoOpener()
    while exitting == false do
        OpenAll()
        os.sleep(3)
    end--end while
end--end function
function MainListener()
    while exitting == false do
        local id, msg, protocol = rednet.receive()
        if protocol == "FireFlyISP" then
            if string.find(msg, "|") then
                if CheckTable(PacketLog, msg)==false then
                    if sep == nil then
                        sep = "|"
                    end--end if sep is null
                    sep = tostring(sep)
                    local Args={} ; i=1
                    for str in string.gmatch(msg, "([^"..sep.."]+)") do
                        Args[i] = str
                        i = i + 1
                    end--end for
                    MyPacketID = Args[1]
                    Payload = decode(Args[2])
                    Args={} ; i=1
                    for str in string.gmatch(Payload, "([^"..sep.."]+)") do
                        Args[i] = str
                        i = i + 1
                    end--end for
                    MyToID = Args[1]
                    MyFromID = Args[2]
                    MyProtocol = Args[3]
                    MyData = Args[4]
                    if CheckTable(DHCP, MyToID) then
                        rednet.send(tonumber(MyToID), Payload)
                    else
                    end
                    table.insert(PacketLog, msg)
                end
            end
            
        else
            if string.lower(msg) == "exit" then
                print("Exiting router")
                exitting = true
            else
                if string.find(msg, "|") then
                    --|Send|RHost|LHost|Data|
                    if sep == nil then
                        sep = "|"
                    end--end if sep is null
                    sep = tostring(sep)
                    local Args={} ; i=1
                    for str in string.gmatch(msg, "([^"..sep.."]+)") do
                        Args[i] = str
                        i = i + 1
                    end--end for
                    if string.lower(Args[1])=="ping" then
                        rednet.send(id, "|PONG|"..os.getComputerID().."|", protocol)
                    elseif string.lower(Args[1])=="join" then
                        if (#Args == 2) then
                            code1 = Args[2]
                            code1 = code1:gsub('{PIPE}','|')
                            if code1 == RouterPassword then
                                if CheckTable(DHCP, id) == false then
                                    table.insert(DHCP, id)
                                    print(id.." Joined the network")
                                else
                                    print("Failed Validation, Already joined: "..id)
                                end
                                rednet.send(id, "200",protocol)
                            else
                                rednet.send(id, "403",protocol)
                            end

                        end
                    elseif string.lower(Args[1])=="leave" then
                        if CheckTable(DHCP, id)  then
                            --table.remove(DHCP, id)
                            RemoveFromTable(DHCP, id)
                            print(id.." Left the network")
                        else
                            print("Failed Validation already removed: "..id)                        
                        end
                        rednet.send(id, "200",protocol)
                    elseif string.lower(Args[1])=="send" then
                        --|ToID|FromID|protocol|Packet|
                        --|Send|ToID|Prot|Pack|
                        if CheckTable(DHCP, id) then
                            if(#Args==4) then
                                Payload = "|"..Args[2].."|"..id.."|"..Args[3].."|"..Args[4].."|"
                                if CheckTable(DHCP, Args[2]) then
                                    rednet.send(tonumber(Args[2]), Payload)
                                    rednet.send(id, "200",protocol)
                                else
                                    Payload = "|"..getStr(15).."|"..encode(Payload).."|"--|PacketID|Packet|
                                    rednet.broadcast(Payload,"FireFlyISP")
                                    table.insert(PacketLog, Payload)
                                    rednet.send(id, "200",protocol)
                                end
                               
                            end
                        else
                            rednet.send(id, "403",protocol)
                        end
                    end--end if arg0 equals
                end--end of if contains pipe
            end--end if not exit
        end--end if protocol fireflyisp
    end--end while
end--end function

function getStr(lenght)
    str = ""
    for i=1, lenght do str = str..string.char(math.random(1, 255)) end
    if string.find(str, "|") then
        str = str:gsub('|','f')
    end
    return str
  end
local b = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
 

function CheckTable(Table1, CompareData)
    var1 = false
    if #Table1 > 0 then
        for i=1, #Table1 do
            if Table1[i] ~= nil then
                if Table1[i].."" == ""..CompareData then
                    return true
                end
            end
            i=i + 1
        end
    end
    return var1
end--end function

function RemoveFromTable(Table1, RemoveData)
    NewTable = {}
    if #Table1 > 0 then
        for i=1, #Table1 do
            if Table1[i] ~= nil then
                if Table1[i].."" == ""..RemoveData then
                    table.remove(Table1, i)
                end
            end
            i=i + 1
        end
    end
end--end function
-- Encoding
function encode(data)
    return ((data:gsub('.', function(x)
        local r,b='',x:byte()
        for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
        return r;
    end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
        if (#x < 6) then return '' end
        local c=0
        for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
        return b:sub(c+1,c+1)
    end)..({ '', '==', '=' })[#data%3+1])
end
 
-- Decoding
function decode(data)
    data = string.gsub(data, '[^'..b..'=]', '')
    return (data:gsub('.', function(x)
        if (x == '=') then return '' end
        local r,f='',(b:find(x)-1)
        for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
        return r;
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if (#x ~= 8) then return '' end
        local c=0
        for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
        return string.char(c)
    end))
end

parallel.waitForAny(AutoOpener, MainListener)

