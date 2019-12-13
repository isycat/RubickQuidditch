pick_beater_lua = class({})
LinkLuaModifier( "modifier_pick_beater_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_rubick_beater_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function pick_beater_lua:OnSpellStart()
	local caster = self:GetCaster()

	local role = "beater"
	local teamnumber = caster:GetTeamNumber()
	local val = GamePlay.teams[teamnumber].picks[role]
	if val > 0 then
		GamePlay.teams[teamnumber].picks[role] = val-1
	else
		--self:StartCooldown(1)
		FireGameEvent( 'custom_error_show', { player_ID = caster:GetPlayerOwnerID(), _error = "Your team already has enough "..role.."s" } )
		return false
	end

	local abs = caster:GetAbilityCount()
	for abi = 0, abs-1 do
		local ability = caster:GetAbilityByIndex(abi)
		if ability ~= nil then
			caster:RemoveAbility(ability:GetAbilityName())
		end
	end

	caster:AddNewModifier( caster, self, "modifier_rubick_beater_lua", {duration="-1"} )
	
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
	    caster:RemoveModifierByName("modifier_prepick_root_lua")
	else
		caster:AddNewModifier( caster, self, "modifier_pick_beater_lua", {duration="-1"} )
	end

    caster:AddAbility("rubick_beat_lua")
    local abzx = caster:FindAbilityByName("rubick_beat_lua")
    if abzx ~= nil then
        abzx:SetAbilityIndex(0)
        abzx:SetLevel(1)
    end
end

--------------------------------------------------------------------------------