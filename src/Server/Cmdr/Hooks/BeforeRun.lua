local MIN_RANK = if game.GameId == 129907317028750 then 254 else 253

function Hook(context)
	if context.Executor:GetRankInGroup(72032651) < MIN_RANK and context.Executor.UserId > 0 then return `You are not a developer and cannot run commands!` end
end

function Register(registry)
	registry:RegisterHook("BeforeRun", Hook)
end

return Register