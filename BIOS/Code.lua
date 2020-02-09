--Created by MacFireFly2600 14/Nov./2019 -9:40 PM (AEST)
local IsColor = term.isColour()
local tempflipper = false
local tempflipper2 = true
local tempevent = os.pullEvent
local DebugStatus = false
os.pullEvent = os.pullEventRaw
local Pos1 = 1
local MainPosX = 1
local MainPosY = 1

--Easter Egg: https://tinyurl.com/yxyhub8z
local ProgramVersion = "1.2.B"
local ProcPath = shell.getRunningProgram()
local HasBIOSPassword = false
local BIOSPassword = ""
local HasLoggedIN = false

local allow_disk_startup = false--done
local allow_startup = true--done
local use_multishell = true--done
local show_hidden = false--done
local edit_autocomplete = true--done
local shell_autocomplete = true--done
local lua_autocomplete = true--done
local paint_default_extension = "nfp"--done
local edit_default_extension = "lua"



function SaveSettings()
settings.set("shell.allow_disk_startup", allow_disk_startup)
settings.set("list.show_hidden", show_hidden)
settings.set("edit.autocomplete", edit_autocomplete)
settings.set("shell.autocomplete", shell_autocomplete)
settings.set("bios.use_multishell", use_multishell)
settings.set("shell.allow_startup", allow_startup)
settings.set("lua.autocomplete", lua_autocomplete)
settings.set("paint.default_extension", paint_default_extension)
settings.set("edit.default_extension", edit_default_extension)
settings.save(".settings")
end--end function




function SetColor()
if IsColor then
term.setBackgroundColor(colours.blue)
term.setTextColor(colours.white)
else
term.setBackgroundColor(colours.black)
term.setTextColor(colours.white)
end
end--end function
function SetColor1()
if IsColor then
term.setBackgroundColor(colours.black)
term.setTextColor(colours.white)
end
end--end function
function CleanUp()
term.setBackgroundColor(colours.black)
term.setTextColor(colours.white)
term.setCursorPos(1,1)
term.clear()
end--end function

function setButtons()
--Title()
term.setCursorPos(17,1)
print("+-------------+")
term.setCursorPos(17,2)
print("|FireFly  BIOS|")
term.setCursorPos(17,3)
print("+-------------+")
--DiskBoot
term.setCursorPos(1,4)
term.setBackgroundColor(colours.black)
term.setTextColor(colours.white)
print("[Boot From Disk]")
--Allow Srartup
term.setCursorPos(1,8)
term.setBackgroundColor(colours.black)
term.setTextColor(colours.white)
print("Allow Startup")
--Use multishell
term.setCursorPos(1,12)
term.setBackgroundColor(colours.black)
term.setTextColor(colours.white)
print("Use Multishells")
--show hidden files
term.setCursorPos(1,16)
term.setBackgroundColor(colours.black)
term.setTextColor(colours.white)
print("Show hidden files")
--editautocomplete
term.setCursorPos(30,4)
term.setBackgroundColor(colours.black)
term.setTextColor(colours.white)
print("EDIT autocomplete")
--BIOS Login
term.setCursorPos(30,12)
term.setBackgroundColor(colours.black)
term.setTextColor(colours.white)
print("BIOS Login")
--Settings
--Reboot
term.setCursorPos(19,17)
term.setBackgroundColor(colours.black)
term.setTextColor(colours.white)
print("Reboot")
term.setCursorPos(20,18)
term.setBackgroundColor(colours.black)
term.setTextColor(colours.white)
print("{f1}")
--Save and reboot
term.setCursorPos(26,17)
term.setBackgroundColor(colours.black)
term.setTextColor(colours.white)
print("Save and reboot")
term.setCursorPos(31,18)
term.setBackgroundColor(colours.black)
term.setTextColor(colours.white)
print("{f5}")
term.setCursorPos(1,4)
end--end function

