resource.AddWorkshop("2328703928")
util.AddNetworkString("KLevels_SetRecoil")

hook.Add("Initialize", "KLevels_CreateDB", function()
    if not sql.TableExists(KLevels.Config.DBName) then
        sql.Query("CREATE TABLE "..KLevels.Config.DBName.."(Name TEXT, SteamID TEXT, TotalXP INTEGER)")
    end

    for k,v in pairs(KAbility.List) do
        local column = sql.SQLStr(v.sql)
        sql.Query("ALTER TABLE "..KLevels.Config.DBName.." ADD "..column.." INTEGER")
    end
end)

hook.Add("PlayerInitialSpawn", "KLevels_HandleJoin", function(ply) // Doing all sort of stuff on player join
    if (not ply:IsPlayer()) then return nil end

    local steamid = sql.SQLStr(ply:SteamID())
    local name = sql.SQLStr(ply:Nick())

    local validate = sql.QueryValue("SELECT SteamID FROM "..KLevels.Config.DBName.." WHERE SteamID = "..steamid) // Do we have the player in the DB?
    if (not validate) then
        sql.Query("INSERT INTO "..KLevels.Config.DBName.."(Name, SteamID, TotalXP) VALUES("..name..", "..steamid..", 0)") // Add Player to DB
    end


    local abilitiesString = ""
    for k,v in pairs(KAbility.List) do // Get Abilities and make sure we can serach them in the DB
        abilitiesString = abilitiesString..","..v.sql 
    end
    abilitiesString = sql.SQLStr(string.sub(abilitiesString, 2, #abilitiesString), true)


    local row = sql.QueryRow("SELECT "..abilitiesString.." FROM "..KLevels.Config.DBName.." WHERE SteamID = "..steamid)
    for k,v in pairs(row or {}) do
        if (isnumber(tonumber(v))) then continue end
        sql.Query("UPDATE "..KLevels.Config.DBName.." SET "..k.." = 0 WHERE SteamID = "..steamid) // make sure there are no NULLs in the database.
    end


    local playerXPAbilities = sql.QueryRow("SELECT "..abilitiesString.." FROM "..KLevels.Config.DBName.." WHERE SteamID = "..steamid)
    print(sql.LastError())
    for ability,xp in pairs(playerXPAbilities or {}) do // Make sure there are no NULLs in the player's abilities.
        ply:SetNWInt("KLevels_"..ability, xp)
    end
    

    local playerTotalXP = sql.QueryValue("SELECT TotalXP FROM "..KLevels.Config.DBName.." WHERE SteamID = "..steamid)
    ply:SetNWInt("KLevels_TotalXP", tonumber(playerTotalXP)) // give player TotalXP

    sql.Query("UPDATE "..KLevels.Config.DBName.." SET Name = "..name.." WHERE SteamID = "..steamid) // Update player's name.
end)

hook.Add("PlayerDisconnected", "KLevels_HandleLeave", function(ply) // Committing players XP to  DB on Disconnect.
    for k,ability in pairs(KAbility.List) do
        ply:CommitAbilityXP(ability)
    end
end)

hook.Add("ShutDown", "KLevels_HandleShutdown", function() // Committing players XP to DB on server shutdown.
    for _,ply in ipairs(player.GetAll()) do
        ply:CommitXP()
        for _,ability in pairs(KAbility.List) do
            ply:CommitAbilityXP(ability)
        end
    end
end)

hook.Add("DoPlayerDeath", "KLevels_HandleDeaths", function(ply, attacker, dmginfo) // Giving players XP For Kills.
    if (not ply:IsPlayer() || not attacker:IsPlayer()) then return nil end
    if (ply == attacker) then return nil end
    
    attacker:GiveXP(KLevels.Config.KillsXPAmount)
end)

timer.Create("KLevels_CommitPlayersXP", KLevels.Config.CommitXPTimer, 0, function() // Commiting players XP to Database.
    for _,ply in ipairs(player.GetAll()) do
        ply:CommitXP()

        for _,ability in pairs(KAbility.List) do
            ply:CommitAbilityXP(ability)
        end
    end
end)

timer.Create("KLevels_PlaytimeXP", KLevels.Config.TimeTickSpeed, 0, function() // Giving players XP for playtime.
    for _,ply in ipairs(player.GetAll()) do
        ply:GiveXP(KLevels.Config.TimeXPAmount)
    end
end)
