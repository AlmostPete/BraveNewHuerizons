local MakePlayerCharacter = require "prefabs/player_common"

local assets = {
	Asset("SCRIPT", "scripts/prefabs/player_common.lua"),

	-- Don't forget to include your character's custom assets!
	Asset("ANIM", "anim/sarah.zip"),
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
	inst.MiniMapEntity:SetIcon("sarah.tex")
end

-- Sanity function (check for nearby crockpots)
local sanity_fn = function(inst)
	local x, y, z = inst.Transform:GetWorldPosition() 
	local delta = 0
	local MAX_RAD = 12
	local ents = TheSim:FindEntities(x, y, z, MAX_RAD, nil, nil, { "structure" })
	for i, v in ipairs(ents) do
		if (v.prefab == "cookpot") and v.components.stewer then
			local sanityamt = (v.components.stewer:IsCooking() and 1.5)
							  or ((v.components.stewer:IsDone() and not v:HasTag("burnt")) and 0.75)
							  or 0.5
			delta = delta + sanityamt
		end
	end
	return math.min(delta, 4) / 60 -- To convert to seconds
end

-- This initializes for the server only. Components are added here.
local master_postinit = function(inst)
	-- choose which sounds this character will play
	inst.soundsname = "willow"
	
	-- Stats
	inst.components.health:SetMaxHealth(150)
	inst.components.hunger:SetMax(150)
	local SARAH_MAX_SANITY = 120
	inst.components.sanity:SetMax(SARAH_MAX_SANITY) -- Normal is 200
	
	-- Damage multiplier (optional)
	inst.components.combat.damagemultiplier = 1
	
	-- Hunger rate (optional)
	inst.components.hunger.hungerrate = 1 * TUNING.WILSON_HUNGER_RATE

	-- Sanity rate
	inst.components.sanity.custom_rate_fn = sanity_fn
	local ignoreNextSanityDelta = false
	inst:ListenForEvent("sanitydelta", function(inst, data)
		if not ignoreNextSanityDelta and (data.newpercent < data.oldpercent) then -- If there was a loss in sanity
			local amt = (data.newpercent - data.oldpercent) * SARAH_MAX_SANITY
			ignoreNextSanityDelta = true
			inst.components.sanity:DoDelta(amt * 0.1)
		end
		ignoreNextSanityDelta = false
	end)
	
	inst.OnLoad = onload
	inst.OnNewSpawn = onload
end

return MakePlayerCharacter("sarah", prefabs, assets, common_postinit, master_postinit, start_inv)