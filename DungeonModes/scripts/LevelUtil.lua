local DungeonFile = require "necro.client.custom.DungeonFile"
local StringUtilities = require "system.utils.StringUtilities"

return {
	SequenceAdd = function(sequence, levelInfo)
		if levelInfo == nil then return end

		local n = #sequence
		--todo if needed: number should keep incrementing on deathless runs...but we don't support that...
		levelInfo.number = n + 1
		sequence[n + 1] = levelInfo
	end,

	-- Given a level file's base name, returns the level in the file with the given name, if any.
	GetPrefabLevel = function(levelSet, levelName)
		local fileName = "mods/DungeonModes/dungeons/" .. levelSet .. ".necrolevel"
		local fileData = DungeonFile.loadFromFile(fileName)

		for _, level in ipairs(fileData.levels) do
			if level.NecroEdit_name == levelName then
				return level
			end
		end

		return nil
	end,

	GetMatchingPrefabs = function(levelSet, levelPrefix)
		local ret = {}
		local fileName = "mods/DungeonModes/dungeons/" .. levelSet .. ".necrolevel"
		local fileData = DungeonFile.loadFromFile(fileName)

		for _, level in ipairs(fileData.levels) do
			if StringUtilities.startsWith(level.NecroEdit_name, levelPrefix) then
				ret[#ret + 1] = level.NecroEdit_name
			end
		end

		return ret
	end
}

