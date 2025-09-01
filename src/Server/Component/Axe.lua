local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)
local Comm = require(ReplicatedStorage.Packages.Comm)
local Knit = require(ReplicatedStorage.Packages.Knit)
local Trove = require(ReplicatedStorage.Packages.Trove)

local UpgradeService = Knit.GetService("Upgrade")
local WheatService = Knit.GetService("Wheat")
local Wheat = require(ReplicatedStorage.Shared.Component.Wheat)

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
    local level = UpgradeService:GetLevel(player, "AxeStrength")
    local strength = UpgradeService:GetStrength("AxeStrength", level)
    wheatHarvested *= strength
    WheatService:AddWheat(player, wheatHarvested)
end

return Axe