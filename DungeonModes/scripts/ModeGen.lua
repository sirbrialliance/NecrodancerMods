local LevelGenerator = require "necro.game.level.LevelGenerator"

print("-- Dungeon Modes Startup --")

LevelGenerator.Type.extend("DungeonModes_TheDepths", "DungeonModes_TheDepths")

--[[
	Determines the levels you'll encounter during a depths run
]]--
event.levelSequenceUpdate.add("DepthsLevelSequence", {order="initSeed", sequence = 1}, function(ev)
	-- print("levelSequenceUpdate", ev)
	if ev.options.modeID ~= LevelGenerator.Type.DungeonModes_TheDepths then
		return
	end

	for levelNum = 1, 10 do
		table.insert(ev.sequence, {
			depth = levelNum,
			floor = 1,
			type = "DungeonModes_Standard",--I guess we could still call on the default generator here....
			zone = 1,
		})
	end

	print("made a sequence", ev)
end)
