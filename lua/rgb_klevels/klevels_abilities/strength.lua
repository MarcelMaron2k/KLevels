KLevels_Strength = KAbility:New()
KLevels_Strength:SetName("Strength")
KLevels_Strength:SetSQL("Strength")
KLevels_Strength:SetMaxLevel(50)
KLevels_Strength:SetMinLevel(0)
KLevels_Strength:SetIcon(Material("rgb_mats/rgb_skills/skill_strength.png"))


if (not SERVER) then return end -- Add this to not error on client.

local function StrengthXP(ply, cmov)
    if (not ply:IsPlayer() || not ply:IsValid()) then return nil end

    if ((cmov:KeyDown(IN_JUMP) || cmov:KeyDown(IN_FORWARD) || cmov:KeyDown(IN_BACK) || cmov:KeyDown(IN_MOVELEFT) || cmov:KeyDown(IN_MOVERIGHT)) && not (cmov:KeyDown(IN_DUCK) || cmov:KeyDown(IN_SPEED))) then
        ply.LastStrengthTick = ply.LastStrengthTick or 0

        if (ply.LastStrengthTick + KLevels.Config.StrengthTickSpeed < CurTime()) then

            ply:GiveAbilityXP(KLevels_Strength, KLevels.Config.StrengthXPAmount)
            ply.LastStrengthTick = CurTime()

        end

    end

end

local function StrengthResult(ply)
    local lvl = ply:GetAbilityLevel(KLevels_Strength)

    timer.Simple(0, function()
        local runSpeed = ply:GetRunSpeed()
        local walkSpeed = ply:GetWalkSpeed()
        
        local jumpPower = ply:GetJumpPower()

        ply:SetRunSpeed( runSpeed * KLevels.Config.SpeedIncrease(lvl, KLevels_Strength:GetMaxLevel()))
        ply:SetWalkSpeed( walkSpeed * KLevels.Config.SpeedIncrease(lvl, KLevels_Strength:GetMaxLevel()))
        ply:SetJumpPower(jumpPower * KLevels.Config.JumpIncrease(lvl, KLevels_Strength:GetMaxLevel()))

    end)
end

hook.Add("PlayerSpawn", "KLevels_StrengthResult", StrengthResult)
hook.Add("SetupMove", "KLevels_StrengthHook", StrengthXP)