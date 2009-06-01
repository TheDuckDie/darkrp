require("datastream")
if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then
	SWEP.PrintName = "Pocket"
	SWEP.Slot = 1
	SWEP.SlotPos = 1
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
end

SWEP.Author = "FPtje"
SWEP.Instructions = "Left click to pick up, right click to drop, reload for menu"
SWEP.Contact = ""
SWEP.Purpose = ""

SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.AnimPrefix	 = "rpg"

SWEP.Spawnable = false
SWEP.AdminSpawnable = true
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

if CLIENT then
	SWEP.FrameVisible = false
end

function SWEP:Initialize()
	if SERVER then self:SetWeaponHoldType("normal") end
end

function SWEP:Deploy()
	if SERVER then
		self.Owner:DrawViewModel(false)
		self.Owner:DrawWorldModel(false)
	end
end

local blacklist = {"drug_lab", "money_printer", "meteor", "door", "func_", "player", "beam", "worldspawn", "env_", "path_"}
function SWEP:PrimaryAttack()
	if CLIENT then return end

	self.Weapon:SetNextPrimaryFire(CurTime() + 0.2)
	local trace = self.Owner:GetEyeTrace()

	if not ValidEntity(trace.Entity) then
		return
	end
	
	if self.Owner:EyePos():Distance(trace.HitPos) > 65 then
		return
	end
	
	local phys = trace.Entity:GetPhysicsObject()
	if not phys:IsValid() then return end
	local mass = phys:GetMass()
	
	if SERVER then
		self:SetWeaponHoldType("pistol")
		timer.Simple(0.2, function(wep) if wep:IsValid() then wep:SetWeaponHoldType("normal") end end, self)
	end
	
	if not self.Owner:GetTable().Pocket then self.Owner:GetTable().Pocket = {} end
	if not SPropProtection.GravGunThings(self.Owner, trace.Entity) or table.HasValue(self.Owner:GetTable().Pocket, trace.Entity) then
		Notify(self.Owner, 1, 4, "You can not put this object in your pocket!")
		return
	end
	for k,v in pairs(blacklist) do 
		if string.find(string.lower(trace.Entity:GetClass()), v) then
			Notify(self.Owner, 1, 4, "You can not put "..v.." in your pocket!")
			return
		end
	end
	
	if mass > 100 then
		Notify(self.Owner, 1, 4, "This object is too heavy.")
		return
	end
	
	if not CfgVars["pocketitems"] then CfgVars["pocketitems"] = 10 end
	if #self.Owner:GetTable().Pocket >= CfgVars["pocketitems"] then
		Notify(self.Owner, 1, 4, "Your pocket is full!")
		return
	end

	
	umsg.Start("Pocket_AddItem", self.Owner)
		umsg.Short(trace.Entity:EntIndex())
	umsg.End()
	
	table.insert(self.Owner:GetTable().Pocket, trace.Entity)
	trace.Entity:SetNoDraw(true)
	trace.Entity:SetCollisionGroup(0)
	local phys = trace.Entity:GetPhysicsObject()
	phys:EnableMotion(true)
	trace.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	if phys:IsValid() then
		phys:EnableCollisions(false)
		phys:Wake()
	end
end

