local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Cmdr = require(ReplicatedStorage.Packages.Cmdr)
local Knit = require(ReplicatedStorage.Packages.Knit)

-- Start Knit
Knit.AddServices(script.Knit)
local success, result = Knit.Start():await()
assert(success, `Failed to start Knit on the server: {result}`)
print("Knit has successfully started on the server!")

-- Start Component
for _, component in script.Component:GetDescendants() do
    if not component:IsA("ModuleScript") then continue end
    require(component)
end
print(`Component has successfully started on the server!`)

-- Start Cmdr
Cmdr:RegisterCommandsIn(script.Cmdr.Commands)
Cmdr:RegisterHooksIn(script.Cmdr.Hooks)
-- Cmdr:RegisterTypesIn(script.Cmdr.Types)
print("Cmdr has successfully started on the server!")