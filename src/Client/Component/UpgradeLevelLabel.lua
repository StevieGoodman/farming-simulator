local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)
local Knit = require(ReplicatedStorage.Packages.Knit)
local Trove = require(ReplicatedStorage.Packages.Trove)

local UpgradeController = Knit.GetController("Upgrade")

local UpgradeLevelLabel = Component.new({ Tag = "UpgradeLevelLabel", Ancestors = { Players.LocalPlayer.PlayerGui } })

function UpgradeLevelLabel:Construct()
    self.Trove = Trove.new()
    self.UpgradeName = self.Instance:GetAttribute("UpgradeName")
end

function UpgradeLevelLabel:RenderSteppedUpdate()
    self:Update()
end

function UpgradeLevelLabel:Stop()
    self.Trove:Clean()
end

function UpgradeLevelLabel:Update()
    local level = UpgradeController:GetLevel(self.UpgradeName)
    self.Instance.Text = `Level {level}`
end

return UpgradeLevelLabel