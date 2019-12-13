modifier_quaffle_passive_lua = class({})
LinkLuaModifier( "modifier_immunetotackle_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function modifier_quaffle_passive_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_quaffle_passive_lua:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_quaffle_passive_lua:OnCreated( kv )
	if IsServer() then
		self:StartIntervalThink( 0.1 )
	end
end

--------------------------------------------------------------------------------



function resetQuaffle(quaffle)
	-- todo: play sound and title notification
	quaffle.rdir = nil
    quaffle:SetAbsOrigin(Vector(0,0,300))
	quaffle.following=false
	quaffle.lastholder=nil
end

function quaffleFollow(quaffle,target)
	local cdirection = target:GetForwardVector()
	cdirection.z=0;
	quaffle.rdir = nil
	quaffle:SetAbsOrigin(target:GetAbsOrigin() + cdirection*65 - Vector(0,0,65))
	-- todo: play sound and title notification
	if not quaffle.following then
    	EmitSoundOn( "rubiq.catch", quaffle )
    	--print("catch")
	end
	quaffle.following=true
	quaffle.lastholder=target
end



scores = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}

function modifier_quaffle_passive_lua:OnIntervalThink()
	if IsServer() then
		self:StartIntervalThink( 0.02 )

		local caster = self:GetCaster()


		local scoreteam = -1
		local points = 0

        for _,hoop in pairs(Entities:FindAllInSphere(GetGroundPosition(caster:GetAbsOrigin(),nil), 15) )  do
            if (hoop:GetName() == "radiant_hoop_1") then
                EmitGlobalSound( "rubiq.goal" )
				local messageinfo = {message = "Dire scores!", duration = 2}
				FireGameEvent("show_center_message",messageinfo) 

	    		print("radiant_hoop_1")
	    		scoreteam=3
	    		points = 5
	    	elseif (hoop:GetName() == "dire_hoop_1") then
                EmitGlobalSound( "rubiq.goal" )
				local messageinfo = {message = "Radiant scores!", duration = 2}
				FireGameEvent("show_center_message",messageinfo) 

	    		print("dire_hoop_1")
	    		scoreteam=2
	    		points = 5
	    		
	    	elseif (hoop:GetName() == "radiant_hoop_2") then
                EmitGlobalSound( "rubiq.goal" )
				local messageinfo = {message = "Dire scores!", duration = 2}
				FireGameEvent("show_center_message",messageinfo) 

	    		print("radiant_hoop_2")
	    		scoreteam=3
	    		points = 2
	    	elseif (hoop:GetName() == "dire_hoop_2") then
                EmitGlobalSound( "rubiq.goal" )
				local messageinfo = {message = "Radiant scores!", duration = 2}
				FireGameEvent("show_center_message",messageinfo) 

	    		print("dire_hoop_2")
	    		scoreteam=2
	    		points = 2
	    		
	    	elseif (hoop:GetName() == "radiant_hoop_3") then
                EmitGlobalSound( "rubiq.goal" )
				local messageinfo = {message = "Dire scores!", duration = 2}
				FireGameEvent("show_center_message",messageinfo) 

	    		print("radiant_hoop_3")
	    		scoreteam=3
	    		points = 1
	    	elseif (hoop:GetName() == "dire_hoop_3") then
                EmitGlobalSound( "rubiq.goal" )
				local messageinfo = {message = "Radiant scores!", duration = 2}
				FireGameEvent("show_center_message",messageinfo) 

	    		print("dire_hoop_3")
	    		scoreteam=2
	    		points = 1
	    	end

	    end







	    if scoreteam~=-1 then
	    	scores[scoreteam]=scores[scoreteam]+points
			GameRules:GetGameModeEntity():SetTopBarTeamValue(scoreteam, scores[scoreteam])

			if scores[scoreteam] >= 50 then
				resetQuaffle(caster)
				GameRules:SetGameWinner(scoreteam)
				-- todo play some end music
			end


	        for _,hero in pairs(Entities:FindAllByClassname("npc_dota_hero_rubick") )  do
	        	if hero:IsAlive() and hero:GetTeamNumber()~=scoreteam and hero:HasModifier("modifier_rubick_chaser_lua") then
	        		--if hero:HasModifier("modifier_cant_hold_ball_lua") then
	        		--else
	        			local target = hero

						if caster.lastholder==nil then
							for ip=1,points do
								target:IncrementKills(1)
							end

							quaffleFollow(caster,target)

							target:AddNewModifier( caster, self, "modifier_immunetotackle_lua", {duration="2.0"} )
						elseif caster.lastholder:GetTeamNumber()~=scoreteam then
							caster.lastholder:AddNewModifier( caster, self, "modifier_cant_hold_ball_lua", {duration="2.0"} )
							-- own   fucking   goal
							print("own goal")
							resetQuaffle(caster)
						else
							for ip=1,points do
								caster.lastholder:IncrementKills(1)
							end

							quaffleFollow(caster,target)

							target:AddNewModifier( caster, self, "modifier_immunetotackle_lua", {duration="2.0"} )
						end



						return nil
	        		--end
	        	end
	        end

			if caster.lastholder==nil then
				for ip=1,points do
					target:IncrementKills(1)
				end
			elseif caster.lastholder:GetTeamNumber()~=scoreteam then
				caster.lastholder:AddNewModifier( caster, self, "modifier_cant_hold_ball_lua", {duration="2.0"} )
				-- own   fucking   goal
				print("own goal     2")
			else
				for ip=1,points do
					caster.lastholder:IncrementKills(1)
				end
			end

			resetQuaffle(caster)
	    	return nil
	    end


		local mindist = 999999
		local target = nil
        for _,hero in pairs(Entities:FindAllByClassnameWithin("npc_dota_hero_rubick",GetGroundPosition(caster:GetAbsOrigin(),nil), 80) )  do
        	if hero:IsAlive() then
        		if hero:HasModifier("modifier_cant_hold_ball_lua") or not(hero:HasModifier("modifier_rubick_chaser_lua")) then

        		else
					local cdirection = hero:GetForwardVector()
					cdirection.z=0;
					local herohands = hero:GetAbsOrigin() + cdirection*65 - Vector(0,0,65)

		        	--local tempdist = CalcDistanceBetweenEntityOBB(hero,caster)
		        	local tempdist = (herohands-caster:GetCenter()):Length()
		        	--print(tempdist)

        			if hero:HasModifier("modifier_immunetotackle_lua") then
        				tempdist=0
        				mindist=1
        			end

		        	if tempdist >=0 and tempdist < mindist then
		        		target = hero
		        		mindist = tempdist
		        	end
		        end
	        end
		end

		if target~=nil then
			quaffleFollow(caster,target)
		else
			if caster.rdir ~= nil then
				local newposition = GetGroundPosition(caster:GetAbsOrigin() + caster.rdir, nil)
	    		if GridNav:IsTraversable(newposition) then
					caster:SetAbsOrigin(newposition)
					caster.rdir = caster.rdir *0.95
					caster.following=false
				else
					caster.rdir = Vector(0-caster.rdir.x, 0-caster.rdir.y, caster.rdir.z)
					caster.rdir = caster.rdir * 0.5
					newposition = GetGroundPosition(caster:GetAbsOrigin() + caster.rdir, nil)
		    		if GridNav:IsTraversable(newposition) then
		    			-- todo: more appropriate ball-hitting-wall sound
    					EmitSoundOn( "rubiq.catch", caster )
						caster:SetAbsOrigin(newposition)
						caster.rdir = caster.rdir *0.95
						caster.following=false
					end
				end
			end
		end
	end
end

--------------------------------------------------------------------------------
