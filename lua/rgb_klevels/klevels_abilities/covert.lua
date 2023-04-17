table.RemoveByValue(KAbility.List, KLevels_Covert)

KLevels_Covert = KAbility:New()
KLevels_Covert:SetName("Covert Movement") -- Name that displays.
KLevels_Covert:SetSQL("Covert_Movement") -- Name in the SQL Database (Used also as an ID) Don't include Special Characters or Spaces
KLevels_Covert:SetMaxLevel(50) -- Max Level
KLevels_Covert:SetMinLevel(0) -- Min Level
KLevels_Covert:SetIcon(Material("rgb_mats/rgb_skills/skill_convertmovement.png"))

if (not SERVER) then return end -- Add this to not error on client.

local function CovertXP(ply, cmv)
    if (not ply:IsPlayer() || not ply:IsValid()) then return nil end

    if (cmv:KeyDown(IN_DUCK) && (cmv:KeyDown(IN_FORWARD) || cmv:KeyDown(IN_BACK) || cmv:KeyDown(IN_LEFT) || cmv:KeyDown(IN_RIGHT)))then
        ply.LastCovertTick = ply.LastCovertTick or 0

        if (ply.LastCovertTick + KLevels.Config.CovertTickSpeed < CurTime()) then

            ply:GiveAbilityXP(KLevels_Covert, KLevels.Config.CovertXPAmount)
            ply.LastCovertTick = CurTime()

        end

    end
end

local function CovertResult(ply)
    timer.Simple(0, function()
        local lvl = ply:GetAbilityLevel(KLevels_Covert)
        local maxlvl = KLevels_Covert:GetMaxLevel()
        local duckSpeed = ply:GetCrouchedWalkSpeed()

        ply:SetCrouchedWalkSpeed(duckSpeed * KLevels.Config.CrouchIncrease(lvl, maxlvl))       
    end)
end

hook.Add("SetupMove", "KLevels_CovertHook", CovertXP)
hook.Add("PlayerSpawn", "KLevels_CovertResult", CovertResult)