ValueCmds = {}
function AddValueCommand(cmd, cfgvar, global)
	ValueCmds[cmd] = { var = cfgvar, global = global }
	concommand.Add(cmd, ccValueCommand)
end

function ccValueCommand(ply, cmd, args)
	local valuecmd = ValueCmds[cmd]

	if not valuecmd then return end

	if #args < 1 then
		if valuecmd.global then
			if ply:EntIndex() == 0 then
				print(cmd .. " = " .. GetGlobalInt(valuecmd.var))
			else
				ply:PrintMessage(2, cmd .. " = " .. GetGlobalInt(valuecmd.var))
			end
		else
			if ply:EntIndex() == 0 then
				print(cmd .. " = " .. CfgVars[valuecmd.var])
			else
				ply:PrintMessage(2, cmd .. " = " .. CfgVars[valuecmd.var])
			end
		end
		return
	end

	if not ply:HasPriv(ADMIN) then
		ply:PrintMessage(2, "You're not an admin")
		return
	end

	local amount = math.floor(tonumber(args[1]))

	if valuecmd.global then
		SetGlobalInt(valuecmd.var, amount)
	else
		CfgVars[valuecmd.var] = amount
	end

	local nick = ""

	if ply:EntIndex() == 0 then
		nick = "Console"
	else
		nick = ply:Nick()
	end

	NotifyAll(0, 4, nick .. " set " .. cmd .. " to " .. amount)
end

ToggleCmds = {}
function AddToggleCommand(cmd, cfgvar, global)
	ToggleCmds[cmd] = {var = cfgvar, global = global}
	concommand.Add(cmd, ccToggleCommand)
end

function ccToggleCommand(ply, cmd, args)
	local togglecmd = ToggleCmds[cmd]

	if not togglecmd then return end

	if #args < 1 then
		if togglecmd.global then
			if ply:EntIndex() == 0 then
				print(cmd .. " = " .. GetGlobalInt(togglecmd.var))
			else
				ply:PrintMessage(2, cmd .. " = " .. GetGlobalInt(togglecmd.var))
			end
		else
			if ply:EntIndex() == 0 then
				print(cmd .. " = " .. CfgVars[togglecmd.var])
			else
				ply:PrintMessage(2, cmd .. " = " .. CfgVars[togglecmd.var])
			end
		end
		return
	end

	if not DB.HasPriv(ply, ADMIN) then
		ply:PrintMessage(2, "Admin only!")
		return
	end

	local toggle = tonumber(args[1])

	if not toggle or (toggle ~= 1 and toggle ~= 0) then
		if ply:EntIndex() == 0 then
			print("Invalid number; must be 1 or 0.")
		else
			ply:PrintMessage(2, "Invalid number; must be 1 or 0.")
		end
		return
	end

	if togglecmd.global then
		SetGlobalInt(togglecmd.var, toggle)
	else
		CfgVars[togglecmd.var] = toggle
	end

	local nick = ""

	if ply:EntIndex() == 0 then
		nick = "Console"
	else
		nick = ply:Nick()
	end

	NotifyAll(0, 3, nick .. " set " .. cmd .. " to " .. toggle)
end

--------------------------------------------------------------------------------------------------
--Cfg Var Toggling
--------------------------------------------------------------------------------------------------

-- Usage of AddToggleCommand
-- (command name,  cfg variable name, is it a global variable or a cfg variable?)

AddToggleCommand("rp_propertytax", "propertytax", false)
AddHelpLabel(-1, HELP_CATEGORY_ADMINTOGGLE, "rp_propertytax - Enable/disable property tax.")

AddToggleCommand("rp_citpropertytax", "cit_propertytax", false)
AddHelpLabel(-1, HELP_CATEGORY_ADMINTOGGLE, "rp_citpropertytax - Enable/disable property tax that is exclusive only for citizens.")

AddToggleCommand("rp_bannedprops", "banprops", false)
AddHelpLabel(-1, HELP_CATEGORY_ADMINTOGGLE, "rp_bannedprops - Whether or not the banned props list is active. (overrides allowed props)")

AddToggleCommand("rp_allowedprops", "allowedprops", false)
AddHelpLabel(-1, HELP_CATEGORY_ADMINTOGGLE, "rp_allowedprops - Whether or not the allowed props list is active.")

AddToggleCommand("rp_strictsuicide", "strictsuicide", false)
AddHelpLabel(-1, HELP_CATEGORY_ADMINTOGGLE, "rp_strictsuicide - Whether or not players should spawn where they suicided (regardless of whether or not they are arrested.")

AddToggleCommand("rp_ooc", "ooc", false)
AddHelpLabel(-1, HELP_CATEGORY_ADMINTOGGLE, "rp_ooc - Whether or not OOC tags are enabled.")

AddToggleCommand("rp_alltalk", "alltalk", false)
AddHelpLabel(-1, HELP_CATEGORY_ADMINTOGGLE, "rp_alltalk - Enable for global chat, disable for local chat.")

AddToggleCommand("rp_allowrpnames", "allowrpnames", false)
AddHelpLabel(-1, HELP_CATEGORY_ADMINTOGGLE, "rp_allowrpnames - Allow Players to Set their RP names using the /rpname command.")

AddToggleCommand("rp_globaltags", "globalshow", true)
AddHelpLabel(-1, HELP_CATEGORY_ADMINTOGGLE, "rp_globaltags - Whether or not to display player info above players' heads in-game.")

AddToggleCommand("rp_showcrosshairs", "crosshair", false)
AddHelpLabel(-1, HELP_CATEGORY_ADMINTOGGLE, "rp_showcrosshairs - Enable/disable crosshair visibility")

AddToggleCommand("rp_showjob", "jobtag", true)
AddHelpLabel(-1, HELP_CATEGORY_ADMINTOGGLE, "rp_showjob - Whether or not to display a player's job above their head in-game.")

AddToggleCommand("rp_showname", "nametag", true)
AddHelpLabel(-1, HELP_CATEGORY_ADMINTOGGLE, "rp_showname - Whether or not to display a player's name above their head in-game.")

AddToggleCommand("rp_showdeaths", "deathnotice", true)
AddHelpLabel(-1, HELP_CATEGORY_ADMINTOGGLE, "rp_showdeaths - Display kill information in the upper right corner of everyone's screen.")

AddToggleCommand("rp_deathblack", "deathblack", true)
AddHelpLabel(-1, HELP_CATEGORY_ADMINTOGGLE, "rp_deathblack - Whether or not a player sees black on death.")

AddToggleCommand("rp_toolgun", "toolgun", false)
AddHelpLabel(-1, HELP_CATEGORY_ADMINTOGGLE, "rp_toolgun - Whether or not non-admin players spawn with toolguns.")