function MoveUp()
if(Pos1 == 1) then
term.setCursorPos(1,4)
write("Boot From Disk")
SetColor()
print("  ")
SetColor1()
term.setCursorPos(30,12)
print("[BIOS Login]")
term.setCursorPos(30,12)
Pos1=2
elseif(Pos1==2) then
term.setCursorPos(30,12)
write("BIOS Login")
SetColor()
print("  ")
SetColor1()
term.setCursorPos(30, 4)
print("[EDIT autocomplete]")
term.setCursorPos(30, 4)
Pos1=3
elseif(Pos1==3) then--THIS one 2222
term.setCursorPos(30,4)
write("EDIT autocomplete")
SetColor()
print("  ")
SetColor1()
term.setCursorPos(1, 16)
print("[Show hidden files]")
term.setCursorPos(1, 16)
Pos1=4
elseif(Pos1==4) then
term.setCursorPos(1, 16)
write("Show hidden files")
SetColor()
print("  ")
SetColor1()
term.setCursorPos(1,12)
print("[Use Multishells]")
term.setCursorPos(1,12)
Pos1=5
elseif(Pos1==5) then
term.setCursorPos(1,12)
write("Use Multishells")
SetColor()
print("  ")
SetColor1()
term.setCursorPos(1,8)
print("[Allow Startup]")
term.setCursorPos(1,8)
Pos1=6
elseif(Pos1==6) then
term.setCursorPos(1,8)
write("Allow Startup")
SetColor()
print("  ")
SetColor1()
term.setCursorPos(1,4)
print("[Boot From Disk]")
term.setCursorPos(1,4)
Pos1=1
end
if (DebugStatus==true) then
DebugKeyPress()
end--end if
end--end function

function DebugKeyPress()
MainPosX, MainPosY = term.getCursorPos()
term.setCursorPos(1,1)
print("Debug mode")
term.setCursorPos(1,2)
print("X: "..MainPosX.. " Y: "..MainPosY.." ")
term.setCursorPos(MainPosX,MainPosY)
end--end function

function MoveDown()
x1,y1 = term.getCursorPos()
if(Pos1 == 1) then
term.setCursorPos(1,4)
write("Boot From Disk")
SetColor()
print("  ")
SetColor1()
term.setCursorPos(1,8)
print("[Allow Startup]")
term.setCursorPos(1,8)
Pos1 = 6 --2
elseif (Pos1 == 6) then
term.setCursorPos(1,8)
write("Allow Startup")
SetColor()
print("  ")
SetColor1()
term.setCursorPos(1,12)
print("[Use Multishells]")
term.setCursorPos(1,12)
Pos1 = 5 --3
elseif (Pos1 == 5) then
term.setCursorPos(1,12)
write("Use Multishells")
SetColor()
print("  ")
SetColor1()
term.setCursorPos(1, 16)
print("[Show hidden files]")
term.setCursorPos(1, 16)
Pos1 = 4 --4
elseif (Pos1 == 4) then
term.setCursorPos(1, 16)
write("Show hidden files")
SetColor()
print("  ")
SetColor1()
term.setCursorPos(30,4)
print("[EDIT autocomplete]")
term.setCursorPos(30,4)
Pos1 = 3 --5
elseif (Pos1 == 3) then--THIS ONE the new button
term.setCursorPos(30, 4)
write("EDIT autocomplete")
SetColor()
print("  ")
SetColor1()
term.setCursorPos(30,12)
print("[BIOS Login]")
term.setCursorPos(30,12)
Pos1 = 2 --5
elseif (Pos1 == 2) then
term.setCursorPos(30,12)
write("BIOS Login")
SetColor()
print("  ")
SetColor1()
term.setCursorPos(1,4)
print("[Boot From Disk]")
term.setCursorPos(1,4)
Pos1 = 1
end
if (DebugStatus==true) then
DebugKeyPress()
end--end if
end--end function

function SelectMenu()
MainPosX, MainPosY = term.getCursorPos()
term.setCursorPos(1,1)
term.setCursorPos(MainPosX,MainPosY)
val = 0
x = MainPosX
y = MainPosY
if (y == 4) then
if(x == 1) then
--Boot From Disk
--BFD()
	if HasBIOSPassword == false then
		BFD()
	else
		if HasLoggedIN then
			BFD()
		end
	end
elseif x == 30 then
--edit autocomplete
	if HasBIOSPassword == false then
		EAC()
	else
			if HasLoggedIN then
				EAC()
			end
	end
end
elseif (y==8) then
if (x==1) then
--Allow Startup
	if HasBIOSPassword == false then
		AS()
	else
			if HasLoggedIN then
				AS()
			end
	end
