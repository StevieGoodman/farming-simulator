local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)

local SellZone = Component.new({ Tag = "ShopZone", Ancestors = { workspace } })

function SellZone:SteppedUpdate()
    local overlapParams = OverlapParams.new()
    overlapParams.FilterType = Enum.RaycastFilterType.Whitelist
    overlapParams:AddToFilter(Players.LocalPlayer.Character:GetDescendants())
    local parts = workspace:GetPartsInPart(self.Instance, overlapParams)
    local inZone = #parts > 0
    self:SetMenuShown(inZone)
end

function SellZone:SetMenuShown(shown: boolean)
    Players.LocalPlayer.PlayerGui.Shop.Enabled = shown
end

return SellZone