/*---------------------------------------------------------
 Gamemode functions
 ---------------------------------------------------------*/
function GM:Initialize()
	self.BaseClass:Initialize()
	DB.Init()
end

function GM:PlayerSpawnProp(ply, model)
	if not self.BaseClass:PlayerSpawnProp(ply, model) then return false end

	local allowed = false

	if RPArrestedPlayers[ply:SteamID()] then return false end
	model = string.gsub(model, "\\", "/")
	if string.find(model,  "//") then Notify(ply, 1, 4, "Cannot spawn props because it has one or more //'s in it") return false end
	-- Banned props take precedence over allowed props
	if CfgVars["banprops"] == 1 then
		for k, v in pairs(BannedProps) do
			if string.lower(v) == string.lower(model) then Notify(ply, 1, 4, "Cannot spawn this prop because it is banned") return false end
		end
	end

	-- If prop spawning is enabled or the user has admin or prop privileges
	if CfgVars["propspawning"] == 1 or ply:HasPriv(ADMIN) or ply:HasPriv(PROP) then
		-- If we are specifically allowing certain props, if it's not in the list, allowed will remain false
		if CfgVars["allowedprops"] == 1 then
			for k, v in pairs(AllowedProps) do
				if v == model then allowed = true end
			end
		else
			-- allowedprops is not enabled, so assume that if it wasn't banned above, it's allowed
			allowed = true
		end
	end

	if allowed then
		if CfgVars["proppaying"] == 1 then
			if ply:CanAfford(CfgVars["propcost"]) then
				Notify(ply, 1, 4, "Deducted " .. CUR .. CfgVars["propcost"])
				ply:AddMoney(-CfgVars["propcost"])
				return true
			else
				Notify(ply, 1, 4, "Need " .. CUR .. CfgVars["propcost"])
				return false
			end
		else
			return true
		end
	end
	return false
end

function GM:PlayerSpawnSENT(ply, model)
	return self.BaseClass:PlayerSpawnSENT(ply, model) and not RPArrestedPlayers[ply:SteamID()]
end

function GM:PlayerSpawnSWEP(ply, model)
	return self.BaseClass:PlayerSpawnSWEP(ply, model) and not RPArrestedPlayers[ply:SteamID()]
end

function GM:PlayerSpawnEffect(ply, model)
	return self.BaseClass:PlayerSpawnEffect(ply, model) and not RPArrestedPlayers[ply:SteamID()]
end

function GM:PlayerSpawnVehicle(ply, model)
	return self.BaseClass:PlayerSpawnVehicle(ply, model) and not RPArrestedPlayers[ply:SteamID()]
end

function GM:PlayerSpawnNPC(ply, model)
	return self.BaseClass:PlayerSpawnNPC(ply, model) and not RPArrestedPlayers[ply:SteamID()]
end

function GM:PlayerSpawnRagdoll(ply, model)
	return self.BaseClass:PlayerSpawnRagdoll(ply, model) and not RPArrestedPlayers[ply:SteamID()]
end

function GM:PlayerSpawnedProp(ply, model, ent)
	self.BaseClass:PlayerSpawnedProp(ply, model, ent)
	ent.SID = ply.SID
	ent:SetNetworkedEntity("TheFingOwner", ply)
end

function GM:PlayerSpawnedSWEP(ply, model, ent)
	self.BaseClass:PlayerSpawnedSWEP(ply, model, ent)
	ent.SID = ply.SID
end

function GM:PlayerSpawnedRagdoll(ply, model, ent)
	self.BaseClass:PlayerSpawnedRagdoll(ply, model, ent)
	ent.SID = ply.SID
end

function GM:ShowSpare1(ply)
	umsg.Start("ToggleClicker", ply)
	umsg.End()
end

function GM:ShowSpare2(ply)
	ply:SendLua("ChangeJobVGUI()")
end

function GM:OnNPCKilled(victim, ent, weapon)
	-- If something killed the npc
	if ent then
		if ent:IsVehicle() and ent:GetDriver():IsPlayer() then ent = ent:GetDriver() end

		-- if it wasn't a player directly, find out who owns the prop that did the killing
		if not ent:IsPlayer() then
			ent = FindPlayerBySID(ent.SID)
		end

		-- if we know by now who killed the NPC, pay them.
		if ent and CfgVars["npckillpay"] > 0 then
			ent:AddMoney(CfgVars["npckillpay"])
			Notify(ent, 1, 4, CUR .. CfgVars["npckillpay"] .. " For killing an NPC!")
		end
	end
end

