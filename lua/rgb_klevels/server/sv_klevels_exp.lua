local meta = FindMetaTable("Player")

function meta:GiveXP(amount) // Give Player XP (could give negative values to reduce.)
    if (not self:IsValid()) then return end
    if (not isnumber(amount)) then return end

    local oldxp = self:GetNWInt("KLevels_TotalXP", 0)
    local newamount = oldxp + amount
    if (oldxp + amount < 0) then
        newamount = 0
    end

    self:SetNWInt("KLevels_TotalXP", math.Round(newamount))
end

function meta:CommitXP() // commits the XP to the Database.
    if (not self:IsValid()) then return end
    local steamid = sql.SQLStr(self:SteamID())

    local amount = sql.SQLStr(self:GetNWInt("KLevels_TotalXP", 0))

    sql.Query("UPDATE "..KLevels.Config.DBName.." SET TotalXP = "..amount.." WHERE SteamID = "..steamid)
end

function meta:GiveAbilityXP(ability, amount) // Give Player Ability XP (could give negative values to reduce.)
    local lvl = self:GetAbilityLevel(ability)
    if (ability:GetMaxLevel() <= lvl) then return end
    if (not isnumber(amount)) then return end
    if (not self:IsValid()) then return end

    abilitystr = ability:GetSQL()
    if (not isstring(abilitystr)) then return end

    local oldxp = self:GetNWInt("KLevels_"..abilitystr, 0)
    local newamount = oldxp + amount
    if (oldxp + amount < 0) then
        newamount = 0
    end

    self:SetNWInt("KLevels_"..abilitystr, math.Round(newamount))
    hook.Run("KLevels_UpdateAbilities", self, ability)
end

function meta:CommitAbilityXP(ability) // commits the ability XP to the Database.
    if (not self:IsValid()) then return end
    local ability = ability:GetSQL()
    local steamid = sql.SQLStr(self:SteamID())

    local amount = sql.SQLStr(self:GetNWInt("KLevels_"..ability, 0))
    ability = sql.SQLStr(ability)
    sql.Query("UPDATE "..KLevels.Config.DBName.." SET "..ability.." = "..amount.." WHERE SteamID = "..steamid)
end