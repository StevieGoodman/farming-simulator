return {
	Name        = "Ban",
	Description = "Bans a player",
	Group       = "Moderation",
	Args        = {
		{
			Name = "Players",
			Description = "Whom to ban from the game",
			Type = "players # numbers",
		},
        {
            Name = "Duration",
            Description = "How long the player should be banned for (in seconds)",
            Type = "duration",
        },
		{
			Name = "Reason",
			Description = "Why the player is being banned",
			Type = "string"
		},
	},
}