local Snapshot = require "necro.game.system.Snapshot"
local Entities = require "system.game.Entities"
local Flyaway = require "necro.game.system.Flyaway"
local Kill = require "necro.game.character.Kill"
local TextFormat = require "necro.config.i18n.TextFormat"
local UI = require "necro.render.UI"
local GFX = require "system.gfx.GFX"
local Menu = require "necro.menu.Menu"
local Render = require "necro.render.Render"
local FileIO = require "system.game.FileIO"

-- print("reloaded")


-- Have we told this client "Safe!" since last level?
local safeNotified = false
-- Have we told this client they are the last one?
local lastNotified = false

local stateText = ""

-- Useful thing for listing resource names:
-- print("dirs", FileIO.listFiles("", FileIO.List.RECURSIVE, FileIO.List.DIRECTORIES))
-- print("files", FileIO.listFiles("ext/gui", FileIO.List.RECURSIVE, FileIO.List.FILES))

local function getIconText(path)
	local dims = GFX.getImageGeometry(path)

	return TextFormat.icon(path, 1, {0, 0, dims.w, dims.h})
end

heartIconText = getIconText("ext/gui/heart.png")
deadIconText = getIconText("ext/gui/heart_empty.png")
stairsIconText = getIconText("ext/level/stairs.png")

local function notify(players, options)
	if type(options) == "string" then
		options = {
			text=options
		}
	end

	for _, player in pairs(players) do
		options.entity = player
		Flyaway.create(options)
	end
end

-- Updates HUD values and tells all players if someone is in the exit stairs,
-- if they're the last standing, etc.
local function updateDoomState()
	local totalCount = 0
	local alive = 0
	local alivePlayers = {}
	local dead = 0
	local inStairs = 0

	for player in Entities.entitiesWithComponents({"playableCharacter"}) do
		-- print("a player:", player)

		if not player.killable or player.killable.dead then
			dead = dead + 1
		elseif player.descent and player.descent.active then
			inStairs = inStairs + 1
		elseif player.spectator and player.spectator.active then
			-- don't count spectators (unless dead or in stairs)
			goto continue
		else
			alive = alive + 1
			table.insert(alivePlayers, player)
		end

		totalCount = totalCount + 1

		::continue::
	end

	-- print("states: ", alive, dead, inStairs)

	if totalCount > 1 then
		if inStairs > 0 and not safeNotified then
			notify(alivePlayers, "Safe!")
			safeNotified = true
		elseif inStairs == 0 and safeNotified then
			notify(alivePlayers, "Not safe!")
			safeNotified = false
		end

		if alive == 1 and inStairs == 0 and not lastNotified then
			notify(alivePlayers, {
				text="Last man standing!",
				size=15,
				duration=4,
			})
			lastNotified = true
		end

	end

	stateText = (
		alive .. heartIconText .. " " ..
		inStairs .. stairsIconText .. " " ..
		dead .. deadIconText
	)

	-- print("statestr:", stateText)
end

event.levelLoad.add("LevelInit", {order="music"}, function (ev)
	safeNotified = false
	lastNotified = false
end)

event.objectDeath.add("NoteDeath", {order="kill", sequence=10}, function (ev)
	if ev.entity and ev.entity.playableCharacter then

		-- Show cause of death
		local causeStr = "Dead!"

		local killerName = ev.killerName
		if not killerName and ev.killer then killerName = Kill.getKillerName(ev.killer) end

		if killerName then causeStr = "Dead: " ..  killerName end

		Flyaway.create({
			text=causeStr,
			entity= ev.entity,
			offsetY=8,
			duration=6,
			distance=-24,
		})
	end
end)

-- I  initially tried to use a bunch of event listeners, but there were funny corner cases.
-- I have better things to do with my time than try to figure out what's wrong, especially with
-- the lack of documentation.
-- So just update every tick.
event.tick.add("Update", {order="hud"}, function(ev)
	updateDoomState()
end)

-- event.objectSpectate.add("NoteSpectate", {order="spectator", sequence=10}, function (ev)
-- 	print("objectSpectate", ev)
-- 	updateDoomState()
-- end)

-- event.objectUnspectate.add("NoteUnspectate", {order="player"}, function (ev)
-- 	print("objectUnspectate", ev, ev.entity)
-- 	updateDoomState()
-- end)

-- leave level
event.objectDescentEnd.add("NoteDescend", {order="exitLevel", sequence=-10}, function (ev)
	-- print("objectDescentEnd", ev, ev.entity)
	updateDoomState()
end)

-- --start new level
-- event.gameStateLevel.add("NoteLevelStart", {order="initLoop", sequence=10}, function (ev)
-- 	print("gameStateLevel")
-- 	updateDoomState()
-- end)

event.render.add("Display", {order="hud"}, function ()
	-- if Menu.getCurrent() then return end

	local scale = UI.getScaleFactor()
	-- Try to draw this just above where the player list would show:
	UI.drawText({
		x=46 * scale,
		y=36 * scale,
		text=stateText,
		font=UI.Font.MEDIUM,
		size=50,
		buffer = Render.Buffer.UI_HUD,
	})
end)


updateDoomState()
