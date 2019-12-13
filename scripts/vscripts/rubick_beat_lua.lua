rubick_beat_lua = class({})
LinkLuaModifier( "modifier_bludger_passive_mode_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_rubick_passive_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

-- this function is not called from IMMEDIATE abilities
--function rubick_passive_lua:OnAbilityPhaseStart()
--	self.vTargetPosition = self:GetCursorPosition()
--end

function rubick_beat_lua:OnUpgrade()
	local caster = self:GetCaster()
	caster:AddNewModifier( caster, self, "modifier_rubick_passive_lua", {duration="-1"} )	-- tackling, flying animation
end

function rubick_beat_lua:OnSpellStart()

    -- todo: play sound and title notification

	-- needs to be set here instead of phase start because immediate
	self.vTargetPosition = self:GetCursorPosition()



	local caster = self:GetCaster()
    for _,bludger in pairs(Entities:FindAllByClassnameWithin("npc_dota_creep",(caster:GetAbsOrigin()), 260) )  do
    	if bludger:GetUnitName()=="npc_rubiq_bludger" then
	    	local direction = self.vTargetPosition-bludger:GetAbsOrigin()
	    	direction.z=0
	    	if direction:Length()>400 then
	    		direction = direction:Normalized()*400
    		elseif direction:Length()<150 then
    			direction = direction:Normalized()*200
    		end
    		direction = direction * 0.18

	    	bludger.rdir = direction

    		EmitSoundOn( "rubiq.catch", caster )
			-- todo: particle effect and more appropriate sound

            bludger:AddNewModifier( bludger, self, "modifier_bludger_passive_mode_lua", {duration="1.0"} )
			-- ^ applies anti-target buff to bludger
			-- ^ when buff ends, target cleared so new target is found


	    	return true
    	end
	end


end

--------------------------------------------------------------------------------