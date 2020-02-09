--Created by MacFireFly2600 14/Nov./2019 -9:45 PM (AEST)
--Edited 17/Nov./2019 -4:00 AM (AEST)
local tempEvent = os.pullEvent
os.pullEvent = os.pullEventRaw
local staticBootPath = "FireFly.sys"
local AllowNextBoot = true
tempflipper = true
Pos1 = 1
local debugStatus = false
SystemPassword = ""
TempPassword = ""
local PrivateKeyCode = "H31l_H1tl3r"
counter1 = 0
x3,y3 = 1

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
							local ResultX = (results[2])
							if(command=="systempassword") then
								SystemPassword = ResultX
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
							--print("System Password: "..SystemPassword)
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
DCX,DCY = 1
CPX,CPY = 1
CWDX, CWDY = 1
TermSizeX, TermSizeY = term.getSize()
function DrawButtons()
term.clear()
if (TermSizeX==26) then
	--Pocket Computer
	--Decrypt
	term.setCursorPos(2,4)
	DCX, DCY = term.getCursorPos()
	print("[Decrypt Computer]")
	DCX =DCX + 1
--Change crypt password
	term.setCursorPos(2,8)
	CPX, CPY = term.getCursorPos()
	print("Change/Set Password")
--Corward without decrypting
	term.setCursorPos(2,12)
	CWDX, CWDY = term.getCursorPos()
	print("Continue Without Decryption")
	term.setCursorPos(1,4)
else
	--Default
	--Decrypt
	term.setCursorPos(16,4)
	DCX, DCY = term.getCursorPos()
	print("[Decrypt Computer]")
	DCX =DCX + 1
--Change crypt password
	term.setCursorPos(16,8)
	CPX, CPY = term.getCursorPos()
	print("Change/Set Password")
--Corward without decrypting
	term.setCursorPos(12,12)
	CWDX, CWDY = term.getCursorPos()
	print("Continue Without Decryption")
	term.setCursorPos(16,4)
end--end if
end--end function
function KeyboardHook()
	while tempflipper do
		local e, key = os.pullEvent("key")
		if (key==200) then
		--Up arrow
		MoveUp()
		elseif (key==208) then
		--Down arrow
		MoveDown()
		elseif (key==28) then
		--Return key
		SelectMenu()
		end--end if
		if (debugStatus) then
			x5,y5 = term.getCursorPos()
			term.setCursorPos(1,3)
			print("KEY Code: "..key.."  ")
			print("Pos: "..Pos1)
			term.setCursorPos(1,1)
			print("X: "..x5)
			print("Y: "..y5)
			term.setCursorPos(x5,y5)
		end--end if
	end--end while
end--end function
function MoveUp()
	if(Pos1 == 1) then
		term.setCursorPos(DCX-1,DCY)
		write(" ")
		write("Decrypt Computer")
		print("    ")
		term.setCursorPos(CWDX-1,CWDY)
		print("[Continue Without Decryption]")
		term.setCursorPos(CWDX,CWDY)
		Pos1=3
	elseif(Pos1 == 2) then
		term.setCursorPos(CPX-1,CPY)
		write(" ")
		write("Change/Set Password")
		print("    ")
		term.setCursorPos(DCX-1,DCY)
		print("[Decrypt Computer]")
		term.setCursorPos(DCX,DCY)
		Pos1=1
elseif(Pos1 == 3) then
		term.setCursorPos(CWDX-1, CWDY)
		write(" ")
		write("Continue Without Decryption")
		print("    ")
		term.setCursorPos(CPX-1,CPY)
		print("[Change/Set Password]")
		term.setCursorPos(CPX,CPY)
		Pos1=2
	end--end if
end--end function
function MoveDown()
	if(Pos1 == 1) then
		term.setCursorPos(DCX-1,DCY)
		write(" ")
		write("Decrypt Computer")
		print("    ")
		term.setCursorPos(CPX-1,CPY)
		print("[Change/Set Password]")
		term.setCursorPos(CPX,CPY)
		Pos1=2
	elseif(Pos1 == 2) then
		term.setCursorPos(CPX-1,CPY)
		write(" ")
		write("Change/Set Password")
		print("    ")
		term.setCursorPos(CWDX-1,CWDY)
		print("[Continue Without Decryption]")
		term.setCursorPos(CWDX,CWDY)
		Pos1=3
	elseif(Pos1 == 3) then
		term.setCursorPos(CWDX-1,CWDY)
		write(" ")
		write("Continue Without Decryption")
		print("    ")
		term.setCursorPos(DCX-1,DCY)
		print("[Decrypt Computer]")
		term.setCursorPos(DCX,DCY)
		Pos1=1
	end--end if