function GM:KeyPress(ply, code)
	self.BaseClass:KeyPress(ply, code)

	if code == IN_USE then
		local trace = { }
		trace.start = ply:EyePos()
		trace.endpos = trace.start + ply:GetAimVector() * 95
		trace.filter = ply
		local tr = util.TraceLine(trace)

		if ValidEntity(tr.Entity) and not ply:KeyDown(IN_ATTACK) then
			if tr.Entity:GetTable().Letter then
				umsg.Start("ShowLetter", ply)
					umsg.Short(tr.Entity:GetNWInt("type"))
					umsg.Vector(tr.Entity:GetPos())
					local numParts = tr.Entity:GetNWInt("numPts")
					umsg.Short(numParts)
					for k=1, numParts do umsg.String(tr.Entity:GetNWString("part" .. tostring(k))) end
				umsg.End()
			end

			if tr.Entity:GetTable().MoneyBag then
				Notify(ply, 0, 4, "You found " .. CUR .. tr.Entity:GetTable().Amount .. "!")
				ply:AddMoney(tr.Entity:GetTable().Amount)
				tr.Entity:Remove()
			end
		else
			umsg.Start("KillLetter", ply)
			umsg.End()
		end
	end
end

function GM:PlayerCanHearPlayersVoice(listener, talker)
	if ValidEntity(listener:GetNWEntity("phone")) and ValidEntity(talker:GetNWEntity("phone")) and listener == talker:GetNWEntity("phone"):GetNWEntity("Caller") then 
		return true
	elseif ValidEntity(talker:GetNWEntity("phone")) then
		return false
	end
	
	if CfgVars["voiceradius"] == 1 and listener:GetShootPos():Distance(talker:GetShootPos()) < 550 then
		return true
	elseif CfgVars["voiceradius"] == 1 then
		return false
	end
	return true
end

function GM:CanTool(ply, trace, mode)
	if not self.BaseClass:CanTool(ply, trace, mode) then return false end

	if ValidEntity(trace.Entity) then
		if trace.Entity.onlyremover then
			if mode == "remover" then
				return (ply:IsAdmin() or ply:IsSuperAdmin())
			else
				return false
			end
		end

		if trace.Entity.nodupe and (mode == "weld" or
					mode == "weld_ez" or
					mode == "spawner" or
					mode == "duplicator" or
					mode == "adv_duplicator") then
			return false
		end

		if trace.Entity:IsVehicle() and mode == "nocollide" and CfgVars["allowvnocollide"] == 0 then
			return false
		end
	end
	return true
end

function GM:CanPlayerSuicide(ply)
	if ply:GetNWInt("slp") == 1 then
		Notify(ply, 4, 4, "Can not suicide while sleeping!")
		return false
	end
	if RPArrestedPlayers[ply:SteamID()] then
		Notify(ply, 4, 4, "You cannot suicide in jail.")
		return false
	end
	return true
end

function GM:PlayerDeath(ply, weapon, killer)
	if GetGlobalInt("deathblack") == 1 then
		local RP = RecipientFilter()
		RP:RemoveAllPlayers()
		RP:AddPlayer(ply)
		umsg.Start("DarkRPEffects", RP)
			umsg.String("colormod")
			umsg.String("1")
		umsg.End()
		RP:AddAllPlayers()
	end
	UnDrugPlayer(ply)

	if weapon:IsVehicle() and weapon:GetDriver():IsPlayer() then killer = weapon:GetDriver() end
	if GetGlobalInt("deathnotice") == 1 then
		self.BaseClass:PlayerDeath(ply, weapon, killer)
	end

	ply:Extinguish()

	if ply:InVehicle() then ply:ExitVehicle() end

	if RPArrestedPlayers[ply:SteamID()] then
		-- If the player died in jail, make sure they can't respawn until their jail sentance is over
		ply.NextSpawnTime = CurTime() + math.ceil(GetGlobalInt("jailtimer") - (CurTime() - ply.LastJailed)) + 1
		for a, b in pairs(player.GetAll()) do
			b:PrintMessage(HUD_PRINTCENTER, ply:Nick() .. " has died in jail!")
		end
		Notify(ply, 4, 4, "You now are dead until your jail time is up!")
	else
		-- Normal death, respawning.
		ply.NextSpawnTime = CurTime() + CfgVars["respawntime"]
	end
	ply:GetTable().DeathPos = ply:GetPos()

	if CfgVars["dmautokick"] == 1 and killer:IsPlayer() and killer ~= ply then
		if not killer.kills or killer.kills == 0 then
			killer.kills = 1
			timer.Simple(CfgVars["dmgracetime"], killer.ResetDMCounter, killer)
		else
			-- if this player is going over their limit, kick their ass
			if killer.kills + 1 > CfgVars["dmmaxkills"] then
				game.ConsoleCommand("kickid " .. killer:UserID() .. " Auto-kicked. Excessive Deathmatching.\n")
			else
				-- killed another player
				killer.kills = killer.kills + 1
			end
		end
	end

	if ply ~= killer or ply:GetTable().Slayed then
		ply:SetNetworkedBool("wanted", false)
		RPArrestedPlayers[ply:SteamID()] = false
		ply:GetTable().DeathPos = nil
		ply:GetTable().Slayed = false
	end
	ply:GetTable().ConfisquatedWeapons = nil
