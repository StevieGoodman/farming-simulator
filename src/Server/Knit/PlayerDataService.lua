local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Observers = require(ReplicatedStorage.Packages.Observers)
local ProfileStore = require(ReplicatedStorage.Packages.ProfileStore)

local ProfileTemplate = require(ReplicatedStorage.Shared.Config.ProfileTemplate)

--[=[
	@class PlayerDataService
	@server

	PlayerDataService is responsible for loading and saving player data using ProfileStore.
	It handles profile loading, releasing, and provides methods to get and set player data.
]=]

local PlayerDataService = Knit.CreateService({ Name = "PlayerData" })
PlayerDataService.ProfileLoadErrorThreshold = 60

function PlayerDataService:KnitInit()
	self.ProfileStore = ProfileStore.New("PlayerData", ProfileTemplate)
	if RunService:IsStudio() then self.ProfileStore = self.ProfileStore.Mock end
	self.Profiles = {}
end

function PlayerDataService:KnitStart()
	Observers.observePlayer(function(player)
		self:LoadProfile(player)
		return function()
			self:ReleaseProfile(player)
		end
	end)
end

--[=[
	Loads a player's profile from the ProfileStore into the service's internal profile table.
	If the profile cannot be loaded, the player is kicked.
	@param player Player - The player whose profile is to be loaded.
]=]
function PlayerDataService:LoadProfile(player)
	local profile = self.ProfileStore:StartSessionAsync(tostring(player.UserId))
	if profile == nil then
		player:Kick(`Cannot load your data. Please rejoin.\nIf issue persists, contact a developer.`)
		return
	end
	profile:AddUserId(player.UserId)
	profile:Reconcile()
	profile.OnSessionEnd:Connect(function()
		self.Profiles[player] = nil
		player:Kick(`Your data was released. Have you joined another server?\nIf issue persists, contact a developer.`)
	end)
	self.Profiles[player] = profile
	if player:IsDescendantOf(Players) then return end
	PlayerDataService:ReleaseProfile(player)
end

function PlayerDataService:ReleaseProfile(player)
	local profile = self.Profiles[player]
	if profile == nil then return end
	profile:EndSession()
	self.Profiles[player] = nil
end

function PlayerDataService:GetProfileData(player)
	local startTime = os.time()
	local profile = self.Profiles[player]
	while profile == nil and player:IsDescendantOf(Players) do
		task.wait(0.1)
		profile = self.Profiles[player]
		local secondsSinceStart = os.time() - startTime
		if secondsSinceStart < PlayerDataService.ProfileLoadErrorThreshold then continue end
		player:Kick(`Unable to load your player data. Try rejoining.\nIf issue persists, contact a developer.`)
		break
	end
	if profile == nil or not player:IsDescendantOf(Players) then return nil end
	return table.clone(profile.Data)
end

function PlayerDataService:GetKey(player, key)
	local data = self:GetProfileData(player)
	return if data == nil then nil else data[key]
end

function PlayerDataService:UpdateKey(player, key, mutator)
	self:GetProfileData(player) -- Ensure profile is loaded
	local profile = self.Profiles[player]
	if profile == nil then return nil end
	local data = profile.Data
	data[key] = mutator(data[key])
	return data
end

function PlayerDataService:SetKey(player, key, newValue)
	self:UpdateKey(player, key, function(_)
		return newValue
	end)
end

return PlayerDataService