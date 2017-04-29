local MakePlayerCharacter = require "prefabs/player_common"

local assets = {
	Asset("SCRIPT", "scripts/prefabs/player_common.lua"),
	Asset("ANIM", "anim/beard.zip"),

	-- Don't forget to include your character's custom assets!
	Asset("ANIM", "anim/josiah.zip"),
}

local prefabs = {
	"beardhair"
}

local start_inv = {
	
}

-- When loading or spawning the character
local function onload(inst)
	
end

-- Custom sanity function
local SEASON_SANITY_TUNING_RATE = 3.3
local RAIN_SANITY_TUNING_RATE = 6.6
local sanity_fn = function(inst)
	local delta = 0
	
	if TheWorld.state.iswinter then -- Winter sanity drain
		delta = -1 * SEASON_SANITY_TUNING_RATE
	elseif TheWorld.state.issummer then  -- Summer sanity boost
		delta = SEASON_SANITY_TUNING_RATE
	end

	if TheWorld.state.israining then
		if TheWorld.state.temperature > 0 then -- It is raining
			delta = delta + (RAIN_SANITY_TUNING_RATE * TheWorld.state.precipitationrate)
		elseif TheWorld.state.temperature < 0 then -- It is snowing
			delta = delta - (RAIN_SANITY_TUNING_RATE * TheWorld.state.precipitationrate)
		end
	end
	
	return delta / 60
end

-- This initializes for both the server and client. Tags can be added here.
local common_postinit = function(inst) 
	-- Choose the minimap icon
	inst.MiniMapEntity:SetIcon("josiah.tex")
end

-- This initializes for the server only. Components are added here.
local master_postinit = function(inst)
	-- choose which sounds this character will play
	inst.soundsname = "woody"

	-- JOSIAH SPECIFIC STATS
	inst.components.health:SetMaxHealth(130) -- Lower than Wilson (150)
	inst.components.hunger:SetMax(150) -- Same as Wilson
	inst.components.sanity:SetMax(200) -- Same as Wilson
	inst.components.hunger.hungerrate = 0.5 * TUNING.WILSON_HUNGER_RATE -- Hunger more slowly

	-- Custom sanity rules
	inst.components.sanity.custom_rate_fn = sanity_fn

	-- Freezing rate change
	inst:WatchWorldState("startwinter", function()
		inst.components.temperature.maxtemp = ( 45 ) -- Standard is 90
		inst.components.temperature.hurtrate = ( 2.0 ) -- Standard is 1.25
	end)
	inst:WatchWorldState("startspring", function()
		inst.components.temperature.maxtemp = ( 90 )
		inst.components.temperature.hurtrate = ( 1.25 )
	end)

	-- Detect initial temperature settings on load
	if TheWorld.state.iswinter then
		inst.components.temperature.maxtemp = ( 45 ) -- Standard is 90
		inst.components.temperature.hurtrate = ( 2.0 ) -- Standard is 1.25
	end
	
	inst.OnLoad = onload
	inst.OnNewSpawn = onload
end

return MakePlayerCharacter("josiah", prefabs, assets, common_postinit, master_postinit, start_inv)