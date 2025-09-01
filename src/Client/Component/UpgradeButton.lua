local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)
local Knit = require(ReplicatedStorage.Packages.Knit)
local Trove = require(ReplicatedStorage.Packages.Trove)

local UpgradeController = Knit.GetController("Upgrade")
local UpgradeService = Knit.GetService("Upgrade")
local UpgradeConfig = require(ReplicatedStorage.Shared.Config.Upgrades)

local UpgradeButton = Component.new({ Tag = "UpgradeButton", Ancestors = { Players.LocalPlayer.PlayerGui } })

function UpgradeButton:Construct()
    self.Trove = Trove.new()
    self.UpgradeName = self.Instance:GetAttribute("UpgradeName")
end

function UpgradeButton:Start()
    self.Trove:Connect(self.Instance.Activated, function()
        self:Upgrade()
    end)
    self.Trove:Add(UpgradeService.Upgrades:Observe(function(upgrades)
        local newLevel = upgrades[self.UpgradeName] or 1
        local cost = UpgradeConfig[self.UpgradeName].UpgradeCost(newLevel)
        self.Instance.Cost.Text = `${cost}`
    end))
end

function UpgradeButton:Stop()
    self.Trove:Clean()
end

function UpgradeButton:Upgrade()
    UpgradeController:PurchaseUpgrade(self.UpgradeName)
end

return UpgradeButton