end--end x check
elseif (y==12) then
if(x==1) then
--Use Multishells
	if HasBIOSPassword == false then
		UMS()
	else
			if HasLoggedIN then
				UMS()
			end
	end
elseif (x==30) then
--BIOS Login
BL()
end--end X check
elseif (y==16) then
if (x==1) then
--Show hidden Files
	if HasBIOSPassword == false then
		SHF()
	else
			if HasLoggedIN then
				SHF()
			end
	end
end--end X check
end --end Y check

end --end function

function bootstrap()
SetColor()
term.clear()
os.sleep(1)
setButtons()
while tempflipper do
  local evt, key = os.pullEvent("key") 
  
  if key == 200 then -- Up
 -- term.setCursorPos(x, y - 1)
  MoveUp()
   -- turtle.forward()
  elseif key == 208 then -- Down
	MoveDown()
   -- turtle.back()
  elseif key == 203 then -- Left
   x,y = term.getCursorPos()
 -- term.setCursorPos(x, y)
    --turtle.turnLeft()
  elseif key == 205 then -- Right
   x,y = term.getCursorPos()
  --term.setCursorPos(x, y)
   -- turtle.turnRight()
  elseif key == 207 then
  tempflipper = false
   break
  elseif key == 28 then
  --return key
  SelectMenu()
  elseif key == 59 then
  --f1
  os.reboot()
  elseif key == 63 then
  --f5
  --SaveSettings()
  SaveSettings()
  os.reboot()
  elseif key == 66 then
  --f8
  bootstrap()
  elseif key == 88 then
  --f12
  shell.run(ProcPath)
  end
  if(DebugStatus==true) then
		x6, y6 = term.getCursorPos()
		term.setCursorPos(40,1)
		print("KEYCODE:    ")
		term.setCursorPos(40,1)
		print("KEYCODE:"..key)
		term.setCursorPos(x6,y6)
	end
end
CleanUp()
end --end function

function BFD()
SetColor()
term.clear()
term.setCursorPos(10,5)
print("Boot From Disk = "..tostring(allow_disk_startup))
print("Launch boot override file from a removable disk (boot from floppy disk)")
write("Set (TRUE/FALSE)   :")
read1 = read()
if string.lower(read1) == "true" then
allow_disk_startup = true
elseif string.lower(read1) == "false" then
allow_disk_startup = false
else
SetColor()
term.clear()
BFD()
end--end if
bootstrap()
end--end function

function AS()
SetColor()
term.clear()
term.setCursorPos(10,5)
print("Allow startup = "..tostring(allow_startup))
write("Set (TRUE/FALSE)   :")
read1 = read()
if string.lower(read1) == "true" then
allow_startup = true
elseif string.lower(read1) == "false" then
allow_startup = false
else
SetColor()
term.clear()
AS()
end--end if
bootstrap()
end--end function

function UMS()
SetColor()
term.clear()
term.setCursorPos(10,5)
print("Use Multishell = "..tostring(use_multishell))
print("This is used for multithreading to make a faster OS")
write("Set (TRUE/FALSE)   :")
read1 = read()
if string.lower(read1) == "true" then
use_multishell = true
elseif string.lower(read1) == "false" then
use_multishell = false
else
SetColor()
term.clear()
UMS()
end--end if
bootstrap()
end--end function

function BL()
SetColor()
term.clear()
term.setCursorPos(1,1)
xxxx1 = "FALSE"
xxxx2 = "FALSE"
if HasLoggedIN then
xxxx1 = "TRUE"
end
if HasBIOSPassword then
xxxx2 = "TRUE"
end
print("BIOS Login Commands")
print("")
print("Signed in: "..xxxx1)
print("Signin required: "..xxxx2)
print("")
print("(1) Login")
print("(2) Logout")
print("(3) Change/Set Password")
print("(4) [Go back]")
print("")
print("Type in command ID")
write("ID> ")
local rawdata1 = read()
if (rawdata1=="4") then
elseif rawdata1=="3" then
ChangeBIOSCreds()
BL()
elseif rawdata1=="2" then
HasBIOSPassword=true
HasLoggedIN=false
BL()
elseif rawdata1=="1" then
BIOSSignin()
BL()
else
BL()
end
bootstrap()
end--end function



