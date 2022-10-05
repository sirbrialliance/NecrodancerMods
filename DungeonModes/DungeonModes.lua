local Event = require "necro.event.Event"
local LevelGenerator = require "necro.game.level.LevelGenerator"
local CurrentLevel = require "necro.game.level.CurrentLevel"
local Object = require "necro.game.object.Object"
local CustomEntities = require "necro.game.data.CustomEntities"
local Tile = require "necro.game.tile.Tile"
local TileTypes = require "necro.game.tile.TileTypes"

print("-- Dungeon Modes Startup --")

LevelGenerator.Type.extend("DungeonModes_HundredFloors", "DungeonModes_HundredFloors")

event.lobbyGenerate.add("AddLobbyModes", {order="medic", sequence = 10}, function(ev)
	Object.spawn("LabelBasic", -3, 4, {
		worldLabel = {
			text = "100 Floors",
		},
	})

	local stairsObj = Object.spawn("TriggerStartRun", -3, 4, {
		trapStartRun = {
			mode = "DungeonModes_HundredFloors"
		},
	})

	local stairsID = TileTypes.lookUpTileID("Stairs", 0)
	Tile.set(stairsObj.position.x, stairsObj.position.y, stairsID)

	print("tweaked", CurrentLevel.isLobby())

end)

event.levelSequenceUpdate.add("LSU", {order="initSeed", sequence = 1}, function(ev)
	-- print("levelSequenceUpdate", ev)
	if ev.options.modeID ~= LevelGenerator.Type.DungeonModes_HundredFloors then
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

	-- print("made a sequence", ev)
end)

-- event.levelSequenceUpdate.add("LSU2", {order="levelIndices", sequence = 100}, function(ev)
-- 	print("levelSequenceUpdate2", ev)
-- end)

event.levelGenerate.add("LevelGenerate", {order="", sequence = 10}, function(level)
	-- print("levelGenerate", level)
	if level.options.modeID ~= LevelGenerator.Type.DungeonModes_HundredFloors then return end

	-- Level.Data, see https://vortexbuffer.com/synchrony/docs/modules/necro.game.level.LevelLoader/#class-Level.Data
	level.level = {
		boss = 0,
		number = level.options.number,
		depth = level.options.depth,
		floor = level.options.floor,
		zone = level.options.zone,
		name = level.options.depth.."/100",
		seed = level.options.seed,

		isProcedural = true,
		isFinal = false,
		isLoopFinal = false,

		entities = {
			{
				type = "WallTorch",
				x = -1, y = -1,
				attributes = {{
					component = "lightSourceRadial",
					field = "outerRadius",
					value = 1344
				}}
			},
			{
				type = "WallTorch",
				x = 3, y = 3,
				attributes = {{
					component = "lightSourceRadial",
					field = "outerRadius",
					value = 1344
				}}
			},
		},

		segments = {{
			-- bounds = {-2, -2, 2, 2},
			bounds = {-1, -1, 5, 5}, -- NB: x,y,w,h, not x1,y1,x2,y2
			tiles = {
				-- NB: 0 = void, 1 = first item in tileNames
				1, 1, 1, 1, 1,
				1, 2, 2, 2, 1,
				1, 2, 3, 2, 1,
				1, 2, 2, 2, 1,
				1, 1, 1, 1, 1,
			},
		}},

		tileMapping = {
			tilesetNames = {[0] = "Zone1"},
			tileNames = {"UnbreakableWall", "Floor", "Stairs"},
			tilesets = {0, 0, 0},
		},

		music = {
      type = "lobby"
    },

		playerOptions = {},


	}

	print("gen level", level)


	-- level.options.isFinal = false
	-- level.options.isLoopFinal = false
end)


-- event.levelLoad.add("TestEvent", {order = "currentLevel", sequence = 2}, function(level)
-- 	-- print("handler did run", level.__name)
-- end)
