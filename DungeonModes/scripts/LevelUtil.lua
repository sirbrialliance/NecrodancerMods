
return {
	SequenceAdd = function(sequence, levelInfo)
		local n = #sequence
		--todo if needed: number should keep incrementing on deathless runs...but we don't support that...
		levelInfo.number = n + 1
		sequence[n + 1] = levelInfo
	end,
}

