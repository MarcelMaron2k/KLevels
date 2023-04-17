KLevels_Recoil= KAbility:New()
KLevels_Recoil:SetName("Recoil Control")
KLevels_Recoil:SetSQL("Recoil_Control")
KLevels_Recoil:SetMaxLevel(50)
KLevels_Recoil:SetMinLevel(0)
KLevels_Recoil:SetIcon(Material("rgb_mats/rgb_skills/skill_recoilcontrol.png"))

if (not SERVER) then return end -- Add this to not error on client.

local function RecoilXP(ent, table)
    if (not ent:IsPlayer() || not ent:IsValid()) then return nil end

    ent.LastRecoilTick = ent.LastRecoilTick or 0

    if (ent.LastRecoilTick + KLevels.Config.RecoilTickSpeed < CurTime()) then

        ent:GiveAbilityXP(KLevels_Recoil, KLevels.Config.RecoilXPAmount)
        ent.LastRecoilTick = CurTime()

    end

end

local function RecoilResult(wep, ply)
    if (not wep.ClassName) then return nil end
    if (not wep.Recoil) then return nil end
    if string.sub(wep.ClassName, 0, 2) != "cw" then return nil end

    local lvl = ply:GetAbilityLevel(KLevels_Recoil) or 1
    local lvlmax = KLevels_Recoil:GetMaxLevel()
    local recoil = nil

    if (lvl <= 0) then return else recoil = wep.Recoil * KLevels.Config.RecoilReduction(lvl, lvlmax) end

    net.Start("KLevels_SetRecoil")
        net.WriteInt(recoil, 3)
    net.Send(ply)

    wep.Recoil = recoil
end


hook.Add("WeaponEquip", "KLevels_RecoilResult", RecoilResult)
hook.Add("EntityFireBullets", "KLevels_HandleRecoil", RecoilXP)

