local meta = FindMetaTable("Player")
local Config = KLevels.Config

/*
    PLAYER:GetLevel()
    Returns:
    Player's Current Level
    Excess XP from previous level. (NOT FULL XP)
    XP needed for next level.
*/
function meta:GetLevel() // Get player's level
    local amount = self:GetNWInt("KLevels_TotalXP", 0)
    for k,v in pairs(KLevels.Config.PlayerLevels) do
        if (amount >= v) then continue end
        return k - 1, v, (KLevels.Config.PlayerLevels[k - 1] or 0)
    end
end

/*
    PLAYER:GetAbilityLevel(ability)
    Returns:
    Player's Current Ability Level
    Excess XP from previous level. (NOT FULL XP)
    XP needed for next level.
*/
function meta:GetAbilityLevel(ability) // Get player's Ability level
    local lvl = ability:GetMinLevel()
    if (not isstring(ability)) then ability = ability:GetSQL() end

    local xp = tonumber(self:GetNWInt("KLevels_"..ability, 0))

    local count = 0
    for k,v in pairs(KLevels.Config.AbilityLevels) do
        count = count + v        
    end

    if (xp > count) then
        local newxp = xp - count
        lvl = 10

        lvl = lvl + math.floor(newxp / 1000)
        newxp = newxp - (1000 * (lvl - 10))

        return lvl, newxp, 1000
    elseif (xp >= 100) then
        for k,v in SortedPairs(KLevels.Config.AbilityLevels) do
            xp = xp - (KLevels.Config.AbilityLevels[k - 1] or 0)
            if (xp >= v) then continue end

            return k - 1, xp, KLevels.Config.AbilityLevels[k + 1]
        end
    end

    return lvl, xp ,100
end

/*
    KLevels.GetXPFromLevel(level)
    Returns:
    total XP required to get to that level
*/
function KLevels.GetXPFromLevel(level)
    if (not isnumber(level)) then return 0 end

    for k,v in SortedPairs(Config.PlayerLevels) do
        if (level> k) then continue end

        return v
    end

    return 0
end

/*
    KLevels.GetAbilityXPFromLevel(level)
    Returns:
    total XP required to get to that ability level
*/
function KLevels.GetAbilityXPFromLevel(level)
    if (not isnumber(level)) then return 0 end

    local count = 0
    for k,v in pairs(Config.AbilityLevels) do
        count = count + v
    end
    local xp = 0
    if (level < 10) then
        for k,v in SortedPairs(Config.AbilityLevels) do
            if (level + 1 > k) then xp = xp + v continue end

            return xp
        end
    else

        return count + ((level - 10) * 1000)
    end

    return 0
end

/*
    KLevels.Config.GetMaterial(level)
    Returns:
    a level's Emblem as a material.
*/
function KLevels.Config.GetMaterial(plylvl)
    local material = nil
    for k,v in SortedPairs(Config.LevelIcons) do
        if (plylvl >= v) then continue end
    
        return Material("rgb_mats/rgb_ranks/rank"..v..".png")
    end
end


Config.LevelIcons = {
    5,
    10,
    15,
    20,
    25,
    30,
    35,
    40,
    45,
    50,
    55,
    60,
    65,
    70,
    75,
    80,
}

Config.AbilityLevels = {-- Fuck tarkov for not having a formula for levels.
    100, 
    100,
    200,
    300,
    400,
    500,
    600,
    700,
    800,
    900,
    1000,
}

Config.PlayerLevels = { -- Fuck tarkov for not having a formula for levels.
    0,
    1000,
    3743,
    7742,
    12998,
    19492,
    27150,
    36001,
    46026,
    57124,
    69350,
    82686,
    99500,
    119424,
    142477,
    168760,
    197979,
    230024,
    264490,
    301534,
    340696,
    382188,
    426190,
    473090,
    524580,
    580660,
    641330,
    706590,
    776440,
    850880,
    929910,
    1013530,
    1104494,
    1202802,
    1308454,
    1421450,
    1541790,
    1669474,
    1804502,
    1946874,
    2096590,
    2253650,
    2420808,
    2598064,
    2785418,
    2982870,
    3190420,
    3408068,
    3635814,
    3873658,
    4121600,
    4379640,
    4651450,
    4937030,
    5236380,
    5549500,
    5872950,
    6235061,
    6604597,
    6991575,
    7398749,
    7828873,
    8286537,
    8780921,
    9330385,
    9953289,
    10713893,
    11749897,
    13199001,
    23199001,
}
