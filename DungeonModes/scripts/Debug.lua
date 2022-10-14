

-- For debugging: (see also: invincibility.permanent = true)
event.objectDealDamage.add("NoDying", {order="freeze", sequence=-10}, function(ev)
	if ev.victim and ev.victim.playableCharacter then
		-- print("player:", ev.victim)
		ev.damage = 0
	end
end)
