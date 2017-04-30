local MakePlayerCharacter = require "prefabs/player_common"

local assets = {
	Asset("SCRIPT", "scripts/prefabs/player_common.lua"),

	-- Don't forget to include your character's custom assets!
	Asset("ANIM", "anim/sam.zip"),
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
	inst.MiniMapEntity:SetIcon("sam.tex")
end

-- This initializes for the server only. Components are added here.
local master_postinit = function(inst)
	-- choose which sounds this character will play
	inst.soundsname = "wolfgang"
	
	-- Stats	
	inst.components.health:SetMaxHealth(150)
	inst.components.hunger:SetMax(150)
	inst.components.sanity:SetMax(200)
	
	-- Damage multiplier (optional)
	inst.components.combat.damagemultiplier = 1.15

	-- Other health things
	inst.components.health.absorb = 0.1
	inst.components.health.playerabsorb = 0.15
	
	-- Hunger rate (optional)
	inst.components.hunger.hungerrate = 1 * TUNING.WILSON_HUNGER_RATE

	-- Listen for when sam kills something
	inst:ListenForEvent("killed", function(inst, data)
		local victim = data.victim
		if victim:HasTag("player") then -- Killed a player
			if victim.prefab == "steve" then
				inst.components.talker:Say("ur hue")
			else
				inst.components.talker:Say("I am sorry, friend.")
				inst.components.sanity:DoDelta(-100)
			end
		else
			-- Get the max health of the creature
			local victimhealth = (victim.components.health ~= nil) and victim.components.health.maxhealth or 0
			-- Invert so killing weaker things does more loss (also limit to 250 health)
			local normhealth = math.min(victimhealth / 250, 1)
			normhealth = 1 - normhealth
			-- Scale to a 2 -> 20 sanity loss
			local sdelta = 2 + (normhealth * 18)
			inst.components.sanity:DoDelta(-sdelta)
			-- Give health back if the target is a monster
			if victim:HasTag("monster") then
				inst.components.health:DoDelta(sdelta * 0.25)
			end
			-- If the target is epic, or a large monster, do his battlecry
			if victim:HasTag("epic") or (victim:HasTag("monster") and victim:HasTag("largecreature")) then
				inst.components.talker:Say("Just kill urself, my man.")
			end
		end
	end)
	
	inst.OnLoad = onload
	inst.OnNewSpawn = onload
end

return MakePlayerCharacter("sam", prefabs, assets, common_postinit, master_postinit, start_inv)