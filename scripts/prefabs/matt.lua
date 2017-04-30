local MakePlayerCharacter = require "prefabs/player_common"

local assets = {
	Asset("SCRIPT", "scripts/prefabs/player_common.lua"),

	-- Don't forget to include your character's custom assets!
	Asset("ANIM", "anim/matt.zip"),
}

local prefabs = {
	
}

local start_inv = {
	
}

-- When loading or spawning the character
local function onload(inst)
	
end

-- This initializes for both the server and client. Tags can be added here.
local common_postinit = function(inst) 
	-- Choose the minimap icon
	inst.MiniMapEntity:SetIcon("matt.tex")
end

-- This initializes for the server only. Components are added here.
local master_postinit = function(inst)
	-- choose which sounds this character will play
	inst.soundsname = "wickerbottom"
	
	-- Stats	
	inst.components.health:SetMaxHealth(110) -- Default is 150
	inst.components.hunger:SetMax(150)
	inst.components.sanity:SetMax(200)
	
	-- Damage multiplier (optional)
	inst.components.combat.damagemultiplier = 1
	
	-- Hunger rate (optional)
	inst.components.hunger.hungerrate = 1 * TUNING.WILSON_HUNGER_RATE
	
	inst.OnLoad = onload
	inst.OnNewSpawn = onload
end

return MakePlayerCharacter("matt", prefabs, assets, common_postinit, master_postinit, start_inv)