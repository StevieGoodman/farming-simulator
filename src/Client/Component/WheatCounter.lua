local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)
local Knit = require(ReplicatedStorage.Packages.Knit)
local Observers = require(ReplicatedStorage.Packages.Observers)
local Trove = require(ReplicatedStorage.Packages.Trove)

local UpgradeController = Knit.GetController("Upgrade")

local WheatCounter = Component.new({ Tag = "WheatCounter", Ancestors = { Players.LocalPlayer.PlayerGui } })

function WheatCounter:Construct()
    self.Trove = Trove.new()
end

function WheatCounter:RenderSteppedUpdate()
    self:Update()
end

function WheatCounter:Stop()
    self.Trove:Clean()
end

function WheatCounter:Update()
    local wheat = Players.LocalPlayer:GetAttribute("Wheat") or 0
    local level = UpgradeController:GetLevel("BagSize")
    local bagSize = UpgradeController:GetStrength("BagSize", level)
    self.Instance.Text = `{wheat}/{bagSize}`
end

return WheatCounter