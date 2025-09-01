local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)
local Knit = require(ReplicatedStorage.Packages.Knit)
local Trove = require(ReplicatedStorage.Packages.Trove)

local UpgradeController = Knit.GetController("Upgrade")

local UpgradeStatsLabel = Component.new({ Tag = "UpgradeStatsLabel", Ancestors = { Players.LocalPlayer.PlayerGui } })

function UpgradeStatsLabel:Construct()
    self.Trove = Trove.new()
    self.UpgradeName = self.Instance:GetAttribute("UpgradeName")
end

function UpgradeStatsLabel:RenderSteppedUpdate()
    self:Update()
end

function UpgradeStatsLabel:Stop()
    self.Trove:Clean()
end

function UpgradeStatsLabel:Update()
    local level = UpgradeController:GetLevel(self.UpgradeName)
    local currentLevelStrength = UpgradeController:GetStrength(self.UpgradeName, level)
    local nextLevelStrength = UpgradeController:GetStrength(self.UpgradeName, level + 1)
    self.Instance.Text = `{currentLevelStrength} → {nextLevelStrength}`
end

return UpgradeStatsLabel