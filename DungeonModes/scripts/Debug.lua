local Entities = require "system.game.Entities"


-- For debugging: (see also: invincibility.permanent = true)
event.objectDealDamage.add("DebugFun", {order="freeze", sequence=-10}, function(ev)
	-- print("Damage event:", ev)

	-- for obj in Entities.entitiesWithComponents({"health"}) do print("obj:", obj) end
	-- for _, obj in pairs(Entities.getEntitiesByType("RedDragur_RedDragurHead")) do print("obj:", obj) end
	-- print("obj:", Entities.getEntityPrototype("SpellTransform"))

	if ev.victim and ev.victim.playableCharacter then
		-- print(
		-- 	"Attached:",
		-- 	ev.victim.characterWithAttachment.attachmentID,
		-- 	Entities.getEntityByID(ev.victim.characterWithAttachment.attachmentID)
		-- )
		-- print("player:", ev.victim)


		-- local spellID = ev.victim.inventory.itemSlots.spell[1]
		-- print("obj:", spellID, Entities.getEntityByID(spellID))

		-- ev.damage = 0 -- no dying
	end
end)
