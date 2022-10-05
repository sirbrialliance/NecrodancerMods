local LevelGenerator = require "necro.game.level.LevelGenerator"
local CurrentLevel = require "necro.game.level.CurrentLevel"
local Object = require "necro.game.object.Object"
local CustomEntities = require "necro.game.data.CustomEntities"
local DungeonLoader = require "necro.game.data.level.DungeonLoader"

local LevelUtil = require "DungeonModes.LevelUtil"

-- DungeonLoader.loadFromFile(fileName, levelNumber)

event.levelGenerate.add("GenerateLevel", {order="", sequence = -10}, function(level)
	print("levelGenerate", level)
	if level.options.type ~= "DungeonModes_Standard" then return end

	print("Generate level for options:", level.options)

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
      type = "training"
    },

		playerOptions = {},


	}

	-- print("gen level", level)


	-- level.options.isFinal = false
	-- level.options.isLoopFinal = false
end)


-- event.levelLoad.add("TestEvent", {order = "currentLevel", sequence = 2}, function(level)
-- 	-- print("handler did run", level.__name)
-- end)

-- event.musicTrack.add("TestMusicEvent", {order = "customMusic", sequence = 1}, function(ev)
-- 	-- print("event.musicTrack", ev)

-- 	local lists = CustomMusic.listPlaylists()
-- 	-- print("Custom playlists", CustomMusic.listPlaylists())
-- 	-- print("Custom playlists", CustomMusic.edit(lists[1]))
-- 	print("Custom playlists", CustomMusic.readMetadata(lists[1]))
-- 	-- CustomMusic.edit opens the edit GUI
-- end)
