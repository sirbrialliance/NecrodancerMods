local Object = require "necro.game.object.Object"
local Tile = require "necro.game.tile.Tile"
local TileTypes = require "necro.game.tile.TileTypes"

event.lobbyGenerate.add("AlterLobby", {order="medic", sequence = 10}, function(ev)
	Object.spawn("LabelBasic", -3, 4, {
		worldLabel = {
			text = "The Depths",
		},
	})

	local stairsObj = Object.spawn("TriggerStartRun", -3, 4, {
		trapStartRun = {
			mode = "DungeonModes_TheDepths"
		},
	})

	local stairsID = TileTypes.lookUpTileID("Stairs", 0)
	Tile.set(stairsObj.position.x, stairsObj.position.y, stairsID)

	-- print("tweaked", CurrentLevel.isLobby())

end)
