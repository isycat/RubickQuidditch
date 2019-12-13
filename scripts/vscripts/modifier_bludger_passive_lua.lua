modifier_bludger_passive_lua = class({})
LinkLuaModifier( "modifier_immune_to_bludger_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_cant_hold_ball_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bludger_slow_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bludger_stun_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function modifier_bludger_passive_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_bludger_passive_lua:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_bludger_passive_lua:OnCreated( kv )
	if IsServer() then
		self:StartIntervalThink( 0.1 )
	end
end

--------------------------------------------------------------------------------

function modifier_bludger_passive_lua:OnIntervalThink()
	if IsServer() then
		self:StartIntervalThink( 0.02 )

		local caster = self:GetCaster()

		local otherbludger=nil
		if caster == GamePlay.bludger then
			otherbludger=GamePlay.bludger2
		else
			otherbludger=GamePlay.bludger
		end

		local mindist = 999999
		local target = nil
        for _,hero in pairs(Entities:FindAllByClassname("npc_dota_hero_rubick") )  do
        	if hero:IsAlive() and otherbludger.btarget~=hero and not(hero:HasModifier("modifier_immune_to_bludger_lua")) then
	        	local tempdist = (hero:GetAbsOrigin()-caster:GetCenter()):Length()
	        	--print(tempdist)
	        	if tempdist >=0 and tempdist < mindist then
	        		target = hero
	        		mindist = tempdist
	        	end
        	end
        end


        if mindist < 150 then
        	-- todo: particle effect
			EmitSoundOn( "rubiq.tackle", target )

			target:AddNewModifier( caster, self, "modifier_immune_to_bludger_lua", {duration="4.5"} )
			target:AddNewModifier( caster, self, "modifier_cant_hold_ball_lua", {duration="2.5"} )
			target:AddNewModifier( caster, self, "modifier_bludger_slow_lua", {duration="2.5"} )

			if target:HasModifier("modifier_rubick_chaser_lua") then
				target:AddNewModifier( caster, self, "modifier_bludger_stun_lua", {duration="0.8"} )
			else
				target:AddNewModifier( caster, self, "modifier_bludger_stun_lua", {duration="0.2"} )
			end

			caster:AddNewModifier( caster, self, "modifier_bludger_stun_lua", {duration="1.5"} )
        else
        	if not(caster:HasModifier("modifier_bludger_passive_mode_lua")) then
	        	if target ~= nil then
	        		if caster.btarget ~= target then
						caster.btarget = target
		        		caster:MoveToNPC(target)
	        		end
		        else
		        	if caster.btarget ~= nil then
		        		caster:MoveToPosition(caster:GetAbsOrigin())
		        		caster.btarget=nil
		        	end
		        end
	    	end
        end

		if caster.rdir ~= nil then
			--caster:SetAbsOrigin(GetGroundPosition(caster:GetAbsOrigin() + caster.rdir, nil))
			--caster.rdir = caster.rdir *0.95

			if caster.rdir ~= nil then
				local newposition = GetGroundPosition(caster:GetAbsOrigin() + caster.rdir, nil)
	    		if GridNav:IsTraversable(newposition) then
					caster:SetAbsOrigin(newposition)
					caster.rdir = caster.rdir *0.95
				else
					
					caster.rdir = Vector(0-caster.rdir.x, 0-caster.rdir.y, caster.rdir.z)
					caster.rdir = caster.rdir * 0.5
					newposition = GetGroundPosition(caster:GetAbsOrigin() + caster.rdir, nil)
		    		if GridNav:IsTraversable(newposition) then
		    			-- todo: more appropriate ball-hitting-wall sound
    					EmitSoundOn( "rubiq.catch", caster )
						caster:SetAbsOrigin(newposition)
						caster.rdir = caster.rdir *0.95
					end
				end
			end

		end

	end
end

--------------------------------------------------------------------------------
