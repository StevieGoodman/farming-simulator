local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)
local Comm = require(ReplicatedStorage.Packages.Comm)
local Trove = require(ReplicatedStorage.Packages.Trove)

local Axe = Component.new({ Tag = "Axe", Ancestors = { workspace } })
Axe.Comm = Comm.ClientComm.new(ReplicatedStorage, true, "Axe")
Axe.Swing = Axe.Comm:GetFunction("Swing")

function Axe:Construct()
    self.Trove = Trove.new()
end

function Axe:Start()
    self.Trove:Connect(self.Instance.Activated, function()
        Axe.Swing(self.Instance)
    end)
end

function Axe:Stop()
    self.Trove:Clean()
end

return Axe