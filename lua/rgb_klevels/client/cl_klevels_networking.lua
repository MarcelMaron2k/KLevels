
net.Receive("KLevels_SetRecoil", function(len)
    local rec = net.ReadInt(3)
    local wep = LocalPlayer():GetActiveWeapon()
    if (not wep:IsWeapon()) then return end
    wep.Recoil = rec
end)