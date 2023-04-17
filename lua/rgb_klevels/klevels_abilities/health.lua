table.RemoveByValue( KAbility.List, KLevels_Health )
KLevels_Health = KAbility:New()
KLevels_Health:SetName("Health") -- Name that displays.
KLevels_Health:SetSQL("Health") -- Name in the SQL Database (Used also as an ID) Don't include Special Characters or Spaces
KLevels_Health:SetMaxLevel(50) -- Max Level
KLevels_Health:SetMinLevel(0) -- Min Level
KLevels_Health:SetIcon(Material("rgb_mats/rgb_skills/skill_health.png"))

if (not SERVER) then return end -- Add this to not error on client.

local healthitems = {
    rloc_painkiller = true,
    rloc_salewa = true,
    rloc_ifak = true,
    rloc_splint = true, 
    rloc_bandage = true,
    rloc_grizzly = true,
}

local function HealthXP1(ent, input, activator, caller)
    if (not activator:IsPlayer() || not caller:IsPlayer()) then return nil end
    if (not healthitems[ent:GetClass()]) then return nil end
    
    caller:GiveAbilityXP(KLevels_Health, KLevels.Config.HealthXPAmount)
end

local function HealthXP2(ent, dmginfo)
    if (not ent:IsPlayer()) then return nil end

    ent.LastHealthTick = ent.LastHealthTick or 0

    if (ent.LastHealthTick + KLevels.Config.HealthTickSpeed < CurTime()) then

        ent:GiveAbilityXP(KLevels_Health, KLevels.Config.HealthXPAmount)
        ent.LastHealthTick = CurTime()
    end
end

local function HealthResult(ply)
    timer.Simple(0.1, function()
        local lvl = ply:GetAbilityLevel(KLevels_Health)
        local ogHealth = ply:GetMaxHealth()

        ply:SetMaxHealth(ogHealth + lvl * 2)
        ply:SetHealth(ply:GetMaxHealth())

    end)
end

// TODO Reduce Concussion Chance.
hook.Add("AcceptInput", "KLevels_HealthHook", HealthXP1)
hook.Add("EntityTakeDamage", "KLevels_HealthHook2", HealthXP2)
hook.Add("PlayerSpawn", "KLevels_HealthResult", HealthResult)
