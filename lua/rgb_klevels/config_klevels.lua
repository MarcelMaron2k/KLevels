local Config = KLevels.Config -- Don't Touch Please
/*  
    The Name of the database in SQL. Use to easily and quickly reset player data. 
    Make sure there are no Spaces or Special Characters.      
    Default: KLevels_Players  
*/
Config.DBName = "KLevels_Players"

/* 
    List of commands to open the levels menu.
*/
Config.Commands = {
    "/levels",
    "!levels",
}

/* 
    How often players gain XP through playtime.
    Default: 3 seconds
*/
Config.PlaytimeXPTick = 3

/* 
    How much players gain XP through playtime.
    Default: 5
*/
Config.PlaytimeXPAmount = 5

/* 
    How much players gain XP through kills.
    Default: 15
*/
Config.KillsXPAmount = 15

/*
    How Often (in seconds) to add XP to the Strength Ability    
    Default: 3 seconds
*/
Config.StrengthTickSpeed = 3

/*
    How much XP to give to the Strength Ability
    Default: 5
*/
Config.StrengthXPAmount = 5

/*
    How Often (in seconds) to add XP to the Health Ability    
    Default: 3
*/
Config.HealthTickSpeed = 3

/*
    How much XP to give to the Health Ability
    Default: 5
*/
Config.HealthXPAmount = 5

/*
    How Often (in seconds) to add XP to the Covert Movement Ability    
    Default: 3
*/
Config.CovertTickSpeed = 3

/*
    How much XP to give to the Covert Movement Ability
    Default: 5
*/
Config.CovertXPAmount = 5

/*
    How Often (in seconds) to add XP to the Recoil Ability    
    Default: 3
*/
Config.RecoilTickSpeed = 3

/*
    How much XP to give to the Recoil Ability
    Default: 5
*/
Config.RecoilXPAmount = 5

/*
    How Often (in seconds) to add XP to the Recoil Ability    
    Default: 3
*/
Config.EnduranceTickSpeed = 3

/*
    How much XP to give to the Recoil Ability
    Default: 5
*/
Config.EnduranceXPAmount = 5

/*
    Sets the max stamina a player can have.
    This is specifically for the stamina system.
    Default: 70
*/
Config.StaminaMax = 70

/*
    How much XP to give to the Metabolism Ability
    Default: 5
*/
Config.MetabolismXPAmount = 5

/*
    How Often to Save player's XP to the server. (This exists in-case the server crashes, players won't lose too much progress.)
    Default: 180 seconds -- Warning, Don't lower this too much, especially don't set to 0. This WILL cause lag.
*/
Config.CommitXPTimer = 180

/*
    How often (in seconds) to give players XP for playtime.
    Default: 10 
*/
Config.TimeTickSpeed = 10

/* 
    How much XP to give players for playing.
    Default: 5
*/
Config.TimeXPAmount = 5 

/*
    How often and how much damage to apply to players when sprinting with painkillers (and broken legs)
    default: 1, 5 (5 damage every 1 second)
*/
Config.PainKillerDamage = {1,5}

/*
    To change the reduction, change the number 45 to something else.
    Default: 45
*/
function KLevels.Config.RecoilReduction(plylvl, maxlvl) -- Used to calculate recoil reduction
    return  1 - (plylvl*45) / (maxlvl*100) -- reduces recoil up to 45% at max level
end

/*
    To change the reduction, change the number 45 to something else.
    Default: 45
*/
function KLevels.Config.HungerReduction(plylvl, maxlvl) -- Used to calculate hunger reduction
    return 1 - (plylvl*45) / (maxlvl*100) -- reduces hunger up to 45% at max level
end

/*
    FOR THE CONCUSSION REDUCTION TO WORK, WE NEED TO EDIT ORIGINAL RLOC FILES.
    
    To change the reduction, change the number 45 to something else.
    Default: 45 
*/
function KLevels.Config.ConcussionChance(plylvl, maxlvl) -- Used to calculate concussion chance
    return 1 - (plylvl*45) / (maxlvl*100) -- reduces concussion chance up to 45% and max level.
end

/*
    To change the increase, change the number 45 to something else.
    Default: 45 
*/
function KLevels.Config.EnduranceIncrease(plylvl, maxlvl) -- Used to calculate Stamina Increase
    return 1 + (plylvl*45) / (maxlvl*100) -- Increase Stamina by 45% at max level.
end

/*
    To change the increase, change the number 45 to something else.
    Default: 45 
*/
function KLevels.Config.SpeedIncrease(plylvl, maxlvl) -- Used to calculate Speed Increase
    return 1 + (plylvl*45) / (maxlvl*100) -- Increase Speed by 45% at max level.
end

/*
    To change the increase, change the number 45 to something else.
    Default: 45 
*/
function KLevels.Config.CrouchIncrease(plylvl, maxlvl) -- Used to calculate Crouch Increase
    return 1 + (plylvl*45) / (maxlvl*100) -- Increase Speed by 45% at max level.
end

/*
    To change the increase, change the number 45 to something else.
    Default: 45 
*/
function KLevels.Config.JumpIncrease(plylvl, maxlvl) -- Used to calculate Jump Increase
    return 1 + (plylvl*45) / (maxlvl*100) -- Increase Jump power by 45% at max level.
end

// TODO: Abilities
/*
List of abilities for the level system
- Strength (faster player speed, higher jump power, and if you can more weight to be carried in PUBG Inventory) TODO: PUBG WEIGHT
- Health (more health, less chance of getting concussion from a headshot - on RALS of course) Done
- Metabolism (DarkRP hunger drains out slower) Done
- Recoil Control (Decreases CW2.0 SWEP.Recoil, -45% recoil on max level of this skill) Done
- Covert Movement (Faster crouching movement speed ONLY DO THIS IF ITS ACTUALLY POSSIBLE) Done


TODO: Ability Actions

How to raise specific skills:
Strength - Just walking, sprinting, jumping -- Done
Health - Healing, taking damage, using painkillers -- Done
Metabolism - Eating -- Done
Recoil Control - Shooting weapons -- Done
Covert Movement - Crouch walking -- Done