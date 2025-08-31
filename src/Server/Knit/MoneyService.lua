local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Observers = require(ReplicatedStorage.Packages.Observers)

local PlayerDataService

local MoneyService = Knit.CreateService({ Name = "Money" })

function MoneyService:KnitStart()
	PlayerDataService = Knit.GetService("PlayerData")

	Observers.observePlayer(function(player)
		self:LoadMoney(player)
		player:GetAttributeChangedSignal("Money"):Connect(function()
			self:SaveMoney(player)
		end)
	end)
end

function MoneyService:LoadMoney(player)
	local money = PlayerDataService:GetKey(player, "Money")
	player:SetAttribute("Money", money)
end

function MoneyService:SaveMoney(player)
	PlayerDataService:UpdateKey(player, "Money", function(_)
		return player:GetAttribute("Money")
	end)
end

function MoneyService:CanAfford(player, price)
    return player:GetAttribute("Money") >= price
end

function MoneyService:UpdateMoney(player, mutator)
	local currentMoney = player:GetAttribute("Money")
	local newMoney = mutator(currentMoney)
	player:SetAttribute("Money", newMoney)
	return newMoney
end

function MoneyService:SetMoney(player, amount)
	assert(amount >= 0, `Cannot set Money to a negative amount`)
	self:UpdateMoney(player, function(_)
		return amount
	end)
end

function MoneyService:AddMoney(player, amount)
	amount = math.floor(amount)
	assert(amount >= 0, `Cannot give player a negative amount of Money`)
	return self:UpdateMoney(player, function(currentMoney)
		return currentMoney + amount
	end)
end

function MoneyService:DeductMoney(player, amount)
    amount = math.floor(amount)
	assert(amount >= 0, `Cannot deduct player a negative amount of Money`)
    assert(self:CanAfford(player, amount), `Cannot deduct Money from player because player has insufficient amount of Money`)
	return self:UpdateMoney(player, function(currentMoney)
		return currentMoney - amount
	end)
end

function MoneyService:ClearMoney(player)
	self:SetMoney(player, 0)
end

return MoneyService