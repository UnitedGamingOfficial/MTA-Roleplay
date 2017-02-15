local versions = { }

function setPlayerVersion(player, version)
	versions[player] = version
end

function getPlayerVersion(player)
	return versions[player]
end