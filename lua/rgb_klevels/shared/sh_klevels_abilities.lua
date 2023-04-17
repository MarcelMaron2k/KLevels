local meta = FindMetaTable("Player")

function KAbility:New(name, sql, maxlevel, minlevel, icon)
	-- This is the table we will return
	local Ability = {
		name = name or "Undefined",
		sql  = sql or "Undefined",
		maxlevel = maxlevel or 0,
        minlevel = minlevel or 0,
        icon = icon or Material(""),
    }
    table.insert(KAbility.List, Ability)
	return setmetatable( Ability, KAbility )
end

function KAbility:SetName(name)
    self.name = name
end
function KAbility:SetSQL(sql)
    self.sql = sql
end
function KAbility:SetMaxLevel(maxlevel)
    self.maxlevel = maxlevel
end
function KAbility:SetMinLevel(minlevel)
    self.minlevel = minlevel
end
function KAbility:SetIcon(icon)
    self.icon = icon
end

function KAbility:GetName()
    return self.name
end
function KAbility:GetSQL()
    return self.sql
end
function KAbility:GetMaxLevel()
    return self.maxlevel
end
function KAbility:GetMinLevel()
    return self.minlevel
end
function KAbility:GetIcon()
    return self.icon
end 

function KAbility:__ToString()
    return "Ability ".."["..self.name.."]"
end

function KAbility.GetByName(name)
    if (not isstring(name)) then return false end

    name = string.lower(name)

    for k,v in pairs(KAbility.List) do
        if (string.find(string.lower(v:GetName()), name, 1)) then return v end
    end

    return false
end
