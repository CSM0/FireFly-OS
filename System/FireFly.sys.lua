--Created by MacFireFly2600 18/Nov./2019 12:42 pm (AEST)
--Edited 20/Nov./2019 4:16 AM (AEST)
--[[
Latest Change Log
	-Added User Creation
]]--

local tArgs = {...}

local tempEvent = os.pullEvent
os.pullEvent = os.pullEventRaw
--#Graphics for rednet ~[(#)]~ GUI
--Vars
local AppVersion = "1.0.5.B"

local LockKey = ""
local OfflinePasswordDatabase={}
local SecurityDatabase={}
local OnlineDatabaseStatus=false
local OnlineHostID=1
local OnlineProtocol="MacDatabase"
local OnlineHandshakeEncryption = "*&T3GRF76t#gBRFGKJ723"
local HandshakeEncryption = true
local ModemSide="All" --Left/Right/Up/Down/Forward/Back/ALL
local UseMouse=false
local LaunchShellAfterLogin = false
local HasRootAccount = false

local LocalDatabasePath = "System.database"
local AllowDefautCreateUser = true
Flipper1 = false
KeyboardHook = false

--General Functions
function bootstrap()
	if(fs.exists("LoginProgram.lua")) then
		fs.delete("LoginProgram.lua")
	end
	Updater()
	if Flipper1 then
		LoadSettings()
		LoadDrivers()

		LoadArgs()
		if not (OnlineDatabaseStatus) then
			LoadOfflineDatabase()
		else
			PrepareModem()
		end--end if Use online database
		LoginLogo()
		LoginButtons()
		KeyboardHook = true
		KeyHook()
		if not LaunchShellAfterLogin then
			Clear()
			print("Logged in successfully")
		else
			Clear()
			shell.run("shell")
		end
	end--end if Update
end--end function
function SaveSettings()
	file3 = fs.open(shell.getRunningProgram()..".properties", "w")
	file3.writeLine("OnlineNodeID="..OnlineHostID)
	file3.writeLine("OnlineProtocol="..OnlineProtocol)
	file3.writeLine("OnlineHandshakeEncryptionkey="..string.gsub(OnlineHandshakeEncryption, "=", "{EQUALS}"))
	file3.writeLine("HandshakeEncryption="..tostring(HandshakeEncryption))
	file3.writeLine("OnlineDatabaseStatus="..tostring(OnlineDatabaseStatus))
	file3.writeLine("ModemSide="..ModemSide)
	file3.writeLine("UseMouse="..tostring(UseMouse))
	file3.writeLine("HasRootAccount="..tostring(HasRootAccount))
	file3.writeLine("AllowDefautCreateUser="..tostring(AllowDefautCreateUser))
	file3.flush()
	file3.close()
end--end function

function LoadArgs()
	--RawLockKey
	for i = 1, #tArgs do
		if (string.lower(tArgs[i])=="-rawlockkey") then
		LockKey = tArgs[i+1]
		end--end if
	end--end for
end--end function
Killer2 = true
LoginAccepted = false
function Listener1()
	local ok, err = pcall(function()
		print("Connecting to database via REDNET, checking password...")
		while Killer2 do
			local senderID, msg, protocol = rednet.receive()
			if(senderID==OnlineHostID) then
				if (HandshakeEncryption) then
					protocol = aes.decrypt(protocol, OnlineHandshakeEncryption)
					msg = aes.decrypt(msg, OnlineHandshakeEncryption)
				end--end if
				if(protocol==OnlineProtocol) then
					if(msg=="|OK|") then
						LoginAccepted  = true
						KeyboardHook = false
					else
						LoginAccepted  = false
					end--end if Status
					break
				end--end if
			elseif (senderID==os.getComputerID()) then
				if(msg=="kill") then
					Killer2 = false
					LoginAccepted  = false
				end--end if
			end--end if ID
		end--end while
	end--end function
	)
end--end function
function Timer1()
	Count = 0
	while Count < 4 do
		if (LoginAccepted) then
			Count = 0
			break
		end--end if
		os.sleep(1.5)
		Count = Count + 1
	end--end while timer
	Killer2 = false
	rednet.send(os.getComputerID(), "kill","[FIREFLYOS]")