AddToggleCommand("rp_propspawning", "propspawning", false)
AddHelpLabel(-1, HELP_CATEGORY_ADMINTOGGLE, "rp_propspawning - Enable/disable props spawning for non-admins.")

AddToggleCommand("rp_proppaying", "proppaying", false)
AddHelpLabel(-1, HELP_CATEGORY_ADMINTOGGLE, "rp_proppaying - Whether or not players should pay for spawning props.")

AddToggleCommand("rp_adminsweps", "adminsweps", false)
AddHelpLabel(-1, HELP_CATEGORY_ADMINTOGGLE, "rp_adminsweps - Whether or not SWEPs should be admin only.")

AddToggleCommand("rp_adminsents", "adminsents", false)
AddHelpLabel(-1, HELP_CATEGORY_ADMINTOGGLE, "rp_adminsents - Whether or not SENTs should be admin only.")

AddToggleCommand("rp_enforcemodels", "enforceplayermodel", false)
AddHelpLabel(-1, HELP_CATEGORY_ADMINTOGGLE, "rp_enforcemodels - Whether or not to force players to use their role-defined character models.")

AddToggleCommand("rp_letters", "letters", false)
AddHelpLabel(-1, HELP_CATEGORY_ADMINTOGGLE, "rp_letters - Enable/disable letter writing / typing.")

AddToggleCommand("rp_cpvoting", "cpvoting", false)
AddHelpLabel(-1, HELP_CATEGORY_ADMINTOGGLE, "rp_cpvoting - Enable/disable /votecop.")

AddToggleCommand("rp_mayorvoting", "mayorvoting", false)
AddHelpLabel(-1, HELP_CATEGORY_ADMINTOGGLE, "rp_mayorvoting - Enable/disable /votemayor.")

AddToggleCommand("rp_cptomayor", "cptomayoronly", false)
AddHelpLabel(-1, HELP_CATEGORY_ADMINTOGGLE, "rp_cptomayor - Enable/disable whether /votemayor is a CP only command.")

AddToggleCommand("rp_earthquakes", "earthquakes", false)
AddHelpLabel(-1, HELP_CATEGORY_ADMINTOGGLE, "rp_earthquakes - Enable/disable earthquakes.")

AddToggleCommand("rp_customjobs", "customjobs", false)
AddHelpLabel(-1, HELP_CATEGORY_ADMINTOGGLE, "rp_customjobs - Enable/disable the /job command (personalized job names).")

AddToggleCommand("rp_copscanunfreeze", "copscanunfreeze", false)
AddHelpLabel(-1, HELP_CATEGORY_ADMINTOGGLE, "rp_copscanunfreeze - Enable/disable the ability of cops to freeze other people's props")

AddToggleCommand("rp_removeclassitems",  "removeclassitems", false)
AddHelpLabel(-1, HELP_CATEGORY_ADMINTOGGLE, "rp_removeclassitems - Enable/disable shipments/microwaves/etc. removal when someone changes team.")


--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------

function ccDoorOwn(ply, cmd, args)
	if ply:EntIndex() == 0 then
		return
	end

	if not ply:HasPriv(ADMIN) then
		ply:PrintMessage(2, "You're not an admin")
		return
	end

	local trace = ply:GetEyeTrace()

	if not ValidEntity(trace.Entity) or not trace.Entity:IsOwnable() or ply:EyePos():Distance(trace.Entity:GetPos()) > 200 then
		return
	end

	trace.Entity:Fire("unlock", "", 0)
	trace.Entity:UnOwn()
	trace.Entity:Own(ply)
end
concommand.Add("rp_own", ccDoorOwn)
AddHelpLabel(-1, HELP_CATEGORY_ADMINCMD, "rp_own - Own the door you're looking at.")

function ccDoorUnOwn(ply, cmd, args)
	if ply:EntIndex() == 0 then
		return
	end

	if not ply:HasPriv(ADMIN) then
		ply:PrintMessage(2, "You're not an admin!")
		return
	end

	local trace = ply:GetEyeTrace()

	if not ValidEntity(trace.Entity) or not trace.Entity:IsOwnable() or ply:EyePos():Distance(trace.Entity:GetPos()) > 200 then
		return
	end

	trace.Entity:Fire("unlock", "", 0)
	trace.Entity:UnOwn()
end
concommand.Add("rp_unown", ccDoorUnOwn)
AddHelpLabel(-1, HELP_CATEGORY_ADMINCMD, "rp_unown - Remove ownership from the door you're looking at.")

function ccAddOwner(ply, cmd, args)
	if ply:EntIndex() == 0 then
		return
	end

	if not ply:HasPriv(ADMIN) then
		ply:PrintMessage(2, "You're not an admin!")
		return
	end

	local trace = ply:GetEyeTrace()

	if not ValidEntity(trace.Entity) or not trace.Entity:IsOwnable() or ply:EyePos():Distance(trace.Entity:GetPos()) > 200 then
		return
	end

	target = FindPlayer(args[1])

	if target then
		if trace.Entity:IsOwned() then
			if not trace.Entity:OwnedBy(target) and not trace.Entity:AllowedToOwn(target) then
				trace.Entity:AddAllowed(target)
			else
				ply:PrintMessage(2, "Player already owns (or is already allowed to own) this door!")
			end
		else
			trace.Entity:Own(target)
		end
	else
		ply:PrintMessage(2, "Could not find player: " .. args)
	end
end
concommand.Add("rp_addowner", ccAddOwner)
AddHelpLabel(-1, HELP_CATEGORY_ADMINCMD, "rp_addowner [Nick|SteamID|UserID] - Add a co-owner to the door you're looking at.")

function ccRemoveOwner(ply, cmd, args)
	if ply:EntIndex() == 0 then
		return
	end

	if not ply:HasPriv(ADMIN) then
		ply:PrintMessage(2, "You're not an admin!")
		return
	end

	local trace = ply:GetEyeTrace()

	if not ValidEntity(trace.Entity) or not trace.Entity:IsOwnable() or ply:EyePos():Distance(trace.Entity:GetPos()) > 200 then
		return
	end

	target = FindPlayer(args[1])

	if target then
		if trace.Entity:AllowedToOwn(target) then
			trace.Entity:RemoveAllowed(target)
		end

		if trace.Entity:OwnedBy(target) then
			trace.Entity:RemoveOwner(target)
		end
	else
		ply:PrintMessage(2, "Could not find player: " .. args)
	end
end
concommand.Add("rp_removeowner", ccRemoveOwner)
AddHelpLabel(-1, HELP_CATEGORY_ADMINCMD, "rp_removeowner [Nick|SteamID|UserID] - Remove co-owner from door you're looking at.")

