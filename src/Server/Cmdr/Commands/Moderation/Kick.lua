return {
    Name = "Kick",
    Description = "Kick a player",
    Group = "Moderation",
    Args = {
        {
            Name = "Players",
            Description = "Whom to kick from the game",
            Type = "player",
        },
        {
            Name = "Reason",
            Description = "Why the player is being kicked",
            Type = "string"
        },
    },
}