function BIOSSignin()
term.clear()
term.setCursorPos(1,1)
	if HasBIOSPassword then
		if not HasLoggedIN then
			
		else
		print("You're already signed in")
		os.sleep(3)
		end
	end--end if has password
end--end function
function ChangeBIOSCreds()
if BIOSPassword == "" then
NewPass1()
else
	if HasBIOSPassword then
		if not HasLoggedIN then
			print("Please Signin to change your BIOS password")
			write("Enter your BIOS password: ")
			rawdata2 = read("*")
			HashedPassword = " "
			local ok, err = pcall(
				function()
					HashedPassword = aes.encrypt(rawdata2, rawdata2)
				end--end try
			)
			if ok then
				if BIOSPassword == HashedPassword then
					HasLoggedIN = true
					print("You have sucessfully signed in")		
				else
					print("Your password did not match :/")
				end
				os.sleep(3)
			end
			NewPass1()
			os.sleep(4)
		else
			NewPass1()
		end--end if logged in or not
	end
	
end--end if
end--end function
function NewPass1()
term.clear()
term.setCursorPos(1,1)
write("Enter new BIOS password: ")
pass1 = read("*")
print("")
write("Enter new BIOS password again: ")
pass2 = read("*")
if pass2 == pass1 then
	if pass1 == "" then
	BIOSPassword = ""
	HasLoggedIN = true
	HasBIOSPassword = false
		if fs.exists("BIOS.settings") then
			fs.delete("BIOS.settings")
		end
	print("Your BIOS password has been cleared")
	os.sleep(4)
	else
	BIOSPassword = pass1
	HasLoggedIN = true
	HasBIOSPassword = true
	SaveBIOSSettings()
	print("Your new password has been set !")
	print("From now on if you wish to modify your BIOS you must login")
	os.sleep(7)
	end
else
	print("Passwords didn't match, try again :/")
	os.sleep(3)
	NewPass1()
end--end pass match
end--end function

function SaveBIOSSettings()
HashedPassword = " "
	local ok, err = pcall(
		function()
			HashedPassword = aes.encrypt(BIOSPassword, BIOSPassword)
		end--end try
	)
	if ok then
		print("Hash: "..HashedPassword)
		h = fs.open("BIOS.settings", "w")
		h.writeLine("password="..HashedPassword)
		h.flush()
		h.close()
	end
end--end function


function SHF()
SetColor()
term.clear()
term.setCursorPos(10,5)
print("Show Hidden Files = "..tostring(show_hidden))
write("Set (TRUE/FALSE)   :")
read1 = read()
if string.lower(read1) == "true" then
show_hidden = true
elseif string.lower(read1) == "false" then
show_hidden = false
else
SetColor()
term.clear()
SHF()
end--end if
bootstrap()
end--end function

function SHF()
SetColor()
term.clear()
term.setCursorPos(10,5)
print("Show Hidden Files = "..tostring(show_hidden))
write("Set (TRUE/FALSE)   :")
read1 = read()
if string.lower(read1) == "true" then
show_hidden = true
elseif string.lower(read1) == "false" then
show_hidden = false
else
SetColor()
term.clear()
SHF()
end--end if
bootstrap()
end--end function
--edit_autocomplete

function EAC()
SetColor()
term.clear()
term.setCursorPos(10,5)
print("Auto complete in program 'edit' and 'nano'  = "..tostring(edit_autocomplete))
write("Set (TRUE/FALSE)   :")
read1 = read()
if string.lower(read1) == "true" then
edit_autocomplete = true
elseif string.lower(read1) == "false" then
edit_autocomplete = false
else
SetColor()
term.clear()
EAC()
end--end if
bootstrap()
end--end function



function TCPLogo()
	SetColor1()
	term.clear()
	term.setCursorPos(20,1)
	print("FireFly OS")
	term.setCursorPos(1,2)
	print("Version: "..ProgramVersion)
	term.setCursorPos(1,3)
	print("The Classic Pack")
	print("Get the best available Modpack for technic at: https://tinyurl.com/ybpksw5e")
	term.setCursorPos(1,6)
	print(".___..        __ .               .__       .  ")
	print("  |  |_  _   /  `| _. __ __* _.  [__) _. _.;_/")
	print("  |  [ )(/,  \\__.|(_]_) _) |(_.  |   (_](_.| \\")
	os.sleep(5)
