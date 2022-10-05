local CustomEntities = require "necro.game.data.CustomEntities"
local Collision = require "necro.game.tile.Collision"
local Render = require "necro.render.Render"
local MinimapTheme = require "necro.game.data.tile.MinimapTheme"


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

	editorAdvanced = {},
	editorCategorySpecial = {},
})
