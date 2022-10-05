local LevelGenerator = require "necro.game.level.LevelGenerator"

print("-- Dungeon Modes Startup --")

LevelGenerator.Type.extend("DungeonModes_TheDepths", "DungeonModes_TheDepths")

--[[
	Determines the levels you'll encounter during a depths run.
	See https://vortexbuffer.com/synchrony/docs/modules/necro.game.level.LevelSequence/
]]--
event.levelSequenceUpdate.add("DepthsLevelSequence", {order="initSeed", sequence = 1}, function(ev)
	-- print("levelSequenceUpdate", ev)
	if ev.options.modeID ~= LevelGenerator.Type.DungeonModes_TheDepths then return end

	local levelNumber = 1

	-- for levelNum = 1, 10 do
	for levelNum = 1, 1 do
		table.insert(ev.sequence, {
			depth = levelNum,
			floor = 1,
			type = "DungeonModes_Standard",--I guess we could still call on the default generator here....
			zone = 1,
			number = levelNumber,
		})
		levelNumber = levelNumber + 1
	end

	table.insert(ev.sequence, {
		depth = 1,
		floor = 1,
		number = 1,
		type = "Necro",
		zone = 1,
		number = levelNumber,
	})
	levelNumber = levelNumber + 1

	-- print("made a sequence", ev)
end)



event.levelSequenceUpdate.add("DebugLevelSequence", {order="levelIndices", sequence = 100}, function(ev)
	print("levelSequence:", ev)
end)

