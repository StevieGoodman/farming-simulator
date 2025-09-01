local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local Component = require(ReplicatedStorage.Packages.Component)
local Octotree = require(ReplicatedStorage.Packages.Octotree)
local Trove = require(ReplicatedStorage.Packages.Trove)

local ParticlePlayer = require(ReplicatedStorage.Shared.Modules.ParticlePlayer)
local SoundPlayer = require(ReplicatedStorage.Shared.Modules.SoundPlayer)

local Wheat = Component.new({ Tag = "Wheat", Ancestors = { workspace } })
Wheat.Octree = Octotree.new()

function Wheat.GetInRange(origin: Vector3, radius: number)
    return Wheat.Octree:SearchRadius(origin, radius)
end

function Wheat.Harvest(origin: Vector3, radius: number): number
    local wheatInRange = Wheat.GetInRange(origin, radius)
    local harvested = 0
    for _, wheatNode in wheatInRange do
        local wheat = wheatNode.Object
        local level = wheat:GetLevel()
        if level == 0 then continue end
        harvested += 1
        wheat:SetLevel(level - 1)
        if RunService:IsServer() then continue end
        wheat:PlayHarvestEffects()
    end
    return harvested
end

function Wheat:Construct()
    self.Trove = Trove.new()
    self.Node = Wheat.Octree:CreateNode(self.Instance:GetPivot().Position, self)
    self.OriginalPartSizes = {}
    self.PartVelocities = {}
end

function Wheat:Start()
    self:SetLevel(self.Instance:GetAttribute("WheatLevel") or 3)
end

function Wheat:RenderSteppedUpdate(deltaTime: number)
    if RunService:IsServer() then return end
    for _, descendant in self.Instance:GetDescendants() do
        local isPart = descendant:IsA("BasePart")
        if not isPart then continue end
        local originalSize = self.OriginalPartSizes[descendant] or descendant.Size
        local partVelocity = self.PartVelocities[descendant] or Vector3.zero
        self.OriginalPartSizes[descendant] = originalSize
        self.PartVelocities[descendant] = partVelocity
        local size, velocity = TweenService:SmoothDamp(
            descendant.Size,
            self.OriginalPartSizes[descendant],
            self.PartVelocities[descendant],
            0.1,
            nil,
            deltaTime
        )
        descendant.Size = size
        self.PartVelocities[descendant] = velocity
    end
end

function Wheat:SteppedUpdate(_: number)
    if self.LastSetLevel == nil then return end
    local threshold = 5
    local timeSince = os.clock() - self.LastSetLevel
    if timeSince < threshold then return end
    local newLevel = math.clamp(self:GetLevel() + 1, 1, 3)
    if newLevel == self:GetLevel() then return end
    self:SetLevel(newLevel)
end

function Wheat:Stop()
    Wheat.Octree:RemoveNode(self.Node)
    self.Trove:Clean()
    self.Node = nil
end

function Wheat:GetLevel()
    return self.Instance:GetAttribute("WheatLevel")
end

function Wheat:SetLevel(newLevel: number)
    self.Instance:SetAttribute("WheatLevel", newLevel)
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

function Wheat:PlayHarvestEffects()
    self:PulseSize()
    SoundPlayer.PlaySoundEffect("Harvest", {
        Parent = self.Instance,
        Pitch = Random.new():NextNumber(0.9, 1.1),
    })
    ParticlePlayer.PlayParticleEffect("Harvest", 20, {
        Parent = self.Instance.PrimaryPart,
    })
end

function Wheat:PulseSize()
    for _, descendant in self.Instance:GetDescendants() do
        local isPart = descendant:IsA("BasePart")
        if not isPart then continue end
        descendant.Size *= 1.2
    end
end

return Wheat