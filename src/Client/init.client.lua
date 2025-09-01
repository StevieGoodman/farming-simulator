local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

local MIN_RANK = if game.GameId == 129907317028750 then 254 else 253

-- Start Knit
Knit.AddControllers(script.Knit)
local success, result = Knit.Start():await()
assert(success, `Failed to start Knit on the server: {result}`)
print("Knit has successfully started on the server!")

-- Start Component
for _, component in script.Component:GetDescendants() do
    if not component:IsA("ModuleScript") then continue end
    require(component)
end
for _, component in ReplicatedStorage.Shared.Component:GetDescendants() do
    if not component:IsA("ModuleScript") then continue end
    require(component)
end
print(`Component has successfully started on the server!`)

-- Start Cmdr
if Players.LocalPlayer:GetRankInGroup(72032651) < MIN_RANK and Players.LocalPlayer.UserId > 0 then return end
local Cmdr = require(ReplicatedStorage:WaitForChild("CmdrClient", 60))
Cmdr:SetActivationKeys({ Enum.KeyCode.F2 })
print("Cmdr has successfully started on the server!")