--Created by MacFireFly2600 5/Nov./2019

local tArgs = { ... }
local lstSides = {"left","right","top","bottom","front","back"}
if #tArgs == 0 then
	print("Usage: ifconfig Up <side/all>")
	print("Usage: ifconfig Down <side/all>")
	print("Usage: ifconfig List")
	print("Usage: ifconfig Send <TargetID> <protocol> <message>")
	print("Usage: ifconfig Broadcast <protocol> <message>")
    return
end
function DetectModem()
local Counter1 = 0
    for i, side in pairs(lstSides) do
      if (peripheral.isPresent(side)) then
       if (peripheral.getType(side) == string.lower("modem")) then
	   Counter1 = Counter1 + 1
           print("("..Counter1..") "..tostring(rednet.isOpen(side))..": "..string.upper(side))
        end
      end
    end
  end --end function
function openModem(xside)
xside = string.lower(xside)
bool = false
for i, side in pairs(lstSides) do
      if (peripheral.isPresent(side)) then
       if (peripheral.getType(side) == string.lower("modem")) then
          if side == xside then
		  if not rednet.isOpen(side) then
		  rednet.open(side)
		  print("Modem opened on side: "..side)
		  else
		  print("Modem was already opened")
		  end
		  bool = true
		  end
		  
        end
      end
    end
	if bool == false then
	print("Could not locate modem on side: "..xside)
	end
end--end function

function OpenAll()
for i, side in pairs(lstSides) do
    if (peripheral.isPresent(side)) then
       if (peripheral.getType(side) == string.lower("modem")) then
			if not rednet.isOpen(side) then
			print("Opened modem: "..side)
			rednet.open(side)
			else
			print("Modem: '"..side.."' was already opened")
			end
			
	   end
	end
end
	   
end--end function
function CloseAll()
for i, side in pairs(lstSides) do
    if (peripheral.isPresent(side)) then
       if (peripheral.getType(side) == string.lower("modem")) then
			if rednet.isOpen(side) then
			rednet.close(side)
			print("Closed modem: "..side)
			else
			print("Modem: '"..side.."' was already closed")
			end
	   end
	end
end
end--end function

function closeModem(xside)
xside = string.lower(xside)
bool = false
for i, side in pairs(lstSides) do
      if (peripheral.isPresent(side)) then
       if (peripheral.getType(side) == string.lower("modem")) then
          if side == xside then
		  if rednet.isOpen(side) then
		  rednet.close(side)
		  print("Modem closed on side: "..side)
		  else
		  print("Modem was already closed")
		  end
		  bool = true
		  end
		  
        end
      end
    end
	if bool == false then
	print("Could not locate modem on side: "..xside)
	end
end--end function
function CheckSides()
for i, side in pairs(lstSides) do
      if (peripheral.isPresent(side)) then
       if (peripheral.getType(side) == string.lower("modem")) then
       return true
	   end
      end
    end
	return false
end --end function

function CheckOpen()
returnval = false
for i, side in pairs(lstSides) do
      if (peripheral.isPresent(side)) then
       if (peripheral.getType(side) == string.lower("modem")) then
			if (rednet.isOpen(side)) then
			returnval = true
			end
	   end
      end
    end
	return returnval
end--end function

function SendUDPPacket(MyID, Protocol, Message1)
	if CheckSides() == true then
		if CheckOpen() == true then
		rednet.send(tonumber(MyID),Message1, Protocol)
		end
	end
end--end function
function BroadcastUDPPacket(Protocol, Message)
if CheckSides() == true then
		if CheckOpen() == true then
		rednet.broadcast(Message, Protocol)
		end
	end
end--end function



if tArgs[1] == string.lower("list") then
DetectModem()
elseif tArgs[1] == string.lower("up") then
if #tArgs == 2 then
if (tArgs[2] == string.lower("all")) then
OpenAll()
else
openModem(tArgs[2])
end

else
print("Usage: ifconfig up <side/all>")
end

elseif tArgs[1] == string.lower("down") then
if #tArgs == 2 then
if (tArgs[2] == string.lower("all")) then
CloseAll()
else
closeModem(tArgs[2])
end

else
print("Usage: ifconfig down <side/all>")
end

elseif tArgs[1] == string.lower("send") then
r1 = ""
for i = 4,#tArgs do
	r1 = r1..(tArgs[i]).." "
end
SendUDPPacket(tArgs[2], tArgs[3], r1)

elseif tArgs[1] == string.lower("broadcast") then
r1 = ""
for i = 3,#tArgs do
	r1 = r1..(tArgs[i]).." "
end
BroadcastUDPPacket(tArgs[2], r1)

end