function ccLock(ply, cmd, args)
	if ply:EntIndex() == 0 then
		return
	end

	if not ply:HasPriv(ADMIN) then
		ply:PrintMessage(2, "You're not an admin!")
		return
	end

	local trace = ply:GetEyeTrace()

	if not ValidEntity(trace.Entity) or not trace.Entity:IsOwnable() or ply:EyePos():Distance(trace.Entity:GetPos()) > 200 then
		return
	end

	ply:PrintMessage(2, "Locked.")

	trace.Entity:Fire("lock", "", 0)
end
concommand.Add("rp_lock", ccLock)
AddHelpLabel(-1, HELP_CATEGORY_ADMINCMD, "rp_lock - Lock the door you're looking at.")

function ccUnLock(ply, cmd, args)
	if ply:EntIndex() == 0 then
		return
	end

	if not ply:HasPriv(ADMIN) then
		ply:PrintMessage(2, "You're not an admin!")
		return
	end

	local trace = ply:GetEyeTrace()

	if not ValidEntity(trace.Entity) or not trace.Entity:IsOwnable() or ply:EyePos():Distance(trace.Entity:GetPos()) > 200 then
		return
	end

	ply:PrintMessage(2, "Unlocked.")
	trace.Entity:Fire("unlock", "", 0)
end
concommand.Add("rp_unlock", ccUnLock)
AddHelpLabel(-1, HELP_CATEGORY_ADMINCMD, "rp_unlock - Unlock the door you're looking at.")

AddValueCommand("rp_propcost", "propcost", false)
AddHelpLabel(-1, HELP_CATEGORY_ADMINCMD, "rp_propcost <Number> - How much prop spawning should cost. (prop paying must be enabled for this to have an effect)")

AddValueCommand("rp_maxcps", "maxcps", false)
AddHelpLabel(-1, HELP_CATEGORY_ADMINCMD, "rp_maxcps <Number> - Maximum number of CPs.")

function ccTell(ply, cmd, args)
	if not ply:HasPriv(ADMIN) then
		ply:PrintMessage(2, "You're not an admin!")
		return
	end

	local target = FindPlayer(args[1])

	if target then
		local msg = ""

		for n = 2, #args do
			msg = msg .. args[n] .. " "
		end

		umsg.Start("AdminTell", target)
			umsg.String(msg)
		umsg.End()
	else
		if ply:EntIndex() == 0 then
			print("Could not find player: " .. args[1])
		else
			ply:PrintMessage(2, "Could not find player: " .. args[1])
		end
	end
end
concommand.Add("rp_tell", ccTell)
AddHelpLabel(-1, HELP_CATEGORY_ADMINCMD, "rp_tell [Nick|SteamID|UserID] <Message> - Send a noticeable message to a named player.")

function ccRemoveLetters(ply, cmd, args)
	if not ply:HasPriv(ADMIN) then
		ply:PrintMessage(2, "You're not an admin!")
		return
	end

	local target = FindPlayer(args[1])

	if target then
		for k, v in pairs(ents.FindByClass("letter")) do
			if v.SID == target.SID then v:Remove() end
		end
	else
		-- Remove ALL letters
		for k, v in pairs(ents.FindByClass("letter")) do
			v:Remove()
		end
	end
end
concommand.Add("rp_removeletters", ccRemoveLetters)
AddHelpLabel(-1, HELP_CATEGORY_ADMINCMD, "rp_removeletters [Nick|SteamID|UserID] - Remove all letters for a given player (or all if none specified).")

function ccSetChatCmdPrefix(ply, cmd, args)
	if ply:EntIndex() ~= 0 and not ply:IsAdmin() and not ply:IsSuperAdmin() then
		ply:PrintMessage(2, "You're not a server admin!")
		return
	end

	local oldprefix = GetGlobalString("cmdprefix")
	SetGlobalString("cmdprefix", args[1])

	if ply:EntIndex() == 0 then
		nick = "Console"
	else
		nick = ply:Nick()
	end

	NotifyAll(0, 3, nick .. " set rp_chatprefix to " .. args[1])

	GenerateChatCommandHelp()

	for k, v in pairs(ChatCommands) do
		if not v.prefixconst then
			v.cmd = string.gsub(v.cmd, oldprefix, args[1])
		end
	end

	umsg.Start("UpdateHelp")
	umsg.End()
end
concommand.Add("rp_chatprefix", ccSetChatCmdPrefix)
AddHelpLabel(-1, HELP_CATEGORY_ADMINCMD, "rp_chatprefix <Prefix> - Set the chat prefix for commands (like the / in /votecop or /job).")

function ccPayDayTime(ply, cmd, args)
	if ply:EntIndex() ~= 0 and not ply:IsAdmin() and not ply:IsSuperAdmin() then
		ply:PrintMessage(2, "You're not a server admin")
		return
	end

	local amount = math.floor(tonumber(args[1]))

	if not amount then return end

	CfgVars["paydelay"] = amount

	for k, v in pairs(player.GetAll()) do
		v:UpdateJob(v:GetNWString("job"))
	end

	if ply:EntIndex() == 0 then
		nick = "Console"
	else
		nick = ply:Nick()
	end

	NotifyAll(0, 3, nick .. " set rp_paydaytime to " .. amount)
end
concommand.Add("rp_paydaytime", ccPayDayTime)
AddHelpLabel(-1, HELP_CATEGORY_ADMINCMD, "rp_paydaytime <Delay> - Pay interval. (in seconds)")

function ccArrest(ply, cmd, args)
	if not ply:HasPriv(ADMIN) then
		ply:PrintMessage(2, "You're not an admin")
		return
	end

	if DB.CountJailPos() == 0 then
		if ply:EntIndex() == 0 then
			print("No jail positions yet!\n")
		else
			ply:PrintMessage(2, "No jail positions yet!")
		end
		return
	end

	local target = FindPlayer(args[1])
	if target then
		local length = tonumber(args[2])
		if length then
			target:Arrest(length)
		else
			target:Arrest()
		end
	else
		if ply:EntIndex() == 0 then
			print("Could not find player: " .. args[1])
		else
			ply:PrintMessage(2, "Could not find player: " .. args[1])
		end
	end
end
concommand.Add("rp_arrest", ccArrest)
AddHelpLabel(-1, HELP_CATEGORY_ADMINCMD, "rp_arrest [Nick|SteamID|UserID] <Length> - Arrest a player for a custom amount of time. If no time is specified, it will default to " .. GetGlobalInt("jailtimer") .. " seconds.")

function ccUnarrest(ply, cmd, args)
	if not ply:HasPriv(ADMIN) then
		ply:PrintMessage(2, "You're not an admin!")
		return
	end

	local target = FindPlayer(args[1])

	if target then
		target:Unarrest()
	else
		if ply:EntIndex() == 0 then
			print("Could not find player: " .. args[1])
		else
			ply:PrintMessage(2, "Could not find player: " .. args[1])
		end
		return
	end