end

function GM:PlayerCanPickupWeapon(ply, weapon)
	if RPArrestedPlayers[ply:SteamID()] then return false end
	if ply:IsAdmin() and CfgVars["AdminsSpawnWithCopWeapons"] == 1 then return true end
	if CfgVars["license"] == 1 and not ply:GetNWBool("HasGunlicense") and not ply:GetTable().RPLicenseSpawn then
		if GetGlobalInt("licenseweapon_"..string.lower(weapon:GetClass())) == 1 then
			return true
		end
		return false
	end
	return true
end

local function IsEmpty(vector)
	local point = util.PointContents(vector)
	local a = point ~= CONTENTS_SOLID 
	and point ~= CONTENTS_MOVEABLE 
	and point ~= CONTENTS_LADDER 
	and point ~= CONTENTS_PLAYERCLIP 
	and point ~= CONTENTS_MONSTERCLIP
	local b = true
	
	for k,v in pairs(ents.FindInSphere(vector, 35)) do
		if v:IsNPC() or v:IsPlayer() or v:GetClass() == "prop_physics" then
			b = false
		end
	end
	return a and b
end

local function removelicense(ply) 
	if not ValidEntity(ply) then return end 
	ply:GetTable().RPLicenseSpawn = false 
end

local CivModels = {
	"models/player/group01/male_01.mdl",
	"models/player/Group01/Male_02.mdl",
	"models/player/Group01/male_03.mdl",
	"models/player/Group01/Male_04.mdl",
	"models/player/Group01/Male_05.mdl",
	"models/player/Group01/Male_06.mdl",
	"models/player/Group01/Male_07.mdl",
	"models/player/Group01/Male_08.mdl",
	"models/player/Group01/Male_09.mdl"
}
function GM:PlayerSetModel(ply)
	local EndModel = ""
	if CfgVars["enforceplayermodel"] == 1 then
		if ply:Team() == TEAM_CITIZEN then
			local validmodel = false

			for k, v in pairs(CivModels) do
				if ply:GetTable().PlayerModel == v then
					validmodel = true
					break
				end
			end

			if not validmodel then
				ply:GetTable().PlayerModel = nil
			end

			local model = ply:GetModel()

			if model ~= ply:GetTable().PlayerModel then
				for k, v in pairs(CivModels) do
					if v == model then
						ply:GetTable().PlayerModel = model
						validmodel = true
						break
					end
				end

				if not validmodel and not ply:GetTable().PlayerModel then
					ply:GetTable().PlayerModel = CivModels[math.random(1, #CivModels)]
				end

				EndModel = ply:GetTable().PlayerModel
			end
		elseif ply:Team() == TEAM_POLICE then
			EndModel = "models/player/police.mdl"
		elseif ply:Team() == TEAM_MAYOR then
			EndModel = "models/player/breen.mdl"
		elseif ply:Team() == TEAM_GANG then
			EndModel = "models/player/group03/male_01.mdl"
		elseif ply:Team() == TEAM_MOB  then
			EndModel = "models/player/gman_high.mdl"
		elseif ply:Team() == TEAM_GUN then
			EndModel = "models/player/monk.mdl"
		elseif ply:Team() == TEAM_MEDIC then
			EndModel = "models/player/kleiner.mdl"
		elseif ply:Team() == TEAM_COOK then
			EndModel = "models/player/mossman.mdl"
		elseif ply:Team() == TEAM_CHIEF then
			EndModel = "models/player/combine_soldier_prisonguard.mdl"
		end
		
		for k,v in pairs(RPExtraTeams) do
			if ply:Team() == (9+k) then
				EndModel = v.model
			end
		end
		util.PrecacheModel(EndModel)
		ply:SetModel(EndModel)
	end
end

function GM:PlayerInitialSpawn(ply)
	self.BaseClass:PlayerInitialSpawn(ply)
	ply.bannedfrom = {}
	ply:NewData()
	ply:InitSID()
	DB.RetrieveSalary(ply)
	DB.RetrieveMoney(ply)
	timer.Simple(10, ply.CompleteSentence, ply)
end

function GM:PlayerSpawn(ply)
	ply:CrosshairEnable()

	if CfgVars["crosshair"] == 0 then
		ply:CrosshairDisable()
	end
	
	ply:GetTable().RPLicenseSpawn = true
	timer.Simple(1, removelicense, ply)
	
	--Kill any colormod
	local RP = RecipientFilter()
	RP:RemoveAllPlayers()
	RP:AddPlayer(ply)
	umsg.Start("DarkRPEffects", RP)
		umsg.String("colormod")
		umsg.String("0")
	umsg.End()
	RP:AddAllPlayers()

	if CfgVars["strictsuicide"] == 1 and ply:GetTable().DeathPos then
		if not (RPArrestedPlayers[ply:SteamID()]) then
			ply:SetPos(ply:GetTable().DeathPos)
		end
	end
	
	-- If the player for some magical reason managed to respawn while jailed then re-jail the bastard.
	if RPArrestedPlayers[ply:SteamID()] and ply:GetTable().DeathPos then
		-- For when CfgVars["teletojail"] == 0
		ply:SetPos(ply:GetTable().DeathPos)
		-- Not getting away that easily, Sonny Jim.
		if DB.RetrieveJailPos() then
			ply:Arrest()
		else
			Notify(ply, 1, 4, "You're no longer under arrest because no jail positions are set!")
		end
	end
	
	if CfgVars["customspawns"] == 1 then
		if not RPArrestedPlayers[ply:SteamID()] then
			local pos = DB.RetrieveTeamSpawnPos(ply)
			if pos then
				ply:SetPos(pos)
			end
		end
	end
	
	local STARTPOS = ply:GetPos()
	if not IsEmpty(STARTPOS) then
		local found = false
		for i = 40, 300, 15 do
			if IsEmpty(STARTPOS + Vector(i, 0, 0)) then
				ply:SetPos(STARTPOS + Vector(i, 0, 0))
				--Yeah I found a nice position to put the player in!
				found = true
				break
			end
		end
		if not found then
			for i = 40, 300, 15 do
				if IsEmpty(STARTPOS + Vector(0, i, 0)) then
					ply:SetPos(STARTPOS + Vector(0, i, 0))
					found = true
					break
				end
			end
		end
		if not found then
			for i = 40, 300, 15 do
				if IsEmpty(STARTPOS + Vector(0, -i, 0)) then
					ply:SetPos(STARTPOS + Vector(0, -i, 0))
					found = true
					break
				end
			end
		end
		if not found then
			for i = 40, 300, 15 do
				if IsEmpty(STARTPOS + Vector(-i, 0, 0)) then
					ply:SetPos(STARTPOS + Vector(-i, 0, 0))
					--Yeah I found a nice position to put the player in!
					found = true
					break
				end
			end
		end
		-- If you STILL can't find it, you'll just put him on top of the other player lol
		if not found then
			ply:SetPos(ply:GetPos() + Vector(0,0,70))
		end
	end

	if CfgVars["babygod"] == 1 and ply:GetNWInt("slp") ~= 1 then
		ply:SetNWBool("Babygod", true)
		ply:GodEnable()
		local r,g,b,a = ply:GetColor()
		ply:SetColor(r, g, b, 100)
		ply:SetCollisionGroup(  COLLISION_GROUP_WORLD )
		timer.Simple(CfgVars["babygodtime"] or 5, function()
			if not ValidEntity(ply) then return end
			ply:SetNWBool("Babygod", false)
			ply:SetColor(r, g, b, a)
			ply:GodDisable()
			ply:SetCollisionGroup( COLLISION_GROUP_PLAYER )
		end)
	end
	ply:SetNWInt("slp", 0)
	
	GAMEMODE:SetPlayerSpeed(ply, CfgVars["wspd"], CfgVars["rspd"] )
	if ply:Team() == TEAM_CHIEF or ply:Team() == TEAM_POLICE then
		GAMEMODE:SetPlayerSpeed(ply, CfgVars["wspd"], CfgVars["rspd"] + 10 )
	end

	ply:Extinguish()
	if ply:GetActiveWeapon() and ValidEntity(ply:GetActiveWeapon()) then
		ply:GetActiveWeapon():Extinguish()
	end

	if ply.demotedWhileDead then
		ply.demotedWhileDead = nil
		ply:ChangeTeam(TEAM_CITIZEN)
	end
	
	ply:GetTable().StartHealth = ply:Health()
	GAMEMODE:PlayerSetModel(ply)
	GAMEMODE:PlayerLoadout( ply )
end

function GM:PlayerLoadout(ply)
	if RPArrestedPlayers[ply:SteamID()] then return end

	local team = ply:Team()

	ply:Give("keys")
	ply:Give("weapon_physcannon")
	ply:Give("gmod_camera")

	if CfgVars["toolgun"] == 1 or ply:HasPriv(ADMIN) or ply:HasPriv(TOOL) then
		ply:Give("gmod_tool")
	end
	
	if CfgVars["pocket"] == 1 then
		ply:Give("pocket")
	end

	if CfgVars["physgun"] == 1 or ply:HasPriv(ADMIN) or ply:HasPriv(PHYS) then
		ply:Give("weapon_physgun")
	end
	
	if team == TEAM_POLICE or team == TEAM_CHIEF or (ply:HasPriv(ADMIN) and CfgVars["AdminsSpawnWithCopWeapons"] == 1) then
		ply:Give("door_ram")
		ply:Give("arrest_stick")
		ply:Give("unarrest_stick")
		ply:Give("stunstick")
		ply:Give("weaponchecker") 
	end

	if team == TEAM_POLICE then
		if CfgVars["noguns"] ~= 1 then
			ply:Give("weapon_glock2")
			ply:GiveAmmo(30, "Pistol")
		end
	elseif team == TEAM_MAYOR then
		if CfgVars["noguns"] ~= 1 then ply:GiveAmmo(28, "Pistol") end
	elseif team == TEAM_GANG then
		if CfgVars["noguns"] ~= 1 then ply:GiveAmmo(1, "Pistol") end
	elseif team == TEAM_MOB then
		ply:Give("unarrest_stick")
		ply:Give("lockpick")
		if CfgVars["noguns"] ~= 1 then ply:GiveAmmo(1, "Pistol") end
	elseif team == TEAM_GUN then
		if CfgVars["noguns"] ~= 1 then ply:GiveAmmo(1, "Pistol") end
	elseif team == TEAM_MEDIC then
		ply:Give("med_kit")
	elseif team == TEAM_COOK then
		if CfgVars["noguns"] ~= 1 then ply:GiveAmmo(1, "Pistol") end
	elseif team == TEAM_CHIEF then
		if CfgVars["noguns"] ~= 1 then
			ply:Give("weapon_deagle2")
			ply:GiveAmmo(30, "Pistol")
		end
	end
	for k,v in pairs(RPExtraTeams) do
		if team == (9 + k) then
			for _,b in pairs(v.Weapons) do ply:Give(b) end
		end
	end
	
	// Switch to prefered weapon if they have it
	local cl_defaultweapon = ply:GetInfo( "cl_defaultweapon" )
	
	if ( ply:HasWeapon( cl_defaultweapon )  ) then
		ply:SelectWeapon( cl_defaultweapon ) 
	end
end

function GM:PlayerDisconnected(ply)
	self.BaseClass:PlayerDisconnected(ply)
	timer.Destroy(ply:SteamID() .. "jobtimer")
	timer.Destroy(ply:SteamID() .. "propertytax")
	for k, v in pairs(ents.FindByClass("money_printer")) do
		if v.SID == ply.SID then v:Remove() end
	end
	for k, v in pairs(ents.FindByClass("microwave")) do
		if v.SID == ply.SID then v:Remove() end
	end
	for k, v in pairs(ents.FindByClass("gunlab")) do
		if v.SID == ply.SID then v:Remove() end
	end
	for k, v in pairs(ents.FindByClass("letter")) do
		if v.SID == ply.SID then v:Remove() end
	end
	for k, v in pairs(ents.FindByClass("drug_lab")) do
		if v.SID == ply.SID then v:Remove() end
	end
	for k, v in pairs(ents.FindByClass("drug")) do
		if v.SID == ply.SID then v:Remove() end
	end
	vote.DestroyVotesWithEnt(ply)
	-- If you're arrested when you disconnect, you will serve your time again when you reconnect!
	if RPArrestedPlayers and RPArrestedPlayers[ply:SteamID()]then
		DB.StoreJailStatus(ply, math.ceil(GetGlobalInt("jailtimer")))
	end
	ply:UnownAll()
end

function GM:Think()
	FlammablePropThink()
end

function GM:GetFallDamage( ply, flFallSpeed )
	if GetConVarNumber("mp_falldamage") == 1 then
		return flFallSpeed / 15
	end
	return 10
end

function GM:PlayerSay(ply, text)
	RP_PlayerChat(ply, text)
end