function SWEP:SecondaryAttack()
	if CLIENT then return end
	self.Weapon:SetNextSecondaryFire(CurTime() + 0.2)
	
	if not self.Owner:GetTable().Pocket or #self.Owner:GetTable().Pocket <= 0 then
		Notify(self.Owner, 1, 4, "Your pocket contains no items.")
		return
	end
	local ent = self.Owner:GetTable().Pocket[#self.Owner:GetTable().Pocket]
	self.Owner:GetTable().Pocket[#self.Owner:GetTable().Pocket] = nil
	if not ValidEntity(ent) then Notify(self.Owner, 1, 4, "Your pocket contains no items.") return end
	if SERVER then
		self:SetWeaponHoldType("pistol")
		timer.Simple(0.2, function(wep) if wep:IsValid() then wep:SetWeaponHoldType("normal") end end, self)
	end
	local trace = {}
	trace.start = self.Owner:EyePos()
	trace.endpos = trace.start + self.Owner:GetAimVector() * 85
	trace.filter = self.Owner
	local tr = util.TraceLine(trace)
	ent:SetMoveType(MOVETYPE_VPHYSICS)
	ent:SetNoDraw(false)
	ent:SetCollisionGroup(4)
	ent:SetPos(tr.HitPos)
	local phys = ent:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableCollisions(true)
		phys:Wake()
	end
	umsg.Start("Pocket_RemoveItem", self.Owner)
		umsg.Short(ent:EntIndex())
	umsg.End()
end

SWEP.OnceReload = false
function SWEP:Reload()
	if CLIENT or self.Weapon.OnceReload then return end
	self.Weapon.OnceReload = true
	timer.Simple(0.5, function() self.Weapon.OnceReload = false end)
	
	if not self.Owner:GetTable().Pocket or #self.Owner:GetTable().Pocket <= 0 then
		Notify(self.Owner, 1, 4, "Your pocket contains no items.")
		return
	end
	
	for k,v in pairs(self.Owner:GetTable().Pocket) do 
		if not ValidEntity(v) then
			self.Owner:GetTable().Pocket[k] = nil
			self.Owner:GetTable().Pocket = table.ClearKeys(self.Owner:GetTable().Pocket)
			if #self.Owner:GetTable().Pocket <= 0 then -- Recheck after the entities have been validated.
				Notify(self.Owner, 1, 4, "Your pocket contains no items.") 
				return
			end
		end
	end
	
	umsg.Start("StartPocketMenu", self.Owner)
	umsg.End()
end

if CLIENT then
	local function StorePocketItem(um)
		if not LocalPlayer():GetTable().Pocket then
			LocalPlayer():GetTable().Pocket = {}
		end
		local ent = Entity(um:ReadShort())
		if ValidEntity(ent) and not table.HasValue(LocalPlayer():GetTable().Pocket, ent) then
			table.insert(LocalPlayer():GetTable().Pocket, ent)
		end
	end
	usermessage.Hook("Pocket_AddItem", StorePocketItem)
	
	local function RemovePocketItem(um)
		if not LocalPlayer():GetTable().Pocket then
			LocalPlayer():GetTable().Pocket = {}
		end
		local ent = Entity(um:ReadShort())
		for k,v in pairs(LocalPlayer():GetTable().Pocket) do
			if v == ent then LocalPlayer():GetTable().Pocket[k] = nil end
		end
	end
	usermessage.Hook("Pocket_RemoveItem", RemovePocketItem)
	
	local frame
	local function PocketMenu()
		if frame and frame:IsValid() and frame:IsVisible() then return end
		if LocalPlayer():GetActiveWeapon():GetClass() ~= "pocket" then return end
		if not LocalPlayer():GetTable().Pocket then LocalPlayer():GetTable().Pocket = {} return end
		for k,v in pairs(LocalPlayer():GetTable().Pocket) do if not ValidEntity(v) then LocalPlayer():GetTable().Pocket[k] = nil end end
		if #LocalPlayer():GetTable().Pocket <= 0 then return end
		frame = vgui.Create( "DFrame" )
		frame:SetTitle( "Drop item" )
		frame:SetVisible( true )
		frame:MakePopup( )
		
		local items = LocalPlayer():GetTable().Pocket
		local function Reload()
			frame:SetSize( #items * 64, 90 ) 
			frame:Center()
			for k,v in pairs(items) do
				if not ValidEntity(v) then 
					items[k] = nil
					items = table.ClearKeys(items)
					frame:Close()
					PocketMenu()
					break
				end
				local icon = vgui.Create("SpawnIcon", frame)
				icon:SetPos((k-1) * 64, 25)
				icon:SetModel(v:GetModel())
				icon:SetIconSize(64)
				icon:SetToolTip()
				icon.DoClick = function()
					icon:SetToolTip()
					RunConsoleCommand("_RPSpawnPocketItem", v:EntIndex())
					items[k] = nil
					if #items == 0 then
						frame:Close()
						return
					end
					items = table.ClearKeys(items)
					Reload()
				end
			end
		end
		Reload()
	end
	usermessage.Hook("StartPocketMenu", PocketMenu)
elseif SERVER then
	local function Spawn(ply, cmd, args)
		if ply:GetActiveWeapon():GetClass() ~= "pocket" then
			return
		end
		if ply:GetTable().Pocket and Entity(tonumber(args[1])) then
			local ent = Entity(tonumber(args[1]))
			
			for k,v in pairs(ply:GetTable().Pocket) do 
				if v == ent then
					ply:GetTable().Pocket[k] = nil
				end
			end
			ply:GetTable().Pocket = table.ClearKeys(ply:GetTable().Pocket)
			
			if not ValidEntity(ent) then return end
			if SERVER then
				ply:GetActiveWeapon():SetWeaponHoldType("pistol")
				timer.Simple(0.2, function(wep) if wep:IsValid() then wep:SetWeaponHoldType("normal") end end, ply:GetActiveWeapon())
			end
			
			local trace = {}
			trace.start = ply:EyePos()
			trace.endpos = trace.start + ply:GetAimVector() * 85
			trace.filter = ply
			local tr = util.TraceLine(trace)
			ent:SetMoveType(MOVETYPE_VPHYSICS)
			ent:SetNoDraw(false)
			ent:SetCollisionGroup(4)
			ent:SetPos(tr.HitPos)
			local phys = ent:GetPhysicsObject()
			if phys:IsValid() then
				phys:EnableCollisions(true)
				phys:Wake()
			end
		end
	end
	concommand.Add("_RPSpawnPocketItem", Spawn)
end