end
concommand.Add("rp_unarrest", ccUnarrest)
AddHelpLabel(-1, HELP_CATEGORY_ADMINCMD, "rp_unarrest [Nick|SteamID|UserID] - Unarrest a player.")

function ccMayor(ply, cmd, args)
	if not ply:HasPriv(ADMIN) then
		ply:PrintMessage(2, "You're not an admin!")
		return
	end

	local target = FindPlayer(args[1])

	if target then
		target:SetTeam(TEAM_MAYOR)
		target:UpdateJob("Mayor")
		target:KillSilent()
		local mnew = CfgVars["normalsalary"] + 40
		target:SetNWInt("salary", mnew)
		local nick = ""

		if ply:EntIndex() ~= 0 then
			nick = ply:Nick()
		else
			nick = "Console"
		end

		target:PrintMessage(2, nick .. " made you Mayor!")
	else
		if ply:EntIndex() == 0 then
			print("Could not find player: " .. args[1])
		else
			ply:PrintMessage(2, "Could not find player: " .. args[1])
		end
		return
	end
end
concommand.Add("rp_mayor", ccMayor)
AddHelpLabel(-1, HELP_CATEGORY_ADMINCMD, "rp_mayor [Nick|SteamID|UserID] - Make a player the Mayor.")

function ccCPChief(ply, cmd, args)
	if not ply:HasPriv(ADMIN) then
		ply:PrintMessage(2, "You're not an admin!")
		return
	end

	local target = FindPlayer(args[1])

	if target then
		target:ChangeTeam(TEAM_CHIEF)
		target:PrintMessage(2, nick .. " made you a CP Chief!")
	else
		print("Could not find player: " .. args[1])
		return
	end
end
concommand.Add("rp_cpchief", ccCPChief)
AddHelpLabel(-1, HELP_CATEGORY_ADMINCMD, "rp_cpchief [Nick|SteamID|UserID] - Make a player the CP Chief.")

function ccCP(ply, cmd, args)
	if not ply:HasPriv(ADMIN) then
		ply:PrintMessage(2, "You're not an admin!")
		return
	end

	local target = FindPlayer(args[1])

	if target then
		target:ChangeTeam(TEAM_POLICE)

		if ply:EntIndex() ~= 0 then
			nick = ply:Nick()
		else
			nick = "Console"
		end

		target:PrintMessage(2, nick .. " made you a CP!")
	else
		if ply:EntIndex() == 0 then
			print("Could not find player: " .. args[1])
		else
			ply:PrintMessage(2, "Could not find player: " .. args[1])
		end
		return
	end
end
concommand.Add("rp_cp", ccCP)
AddHelpLabel(-1, HELP_CATEGORY_ADMINCMD, "rp_cp [Nick|SteamID|UserID] - Make a player into a CP.")

function ccCitizen(ply, cmd, args)
	if not ply:HasPriv(ADMIN) then
		ply:PrintMessage(2, "You're not an admin!")
		return
	end

	local target = FindPlayer(args[1])

	if target then
		target:ChangeTeam(TEAM_CITIZEN)

		if ply:EntIndex() ~= 0 then
			nick = ply:Nick()
		else
			nick = "Console"
		end

		target:PrintMessage(2, nick .. " made you a Citizen!")
	else
		if ply:EntIndex() == 0 then
			print("Could not find player: " .. args[1])
		else
			ply:PrintMessage(2, "Could not find player: " .. args[1])
		end
		return
	end
end
concommand.Add("rp_citizen", ccCitizen)
AddHelpLabel(-1, HELP_CATEGORY_ADMINCMD, "rp_citizen [Nick|SteamID|UserID] - Make a player become a Citizen.")

for k,v in pairs(RPExtraTeams) do
	concommand.Add("rp_"..v.command, function(ply, cmd, args)
		if (ply:EntIndex() ~= 0 and not ply:HasPriv(ADMIN)) then
			ply:PrintMessage(2, "You're not an admin!")
			return
        end
		
		if v.admin > 1 and not ply:IsSuperAdmin() then
			ply:PrintMessage(2, "You're not a super admin!")
			return
		end
		
		if v.Vote then
			if v.admin == 1 and not ply:IsSuperAdmin() then
				ply:PrintMessage(2, "You're not a super admin!")
				return
			elseif v.admin > 1 and ply:IsSuperAdmin() then
				ply:PrintMessage(2, "You cannot make anyone "..v.name.." because voting is on and admin is set to super admin. Make a vote...")
				return
			end
		end
		local target = FindPlayer(args[1])
		
        if (target) then
			target:ChangeTeam(9 + k)
			if (ply:EntIndex() ~= 0) then
				nick = ply:Nick()
			else
				nick = "Console"
			end
			target:PrintMessage(2, nick .. " made you a " .. v.name .. "!")
        else
			if (ply:EntIndex() == 0) then
				print("Could not find player: " .. args[1])
			else
				ply:PrintMessage(2, "Could not find player: " .. args[1])
			end
			return
        end
	end)
	AddHelpLabel(-1, HELP_CATEGORY_ADMINCMD, "rp_"..v.command.. " [Nick|SteamID|UserID] - Make a player become a "..v.name..".")
end
		

function ccKickBan(ply, cmd, args)
	if not ply:HasPriv(ADMIN) then
		ply:PrintMessage(2, "You're not an admin!")
		return
	end

	local target = FindPlayer(args[1])

	if target then
		if not args[2] then
			args[2] = 0
		end

		if (target:HasPriv(ADMIN) or target:IsAdmin() or target:IsSuperAdmin()) and (not ply:IsAdmin() or not ply:IsSuperAdmin()) then
			ply:PrintMessage(2, "Normal RP admins can not kick or ban another admin!")
			return
		end

		game.ConsoleCommand("banid " .. args[2] .. " " .. target:UserID() .. "\n")
		game.ConsoleCommand("kickid " .. target:UserID() .. " \"Kicked and Banned\"\n")
	else
		if ply:EntIndex() == 0 then
			print("Could not find player: " .. args[1])
		else
			ply:PrintMessage(2, "Could not find player: " .. args[1])
		end
		return
	end
end
concommand.Add("rp_kickban", ccKickBan)
AddHelpLabel(-1, HELP_CATEGORY_ADMINCMD, "rp_kickban [Nick|SteamID|UserID] <Length in minutes> - Kick and ban a player.")

