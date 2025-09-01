local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Component = require(ReplicatedStorage.Packages.Component)
local Comm = require(ReplicatedStorage.Packages.Comm)
local Knit = require(ReplicatedStorage.Packages.Knit)
local Trove = require(ReplicatedStorage.Packages.Trove)

local WheatService = Knit.GetService("Wheat")
local Wheat = require(ServerScriptService.Server.Component.Wheat)

local Axe = Component.new({ Tag = "Axe", Ancestors = { workspace } })
Axe.Comm = Comm.ServerComm.new(ReplicatedStorage, "Axe")
Axe.Comm:BindFunction("Swing", function(player, axe)
    local axeComponent = Axe:FromInstance(axe)
    assert(axeComponent, "Axe component not found for the given instance")
    return axeComponent:OnSwing(player)
end)

function Axe:Construct()
    self.Trove = Trove.new()
end

function Axe:Stop()
    self.Trove:Clean()
end

function Axe:OnSwing(player: Player)
    local character = player.Character
    if character == nil then return end
    local origin = character:GetPivot().Position
    local wheatHarvested = Wheat.Harvest(origin, 4)
    WheatService:AddWheat(player, wheatHarvested)
end

return Axe