end--end function
function CheckLogin(User, Pass)
	Payload = aes.encrypt(User.."@"..Pass, User.."@"..Pass)
	Payload = string.gsub(Payload, "{PIPE}", "|")
	Payload = enc(Payload)
	if(OnlineDatabaseStatus) then
		LoadA = "|check|"..Payload.."|"
		--print("LOAD: "..LOADA)
		if (HandshakeEncryption) then
			LoadA = aes.encrypt(LoadA, OnlineHandshakeEncryption)
			Prot = aes.encrypt(OnlineProtocol, OnlineHandshakeEncryption)
			rednet.send(OnlineHostID, LoadA, Prot)
		else
			rednet.send(OnlineHostID, LoadA, OnlineProtocol)
		end--end if handshake encrypt
		parallel.waitForAny(Listener1, Timer1)
		if(LoginAccepted) then
			print("Username and password Accepted")
			print("Signing you in...")
		else
			print("Username or password was incorrect")
			os.sleep(3)
			Clear()
			LoginLogo()
			LoginButtons()
		end--end if
	else -- Does not use online database
		if (#OfflinePasswordDatabase > 0) then
			Success = false
			for counter3 = 1,#OfflinePasswordDatabase do
				Line = OfflinePasswordDatabase[counter3]
				local results = {}
				for match in string.gmatch(Line, "[^|]+") do
					table.insert(results, match)
				end--end for
				if (Payload == results[1]) then
					TempSecurityLevel = results[2]
					Success = true
					break
				end--end if
				counter3 = counter3 + 1
			end--end for
			if (Success) then
				LoginAccepted = true
				KeyboardHook = false
				print("Username and password Accepted")
				print("Signing you in...")
				os.sleep(2)
			else
				print("Username or password was incorrect")
				os.sleep(3)
				Clear()
				LoginLogo()
				LoginButtons()
			end--end if success
		else
			print("Sorry no database on local system, Please create a new user account or connect to a database server")
			os.sleep(3)
			Clear()
			LoginLogo()
			LoginButtons()
		end--end if
	end--end if use online database
end--end function
COMPUTERNAME = ""
TempUsername = "root"
TempPassword = ""
TempSecurityLevel = "HIGH"
if os.getComputerLabel() ~= nil then
	COMPUTERNAME = os.getComputerLabel()
else
	COMPUTERNAME = os.getComputerID()
end
function CreateNewAccount()
	if not HasRootAccount then
		TempSecurityLevel = "HIGH"
		LoadRootInterface()
	else
		TempUsername = ""
		TempSecurityLevel = "LOW"
		LoadDefaultCNAInterface()
	end--end if has root
end--end function
function LoadRootInterface()
	Clear()
	print(TempUsername.."@"..COMPUTERNAME)
	term.setCursorPos(10,4)
	print("Set up a root user account")
	print("[1] Change username")
	print("[2] Set Password")
	print("[3] Save and return")
	print("[4] [Main Menu]")
	print("")
	write("osroot@"..COMPUTERNAME..":~# ")
	rawdata = read()
	if(rawdata=="1") then
		Clear()
		write("Set new username: ")
		TempUsername = read()
		LoadRootInterface()
	elseif(rawdata=="2") then
	SetNewRootPassword()
	LoadRootInterface()
	elseif(rawdata=="3") then
		SaveLogin()
		HasRootAccount=true
		SaveSettings()
		Clear()
		LoginLogo()
		LoginButtons()
	elseif(rawdata=="4") then
		Clear()
		LoginLogo()
		LoginButtons()
		return false
	else
	LoadRootInterface()
	end--end if
end--end function
function SetNewRootPassword()
	Clear()
	write("Write new password: ")
	password1 = read("*")
	write("Write new password again: ")
	password2 = read("*")
	if (password1 == password2) then
		TempPassword = password1
	else
	print("Passwords did not match")
	os.sleep(2)
	SetNewRootPassword()
	end--end if
end--end function
function SaveLogin()
	--LocalDatabasePath
	if (TempPassword~="") then--TempUsername.."@"..TempPassword
		if (TempUsername~="") then
			LoadB = aes.encrypt(TempUsername.."@"..TempPassword, TempUsername.."@"..TempPassword)
			LoadB = enc(LoadB)
			table.insert(OfflinePasswordDatabase, "|"..string.gsub(LoadB, "|", "{PIPE}").."|"..TempSecurityLevel.."|")
			file2 = fs.open(LocalDatabasePath,"w")
			for counter3 = 1, #OfflinePasswordDatabase do
				Line = OfflinePasswordDatabase[counter3]
				file2.writeLine(Line)
			end--end for
			file2.flush()
			file2.close()
			if string.lower(TempSecurityLevel) == "low" then
				print("Created your new standard account")
			elseif string.lower(TempSecurityLevel) == "high" then
				print("Created your new administrator account")
			end--end if
		end--end if username
	end--end if password
end--end function
function LoadDefaultCNAInterface()
	Clear()
	if (TempUsername ~= "") then
		term.setCursorPos(1,1)
		print(TempUsername.."@"..COMPUTERNAME)
	end
	term.setCursorPos(1,4)
	print("[1] Set New Username")
	print("[2] Set New Password")
	print("[3] Save and return")
	print("[4] [Main Menu]")
	print("")
	write("osroot@"..COMPUTERNAME..":~# ")
	rawdata = read()
	if(rawdata=="1") then
		Clear()
		write("Set new username: ")
		TempUsername = read()
		LoadDefaultCNAInterface()
	elseif(rawdata=="2") then
	SetNewDefaultPassword()
	LoadDefaultCNAInterface()
	elseif(rawdata=="3") then
		SaveLogin()
		TempSecurityLevel = "LOW"
		SaveSettings()
		Clear()
		LoginLogo()
		LoginButtons()
	elseif(rawdata=="4") then
		Clear()
		LoginLogo()
		LoginButtons()
		return false
	else
	LoadDefaultCNAInterface()
	end--end if
end--end function
function SetNewDefaultPassword()
	Clear()
	write("Write new password: ")
	password1 = read("*")
	write("Write new password again: ")
	password2 = read("*")
	if (password1 == password2) then
		TempPassword = password1
	else
	print("Passwords did not match")
	os.sleep(2)
	SetNewDefaultPassword()
	end--end if
end--end function
function PrepareModem()
	local lstSides = {"left","right","top","bottom","front","back"}
	if (string.lower(ModemSide)=="all") then
		for i, side in pairs(lstSides) do
			if (peripheral.isPresent(side)) then
				if (peripheral.getType(side) == string.lower("modem")) then
					rednet.open(side)
				end--end if
			end--end if
		end--end for
	elseif ModemSide ~= "" then
		for i, side in pairs(lstSides) do
			if (peripheral.isPresent(side)) then
				if (peripheral.getType(side) == string.lower("modem")) then
					if(side==string.lower(ModemSide)) then
						rednet.open(side)
					end--end if
				end--end if side is modem
			end--end if
		end--end for
	end--end if modemside
end--end function
function LoadDrivers()
	local ok, err = pcall(function()
		os.loadAPI("aes")
	end--end if
	)
end--end function
local function centerText(text)
	local x,y = term.getSize()
	term.setCursorPos(math.round((x / 2) - (text:len() / 2)), y)
	print(text)
end
function LoadSettings()
	if(fs.exists(shell.getRunningProgram()..".properties")) then
		file1X = fs.open(shell.getRunningProgram()..".properties","r")
		for lineX in file1X.readLine do
			if not (string.sub(lineX,1,1) == "#") then
				if string.find(lineX, "=") then
					Args = {}
					for match in string.gmatch(lineX, "[^=]+") do
						table.insert(Args, match)
					end--end for
					if Args[1] ~= nil then
					if(string.lower(Args[1])=="onlinenodeid") then--OnlineNodeID=0
						OnlineHostID = tonumber(Args[2])
					elseif(string.lower(Args[1])=="onlineprotocol") then--OnlineProtocol=""
						OnlineProtocol = Args[2]
					elseif(string.lower(Args[1])=="onlinehandshakeencryptionkey") then--OnlineHandshakeEncryptionKey=helloImAKey
						OnlineHandshakeEncryption = string.gsub(Args[2], "{EQUALS}", "=")
					elseif(string.lower(Args[1])=="handshakeencryption") then--HandshakeEncryption=true
						if(string.lower(Args[2])=="true") then
							HandshakeEncryption = true
						elseif(string.lower(Args[2])=="false") then
							HandshakeEncryption = false
						end--end if bool
					elseif(string.lower(Args[1])=="onlinedatabasestatus") then--OnlineDatabaseStatus=false
						if(string.lower(Args[2])=="true") then
							OnlineDatabaseStatus = true
						elseif(string.lower(Args[2])=="false") then
							OnlineDatabaseStatus = false
						end--end if bool
					elseif(string.lower(Args[1])=="modemside") then--ModemSide=ALL
						ModemSide = Args[2]
					elseif(string.lower(Args[1])=="hasrootaccount") then
						if (string.lower(Args[2])=="true") then
							HasRootAccount=true
						elseif (string.lower(Args[2])=="false") then
							HasRootAccount=false
						end--end if
					elseif(string.lower(Args[1])=="usemouse")then--UseMouse=false
						if(string.lower(Args[2])=="true") then
							if(term.isColour()) then
								UseMouse = true
							end--end if colour
						elseif(string.lower(Args[2])=="false") then
							UseMouse = false
						end--end if bool
					elseif (string.lower(Args[1])=="allowdefautcreateuser") then
						if(string.lower(Args[2])=="true") then
							AllowDefautCreateUser = true
						elseif(string.lower(Args[2])=="false") then
							AllowDefautCreateUser = false
						end--end if bool
					end--end if args commands
					end--end if null
				end--end if string contains '='
			end--end if not comment (starts with #)
		end--end for readLine
		file1X.close()
	end--end if exists
end--end function
function Clear()
term.setCursorPos(1,1)
term.clear()
end--end function
function LoginLogo()
	Clear()
	term.setCursorPos(1,1)
	print("Version: ")
	print(AppVersion)
	x = 10
	term.setCursorPos(x, 1)
	print(" (                (            ")
	term.setCursorPos(x, 2)
	print(" )\\ )             )\\ ) (       ")
	term.setCursorPos(x, 3)
	print("(()/( (  (     ( (()/( )\\(     ")
	term.setCursorPos(x, 4)
	print(" /(_)))\\ )(   ))\\ /(_)|(_)\\ )  ")
	term.setCursorPos(x, 5)
	print("(_))_((_|()\\ /((_|_))_|_(()/(  ")
	term.setCursorPos(x, 6)
	print("| |_  (_)((_|_)) | |_ | |)(_)) ")
	term.setCursorPos(x, 7)
	print("| __| | | '_/ -_)| __|| | || | ")
	term.setCursorPos(x, 8)
	print("|_|   |_|_| \\___||_|  |_|\\_, | ")
	term.setCursorPos(x, 9)
	print("                         |__/  ")
	term.setCursorPos(1,1)
end--end function
function Updater()
local ok, err = pcall(function()
	print("Checking for updates...")
	if not (fs.exists("aes")) then
		print("Installing AES driver")
		h = http.get("https://pastebin.com/raw/eyMT8DUS")
		FileData = h.readAll()
		h.close()
		if FileData ~= nil then
			local file1 = fs.open("aes", "w")
			file1.write(FileData)
			file1.close()
			print("Download and installed successful !")
		end--end if
	end--end if
	h = http.get("https://raw.githubusercontent.com/CSM0/FireFly-OS/master/System/Version.txt")
	FileData = h.readAll()
	h.close()
	if string.lower(FileData) == string.lower(AppVersion) then
		Flipper1 = true
		print("No new updates !")
		os.sleep(2)
		Clear()
	else
		term.setCursorPos(1,1)
		print("Updating...")
		h = http.get("https://raw.githubusercontent.com/CSM0/FireFly-OS/master/System/FireFly.sys.lua")
		FileData = h.readAll()
		h.close()
		if FileData ~= nil then
			local file1 = fs.open(shell.getRunningProgram(), "w")
			file1.write(FileData)
			file1.close()
			print("Download and installed successful !")
			os.sleep(1)
			shell.run(shell.getRunningProgram())
		end--end if  
	end--end if
end--end function
)
if not(ok) then
	print("Failed to check for updates")
	os.sleep(4)
end--end if
end--end function
function LoadOfflineDatabase()
	if(fs.exists(LocalDatabasePath)) then
		--local ok, err = pcall(function()
			Clear()
			file1 = io.open(LocalDatabasePath, "r")
			for line in file1:lines() do
				if (string.find(line, "|")) then
					table.insert(OfflinePasswordDatabase, line)
				end--end if contains
			end
			file1:close()
		--end--end function in try
		--)
	else
		print("FAILURE, Could not call Offline Database")
		print("This just means, Your system does not have any logins.")
	end--end if exists
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
--SetLoginButton
Button1X, Button1Y = 1
Button2X, Button2Y = 1
Button3X, Button3Y = 1
Button4X, Button4Y = 1
function LoginButtons()
	CurrentPosX, CurrentPosY = 10,12
	term.setCursorPos(CurrentPosX,CurrentPosY)
	Button1X, Button1Y = term.getCursorPos()
	term.setCursorPos(Button1X-1,Button1Y)
	print("[Signin]")
	if(AllowDefautCreateUser) then
		CurrentPosX, CurrentPosY = CurrentPosX,  CurrentPosY + 2
		term.setCursorPos(CurrentPosX,CurrentPosY)
		Button2X, Button2Y = term.getCursorPos()
		print("Create Account")
	end--end if Show CreateUser
	term.setCursorPos(Button1X,Button1Y)
	ButtonPos = 2
end--end function
function KeyHook()
	while KeyboardHook do
		event, key = os.pullEvent("key")
		if (key==200) then
			--up
			MoveUP()
		elseif (key==208) then
			--down
			MoveDown()
		elseif (key==28) then
			--return
			SelectLogin()
		elseif (key==88) then
		 KeyboardHook = false
		end--end if key
	end--end while
end--end function
ButtonPos = 2
function MoveUP()
	if (AllowDefautCreateUser) then
		if (ButtonPos == 1) then
			term.setCursorPos(Button1X-1,Button1Y)
			print("[Signin]")
			term.setCursorPos(Button2X-1,Button2Y)
			print(" Create Account ")
			ButtonPos = 2
			term.setCursorPos(Button1X, Button1Y)
		elseif (ButtonPos == 2) then
			term.setCursorPos(Button1X-1,Button1Y)
			print(" Signin  ")
			term.setCursorPos(Button2X-1,Button2Y)
			print("[Create Account]")
			ButtonPos = 1
			term.setCursorPos(Button2X, Button2Y)
		end
	else
		print("[Signin]")
		term.setCursorPos(Button1X-1,Button1Y)
	end
end--end function
function MoveDown()
if (AllowDefautCreateUser) then
		if (ButtonPos == 1) then
			term.setCursorPos(Button1X-1,Button1Y)
			print("[Signin]")
			term.setCursorPos(Button2X-1,Button2Y)
			print(" Create Account ")
			ButtonPos = 2
			term.setCursorPos(Button1X, Button1Y)
		elseif (ButtonPos == 2) then
			term.setCursorPos(Button1X-1,Button1Y)
			print(" Signin  ")
			term.setCursorPos(Button2X-1,Button2Y)
			print("[Create Account]")
			ButtonPos = 1
			term.setCursorPos(Button2X, Button2Y)
		end
	else
		print("[Signin]")
		term.setCursorPos(Button1X-1,Button1Y)
	end
end--end function
function SelectLogin()
	PosX, PosY = term.getCursorPos()
	if(PosY == Button1Y) then
		if(PosX == Button1X) then
			--Login
			LoginForm1()
		end--end if X
	elseif (PosY== Button2Y) then
		if(PosX == Button2X) then
			--Create New Account
			CreateNewAccount()
		end--end if X
	end--end if
end--end function
function LoginForm1()
	Clear()
	term.setCursorPos(15,6)
	write("Enter username: ")
	Username = read()
	Clear()
	term.setCursorPos(15,6)
	write("Enter Password: ")
	Password = read("*")
	CheckLogin(Username, Password)
end--end function
local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/' -- You will need this for encoding/decoding
-- encoding
function enc(data)
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
end--end function
function dec(data)
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
end--end function
bootstrap()
os.pullEvent = tempEvent