function ccKick(ply, cmd, args)
	if not ply:HasPriv(ADMIN) then
		ply:PrintMessage(2, "You're not an admin!")
		return
	end

	local target = FindPlayer(args[1])

	if target then
		if (target:HasPriv(ADMIN) or target:IsAdmin() or target:IsSuperAdmin()) and (not ply:IsAdmin() or not ply:IsSuperAdmin()) then
			ply:PrintMessage(2, "Normal RP admins can not kick or ban another admin!")
			return
		end

		local reason = ""

		if args[2] then
			for n = 2, #args do
				reason = reason .. args[n]
				reason = reason .. " "
			end
		end

		game.ConsoleCommand("kickid " .. target:UserID() .. " \"" .. reason .. "\"\n")
	else
		if ply:EntIndex() == 0 then
			print("Could not find player: " .. args[1])
		else
			ply:PrintMessage(2, "Could not find player: " .. args[1])
		end
		return
	end
end
concommand.Add("rp_kick", ccKick)
AddHelpLabel(-1, HELP_CATEGORY_ADMINCMD, "rp_kick [Nick|SteamID|UserID] <Kick reason> - Kick a player. The reason is optional.")

function ccSetMoney(ply, cmd, args)
	if ply:EntIndex() ~= 0 and not ply:IsAdmin() and not ply:IsSuperAdmin() then
		ply:PrintMessage(2, "You're not a server admin!")
		return
	end

	local amount = math.floor(tonumber(args[2]))

	if not amount then
		if ply:EntIndex() == 0 then
			print("Invalid amount of money: " .. args[2])
		else
			ply:PrintMessage(2, "Invalid amount of money: " .. args[2])
		end
		return
	end

	local target = FindPlayer(args[1])

	if target then
		local nick = ""
		target:SetNWInt("money", amount)
		target:SetNWString("moneyshow", amount)
		DB.StoreMoney(target, amount)

		if ply:EntIndex() == 0 then
			print("Set " .. target:Nick() .. "'s money to: " .. CUR .. amount)
			nick = "Console"
		else
			ply:PrintMessage(2, "Set " .. target:Nick() .. "'s money to: " .. CUR .. amount)
			nick = ply:Nick()
		end
		target:PrintMessage(2, nick .. " set your money to: " .. CUR .. amount)
	else
		if ply:EntIndex() == 0 then
			print("Could not find player: " .. args[1])
		else
			ply:PrintMessage(2, "Could not find player: " .. args[1])
		end
		return
	end
end
concommand.Add("rp_setmoney", ccSetMoney)
AddHelpLabel(-1, HELP_CATEGORY_ADMINCMD, "rp_setmoney [Nick|SteamID|UserID] <Amount> - Set a player's money to a specific amount.")

function ccSetSalary(ply, cmd, args)
	if ply:EntIndex() ~= 0 and not ply:IsAdmin() and not ply:IsSuperAdmin() then
		ply:PrintMessage(2, "You're not a server admin!")
		return
	end

	local amount = math.floor(tonumber(args[2]))

	if not amount or amount < 0 then
		if ply:EntIndex() == 0 then
			print("Invalid Salary: " .. args[2])
		else
			ply:PrintMessage(2, "Invalid Salary: " .. args[2])
		end
		return
	end

	if amount > 150 then
		if ply:EntIndex() == 0 then
			print("Salary must be below " .. CUR .. "150")
		else
			ply:PrintMessage(2, "Salary must be less than or equal to " .. CUR .. "150")
		end
		return
	end

	local target = FindPlayer(args[1])

	if target then
		local nick = ""
		DB.StoreSalary(target, amount)
		target:SetNWInt("salary", amount)
		if ply:EntIndex() == 0 then
			print("Set " .. target:Nick() .. "'s Salary to: " .. CUR .. amount)
			nick = "Console"
		else
			ply:PrintMessage(2, "Set " .. target:Nick() .. "'s Salary to: " .. CUR .. amount)
			nick = ply:Nick()
		end
		target:PrintMessage(2, nick .. " set your Salary to: " .. CUR .. amount)
	else
		if ply:EntIndex() == 0 then
			print("Could not find player: " .. args[1])
		else
			ply:PrintMessage(2, "Could not find player: " .. args[1])
		end
		return
	end
end
concommand.Add("rp_setsalary", ccSetSalary)
AddHelpLabel(-1, HELP_CATEGORY_ADMINCMD, "rp_setsalary [Nick|SteamID|UserID] <Amount> - Set a player's Roleplay Salary.")

function ccGrantPriv(ply, cmd, args)
	if not ply:IsSuperAdmin() then
		ply:PrintMessage(2, "You're not a super admin!")
		return
	end

	local target = FindPlayer(args[2])

	if target then
		if args[1] == "tool" then
			DB.GrantPriv(target, TOOL)
			Notify(target, 1, 3, ply:Nick() .. " has granted you toolgun priveleges.")
		elseif args[1] == "admin" then
			DB.GrantPriv(target, ADMIN)
			Notify(target, 1, 3, ply:Nick() .. " has granted you admin priveleges.")
		elseif args[1] == "phys" then
			DB.GrantPriv(target, PHYS)
			Notify(target, 1, 3, ply:Nick() .. " has granted you physgun priveleges.")
		elseif args[1] == "prop" then
			DB.GrantPriv(target, PROP)
			Notify(target, 1, 3, ply:Nick() .. " has granted you prop spawn priveleges.")
		elseif args[1] == "mayor" then
			DB.GrantPriv(target, MAYOR)
			Notify(target, 1, 3, ply:Nick() .. " has granted you /mayor priveleges.")
		elseif args[1] == "cp" then
			DB.GrantPriv(target, CP)
			Notify(target, 1, 3, ply:Nick() .. " has granted you /cp priveleges.")
		else
			if ply:EntIndex() == 0 then
				print("There is not a " .. args[1] .. " privilege!")
			else
				ply:PrintMessage(2, "There is not a " .. args[1] .. " privilege!")
			end
		end
	else
		if ply:EntIndex() == 0 then
			print("Could not find player: " .. args[2])
		else
			ply:PrintMessage(2, "Could not find player: " .. args[2])
		end
	end
end
concommand.Add("rp_grant", ccGrantPriv)
AddHelpLabel(-1, HELP_CATEGORY_ADMINCMD, "rp_grant [tool|phys|admin|prop|cp|mayor] [Nick|SteamID|UserID] - Gives a privilege to a player.")

