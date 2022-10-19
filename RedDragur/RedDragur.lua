local Components = require "necro.game.data.Components"
local CustomEntities = require "necro.game.data.CustomEntities"
local Action = require "necro.game.system.Action"
-- local OutlineFilter = require "necro.render.filter.OutlineFilter"
local Damage = require "necro.game.system.Damage"
local Attack = require "necro.game.character.Attack"
local Entities = require "system.game.Entities"

-- I think certain Chaunter features are buried in Sync_possessable,
-- so we have to emulate the behavior.
-- Namely, I think things like Sync_possessableDelayOverride, Sync_possessableTimer,
-- and Sync_possessableGlow won't work if Sync_possessable.possessor isn't set?
-- Anyway, playable characters can't have Sync_possessable, the game just locks up.

Components.register({
	fixMoveDelay = {},
	bloodlustTimer = {
		Components.dependency("damageCountdown"),
		Components.field.int("killBeatsEarned", 4),
	},
})

event.turn.add("KeepMoving", {order="updateAttachments"}, function(ev)
	-- Note: filter="RedDragur_fixMoveDelay" doens't work here

	for k, action in ipairs(ev.actionQueue) do
		if action.entity.RedDragur_fixMoveDelay and action.ev.result == Action.Result.MOVE then
			action.entity.beatDelay.counter = 0
		end
	end
end)

event.gameStateLevel.override("resetDamageCountdown", {sequence=1}, function(orig, ev)
	local prevStates = {}
	for player in Entities.entitiesWithComponents({"RedDragur_bloodlustTimer"}) do
		-- No timer reset on new level
		prevStates[player] = player.damageCountdown.countdown
	end

	orig(ev)

	for player in Entities.entitiesWithComponents({"RedDragur_bloodlustTimer"}) do
		if prevStates[player] then
			player.damageCountdown.countdown = prevStates[player]
		end
	end
end)

event.objectKill.override("resetDamageCountdown", {sequence=1, filter="RedDragur_bloodlustTimer"}, function(orig, ev)
	local bloodlust = ev.entity.RedDragur_bloodlustTimer
	if bloodlust then
		-- Not full reset, just add beats
		ev.entity.damageCountdown.countdown = (
			ev.entity.damageCountdown.countdown +
			bloodlust.killBeatsEarned
		)
	else
		print("filter is wrong?")
		orig(ev)
	end
end)

-- todo: emulate Chaunter and don't count down on beats we can't move.
-- event.turn.override("reduceDamageCountdown", {sequence=1}, function(orig, ev)
-- 	for k, action in ipairs(ev.actionQueue) do
-- 		if action.entity.RedDragur_bloodlustTimer then
-- 			print("action.entity.damageCountdown", action.entity.damageCountdown)
-- 		end
-- 	end

-- 	orig(ev)
-- end)


CustomEntities.extend({
	name = "DragonFireball",
	template = CustomEntities.template.item("spell_fireball"),
	components = {
		friendlyName = {name = "Dragon Fire"},
		itemHintLabel = {text = "Dragon Fire"},
		itemSlot = {name = "spell"},
		itemCastOnUse = {spell = "SpellcastFireballDragon"},
		spellCooldownKills = {cooldown = 0},
		spellCooldownTime = {cooldown = 3},
		spellBloodMagic = false,
		spellUseCasterFacingDirection = {},
		sprite = {
			texture = "mods/RedDragur/DragonFireball.png",
			width = 24,
			height = 24
		},

		voiceSpellTypeSuffix = false,
		itemPoolChest = false,
		itemPoolRedChest = false,
		itemPoolPurpleChest = false,
		itemPoolBlackChest = false,
		itemPoolLockedChest = false,
		itemPoolShop = false,
		itemPoolLockedShop = false,
		itemPoolUrn = false,
		itemPoolSecret = false,
		itemPoolFood = false,
		itemPoolHearts = false,
		itemPoolCrate = false,
		itemPoolWar = false,
		itemPoolUncertainty = false,
		itemPoolEnchant = false,
		itemPoolNeed = false,
		itemPoolVault = false,
		itemExcludeFromTransmute = false,
		itemExcludeFromBossChests = false,
		itemBanHealthlocked = false,
		itemBanWeaponlocked = false,
		itemBanShoplifter = false,
		itemBanNoDamage = false,
		itemBanDiagonal = false,
		itemBanMoveAmplifier = false,
		itemBanPoverty = false,
		itemBanKillPoverty = false,
		itemBanPacifist = false,
		itemBanInnateSpell = false,
		itemBanAria = false,
		itemBanDorian = false,
		itemBanEli = false,
		itemBanDiamond = false,
		itemBanMary = false,
		itemBanTempo = false,
	},
})



------------ Character ------------

