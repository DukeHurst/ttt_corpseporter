if SERVER then
	AddCSLuaFile("shared.lua")
end

if ( CLIENT ) then
	SWEP.PrintName = "Corpse Porter"
	SWEP.Slot = 6
	
	SWEP.EquipMenuData = {
		type = "item_weapon",
		desc = "Choose a location with primary fire and teleport the coprse to that spot with secondary fire."
	};
	
	SWEP.Icon = "vgui/ttt/icon_golden_deagle"
	
	SWEP.Author = "Duke"
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = true
	SWEP.ViewModelFOV = 54
	SWEP.ViewModelFlip = false
	
	SWEP.IconLetter = "G"
end
	
SWEP.Spawnable = false
SWEP.AdminSpawnable = true

SWEP.Purpose = "Bring a corpse to you!"
SWEP.Instructions = "Primary - Tag Corpse.\nSecondary - Bring tagged Corpse."

SWEP.AmmoEnt               = "item_ammo_revolver_ttt"

SWEP.UseHands              = true
SWEP.ViewModel             = "models/weapons/zaratusa/golden_deagle/v_golden_deagle.mdl"
SWEP.WorldModel            = "models/weapons/zaratusa/golden_deagle/w_golden_deagle.mdl"

SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.Category = "Corpse Porter"
SWEP.Kind = WEAPON_EQUIP1
SWEP.CanBuy = { ROLE_TRAITOR }
SWEP.LimitedStock = true
SWEP.Base = "weapon_tttbase"
SWEP.AllowDrop = true
SWEP.HoldType = "pistol"
SWEP.NoSights = true


SWEP.Primary.Sound = Sound("Golden_Deagle.Single")
SWEP.Primary.Damage = 1  
SWEP.Primary.TakeAmmo = 1  
SWEP.Primary.ClipSize = 3  
SWEP.Primary.Ammo = "Pistol"  
SWEP.Primary.DefaultClip = 3 
SWEP.Primary.Spread = 0.1  
SWEP.Primary.NumberofShots = 1 
SWEP.Primary.Automatic = false 
SWEP.Primary.Recoil = 0 
SWEP.Primary.Delay = 2 
SWEP.Primary.Force = 1 

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Ammo = ""

function SWEP:Initialize()
	self:SetHoldType("pistol")
end

local function getsomename(ent)
local name = ""
if ent:IsRagdoll() then
name = ent:Nick()
end
return name
end
local function switch(path,dmginfo)
local ent = path.Entity
local att = dmg.GetAttacker()
if not (ent:IsRagdoll() || (ent:IsNPC() && GetConVarString("gamemode") == "sandbox")) then return end
local hitpos = ent:GetPos()
local selfpos = att:GetPos()
ent:SetPos(selfpos)


end

function SWEP:PrimaryAttack(worldsnd)
 
   self.Weapon:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
   self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
 
   --if not self:CanPrimaryAttack() then return end
   if self:Clip1() <= 0 then return end
   local bullet = {}
   bullet.Num = 1
   bullet.Src = self.Owner:GetShootPos()
   bullet.Dir = self.Owner:GetAimVector()
   bullet.Spread = Vector( self.Primary.Cone, self.Primary.Cone, 0 )
   bullet.Tracer = 1
   bullet.Force = 0
   bullet.Damage = self.Primary.Damage
   bullet.TracerName = 1
   bullet.Callback = switch

   self.Owner:FireBullets( bullet )
   if GetConVarString("gamemode") == "terrortown" then self:TakePrimaryAmmo( 1 ) end
   if IsValid(self.Owner) then
      self.Owner:SetAnimation( PLAYER_ATTACK1 )

      self.Owner:ViewPunch( Angle( math.Rand(-0.2,-0.1) * self.Primary.Recoil, math.Rand(-0.1,0.1) *self.Primary.Recoil, 0 ) )
   end
   --self:TakePrimaryAmmo( 1 )
    
   if not IsValid(self.Owner) or self.Owner:IsNPC() or (not self.Owner.ViewPunch) then return end
    
   self.Owner:ViewPunch( Angle( math.Rand(-0.2,-0.1) * self.Primary.Recoil, math.Rand(-0.1,0.1) *self.Primary.Recoil, 0 ) )
    
   if ( (game.SinglePlayer() and SERVER) or CLIENT ) then
      self.Weapon:SetNetworkedFloat( "LastShootTime", CurTime() )
   end
 
end
