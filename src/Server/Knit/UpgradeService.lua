local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Observers = require(ReplicatedStorage.Packages.Observers)

local MoneyService
local PlayerDataService
local UpgradesConfig = require(ReplicatedStorage.Shared.Config.Upgrades)

local UpgradeService = Knit.CreateService({
	Name = "Upgrade",
	Client = {
		Upgrades = Knit.CreateProperty({}),
	}
})

function UpgradeService:KnitStart()
	MoneyService = Knit.GetService("Money")
	PlayerDataService = Knit.GetService("PlayerData")

	Observers.observePlayer(function(player)
		self:UpdateClient(player)
	end)
end

function UpgradeService:GetLevel(player, upgradeName)
	local upgrades = UpgradeService.Client.Upgrades:GetFor(player)
	return upgrades[upgradeName] or 1
end

function UpgradeService:GetCost(upgradeName, level)
	return UpgradesConfig[upgradeName].UpgradeCost(level)
end

function UpgradeService:GetStrength(upgradeName, level)
	return UpgradesConfig[upgradeName].Strength(level)
end

function UpgradeService:SetLevel(player, upgradeName, newLevel)
	PlayerDataService:UpdateKey(player, "Upgrades", function(upgrades)
		upgrades[upgradeName] = newLevel
		return upgrades
	end)
	self:UpdateClient(player)
end

function UpgradeService:PurchaseUpgrade(player, upgradeName)
	local currentLevel = self:GetLevel(player, upgradeName)
	local nextLevel = currentLevel + 1
	local cost = self:GetCost(upgradeName, currentLevel)

	assert(MoneyService:CanAfford(player, cost), `Player cannot afford upgrade {upgradeName} to level {nextLevel}`)

	MoneyService:DeductMoney(player, cost)
	self:SetLevel(player, upgradeName, nextLevel)
	return nextLevel
end

function UpgradeService:CanAffordUpgrade(player, upgradeName)
	local nextLevel = self:GetLevel(player, upgradeName) + 1
	return MoneyService:CanAfford(player, self:GetCost(upgradeName, nextLevel))
end

function UpgradeService:UpdateClient(player)
	local upgrades = PlayerDataService:GetKey(player, "Upgrades")
	UpgradeService.Client.Upgrades:SetFor(player, upgrades)
end

function UpgradeService.Client:PurchaseUpgrade(player, upgradeName)
	return UpgradeService:PurchaseUpgrade(player, upgradeName)
end

return UpgradeService