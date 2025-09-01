local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)
local Observers = require(ReplicatedStorage.Packages.Observers)
local Trove = require(ReplicatedStorage.Packages.Trove)

local WheatCounter = Component.new({ Tag = "WheatCounter", Ancestors = { Players.LocalPlayer.PlayerGui } })

function WheatCounter:Construct()
    self.Trove = Trove.new()
end

function WheatCounter:Start()
    self.Trove:Add(Observers.observeAttribute(Players.LocalPlayer, "Wheat", function(wheat)
        self.Instance.Text = wheat
    end))
end

function WheatCounter:Stop()
    self.Trove:Clean()
end

return WheatCounter