function ccRevokePriv(ply, cmd, args)
	if not ply:IsSuperAdmin() then
		ply:PrintMessage(2, "You're not a super admin!")
		return
	end

	local target = FindPlayer(args[2])

	if target then
		if args[1] == "tool" then
			DB.RevokePriv(target, TOOL)
			Notify(target, 1, 3, ply:Nick() .. " has revoked your toolgun priveleges.")
		elseif args[1] == "admin" then
			DB.RevokePriv(target, ADMIN)
			Notify(target, 1, 3, ply:Nick() .. " has revoked your admin priveleges.")
		elseif args[1] == "phys" then
			DB.RevokePriv(target, PHYS)
			Notify(target, 1, 3, ply:Nick() .. " has revoked your physgun priveleges.")
		elseif args[1] == "prop" then
			DB.RevokePriv(target, PROP)
			Notify(target, 1, 3, ply:Nick() .. " has revoked your prop spawn priveleges.")
		elseif args[1] == "mayor" then
			DB.RevokePriv(target, MAYOR)
			Notify(target, 1, 3, ply:Nick() .. " has revoked your /mayor priveleges.")
		elseif args[1] == "cp" then
			DB.RevokePriv(target, CP)
			Notify(target, 1, 3, ply:Nick() .. " has revoked your /cp priveleges.")
		else
			if ply:EntIndex() == 0 then
				print("There is not a " .. args[1] .. " privilege!")
			else
				ply:PrintMessage(2, "There is not a " .. args[1] .. " privilege!")
			end
		end
	else
		if ply:EntIndex() == 0 then
			print("Could not find player: " .. args[2])
		else
			ply:PrintMessage(2, "Could not find player: " .. args[2])
		end
		return
	end
end
concommand.Add("rp_revoke", ccRevokePriv)
AddHelpLabel(-1, HELP_CATEGORY_ADMINCMD, "rp_revoke [tool|phys|admin|prop|cp|mayor] [Nick|SteamID|UserID] - Revokes a privilege from a player.")

function ccMute(ply, cmd, args)
	if not ply:HasPriv(ADMIN) then
		ply:PrintMessage(2, "You're not an admin!")
		return
	end

	local target = FindPlayer(args[1])
	if target then
		local vtoggle = tonumber(args[2])
		if vtoggle == 1 then
			vmute(target)
		elseif vtoggle == 0 then
			vunmute(target)
		else
			ply:PrintMessage(2, "Need a 0 or a 1 after the player's name.")
		end
		return
	else
		if ply:EntIndex() == 0 then
			print("Could not find player: " .. args[1])
		else
			ply:PrintMessage(2, "Could not find player: " .. args[1])
		end
		return
	end
end
concommand.Add("rp_mute", ccMute)

function ccSWEPSpawn(ply, cmd, args)
	if CfgVars["adminsweps"] == 1 then
		if not ply:HasPriv(ADMIN) and not ply:IsAdmin() and not ply:IsSuperAdmin() then
			Notify(ply, 1, 2, "You're not an admin!")
			return
		end
	end
	CCSpawnSWEP(ply, cmd, args)
end
concommand.Add("gm_giveswep", ccSWEPSpawn)

function ccSWEPGive(ply, cmd, args)
	if CfgVars["adminsweps"] == 1 then
		if not ply:HasPriv(ADMIN) and not ply:IsAdmin() and not ply:IsSuperAdmin() then
			Notify(ply, 1, 2, "You're not an admin!")
			return
		end
	end
	CCSpawnSWEP(ply, cmd, args)
end
concommand.Add("gm_spawnswep", ccSWEPGive)

function ccSENTSPawn(ply, cmd, args)
	if CfgVars["adminsents"] == 1 then
		if not ply:HasPriv(ADMIN) and not ply:IsAdmin() and not ply:IsSuperAdmin() then
			Notify(ply, 1, 2, "You're not an admin!")
			return
		end
	end
	CCSpawnSENT(ply, cmd, args)
end
concommand.Add("gm_spawnsent", ccSENTSPawn)

AddHelpLabel(-1, HELP_CATEGORY_ADMINCMD, "rp_mute [Nick|SteamID|UserID] <1/0> - Enable/Disable a player's ability to use the voice menu.")

AddValueCommand("rp_ak47cost", "ak47cost", true)
AddHelpLabel(-1, HELP_CATEGORY_ADMINCMD, "rp_ak47cost <Number> - Sets the cost of a shipment of AK47s.")

AddValueCommand("rp_mp5cost", "mp5cost", true)
AddHelpLabel(-1, HELP_CATEGORY_ADMINCMD, "rp_mp5cost <Number> - Sets the cost of a shipment of mp5s.")

AddValueCommand("rp_m16cost", "m16cost", true)
AddHelpLabel(-1, HELP_CATEGORY_ADMINCMD, "rp_m16cost <Number> - Sets the cost of a shipment of m16s.")

AddValueCommand("rp_mac10cost", "mac10cost", true)
AddHelpLabel(-1, HELP_CATEGORY_ADMINCMD, "rp_mac10cost <Number> - Sets the cost of a shipment of mac10s.")

AddValueCommand("rp_shotguncost", "shotguncost", true)
AddHelpLabel(-1, HELP_CATEGORY_ADMINCMD, "rp_shotguncost <Number> - Sets the cost of a shipment of shotguns.")

AddValueCommand("rp_snipercost", "snipercost", true)
AddHelpLabel(-1, HELP_CATEGORY_ADMINCMD, "rp_snipercost <Number> - Sets the cost of a shipment of snipers.")

AddValueCommand("rp_deaglecost", "deaglecost", true)
AddHelpLabel(-1, HELP_CATEGORY_ADMINCMD, "rp_deaglecost <Number> - Sets the cost of a deagle.")

AddValueCommand("rp_fivesevencost", "fivesevencost", true)
AddHelpLabel(-1, HELP_CATEGORY_ADMINCMD, "rp_fivesevencost <Number> - Sets the cost of a five seven.")

AddValueCommand("rp_glockcost", "glockcost", true)
AddHelpLabel(-1, HELP_CATEGORY_ADMINCMD, "rp_glockcost <Number> - Sets the cost of a glock.")

AddValueCommand("rp_p228cost", "p228cost", true)
AddHelpLabel(-1, HELP_CATEGORY_ADMINCMD, "rp_p228cost <Number> - Sets the cost of a p228.")

AddValueCommand("rp_druglabcost", "druglabcost", true)
AddHelpLabel(-1, HELP_CATEGORY_ADMINCMD, "rp_druglabcost <Number> - Sets the cost of a druglab.")

AddValueCommand("rp_ammopistolcost", "ammopistolcost", true)
AddHelpLabel(-1, HELP_CATEGORY_ADMINCMD, "rp_ammopistolcost <Number> - Sets the cost of pistol ammo.")

AddValueCommand("rp_ammoriflecost", "ammoriflecost", true)
AddHelpLabel(-1, HELP_CATEGORY_ADMINCMD, "rp_ammoriflecost <Number> - Sets the cost of rifle ammo.")

AddValueCommand("rp_ammoshotguncost", "ammoshotguncost", true)
AddHelpLabel(-1, HELP_CATEGORY_ADMINCMD, "rp_ammoshotguncost <Number> - Sets the cost of shotgun ammo.")

AddValueCommand("rp_healthcost", "healthcost", true)
AddHelpLabel(-1, HELP_CATEGORY_ADMINCMD, "rp_healthcost <Number> - Sets the cost of health.")

