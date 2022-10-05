local LevelGenerator = require "necro.game.level.LevelGenerator"

event.levelSequenceUpdate.add("GenerateLevelSequence", {order="initSeed", sequence = 1}, function(ev)
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
