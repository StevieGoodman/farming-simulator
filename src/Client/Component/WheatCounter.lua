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
    self.Trove:Add(Observers.observeAttribute(Players.LocalPlayer, "Wheat", function(_)
        self:Update()
    end))
    self.Trove:Add(Observers.observeAttribute(Players.LocalPlayer, "BagSize", function(_)
        self:Update()
    end))
end

function WheatCounter:Stop()
    self.Trove:Clean()
end

function WheatCounter:Update()
    local wheat = Players.LocalPlayer:GetAttribute("Wheat") or 0
    local bagSize = Players.LocalPlayer:GetAttribute("BagSize") or 0
    self.Instance.Text = `{wheat}/{bagSize}`
end

return WheatCounter