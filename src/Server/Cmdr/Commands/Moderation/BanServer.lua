local Players = game:GetService("Players")

return function(context, players: {Players | number}, duration: number, reason: string)
	for index, player in players do
		players[index] = if typeof(player) == "number" then player else player.UserId
	end
	Players:BanAsync({
		UserIds = players,
		ApplyToUniverse = true,
		Duration = duration,
		DisplayReason = reason,
		PrivateReason = `Banned by {context.Executor or "system"}: {reason}`,
		ExcludeAltAccounts = false,
	})
	return `Banned {#players} player(s) from the game.`
end