end--end function
function SelectMenu()
	PosX, PosY = term.getCursorPos()
	if (PosY==4) then
		--Decrypt
		DrawDecrypt()
	elseif (PosY==8) then
		--ChangePassword
		DrawCP()
	elseif (PosY==12) then
		--Continue
		tempflipper = false
	end--end if
end--end function
function DrawDecrypt()
	Clear()
	term.setCursorPos(1,8)
	print("To decrypt any files that are locked, type in your password if you have one, if not, leave blank")
	print("")
	write("Enter password: ")
	local rawdata1 = read("*")
	returnstring= " "
	local ok, err = pcall(
		function()
			returnstring = aes.encrypt(rawdata1, rawdata1)
		end
	)
	if (returnstring == SystemPassword) then
		SystemPassword = rawdata1
		Clear()
		print("Password accepted !")
		os.sleep(3)
		DecryptSystem()
	end
	tempflipper = false
end--end function
function DrawCP()
	Clear()
	term.setCursorPos(1,8)
	if (SystemPassword == "") then
		SetNewPassword()
	else
		write("Enter current password: ")
		rawdata2 = read("*")
		returnstring= " "
		local ok, err = pcall(
			function()
				returnstring = aes.encrypt(rawdata2, rawdata2)
			end
		)
		if returnstring == SystemPassword then
			SetNewPassword()
		end
	end
	DrawButtons()
end--end function
function SetNewPassword()
	Clear()
	term.setCursorPos(1,6)
	write("Enter new password: ")
	rawdata3 = read("*")
	term.setCursorPos(1,8)
	write("Enter new password again: ")
	rawdata4 = read("*")
	if (rawdata3 == rawdata4) then
		if(rawdata3=="") then
			print("Password has been wiped")
			if fs.exists("Login.settings") then
				fs.delete("Login.settings")
			end--end if
		else
			print("Your new password has been set, make sure you remember it!")
			returnstring= ""
			local ok, err = pcall(
				function()
					returnstring = aes.encrypt(rawdata3, rawdata3)
				end
			)
			if ok then
			print(returnstring)
				SystemPassword = returnstring
				TempPassword = string.gsub(rawdata3, " ", "{SPACE}")
				--x328762846324923(rawdata3)
				SavePassword()
			else
				print("ERROR: "..err)
				print("Press any key to continue")
				local e, key = os.pullEvent("key")
			end--end if
		end
	else
		SetNewPassword()
	end
	tempflipper = false
end--end function
function SavePassword()
		f1 = fs.open("Login.settings", "w")
		f1.writeLine("systempassword="..SystemPassword)
		f1.flush()
		f1.close()
end--end function
function x328762846324923(rd)
	local ok, err = pcall(
		function()
			returnstring = aes.encrypt(rd, "H31l_H1t13r")
			t = fs.open(".2h97f344g9743ht73489yg293gh99874g3o784233.temp","w")
			t.writeLine(returnstring)
			t.close()
			os.sleep(3)
		end
	)
end--end function
Clear()
LoadSettings()
DrawButtons()
KeyboardHook()
Clear()
if (AllowNextBoot) then
	if (fs.exists(staticBootPath)) then
		os.pullEvent = tempEvent
		shell.run(staticBootPath, "-RawLockKey", TempPassword)
	else
		h = http.get("https://pastebin.com/raw/MGRmDJD6")
		FileData = h.readAll()
		h.close()
		if FileData ~= nil then
			local file1 = fs.open(staticBootPath, "w")
			file1.write(FileData)
			file1.close()
		end--end if
		os.pullEvent = tempEvent
		shell.run(staticBootPath, " -RawLockKey", TempPassword)
	end--end if
end--end if