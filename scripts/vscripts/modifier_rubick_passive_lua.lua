modifier_rubick_passive_lua = class({})
LinkLuaModifier( "modifier_cant_hold_ball_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tackleslow_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function modifier_rubick_passive_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_rubick_passive_lua:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_rubick_passive_lua:OnCreated( kv )
	if IsServer() then
		self:StartIntervalThink( 0.1 )
	end
end

--------------------------------------------------------------------------------

function modifier_rubick_passive_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_rubick_passive_lua:CheckState()
	local state = {
	[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}

	return state
end

--------------------------------------------------------------------------------

function modifier_rubick_passive_lua:GetActivityTranslationModifiers( params )
	if self:GetParent() == self:GetCaster() then
		return "firefly"
	end

	return 0
end

--------------------------------------------------------------------------------

function modifier_rubick_passive_lua:OnIntervalThink()
	if IsServer() then
		self:StartIntervalThink( 0.01 )

		local caster = self:GetCaster()

		if caster:HasModifier("modifier_cant_hold_ball_lua") then
			return nil
        end

        for _,hero in pairs(Entities:FindAllByClassnameWithin("npc_dota_hero_rubick",GetGroundPosition(caster:GetAbsOrigin(),nil), 150) )  do
        	if hero:IsAlive() then
        		if hero:GetTeamNumber()~=caster:GetTeamNumber() and not(hero:HasModifier("modifier_immunetotackle_lua")) then
					--caster:StartGesture( ACT_DOTA_ATTACK )
					
					if not hero:HasModifier("modifier_tackleslow_lua") then
	            		EmitSoundOn( "rubiq.tackle", hero )
	            		--print("tackle")
        				-- todo: particle effect
	            	end
	            	if caster:HasModifier("modifier_rubick_chaser_lua") then
	            		-- chasers can knock quaffle out of other chasers hands
						hero:AddNewModifier( caster, self, "modifier_cant_hold_ball_lua", {duration="0.5"} )
						hero:AddNewModifier( caster, self, "modifier_tackleslow_lua", {duration="0.5"} )
					else
						-- non chasers cant knock ball out of peoples hands
						hero:AddNewModifier( caster, self, "modifier_tackleslow_lua", {duration="0.5"} )
					end
        		end
	        end
		end

	end
end

--------------------------------------------------------------------------------