local components = {
	------------ Character Base ------------
	friendlyName = {name = "Red Dragur"},
	textCharacterSelectionMessage = {
		text = "Basically Chaunter posessing a red dragon.\nLose HP over time, kill to regen.\nLose the capture and you die."
	},
	playableCharacter = {
		lobbyOrder = 100,
	},
	bestiary = {image = "ext/bestiary/bestiary_reddragon.png"},
	initialInventory = {items = {
		"HeadCrownOfThorns",
		"RedDragur_DragonFireball",
	}},


	------------ Rules ------------
	health = {
		maxHealth = 6,
		health = 7, -- we start missing half a heart 'cuz of equipping crown of thorns
	},
	damageCountdown = {
		countdown = 24,
    countdownReset = 16,
    damage = 1,
    killerName = "Bloodlust",
    type = Damage.Type.SELF_DAMAGE,
	},
	RedDragur_bloodlustTimer = {
		killBeatsEarned = 4,
	},
	RedDragur_fixMoveDelay = {},
	actionDelay = {
		actions = {
			[13] = {
				beatDelay = 1,
				sound = "dragonPrefire"
			},
		},
		currentAction = 0,
		delay = 0
	},
	dig = {
		innateShovel = false,
		isPlayer = false,
		silentFail = false,
		strength = 4
	},
	innateAttack = {
		damage = 6,
		flags = 1,
		knockback = 0,
		swipe = "enemy",
		type = 40
	},
	beatDelay = {
		counter = 0,
		interval = 2
	},
	beatDelayBypass = {
		actions = {
			[13] = true
		}
	},
	inventoryCursedSlots = {
		slots = {spell = true}
	},
	attackable = {
		-- we don't want Attack.Flag.TRAP
		currentFlags = 1827,
		flags = 803
	},

	------------ Visuals/Sounds ------------
	CharacterSkins_equipmentSprites = false,
	DynChar_dynamicCharacter = false,
	positionalSprite = {
		offsetX = -22,
		offsetY = -24
	},
	moveSwipe = {
		duration = 0.33333333333333,
		height = 24,
		numFrames = 5,
		offsetY = -2,
		texture = "ext/particles/jump_dirt.png",
		width = 24
	},
	Sync_possessableGlow = {
		color = 1000,
		hideEyes = true
	},
	-- It's easiest to just get rid of characterWithAttachment, but it breaks the "Change Skin" menu.
	-- So instead of characterWithAttachment = false, we do Voodoo with RedDragurHead instead.
	-- Mind, changing the dragon's skin doens't work, but I don't care to try to make it work.
	facingMirrorX = {
		directions = {
			 -1, -1,
			[4] = 1,
			[5] = 1,
			[6] = 1,
			[8] = -1
		}
	},
	screenShakeOnWalk = {
		duration = 0.25,
		intensity = 10,
		range = 16
	},
	shadow = {
		offsetX = 0,
		offsetY = 0,
		offsetZ = -900,
		originX = 0,
		originY = 10,
		scale = 1,
		texture = "ext/entities/TEMP_shadow_large.png",
		visible = true
	},
	shadowPosition = {
		x = -36,
		y = 72
	},
	sprite = {
		color = -1711276033,
		height = 51,
		mirrorOffsetX = 7,
		mirrorX = 1,
		mirrorY = 1,
		originX = 0,
		originY = 10,
		scale = 1,
		texture = "ext/entities/dragon_red.png",
		textureShiftX = 61,
		textureShiftY = 0,
		visible = true,
		width = 61,
		x = -58,
		y = 48
	},
	spriteCropOnDescent = {
		acceleration = 540,
		active = false,
		cropOffset = 7,
		descentType = 2,
		offset = 3.6,
		velocity = -126
	},
	spriteCropOnSink = {
		animationDelay = 0,
		animationDuration = 0.05,
		endCrop = 0,
		sinkDistance = 6,
		sinkOffset = 0,
		startCrop = 0
	},
	spriteSheet = {
		frameX = 2,
		frameY = 1
	},
	rowOrder = {
		-- for the game data I inspected, it's 56, which is too high.
		z = 40,
	},

	-- fixme: So picking up leather armor turns the dragon black (spriteSheet.frameY = 2).
	-- Haven't found a way to address that w/out making a new sprite sheet.
		-- itemArmorBodySpriteRow = {row = 0},
		-- characterEquipmentSpriteRow = {defaultBodyRow = 3},
		-- spriteSheetRowWrap = {frames = 4},

	bounceTweenOnAttack = {tween = 2},
	soundHit = { -- soundHit
		sound = "generalHit"
	},
	soundWalk = { -- soundWalk
		playOnKnockback = false,
		sound = "dragonWalk"
	},
	voiceAttack = {
		sound = "dragonAttack"
	},
	voiceMeleeAttack = {
		sounds = {"dragonAttack"}
	},
	voiceDeath = {
		sound = "dragonDeath"
	},
	voiceHit = {
		minimumDamage = 0,
		sound = "dragonHit"
	},
	voiceSpawn = {
		sound = "dragonRoar"
	},
	voiceDig = false,
	voiceGrab = false,
	voiceReveal = false,
	voiceHeal = false,
	actionDelayAnimation = {
		frames = {5, 6, 7},
	},
	moveResultAnimation = {
		active = false,
		result = 4, -- after spell cast
		frames = {
			frames = {8, 9},
			offBeat = {
				duration = 0.2,
				hold = false,
				loop = false
			},
			times = {0, 0.5}
		},
	},
}

-- Hacks to keeps the dragon from having a glitched-out extra head but still not break the skins menu.
-- (I guess extending a player makes a {player}Head entitiy that magically appears and follows the player
-- around.)
CustomEntities.register({
	name = "RedDragurHead",
	gameObject = {},
	sprite = {width = 0, height = 0},
})

CustomEntities.extend({
	name = "RedDragur",
	template = CustomEntities.template.player(0),
	components = components,
})

