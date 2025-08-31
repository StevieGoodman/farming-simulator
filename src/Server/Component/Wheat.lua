local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Component = require(ReplicatedStorage.Packages.Component)
local Octotree = require(ReplicatedStorage.Packages.Octotree)
local Trove = require(ReplicatedStorage.Packages.Trove)

local Wheat = Component.new({ Tag = "Wheat", Ancestors = { workspace } })
Wheat.Octree = Octotree.new()

function Wheat.GetInRange(origin: Vector3, radius: number)
    return Wheat.Octree:SearchRadius(origin, radius)
end

function Wheat:Construct()
    self.Trove = Trove.new()
    self.Node = Wheat.Octree:CreateNode(self.Instance:GetPivot().Position, self)
end

function Wheat:Start()
    self:SetLevel(0)
end

function Wheat:SteppedUpdate(_: number)
    if self.LastSetLevel == nil then return end
    local threshold = if self.CurrentLevel == 0 then 10 else 3
    local timeSince = os.clock() - self.LastSetLevel
    if timeSince < threshold then return end
    local newLevel = math.clamp(self.CurrentLevel + 1, 1, 3)
    if newLevel == self.CurrentLevel then return end
    self:SetLevel(newLevel)
end

function Wheat:Stop()
    Wheat.Octree:RemoveNode(self.Node)
    self.Trove:Clean()
    self.Node = nil
end

function Wheat:SetLevel(newLevel: number)
    self.CurrentLevel = newLevel
    for _, descendant in self.Instance:GetDescendants() do
        local isPart = descendant:IsA("BasePart")
        if not isPart then continue end
        local level = string.match(descendant.Name, "%d")
        level = tonumber(level)
        if level == nil then continue end
        descendant.Transparency = if level > newLevel then 1 else 0
    end
    self.LastSetLevel = os.clock()
end

function Wheat:PlayHitEffects()
end

function Wheat:PulseSize()
    for _, descendant in self.Instance:GetDescendants() do
        local isPart = descendant:IsA("BasePart")
        if not isPart then continue end
        local tween = TweenService:Create(
            descendant,
            TweenInfo.new(0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, true, 0),
            { Size = descendant.Size * 1.3 }
        )
        tween:Play()
    end
end

return Wheat