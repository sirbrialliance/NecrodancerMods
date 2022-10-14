local CustomEntities = require "necro.game.data.CustomEntities"
local Collision = require "necro.game.tile.Collision"
local Render = require "necro.render.Render"
local MinimapTheme = require "necro.game.data.tile.MinimapTheme"
local Attack = require "necro.game.character.Attack"
local Components = require "necro.game.data.Components"
local StateControl = require "necro.client.StateControl"
local Render = require "necro.render.Render"
local Utilities = require "system.utils.Utilities"

CustomEntities.register({
	name = "WavesRune",
	position = {},
	collision = {mask = Collision.Type.TRAP},
	attackable = false,

	spriteSheet = {frameX = 2},
	rowOrder = {z = Render.SPRITE_DECAL_Z + 1},
	minimapStaticPixel = {
		color = MinimapTheme.Color.TRAP,
		depth = MinimapTheme.Depth.TRAP,
	},
	sprite = {texture = "mods/DungeonModes/sprites/WavesRune.png"},
	positionalSprite = {
		offsetX = -1,
		offsetY = 12,
	},

	visibility = {},
	visibilityRevealWhenLit = {},
	visibilityVisibleOnProximity = {},
	silhouette = {},

	gameObject = {},

	editorName = {name = "Waves Rune"},
	editorAdvanced = {},
	editorCategorySpecial = {},
})

---------------------------------------------------------------------------------------------------

stairEntityCommon = {
	position = {},
	collision = {mask = Collision.Type.TRAP},
	attackable = false,

	trap = {targetFlags = Attack.Flag.CHARACTER},

	rowOrder = {z = Render.SPRITE_DECAL_Z},
	minimapStaticPixel = {
		color = MinimapTheme.Color.DOOR,
		depth = MinimapTheme.Depth.DOOR,
	},
	sprite = {
		texture = "ext/level/stairs.png",
		originX = 0,
		originY = 0,
	},
	positionalSprite = {
		offsetX = 0,
		offsetY = 12,
	},
	worldLabel = {
		text = "___",
	},

	visibility = {},
	visibilityRevealWhenLit = {},
	visibilityVisibleOnProximity = {},
	silhouette = {},

	gameObject = {},

	editorName = {name = "___"},
	editorAdvanced = {},
	editorCategorySpecial = {},
}

---------------------------------------------------------------------------------------------------

Components.register({
	trapReturnLevels = {}
})

CustomEntities.register(Utilities.mergeDefaults(stairEntityCommon, {
	name = "ReturnStairs",
	editorName = {name = "Return Stairs"},
	DungeonModes_trapReturnLevels = {},
	worldLabel = {text = "Go Back"},
}))

event.trapTrigger.add("LevelRewind", {order="descend", filter= "DungeonModes_trapReturnLevels"}, function (ev)
	print("Trap stairs triggered.", ev)
	-- StateControl.changeLevel takes the 1-based level index in the level sequence and
	-- can only go backwards, it appears.
	StateControl.changeLevel(3, 0)
end)

---------------------------------------------------------------------------------------------------

CustomEntities.register(Utilities.mergeDefaults(stairEntityCommon, {
	name = "CharSelCadence",
	editorName = {name = "Character Select: Cadence"},
	trapSelectCharacter = {character = "Cadence"},
	worldLabel = {text = "Become Cadence"},
}))

