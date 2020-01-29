--Created by MacFireFly2600 14/Nov./2019 -9:45 PM (AEST)
local IsOnlineDatabase = false
local OnlineServerID = 0
local OnlineProtocolRequired = true
local OnlineServerProtocol = ""
local OfflineDatabaseFilePath = ""
local SystemPassword = "12345"
local OfflineDatabase = {}
local PrivateKeyCode = "{H31l_H1tl3r}"
counter1 = 0
x3,y3 = 1

function bootstrap()
term.clear()
LoadAPIs()
LoadSettings()
DecryptSystem()
MainThread()
end--end function
function MainThread()

end--end function
function KW(message)
if term.isColour() then
term.setTextColor(colours.white)
write("[")
term.setTextColor(colours.lime)
write("OK")
term.setTextColor(colours.white)
write("]")
print("		"..message)
else
print("[OK]		"..message)
end--end if
end--end function


function LoadAPIs()
if fs.exists("aes") then
os.loadAPI("aes")
KW("AES loaded")
os.sleep(1)
end
end--end function
function LoadSettings()
	if fs.exists("Login.settings") then
		--Login.settings
		local tFile = io.open("Login.settings","r")
		if tFile then
			for line in tFile:lines() do
			--checks if the current line in the file starts with a '#' usually used for commenting
				if not (string.sub(line,1,1) == "#") then
					if string.find(line, "=" ) then
						local results = {}
						for match in string.gmatch(line, "[^=]+") do
							table.insert(results, match)
						end
						if #results == 2 then
							local command = string.lower(results[1])
							local ResultX = string.lower(results[2])
							if(command=="systempassword") then
								SystemPassword = ResultX
							elseif (command=="isonlinedatabase") then
								if ResultX=="true" then
									OfflineDatabase = true
								else
									OfflineDatabase = true
								end
							elseif (command=="onlineprotocolrequired") then
								if ResultX=="true" then
									OnlineProtocolRequired = true
								else
									OnlineProtocolRequired = true
								end
							elseif (command=="onlineserverid") then
								OnlineServerID = ResultX
							elseif (command=="onlineserverprotocol") then
								OnlineServerProtocol = ResultX
							elseif (command=="offlinedatabasefilepath") then
								OfflineDatabaseFilePath = ResultX
							end--if command
						end
					end
				end--end if is not a comment (does not Startwith #)
			end--end for
		end
		io.close()
	end--end if
	KW("Settings loaded")
	os.sleep(1)
end--end function
function DecryptSystem()
Clear()
print("Decrypting system...")
term.setCursorPos(1,3)
OpenFolder("/")
end--end function

function OpenFolder(Folder1)
local t = fs.list(Folder1) 
	if #t > 0 then
		for k, v in pairs(t) do	
			local sFullName = fs.combine(Folder1, v)
			if not (fs.isReadOnly(v)) then
				if fs.isDir(v) then
					OpenFolder(Folder1.."/"..v)
				else
					if (string.lower(v)=="loginprogram.lua") then
					elseif (string.lower(v)==string.lower(shell.getRunningProgram())) then
					elseif (string.lower(v)=="bios.lua") then
					elseif (string.lower(v)=="login.settings") then
					elseif (string.lower(v)=="startup.lua") then
					elseif (string.lower(v)=="teste.lua") then
					elseif (string.lower(v)=="aes") then
					else
						local f1 = fs.open(sFullName, "r")
						local data = f1.readAll()
						f1.close()
							returnstring= " "
						local ok, err = pcall(
							function()
								returnstring = aes.decrypt(data, SystemPassword)--SystemPassword
							end
						)
						if string.find(returnstring, PrivateKeyCode) then
							counter1 = counter1 + 1
							x4,y4 = term.getCursorPos()
							KW("\""..sFullName.."\" fn{DECRYPTION) SUCESSFUL!")
							returnstring = returnstring:gsub(PrivateKeyCode,"")
							f1 = fs.open(sFullName, "w")
							f1.write(returnstring)
							f1.flush()
							f1.close()
						end
						x3,y3 = term.getCursorPos()
						term.setCursorPos(1,2)
						print("Files decrypted ("..counter1..")")
						term.setCursorPos(x3,y3)
					end--end else
				end--end if file
			end--end if read only
			os.sleep(0.1)
		end--end for
		counter1 = 0
    end--end if
end--end function


--Drawing
function Clear()
term.setCursorPos(1,1)
term.clear()
end--end function

function centerText(text, yval)
local x,y = term.getSize()
local x2,y2 = term.getCursorPos()
term.setCursorPos(math.round((x / 2) - (text:len() / 2)), yval)
write(text)
end--end function

function DrawButtons()
--Decrypt
	centerText("Decrypt Computer", 4)
--Change crypt password
	centerText("Change/Set Password", 8)
	os.sleep(10)
end

Clear()
DrawButtons()
--bootstrap()