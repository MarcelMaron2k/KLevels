KLevels = {}
KLevels.Config = {}
if (CLIENT) then KLevels.Client = {} end

KAbility = {}
KAbility.List = {}
KAbility.__index = KAbility


local path = "rgb_klevels/"

if SERVER then

	print("-----------------------")
	print("Started Loading KLevels")
	
    include(path.."config_klevels.lua")
	AddCSLuaFile(path.."config_klevels.lua")

	local files, folders = file.Find(path .. "*", "LUA")

    for _, folder in SortedPairs(folders, true) do
        print("---------")
		print("Loading folder:", folder)

		for b, File in SortedPairs(file.Find(path .. folder .. "/sv_*.lua", "LUA"), true) do
			print("Loading file:", File)
			include(path .. folder .. "/" .. File)
		end
		for b, File in SortedPairs(file.Find(path .. folder .. "/cl_*.lua", "LUA"), true) do
			print("Loading file:", File)
			AddCSLuaFile(path .. folder .. "/" .. File)
		end
		for b, File in SortedPairs(file.Find(path .. folder .. "/sh_*.lua", "LUA"), true) do
			print("Loading file:", File)
			AddCSLuaFile(path .. folder .. "/" .. File)
			include(path .. folder .. "/" .. File)
		end
        if (folder == "klevels_abilities") then
            for b, File in SortedPairs(file.Find(path .. folder .. "/*.lua", "LUA"), true) do
				print("Loading file:", File)
				AddCSLuaFile(path .. folder .. "/" .. File)
                include(path .. folder .. "/" .. File)
            end
        end
	end
	print("Finished Loading KLevels")
	print("-----------------------")
end

if CLIENT then
	include(path.."config_klevels.lua")

	local files, folders = file.Find(path .. "*", "LUA")

    for _, folder in SortedPairs(folders, true) do
		for b, File in SortedPairs(file.Find(path .. folder .. "/sh_*.lua", "LUA"), true) do
			include(path .. folder .. "/" .. File)
		end
		for b, File in SortedPairs(file.Find(path .. folder .. "/cl_*.lua", "LUA"), true) do
			include(path .. folder .. "/" .. File)
		end
		if (folder == "klevels_abilities") then
            for b, File in SortedPairs(file.Find(path .. folder .. "/*.lua", "LUA"), true) do
                include(path .. folder .. "/" .. File)
            end
        end
	end
end

