local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)
local Knit = require(ReplicatedStorage.Packages.Knit)
local Trove = require(ReplicatedStorage.Packages.Trove)

local MoneyService = Knit.GetService("Money")
local WheatService = Knit.GetService("Wheat")
local SoundPlayer = require(ReplicatedStorage.Shared.Modules.SoundPlayer)

local SellZone = Component.new({ Tag = "SellZone", Ancestors = { workspace } })

function SellZone:Construct()
    self.Trove = Trove.new()
end

function SellZone:Start()
    self.Trove:Connect(self.Instance.Touched, function(otherPart)
        local model = otherPart:FindFirstAncestorOfClass("Model")
        if model == nil then return end
        local player = Players:GetPlayerFromCharacter(model)
        if player == nil then return end
        self:SellWheat(player)
    end)
end

function SellZone:Stop()
    self.Trove:Clean()
end

function SellZone:SellWheat(player: Player)
    local wheat = player:GetAttribute("Wheat")
    if wheat == 0 then return end
    WheatService:DeductWheat(player, wheat)
    MoneyService:AddMoney(player, wheat)
    SoundPlayer.PlaySoundEffect("SellWheat", {
        Parent = player.PlayerGui,
    })
end

return SellZone