AddValueCommand("rp_jailtimer", "jailtimer", true)
AddHelpLabel(-1, HELP_CATEGORY_ADMINCMD, "rp_jailtimer <Number> - Sets the jailtimer. (in seconds)")

AddValueCommand("rp_maxdruglabs", "maxdruglabs", false)
AddHelpLabel(-1, HELP_CATEGORY_ADMINCMD, "rp_maxdruglabs <Number> - Sets max druglabs.")

AddValueCommand("rp_maxdrugs", "maxdrugs", false)
AddHelpLabel(-1, HELP_CATEGORY_ADMINCMD, "rp_maxdrugs <Number> - Sets max drugs.")

AddValueCommand("rp_maxletters", "maxletters", false)
AddHelpLabel(-1, HELP_CATEGORY_ADMINCMD, "rp_maxletters <Number> - Sets max letters.")

AddValueCommand("rp_maxgangsters", "maxgangsters", false)
AddHelpLabel(-1, HELP_CATEGORY_ADMINCMD, "rp_maxgangsters <Number> - Sets max gangsters.")

AddToggleCommand("rp_allowgang", "allowgang", false)
AddHelpLabel(-1, HELP_CATEGORY_ADMINTOGGLE, "rp_allowgang - Enable/disable gangsters & mob boss.")

AddToggleCommand("rp_allowvehiclenocollide", "allowvnocollide", false)
AddHelpLabel(-1, HELP_CATEGORY_ADMINTOGGLE, "rp_allowvehiclenocollide - Enable/disable the ability to no-collide a vehicle (for security).")

AddToggleCommand("rp_restrictbuypistol", "restrictbuypistol", false)
AddHelpLabel(-1, HELP_CATEGORY_ADMINTOGGLE, "rp_restrictbuypistol - Enabling this feature makes /buypistol available only to Gun Dealers (if one or more).")

AddToggleCommand("rp_noguns", "noguns", false)
AddHelpLabel(-1, HELP_CATEGORY_ADMINTOGGLE, "rp_noguns - Enabling this feature bans Guns and Gun Dealers.")

AddToggleCommand("rp_chiefjailpos", "chiefjailpos", false)
AddHelpLabel(-1, HELP_CATEGORY_ADMINTOGGLE, "rp_chiefjailpos - Allow the Chief to set the jail positions.")

AddToggleCommand("rp_physgun", "physgun", false)
AddHelpLabel(-1, HELP_CATEGORY_ADMINTOGGLE, "rp_physgun - Enable/disable Players spawning with physguns.")

AddValueCommand("rp_doorcost", "doorcost", false)
AddHelpLabel(-1, HELP_CATEGORY_ADMINCMD, "rp_doorcost <Number> - Sets the cost of a door.")

AddValueCommand("rp_vehiclecost", "vehiclecost", false)
AddHelpLabel(-1, HELP_CATEGORY_ADMINCMD, "rp_vehiclecost <Number> - Sets the cost of a vehicle (To own it).")

AddToggleCommand("rp_allowmedics", "allowmedics", false)
AddHelpLabel(-1, HELP_CATEGORY_ADMINTOGGLE, "rp_allowmedics - Enable/disable Medics.")

AddToggleCommand("rp_allowgundealers", "allowdealers", false)
AddHelpLabel(-1, HELP_CATEGORY_ADMINTOGGLE, "rp_allowgundealers - Enable/disable Gun Dealers.")

AddToggleCommand("rp_allowcooks", "allowcooks", false)
AddHelpLabel(-1, HELP_CATEGORY_ADMINTOGGLE, "rp_allowcooks - Enable/disable Cooks.")

AddToggleCommand("rp_allowhobos", "allowhobos", false)
AddHelpLabel(-1, HELP_CATEGORY_ADMINTOGGLE, "rp_allowhobos - Enable/disable Hobos.")

AddToggleCommand("rp_allowpdchief", "allowpdchief", false)
AddHelpLabel(-1, HELP_CATEGORY_ADMINTOGGLE, "rp_allowpdchief - Enable/disable CP Chief as a job.")

AddToggleCommand("rp_enableshipments", "enableshipments", false)
AddHelpLabel(-1, HELP_CATEGORY_ADMINTOGGLE, "rp_enableshipments - Turn /buyshipment on of off.")

AddToggleCommand("rp_enablebuypistol", "enablebuypistol", false)
AddHelpLabel(-1, HELP_CATEGORY_ADMINTOGGLE, "rp_enablebuypistol - Turn /buypistol on of off.")

AddToggleCommand("rp_enablemayorsetsalary", "mayorsetsalary", false)
AddHelpLabel(-1, HELP_CATEGORY_ADMINTOGGLE, "rp_enablemayorsetsalary - Enable Mayor salary control.")

AddToggleCommand("rp_customspawns", "customspawns", false)
AddHelpLabel(-1, HELP_CATEGORY_ADMINTOGGLE, "rp_customspawns - Enable/disable whether custom spawns should be used.")

AddToggleCommand("rp_dm_autokick", "dmautokick", false)
AddHelpLabel(-1, HELP_CATEGORY_ADMINTOGGLE, "rp_dm_autokick - Enable/disable Auto-kick of deathmatchers.")

AddToggleCommand("rp_norespawn", "norespawn", false)
AddHelpLabel(-1, HELP_CATEGORY_ADMINTOGGLE, "rp_norespawn - Enable/Disable that people don't have to respawn when they change job")

AddToggleCommand("rp_advertisements", "advertisements", false)
AddHelpLabel(-1, HELP_CATEGORY_ADMINTOGGLE, "rp_advertisements - Enable/Disable chatprint advertisements")

AddToggleCommand("rp_doorwarrants", "doorwarrants", false)
AddHelpLabel(-1, HELP_CATEGORY_ADMINTOGGLE, "rp_doorwarrants - Enable/disable Warrant requirement to enter property.")

AddValueCommand("rp_maxmedics", "maxmedics", false)
AddHelpLabel(-1, HELP_CATEGORY_ADMINCMD, "rp_maxmedics <Number> - Sets the max number of Medics.")

AddValueCommand("rp_maxgundealers", "maxgundealers", false)
AddHelpLabel(-1, HELP_CATEGORY_ADMINCMD, "rp_maxgundealers <Number> - Sets the max number of Gun Dealers.")

AddValueCommand("rp_maxcooks", "maxcooks", false)
AddHelpLabel(-1, HELP_CATEGORY_ADMINCMD, "rp_maxcooks <Number> - Sets the max number of Cooks.")

AddValueCommand("rp_microwavefoodcost", "microwavefoodcost", true)
AddHelpLabel(-1, HELP_CATEGORY_ADMINCMD, "rp_microwavefoodcost <Number> - Sets the sale price of Microwave Food.")