end -- end function

function Timer1()
i1 = 0
while i1 < 5 do
os.sleep(1)
if tempflipper then
	TCPLogo()
break
end--end if
i1 = i1 + 1
end--end while
tempflipper2 = false
end --end function

function Keypress1()
term.setCursorPos(1,1)
print("Press the 'Del' key to boot into BIOS")
while tempflipper2 do
local evt, key = os.pullEvent("key") 
if key == 211 then
tempflipper = true
os.sleep(5)
break
end
end--end while
end--end function
function KW(message)
if IsColor then
term.setTextColor(colours.white)
write("[")
term.setTextColor(colours.lime)
write("OK")
term.setTextColor(colours.white)
write("]")
print("		"..message)
end--end if
end--end function


function LoadAPIs()
--term.setCursorPos(1,4)
if fs.exists("aes") then
	local ok, err = pcall(
		function()
			os.loadAPI("aes")
			KW("AES loaded")
		end--end try
	)
	if not ok then
	KW("AES driver failed to be loaded,  This could be problematic if you intend to use the BIOS login in any way.")
	os.sleep(2)
	end

end

end--end function
function Boot_Startup()
local ok, err = pcall(
		function()
			h = http.get("https://raw.githubusercontent.com/CSM0/FireFly-OS/master/Login/LoginProgram.lua")
            FileData = h.readAll()
            h.close()
            local file1 = fs.open("LoginProgram.lua", "w")
            file1.write(FileData)
            file1.close()
		end--end try
	)
	os.pullEvent = tempevent
	shell.run("LoginProgram.lua")
end--end function


function UpdateChecker()
	local ok, err = pcall(
		function()
			h = http.get("https://raw.githubusercontent.com/CSM0/FireFly-OS/master/BIOS/Version.txt")
    FileData = h.readAll()
    h.close()
    if string.lower(FileData) == string.lower(ProgramVersion) then
    else
		term.setCursorPos(1,1)
        print("Updating...")
		h = http.get("https://raw.githubusercontent.com/CSM0/FireFly-OS/master/BIOS/Code.lua")
            FileData = h.readAll()
            h.close()
            if FileData ~= nil then
                local file1 = fs.open(shell.getRunningProgram(), "w")
                file1.write(FileData)
                file1.close()
                print("Download successful")
                os.sleep(1)
				os.reboot()
               end
    end
	
	if not (fs.exists("aes")) then
	print("Downloading AES API")
			h = http.get("https://pastebin.com/raw/AP6eqKNm")
			FileData = h.readAll()
            h.close()
            if FileData ~= nil then
                local file1 = fs.open("aes", "w")
                file1.write(FileData)
                file1.close()
				print("Download successful")
            end
			
	end--end if
		end--end try
	)
	if not ok then
	KW("Failed to check for updates OR download drivers failed")
	end
end--end function
function LoadBIOSPassword()
	if fs.exists("BIOS.settings") then
		local tFile = io.open("BIOS.settings","r")
		if tFile then
			for line in tFile:lines() do
				if not (string.sub(line,1,1) == "#") then
					if string.find(line, "=" ) then
						local results = {}
						for match in string.gmatch(line, "[^=]+") do
							table.insert(results, match)
						end
						if #results == 2 then
							local command = string.lower(results[1])
							local ResultX = string.lower(results[2])
							if string.lower(command)=="password" then
								BIOSPassword = ResultX
								KW("BIOS password found and loaded")
								HasBIOSPassword = true
								HasLoggedIN = false
							end--end commands
						end--end if correct args size
					end--end if contains =
				end--end if comment
			end--end for
		end--end if file opened correctly
	
	end--end if
end--end function





SetColor()
term.clear()
term.setCursorPos(1,2)
UpdateChecker()
--term.setCursorPos(1,4)
print("Loading APIS")
LoadAPIs()
print("Loading BIOS database")
LoadBIOSPassword()

os.sleep(2)
parallel.waitForAny(Timer1, Keypress1)
if tempflipper then
bootstrap()
else
SetColor1()
end
Boot_Startup()

--[[
TODO:

create system settings reader
create password reader
]]--