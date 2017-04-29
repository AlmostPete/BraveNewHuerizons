local MakePlayerCharacter = require "prefabs/player_common"

local assets = {
	Asset("SCRIPT", "scripts/prefabs/player_common.lua"),

	-- Don't forget to include your character's custom assets!
	Asset("ANIM", "anim/steve.zip"),
}

local prefabs = {
	
}

local start_inv = {
	
}

-- When loading or spawning the character
local function onload(inst)
	
end

-- Function for sanity regain during the day
local sanity_fn = function(inst)
	return (TheWorld.state.isday and 5 / 60) 
		   or (TheWorld.state.isdusk and 2 / 60)
		   or 0
end

-- This initializes for both the server and client. Tags can be added here.
local common_postinit = function(inst) 
	-- Choose the minimap icon
	inst.MiniMapEntity:SetIcon("steve.tex")
end

-- This initializes for the server only. Components are added here.
local master_postinit = function(inst)
	-- choose which sounds this character will play
	inst.soundsname = "wendy"
	
	-- Stats	
	inst.components.health:SetMaxHealth(150)
	inst.components.hunger:SetMax(150)
	inst.components.sanity:SetMax(70)
	
	-- Damage multiplier (optional)
	inst.components.combat.damagemultiplier = 1
	
	-- Hunger rate (optional)
	inst.components.hunger.hungerrate = 1 * TUNING.WILSON_HUNGER_RATE

	-- Sanity stuff
	inst.components.sanity.night_drain_mult = 1.5
	inst.components.sanity.custom_rate_fn = sanity_fn
	
	inst.OnLoad = onload
	inst.OnNewSpawn = onload
end

return MakePlayerCharacter("steve", prefabs, assets, common_postinit, master_postinit, start_inv)