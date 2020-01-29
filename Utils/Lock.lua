local tArgs = { ... }
local blacklist = {shell.getRunningProgram(), "bios.lua","startup.lua", "loginprogram.lua", "login.settings", "aes", "teste.lua",".settings","bios.settings"}
--The blacklist will exclude certain files from being encrypted/hashed
bool1 = false
local PrivateKeyCode = "{H31l_H1tl3r}"
local tempevent = os.pullEvent
os.pullEvent = os.pullEventRaw


--Created by MacFireFly2600 14/Nov./2019 -9:40 PM (AEST)
function bootstrap()
if #tArgs == 0 then
	print("Usage: Lock <File/Password> /<Password>")
	print("EG, Usage: Lock myfile mypassword")
	print("This will allow you to encrypt a file")
	print("EG, Usage: Lock mypassword")
	print("This command however is dangerous, it will encrypt every file, excluding itself")
    return false
elseif #tArgs == 2 then
--Lock 1 file
bool1 = true
end--end if
if fs.exists("aes") then
	local ok, err = pcall(
		function()
			os.loadAPI("aes")
		end--end try
	)
	if not ok then
	print("Failed to load driver, reinstalling...")
	InstallLib()
	end
else
print("Installing driver")
	InstallLib()
end
if (bool1) then
--Lock single file
LockFile()
else
--Lock system
LockSystem()
end--end if
end--end function
function LockFile()
	if (fs.exists(tArgs[1])) then
		if not (fs.isReadOnly(tArgs[1])) then
			if not fs.isDir(tArgs[1]) then
			for cnt = 1,#blacklist do
				if(blacklist[cnt] == tArgs[1]) then
					return false
				end--end if
			end--end for
				local f1 = fs.open(tArgs[1], "r")
				local data = f1.readAll()
				f1.close()
				if not string.find(data, PrivateKeyCode) then
					data = data.."\n"..PrivateKeyCode--This message is added to any encrypted file for when decrypting, it will not overwrite with malformed data.
					--Fun fact !
					--"Heil Hitler" was the code the germans used during WW2, to encrpt their messages, and to decrypt their messages to prevent any maldecrypted messages to say the wrong information on their enigma machines.
					--This same method is used through out these programs to ensure swift and successful data cryption.
					--Watch the movie, 'The Imitation Game' ... That's what I did lol
					--I am a strong believer in privacy and piracy. Hack The Planet !
					--And with that fact in your head... Nazi germany inspided ways to improve my code :')
				end--end find
				local returnstring= " "
				--Try and catch
				local ok, err = pcall(
					function()
						returnstring = aes.encrypt(data, tArgs[2])
					end--end try
				)
				if returnstring ~= " " then
					h = fs.open(tArgs[1], "w")
					h.writeLine(returnstring)
					h.flush()
					h.close()
				end--end if returnstring is not blank
			end--end if not dir
		end--end if readonly
	end--end if exists
end--end function
function LockSystem()
OpenFolder("/")
end--end function
function InstallLib()
	local ok, err = pcall(
		function()
			h = http.get("https://pastebin.com/raw/AP6eqKNm")
			--Mirror https://hastebin.com/raw/guwizehofa
			FileData = h.readAll()
			h.close()
			local file1 = fs.open("aes", "w")
			file1.write(FileData)
			file1.close()
		end--end try
	)
	if ok then
		print("Sucessfully installed driver")
	else
	print(err)
		return false
	end
	
end--end function
function OpenFolder(Folder1)
local t = fs.list(Folder1) 
	if #t > 0 then	
		for k, v in pairs(t) do	
			bool2 = false
			local sFullName = fs.combine(Folder1, v)
			if not (fs.isReadOnly(v)) then
				if fs.isDir(v) then
					OpenFolder(Folder1.."/"..v)
				else
					for cnt = 1,#blacklist do
						if(string.lower(blacklist[cnt]) == string.lower(sFullName)) then
							bool2 = true
							break
						end--end if
					end--end for
					if bool2 == false then
						local f1 = fs.open(sFullName, "r")
						local data = f1.readAll()
						f1.close()
						if not string.find(data, PrivateKeyCode) then
							data = data.."\n"..PrivateKeyCode
						end--end if find
						local returnstring= " "
						--Try and catch
						local ok, err = pcall(
							function()
								returnstring = aes.encrypt(data, tArgs[1])
							end--end try
						)
						if returnstring ~= " " then
						h = fs.open(sFullName, "w")
						h.writeLine(returnstring)
						h.flush()
						h.close()
						end
					end--end if bool
				end--end if file
			end--end if read only
   -- os.sleep(0.3)
		end--end for3
    end--end if
end--end function
bootstrap()