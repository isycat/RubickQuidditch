rubick_passive_lua = class({})
LinkLuaModifier( "modifier_rubick_passive_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_cant_hold_ball_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tackleslow_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

-- this function is not called from IMMEDIATE abilities
--function rubick_passive_lua:OnAbilityPhaseStart()
--	self.vTargetPosition = self:GetCursorPosition()
--end

function rubick_passive_lua:OnUpgrade()
	local caster = self:GetCaster()
	caster:AddNewModifier( caster, self, "modifier_rubick_passive_lua", {duration="-1"} )
end

function rubick_passive_lua:OnSpellStart()

    -- todo: play sound and title notification

	-- needs to be set here instead of phase start because immediate
	self.vTargetPosition = self:GetCursorPosition()

	local caster = self:GetCaster()

	if caster:HasModifier("modifier_cant_hold_ball_lua") then
		return false
	end

	
	caster:AddNewModifier( caster, self, "modifier_cant_hold_ball_lua", {duration="0.5"} )
	caster:AddNewModifier( caster, self, "modifier_tackleslow_lua", {duration="0.5"} )

	local caster = self:GetCaster()
    for _,quaffle in pairs(Entities:FindAllByClassnameWithin("npc_dota_creep",(caster:GetAbsOrigin()), 60) )  do
    	if quaffle:GetUnitName()=="npc_rubiq_quaffle" then
	    	local direction = self.vTargetPosition-quaffle:GetAbsOrigin()
	    	direction.z=0
	    	if direction:Length()>400 then
	    		direction = direction:Normalized()*400
    		elseif direction:Length()<150 then
    			direction = direction:Normalized()*200
    		end
    		direction = direction * 0.16

	    	quaffle.rdir = direction
            quaffle.lastholder=caster
            EmitSoundOn( "rubiq.catch", caster )
            --print("kick")
	    	return true
    	end
	end


end

--------------------------------------------------------------------------------