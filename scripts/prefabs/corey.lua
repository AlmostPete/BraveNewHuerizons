local MakePlayerCharacter = require "prefabs/player_common"

local assets = {
	Asset("SCRIPT", "scripts/prefabs/player_common.lua"),

	-- Don't forget to include your character's custom assets!
	Asset("ANIM", "anim/corey.zip"),
}

local prefabs = {
	
}

local start_inv = {
	
}

-- When loading or spawning the character
local function onload(inst)
	if inst.components.hunger:GetPercent() <= 0.33 then
		inst.components.locomotor.walkspeed = TUNING.WILSON_WALK_SPEED * 0.75
		inst.components.locomotor.runspeed = TUNING.WILSON_RUN_SPEED * 0.75
	end
end

-- This initializes for both the server and client. Tags can be added here.
local common_postinit = function(inst) 
	-- Choose the minimap icon
	inst.MiniMapEntity:SetIcon("corey.tex")
end

-- This initializes for the server only. Components are added here.
local master_postinit = function(inst)
	-- choose which sounds this character will play
	inst.soundsname = "wx78"
	
	-- Stats	
	inst.components.health:SetMaxHealth(150)
	inst.components.hunger:SetMax(150)
	inst.components.sanity:SetMax(200)
	
	-- Damage multiplier (optional)
	inst.components.combat.damagemultiplier = 1
	
	-- Hunger rate (optional)
	inst.components.hunger.hungerrate = 1.1 * TUNING.WILSON_HUNGER_RATE
	inst:ListenForEvent("hungerdelta", function(inst, data)
		if data.newpercent <= 0.33 then
			if data.oldpercent > 0.33 then
				inst.components.talker:Say("I'm not out of shape. I'm dehydrated.")
			end
			inst.components.locomotor.walkspeed = TUNING.WILSON_WALK_SPEED * 0.75
			inst.components.locomotor.runspeed = TUNING.WILSON_RUN_SPEED * 0.75
		else
			inst.components.locomotor.walkspeed = TUNING.WILSON_WALK_SPEED * 1
			inst.components.locomotor.runspeed = TUNING.WILSON_RUN_SPEED * 1
		end
	end)
	
	inst.OnLoad = onload
	inst.OnNewSpawn = onload
end

return MakePlayerCharacter("corey", prefabs, assets, common_postinit, master_postinit, start_inv)