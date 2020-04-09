local PacketLog = {}
local MainProtocol = "FireFlyISP"

local lstSides = {"left","right","top","bottom","front","back"}
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
end--end function

function Listener()
    while true do
        local id, msg, protocol = rednet.receive()
        if protocol == MainProtocol then
            if string.find(msg, "|") then
                if CheckTable(PacketLog, msg) == false then
                    table.insert(PacketLog, msg)
                    rednet.broadcast(msg, MainProtocol)
                end
            end
        end
    end
end--end function

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
end

OpenAll()
Listener()