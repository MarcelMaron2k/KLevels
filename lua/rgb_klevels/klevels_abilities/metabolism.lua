KLevels_Metabolism = KAbility:New()
KLevels_Metabolism:SetName("Metabolism")
KLevels_Metabolism:SetSQL("Metabolism")
KLevels_Metabolism:SetMaxLevel(50)
KLevels_Metabolism:SetMinLevel(0)
KLevels_Metabolism:SetIcon(Material("rgb_mats/rgb_skills/skill_metabolism.png"))


if (not SERVER) then return end -- Add this to not error on client.

local fooditems = {
    spawned_food = true
}

local function MetabolismXP(ent, input, activator, caller)
    if (not activator:IsPlayer() || not caller:IsPlayer()) then return nil end
    if (not fooditems[ent:GetClass()]) then return nil end

    caller:GiveAbilityXP(KLevels_Metabolism, KLevels.Config.MetabolismXPAmount)
end

local function MetabolismResult(ply, energy)

    local lvl = ply:GetAbilityLevel(KLevels_Metabolism)
    local maxlvl = KLevels_Metabolism:GetMaxLevel()
    local reduction = KLevels.Config.HungerReduction(lvl, maxlvl)
    
    -- override starts here.
    ply:setSelfDarkRPVar("Energy", energy and math.Clamp(energy - GAMEMODE.Config.hungerspeed * reduction, 0, 100) or 100)

    if ply:getDarkRPVar("Energy") == 0 then
        local health = ply:Health()

        local dmg = DamageInfo()
        dmg:SetDamage(GAMEMODE.Config.starverate)
        dmg:SetInflictor(ply)
        dmg:SetAttacker(ply)
        dmg:SetDamageType(bit.bor(DMG_DISSOLVE, DMG_NERVEGAS))

        ply:TakeDamageInfo(dmg)

        if health - GAMEMODE.Config.starverate <= 0 then
            ply.Slayed = true
            hook.Call("playerStarved", nil, ply)
        end
    end

    return true
end


hook.Add("hungerUpdate", "KLevels_MetabolismResult", MetabolismResult)
hook.Add("AcceptInput", "KLevels_HandleMetabolism", MetabolismXP)