AddValueCommand("rp_maxmicrowaves", "maxmicrowaves", false)
AddHelpLabel(-1, HELP_CATEGORY_ADMINCMD, "rp_maxmicrowaves <Number> - Sets the max Microwave Ovens per player.")

AddValueCommand("rp_maxfoods", "maxfoods", false)
AddHelpLabel(-1, HELP_CATEGORY_ADMINCMD, "rp_maxfoods <Number> - Sets the max food cartons per Microwave owner.")

AddValueCommand("rp_maxgunlabs", "maxgunlabs", false)
AddHelpLabel(-1, HELP_CATEGORY_ADMINCMD, "rp_maxgunlabs <Number> - Sets the max Gun Labs per Gun Dealer.")

AddValueCommand("rp_gunlabcost", "gunlabcost", true)
AddHelpLabel(-1, HELP_CATEGORY_ADMINCMD, "rp_gunlabcost <Number> - Sets the cost of a Gun Lab.")

AddValueCommand("rp_microwavecost", "microwavecost", true)
AddHelpLabel(-1, HELP_CATEGORY_ADMINCMD, "rp_microwavecost <Number> - Sets the cost of a Microwave Oven.")

AddValueCommand("rp_maxmayorsetsalary", "maxmayorsetsalary", false)
AddHelpLabel(-1, HELP_CATEGORY_ADMINCMD, "rp_maxmayorsetsalary <Number> - Sets the Max Salary that a Mayor can set for another player.")

AddValueCommand("rp_runspeed", "rspd", false)
AddHelpLabel(-1, HELP_CATEGORY_ADMINCMD, "rp_runspeed <Number> - Sets the max running speed.")

AddValueCommand("rp_arrestspeed", "aspd", false)
AddHelpLabel(-1, HELP_CATEGORY_ADMINCMD, "rp_arrestspeed <Number> - Sets the max arrest speed.")

AddValueCommand("rp_walkspeed", "wspd", false)
AddHelpLabel(-1, HELP_CATEGORY_ADMINCMD, "rp_walkspeed <Number> - Sets the max walking speed.")

AddValueCommand("rp_npckillpay", "npckillpay", false)
AddHelpLabel(-1, HELP_CATEGORY_ADMINCMD, "rp_npckillpay <Number> - Sets the money given for each NPC kill.")

AddValueCommand("rp_normalsalary", "normalsalary", true)
AddHelpLabel(-1, HELP_CATEGORY_ADMINCMD, "rp_normalsalary <Number> - Sets the starting salary for newly joined players.")

AddValueCommand("rp_maxnormalsalary", "maxnormalsalary", true)
AddHelpLabel(-1, HELP_CATEGORY_ADMINCMD, "rp_maxnormalsalary <Number> - Sets the max normal salary.")

AddValueCommand("rp_maxmayorsetsalary", "mayorsetsalary", true)
AddHelpLabel(-1, HELP_CATEGORY_ADMINCMD, "rp_maxmayorsetsalary <Number> - Sets the max salary that the Mayor can set for a player.")

AddValueCommand("rp_maxcopsalary", "maxcopsalary", true)
AddHelpLabel(-1, HELP_CATEGORY_ADMINCMD, "rp_maxcopsalary <Number> - Sets the max salary that the Mayor can give to a CP.")

AddValueCommand("rp_quakechance_1_in", "quakechance", false)
AddHelpLabel(-1, HELP_CATEGORY_ADMINCMD, "rp_quakechance_1_in <Number> - Chance of an earthquake happening.")

AddValueCommand("rp_respawntime", "respawntime", false)
AddHelpLabel(-1, HELP_CATEGORY_ADMINCMD, "rp_respawntime <Number> - Minimum amount of seconds a player has to wait before respawning.")

AddValueCommand("rp_dm_gracetime", "dmgracetime", false)
AddHelpLabel(-1, HELP_CATEGORY_ADMINCMD, "rp_dm_gracetime <Number> - Number of seconds after killing a player that the killer will be watched for DM.")

AddValueCommand("rp_dm_maxkills", "dmmaxkills", false)
AddHelpLabel(-1, HELP_CATEGORY_ADMINCMD, "rp_dm_maxkills <Number> - Max number of kills allowed during rp_dm_gracetime to avoid being auto-kicked for DM.")

AddValueCommand("rp_demotetime", "demotetime", false)
AddHelpLabel(-1, HELP_CATEGORY_ADMINCMD, "rp_demotetime <Number> - Number of seconds before a player can rejoin a team after demotion from that team.")

AddValueCommand("rp_searchtime", "searchtime", false)
AddHelpLabel(-1, HELP_CATEGORY_ADMINCMD, "rp_searchtime <Number> - Number of seconds for which a search warrant is valid.")

AddValueCommand("rp_wantedtime", "wantedtime", false)
AddHelpLabel(-1, HELP_CATEGORY_ADMINCMD, "rp_wantedtime <Number> - Number of seconds for which a player is wanted for.")

AddValueCommand("rp_moneyprintercost", "mprintercost", true)
AddHelpLabel(-1, HELP_CATEGORY_ADMINCMD, "rp_moneyprintercost <Number> - Cost of a Money Printer.")

AddValueCommand("rp_maxmoneyprinters", "maxmprinters", false)
AddHelpLabel(-1, HELP_CATEGORY_ADMINCMD, "rp_maxmoneyprinters <Number> - Max number of Money Printers per player.")

AddValueCommand("rp_printamount", "mprintamount", false)
AddHelpLabel(-1, HELP_CATEGORY_ADMINCMD, "rp_printamount <Number> - Value of the money printed by the money printer.")

for k,v in pairs(RPExtraTeams) do
	ValueCmds["rp_max"..v.command] = { var = "rp_max"..v.command, global = false }
	AddHelpLabel(-1, HELP_CATEGORY_ADMINCMD, "rp_max"..v.command.." <Number> - Sets max "..v.name.."s.")
	if CfgVars["rp_max"..v.command] == nil then CfgVars["rp_max"..v.command] = v.max end
	concommand.Add("rp_max"..v.command, function(ply, cmd, args)
		if #args < 1 then
			print("rp_max"..v.command, "=", v.max)
			ply:PrintMessage(2, "rp_max"..v.command..  "    =    ".. v.max)
		end
		if not ply:HasPriv(ADMIN) then
			ply:PrintMessage(2, "You're not an admin")
			return
		end
		v.max = tonumber(args[1])
		CfgVars["rp_max"..v.command] = tonumber(args[1])
		
		local nick = ""

		if ply:EntIndex() == 0 then
			nick = "Console"
		else
			nick = ply:Nick()
		end
		NotifyAll(0, 4, nick .. " set " .. "rp_max"..v.command .. " to " .. args[1])
	end)
end
