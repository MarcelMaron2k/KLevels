local CATEGORY_NAME = "Utility"

------------------------------ GiveXP ------------------------------
local function givexp( calling_ply, target_plys, amount)
    for k,v in pairs(target_plys) do
        v:GiveXP(amount)
    end

    ulx.fancyLogAdmin( calling_ply, "#A Gave #T #s Experience!", target_plys, amount )
end
local giveexp = ulx.command( CATEGORY_NAME, "ulx givexp", givexp, "!givexp" )
giveexp:addParam{type=ULib.cmds.PlayersArg}
giveexp:addParam{ type=ULib.cmds.NumArg, hint="Exp"}
giveexp:defaultAccess( ULib.ACCESS_SUPERADMIN )
giveexp:help( "Adds XP to the specificed Players (can remove XP with negative number)" )

------------------------------ GiveAbilityXP ------------------------------
local ability_list = {}
for k,v in pairs(KAbility.List) do
    table.insert(ability_list, v:GetName())
end
local function giveabilityxp( calling_ply, target_plys, ability, amount)
    local abilitytbl = KAbility.GetByName(ability)
    for k,v in pairs(target_plys) do
        v:GiveAbilityXP(abilitytbl, amount)
    end

    ulx.fancyLogAdmin( calling_ply, "#A Gave #T #s #s Experience!", target_plys, amount ,ability )
end
local giveabxp = ulx.command( CATEGORY_NAME, "ulx giveabilityxp", giveabilityxp, "!giveabilityxp" )
giveabxp:addParam{type=ULib.cmds.PlayersArg}
giveabxp:addParam{ type=ULib.cmds.StringArg, completes=ability_list,hint="Ability"}
giveabxp:addParam{ type=ULib.cmds.NumArg, hint="Exp"}
giveabxp:defaultAccess( ULib.ACCESS_SUPERADMIN )
giveabxp:help( "Adds XP to the specificed Players (can remove XP with negative number)" )


------------------------------ SetLevel ------------------------------
local function setlevel( calling_ply, target_plys, level)
    for k,v in pairs(target_plys) do
        local playerLvl = v:GetLevel()
        local playerXP = v:GetNWInt("KLevels_TotalXP")
        local Exp = KLevels.GetXPFromLevel(level)

        local subXP = Exp - playerXP 
        v:GiveXP(subXP)            
    end

    ulx.fancyLogAdmin( calling_ply, "#A Set #T's Level to #s", target_plys, level )
end
local plysetlevel = ulx.command( CATEGORY_NAME, "ulx setlevel", setlevel, "!setlevel" )
plysetlevel:addParam{type=ULib.cmds.PlayersArg}
plysetlevel:addParam{ type=ULib.cmds.NumArg, hint="Level"}
plysetlevel:defaultAccess( ULib.ACCESS_SUPERADMIN )
plysetlevel:help( "Set the player's level." )

------------------------------ SetAbilityLevel ------------------------------
local function setabilitylevel( calling_ply, target_plys, ability, level)
    local abilitymeta = KAbility.GetByName(ability)
    if (level > abilitymeta:GetMaxLevel()) then
		ULib.tsayError( calling_ply, "Level is higher than Ability's Max Level.", true )
        return 
    end
    for k,v in pairs(target_plys) do
        local Exp = KLevels.GetAbilityXPFromLevel(level)
        local plyXP = v:GetNWInt("KLevels_"..abilitymeta:GetSQL())

        print(Exp - plyXP)
        v:SetNWInt("KLevels_"..abilitymeta:GetSQL(), math.Round(Exp))
    end

    ulx.fancyLogAdmin( calling_ply, "#A Set #T's #s Level to #s", target_plys, ability,level )
end
local plysetalevel = ulx.command( CATEGORY_NAME, "ulx setabilitylevel", setabilitylevel, "!setabilitylevel" )
plysetalevel:addParam{type=ULib.cmds.PlayersArg}
plysetalevel:addParam{ type=ULib.cmds.StringArg, completes=ability_list,hint="Ability"}
plysetalevel:addParam{ type=ULib.cmds.NumArg, hint="Level"}
plysetalevel:defaultAccess( ULib.ACCESS_SUPERADMIN )
plysetalevel:help( "Set the player's level." )
