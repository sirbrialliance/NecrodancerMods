local LevelGenerator = require "necro.game.level.LevelGenerator"

local LevelUtil = require "DungeonModes.LevelUtil"

print("-- Dungeon Modes Startup --")

LevelGenerator.Type.extend("DungeonModes_TheDepths", "DungeonModes_TheDepths")

--[[
	Determines the levels you'll encounter during a depths run.
	See https://vortexbuffer.com/synchrony/docs/modules/necro.game.level.LevelSequence/
]]--
event.levelSequenceUpdate.add("DepthsLevelSequence", {order="initSeed", sequence = 1}, function(ev)
	-- print("levelSequenceUpdate", ev)
	if ev.options.modeID ~= LevelGenerator.Type.DungeonModes_TheDepths then return end

	-- for levelNum = 1, 10 do ... end

	print("Wave levels:", LevelUtil.GetMatchingPrefabs("Depths", "Wave_"))

	LevelUtil.SequenceAdd(ev.sequence, {
		depth = 1,
		floor = 1,
		type = "DungeonModes_Prefab",
		DungeonModes_levelSet = "Depths",
		DungeonModes_prefab = "Start",
		zone = 1,
	})

	LevelUtil.SequenceAdd(ev.sequence, {
		depth = 1,
		floor = 1,
		type = "DungeonModes_Standard",
		zone = 1,
	})

	LevelUtil.SequenceAdd(ev.sequence, {
		depth = 1,
		floor = 1,
		number = 1,
		type = "Necro",
		zone = 1,
	})

	-- print("made a sequence", ev)
end)



-- event.levelSequenceUpdate.add("DebugLevelSequence", {order="levelIndices", sequence = 100}, function(ev)
-- 	-- print("levelSequence:", ev)
-- 	print("levelSequence:", ev.sequence)
-- end)

