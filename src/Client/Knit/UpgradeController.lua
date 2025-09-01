local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

local UpgradeService
local UpgradesConfig = require(ReplicatedStorage.Shared.Config.Upgrades)

local UpgradeController = Knit.CreateController({ Name = "Upgrade" })

function UpgradeController:KnitStart()
	UpgradeService = Knit.GetService("Upgrade")
end

function UpgradeController:GetLevel(upgradeName)
	local upgrades = UpgradeService.Upgrades:Get()
	return upgrades[upgradeName] or 1
end

function UpgradeController:GetCost(upgradeName, level)
	return UpgradesConfig[upgradeName].UpgradeCost(level)
end

function UpgradeController:GetStrength(upgradeName, level)
	return UpgradesConfig[upgradeName].Strength(level)
end

function UpgradeController:CanAffordUpgrade(upgradeName)
	local nextLevel = self:GetLevel(upgradeName) + 1
	local money = Players.LocalPlayer:GetAttribute("Money") or 0
	return money >= self:GetCost(upgradeName, nextLevel)
end

function UpgradeController:PurchaseUpgrade(upgradeName)
	local newLevel = UpgradeService:PurchaseUpgrade(upgradeName)
	return newLevel
end

return UpgradeController