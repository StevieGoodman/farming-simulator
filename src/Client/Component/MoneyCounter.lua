local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)
local Observers = require(ReplicatedStorage.Packages.Observers)
local Trove = require(ReplicatedStorage.Packages.Trove)

local MoneyCounter = Component.new({ Tag = "MoneyCounter", Ancestors = { Players.LocalPlayer.PlayerGui } })

function MoneyCounter:Construct()
    self.Trove = Trove.new()
end

function MoneyCounter:Start()
    self.Trove:Add(Observers.observeAttribute(Players.LocalPlayer, "Money", function(money)
        self.Instance.Text = `${money}`
    end))
end

function MoneyCounter:Stop()
    self.Trove:Clean()
end

return MoneyCounter