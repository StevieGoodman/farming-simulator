return function(_, player:Player, reason: string)
    player:Kick(reason)
    return `Kicked {player.Name} from the game.`
end