--table.RemoveByValue(KAbility.List, KLevels_Endurance)
KLevels_Endurance = KAbility:New()
KLevels_Endurance:SetName("Endurance")
KLevels_Endurance:SetSQL("Endurance")
KLevels_Endurance:SetMaxLevel(50)
KLevels_Endurance:SetMinLevel(0)
KLevels_Endurance:SetIcon(Material("rgb_mats/rgb_skills/skill_endurnace.png"))

if (not SERVER) then return end -- Add this to not error on client.

local function EnduranceXP(ply, cmov, cmd)
    if (not ply:IsPlayer() || not ply:IsValid()) then return nil end
    
    if (cmov:KeyDown(IN_SPEED)) then
        ply.LastEnduranceTick = ply.LastEnduranceTick or 0

        if (ply.LastEnduranceTick + KLevels.Config.EnduranceTickSpeed < CurTime()) then

            ply:GiveAbilityXP(KLevels_Endurance, KLevels.Config.EnduranceXPAmount)
            ply.LastEnduranceTick = CurTime()

        end

    end

end

local function EnduranceResult(ply)
    if (not ply:IsPlayer() || not ply:IsValid()) then return nil end

    local plylvl = ply:GetAbilityLevel(KLevels_Endurance)
    local maxlevel = KLevels_Endurance:GetMaxLevel()
    local mult = KLevels.Config.EnduranceIncrease(plylvl, maxlevel)

	ply:SetNWFloat( "EFT_StaminaMax", KLevels.Config.StaminaMax * mult)
end

hook.Add("PlayerSpawn", "KLevels_EnduranceResult", EnduranceResult)
hook.Add("SetupMove", "KLevels_EnduranceXP", EnduranceXP)