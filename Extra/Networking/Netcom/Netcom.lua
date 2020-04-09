local Args = { ... }

local RouterID = 3
--This is the ID of your router


function run()
    if string.lower(Args[1]) == string.lower("send") then
        if #Args >= 5 then
            RouterID = Args[2]
            RemoteID = Args[3]
            Protocol = Args[4]
            Msg = ""
            for i=5, #Args do
                if i == #Args then
                    Msg = Msg..Args[i]
                else
                    Msg = Msg..Args[i].." "
                end
                i = i +1
            end--end for loop
            if string.find(Protocol, "|") then
                Protocol = Protocol:gsub('|','{PIPE}')
            end--end if contains pipe
            if string.find(Msg, "|") then
                Msg = Msg:gsub('|','{PIPE}')
            end--end if contains pipe
            rednet.send(tonumber(RouterID), "|Send|"..RemoteID.."|"..Protocol.."|"..Msg.."|")
        end
    elseif string.lower(Args[1]) == string.lower("routerjoin") then
        if #Args >= 3 then
            RouterID = Args[2]
            Pass = ""
            for i=5, #Args do
                if i == #Args then
                    Pass= Pass..Args[i]
                else
                    Pass = Pass..Args[i].." "
                end
                i = i +1
            end--end for loop
            if string.find(Pass, "|") then
                Pass = Pass:gsub('|','{PIPE}')
            end--end if contains pipe
            rednet.send(tonumber(RouterID), "|join|"..Pass.."|")
        end--end args
    elseif string.lower(Args[1]) == string.lower("routerleave") then
        if #Args == 2 then
            RouterID = Args[2]
            rednet.send(tonumber(RouterID), "|leave|")
        end--end args length
    end--end if send
end
   

if #Args == 0 then
    print("Usage: Netcom Send <RouterID> <RemoteID> <Protocol> <Msg>")
    print("Usage Netcom RouterJoin <RouterID> <Password>")
    print("Usage Netcom RouterLeave <RouterID>")
    return
else
    run()
end