local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Observers = require(ReplicatedStorage.Packages.Observers)

local UpgradeService
local PlayerDataService

local WheatService = Knit.CreateService({ Name = "Wheat" })

function WheatService:KnitStart()
	UpgradeService = Knit.GetService("Upgrade")
	PlayerDataService = Knit.GetService("PlayerData")

	Observers.observePlayer(function(player)
		self:LoadWheat(player)
		player:GetAttributeChangedSignal("Wheat"):Connect(function()
			self:SaveWheat(player)
		end)
	end)
end

function WheatService:LoadWheat(player)
	local wheat = PlayerDataService:GetKey(player, "Wheat")
	local bagSize = PlayerDataService:GetKey(player, "BagSize")
	player:SetAttribute("Wheat", wheat)
	player:SetAttribute("BagSize", bagSize)
end

function WheatService:SaveWheat(player)
	PlayerDataService:UpdateKey(player, "Wheat", function(_)
		return player:GetAttribute("Wheat")
	end)
end

function WheatService:CanAfford(player, price)
    return player:GetAttribute("Wheat") >= price
end

function WheatService:GetBagSize(player)
	local level = UpgradeService:GetLevel(player, "BagSize")
	return UpgradeService:GetStrength("BagSize", level)
end

function WheatService:UpdateWheat(player, mutator)
	local currentWheat = player:GetAttribute("Wheat")
	local newWheat = mutator(currentWheat)
	newWheat = math.min(newWheat, self:GetBagSize(player))
	player:SetAttribute("Wheat", newWheat)
	return newWheat
end

function WheatService:SetWheat(player, amount)
	assert(amount >= 0, `Cannot set Wheat to a negative amount`)
	self:UpdateWheat(player, function(_)
		return amount
	end)
end

function WheatService:AddWheat(player, amount)
	amount = math.floor(amount)
	assert(amount >= 0, `Cannot give player a negative amount of Wheat`)
	return self:UpdateWheat(player, function(currentWheat)
		return currentWheat + amount
	end)
end

function WheatService:DeductWheat(player, amount)
    amount = math.floor(amount)
	assert(amount >= 0, `Cannot deduct player a negative amount of Wheat`)
    assert(self:CanAfford(player, amount), `Cannot deduct Wheat from player because player has insufficient amount of Wheat`)
	return self:UpdateWheat(player, function(currentWheat)
		return currentWheat - amount
	end)
end

function WheatService:ClearWheat(player)
	self:SetWheat(player, 0)
end

return WheatService