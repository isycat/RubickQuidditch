--[[]

TODO:




]]


require("modifier_bludger_passive_lua")
require("globalstorage")

LinkLuaModifier( "modifier_prepick_root_lua", LUA_MODIFIER_MOTION_NONE )


Testing = false


if CRubickQuidditchGameMode == nil then
	CRubickQuidditchGameMode = class({})
end


function Precache( context )


	PrecacheResource("model_folder", "models/items/rubick", context)
	PrecacheResource("particle_folder", "econ/items/rubick", context)

    --PrecacheResource("model_folder", "particles/units/heroes/hero_techies", context)
    --PrecacheResource("particle_folder", "particles/units/heroes/hero_techies", context)




    PrecacheResource("particle_folder", "particles/units/heroes/hero_earth_spirit", context)



	-- required for cosmetic shit
	PrecacheResource( "model", "models/development/invisiblebox.vmdl", context )



    PrecacheResource( "model", "models/particle/snowball.vmdl", context )


    -- heroes
    PrecacheUnitByNameSync("npc_dota_hero_rubick", context)

    PrecacheUnitByNameSync("npc_dota_hero_wisp", context)
    PrecacheUnitByNameSync("npc_dota_hero_earth_spirit", context)
    PrecacheUnitByNameSync("npc_dota_hero_oracle", context)
    PrecacheUnitByNameSync("npc_dota_hero_tusk", context)

    --PrecacheUnitByNameSync("npc_dota_hero_batrider", context)


    -- Sounds
    --PrecacheResource( "sound", "sounds/qmusic.vsnd", context )
    --PrecacheResource( "soundfile", "soundevents/custom_sounds.vsndevts", context )
    PrecacheResource( "sound_folder", "sounds", context)

    PrecacheResource( "sound", "sounds/qmusic.vsnd", context )
    PrecacheResource( "sound", "sounds/qmusic.mp3", context )
    PrecacheResource( "sound", "soundevents/custom_sounds.vsndevts", context )
    PrecacheResource( "soundfile", "soundevents/custom_sounds.vsndevts", context )

    PrecacheResource( "sound", "sounds/rbq/cheering.vsnd", context )
    PrecacheResource( "sound", "sounds/rbq/gamestart.vsnd", context )
    PrecacheResource( "sound", "sounds/rbq/tackle.vsnd", context )
    PrecacheResource( "sound", "sounds/rbq/horn.vsnd", context )
    PrecacheResource( "sound", "sounds/rbq/kick.vsnd", context )
    PrecacheResource( "sound", "sounds/rbq/catch.vsnd", context )
    -- Buildings



end

-- Create the game mode when we activate
function Activate()
	GameRules.AddonTemplate = CRubickQuidditchGameMode()
    GamePlay.zxc="value x"
	GameRules.AddonTemplate:InitGameMode()
end

function learnabilities(unit)
    if unit==nil then 
        return nil;
    end
    if not unit:IsAlive() then
        return nil;
    end

    for aaaai=0, unit:GetAbilityCount()-1 do
        local aab = unit:GetAbilityByIndex(aaaai)
        if aab ~= nil then
            if aab:GetLevel() <1 then
                aab:SetLevel(1)
            end
        end
    end
end

function CRubickQuidditchGameMode:InitGameMode()
	print( "rubiQ is loaded." )

    GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 1 )
	
	--ListenToGameEvent('player_fullyjoined', Dynamic_Wrap(CRubickQuidditchGameMode, 'OnPlayerLoaded'), self)
	--ListenToGameEvent("player_connect_full", Dynamic_Wrap(CRubickQuidditchGameMode, "OnPlayerLoaded"), self)  -- THIS ONE

	GameRules:SetUseUniversalShopMode( false )

    GameRules:SetHeroSelectionTime( 20.0 ) -- hero selection is not skipped unless this is set to 0 it seems
	GameRules:SetPreGameTime( 35.0 )
	GameRules:SetPostGameTime( 30.0 )
    GameRules:SetRuneSpawnTime(30)

	GameRules:SetTreeRegrowTime( 5.0 )
	GameRules:SetGoldTickTime( 60.0 )
	GameRules:SetGoldPerTick( 0 )
    GameRules:SetUseBaseGoldBountyOnHeroes(true)
    GameRules:SetFirstBloodActive(false)

    --GameRules:SetHeroMinimapIconSize( 400 )
    --GameRules:SetCreepMinimapIconScale( 0.7 )
    --GameRules:SetRuneMinimapIconScale( 0.7 )

    GameRules:SetSameHeroSelectionEnabled(true)
    GameRules:SetHeroRespawnEnabled( false )




    GameRules:GetGameModeEntity():SetCustomGameForceHero("npc_dota_hero_rubick")


	--GameRules:GetGameModeEntity():SetRemoveIllusionsOnDeath( true )
	GameRules:GetGameModeEntity():SetTopBarTeamValuesOverride( true )    -- Override the top bar values to show your own settings instead of total deaths
	--GameRules:GetGameModeEntity():SetTopBarTeamValuesVisible( false )
	--GameRules:GetGameModeEntity():SetUseCustomHeroLevels(true)

	--GameRules:GetGameModeEntity():SetCustomHeroMaxLevel(20)

	GameRules:GetGameModeEntity():SetCustomHeroMaxLevel(7)

	GameRules:GetGameModeEntity():SetBuybackEnabled(false)
    --GameRules:GetGameModeEntity():SetCameraDistanceOverride( 1404.0 )


--[[
    GamePlay.bludger = CreateUnitByName("npc_rubiq_bludger", Vector(300,-300,300), false, nil, nil, 1 ) 
    if GamePlay.bludger ~= nil then
        learnabilities(GamePlay.bludger)
        GamePlay.bludger:GetAbilityByIndex(0):SetLevel(1)
        GamePlay.bludger:AddNewModifier(GamePlay.bludger, nil, "modifier_bloodseeker_thirst", {})
    end
    GamePlay.bludger2 = CreateUnitByName("npc_rubiq_bludger", Vector(-300,300,300), false, nil, nil, 1 ) 
    if GamePlay.bludger2 ~= nil then
        learnabilities(GamePlay.bludger2)
        GamePlay.bludger2:GetAbilityByIndex(0):SetLevel(1)
        GamePlay.bludger2:AddNewModifier(GamePlay.bludger2, nil, "modifier_bloodseeker_thirst", {})
    end
    
    GamePlay.quaffle = CreateUnitByName("npc_rubiq_quaffle", Vector(0,0,300), false, nil, nil, 1 ) 
    if GamePlay.quaffle ~= nil then
        learnabilities(GamePlay.quaffle)
        GamePlay.quaffle:GetAbilityByIndex(0):SetLevel(1)
    end]]


end



starttime = -1

notpicked=true      -- heroes have not been given their chosen classes

startedmusic = false
cheerb = false



-- Evaluate the state of the game
function CRubickQuidditchGameMode:OnThink()

	local currentGameTime = GameRules:GetDOTATime(false,true);


	for _,hero in pairs( Entities:FindAllByClassname( "npc_dota_hero_rubick")) do

            if hero:GetAbilityPoints()>0 then
                hero:AddNewModifier( hero, self, "modifier_prepick_root_lua", {duration="-1"} )
                hero:SetAbilityPoints(0)

                hero:AddAbility("pick_chaser_lua")
                local abzx = hero:FindAbilityByName("pick_chaser_lua")
                if abzx ~= nil then
                    --abzx:SetAbilityIndex(0)
                    abzx:SetLevel(1)
                end

                hero:AddAbility("pick_beater_lua")
                abzx = hero:FindAbilityByName("pick_beater_lua")
                if abzx ~= nil then
                    --abzx:SetAbilityIndex(0)
                    abzx:SetLevel(1)
                end
            end

            local id = hero:GetPlayerOwner():GetPlayerID()
            if id ~= -1 then

               	if hero:GetTeamNumber() == 2 then
                	if starttime>-1 and currentGameTime >= 60 then
                        -- auto select
       				end
               	elseif hero:GetTeamNumber() == 3 then
                	if starttime>-1 and currentGameTime >= 60 then
                        -- auto select team B
    				end
                end
            end

    end

        --print(currentGameTime)

    if GameRules:State_Get() == DOTA_GAMERULES_STATE_PRE_GAME then

        if not cheerb then
            EmitGlobalSound( "rubiq.cheering" )
            cheerb = true
        end

        if currentGameTime>-3 then
            if not startedmusic then
                EmitGlobalSound( "rubiq.gamestart" )
                startedmusic = true
            
                GamePlay.quaffle = CreateUnitByName("npc_rubiq_quaffle", Vector(0,0,300), false, nil, nil, 1 ) 
                if GamePlay.quaffle ~= nil then
                    learnabilities(GamePlay.quaffle)
                    GamePlay.quaffle:GetAbilityByIndex(0):SetLevel(1)
                end

            end
        end
    end

	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then

        if currentGameTime % 50 == 0 then
            EmitGlobalSound( "rubiq.cheering" )
        end

        if notpicked and currentGameTime >= 0 then
            print("SPAWNING OK")

            local newteams = {}

            newteams[2] = {}
            newteams[2].picks = {}
            newteams[2].picks["chaser"] = GamePlay.teams[2].picks["chaser"]+0
            newteams[2].picks["beater"] = GamePlay.teams[2].picks["beater"]+0
            newteams[2].picks["seker"] = GamePlay.teams[2].picks["seker"]+0

            newteams[3] = {}
            newteams[3].picks = {}
            newteams[3].picks["chaser"] = GamePlay.teams[3].picks["chaser"]+0
            newteams[3].picks["beater"] = GamePlay.teams[3].picks["beater"]+0
            newteams[3].picks["seker"] = GamePlay.teams[3].picks["seker"]+0

            for _,hero in pairs( Entities:FindAllByClassname( "npc_dota_hero_rubick")) do

                if hero:HasModifier("modifier_pick_beater_lua") then
                    pickBeater(hero)

                elseif hero:HasModifier("modifier_pick_chaser_lua") then
                    pickChaser(hero)

                else    -- give them something random (within the team structure limits)

                    --local abs = hero:GetAbilityCount()
                    --for abi = 0, abs-1 do
                    --    local ability = hero:GetAbilityByIndex(abi)
                    --    if ability ~= nil then
                    --        hero:RemoveAbility(ability:GetAbilityName())
                    --    end
                    --end
                    --pickChaser(hero)
                    --pickBeater(hero)


                    local role = "chaser"
                    local teamnumber = hero:GetTeamNumber()
                    local val = newteams[teamnumber].picks[role]
                    if val > 0 then
                        newteams[teamnumber].picks[role] = val-1
                        hero:CastAbilityNoTarget(hero:FindAbilityByName("pick_chaser_lua"), hero:GetPlayerOwnerID())
                    else
                        role = "beater"
                        teamnumber = hero:GetTeamNumber()
                        val = newteams[teamnumber].picks[role]
                        if val > 0 then
                            newteams[teamnumber].picks[role] = val-1
                            hero:CastAbilityNoTarget(hero:FindAbilityByName("pick_beater_lua"), hero:GetPlayerOwnerID())
                        end
                    end

                end

            end




            GamePlay.bludger = CreateUnitByName("npc_rubiq_bludger", Vector(300,-300,300), false, nil, nil, 1 ) 
            if GamePlay.bludger ~= nil then
                learnabilities(GamePlay.bludger)
                GamePlay.bludger:GetAbilityByIndex(0):SetLevel(1)
                GamePlay.bludger:AddNewModifier(GamePlay.bludger, nil, "modifier_bloodseeker_thirst", {})
            end
            GamePlay.bludger2 = CreateUnitByName("npc_rubiq_bludger", Vector(-300,300,300), false, nil, nil, 1 ) 
            if GamePlay.bludger2 ~= nil then
                learnabilities(GamePlay.bludger2)
                GamePlay.bludger2:GetAbilityByIndex(0):SetLevel(1)
                GamePlay.bludger2:AddNewModifier(GamePlay.bludger2, nil, "modifier_bloodseeker_thirst", {})
            end


            

            notpicked=false
        end


		if starttime == -1 then
			starttime = GameRules:GetGameTime()
		end

		self:_CheckForDefeat()
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	return 1
end



function pickChaser(hero)
    print("picked chaser")
    hero:RemoveModifierByName("modifier_prepick_root_lua")
    hero:RemoveModifierByName("modifier_pick_chaser_lua")
    --[[hero:AddAbility("rubick_passive_lua")
    local abzx = hero:FindAbilityByName("rubick_passive_lua")
    if abzx ~= nil then
        abzx:SetAbilityIndex(0)
        abzx:SetLevel(1)
    end]]
end

function pickBeater(hero)
    print("picked beater")
    hero:RemoveModifierByName("modifier_prepick_root_lua")
    hero:RemoveModifierByName("modifier_pick_beater_lua")
    --[[hero:AddAbility("rubick_beat_lua")
    local abzx = hero:FindAbilityByName("rubick_beat_lua")
    if abzx ~= nil then
        abzx:SetAbilityIndex(0)
        abzx:SetLevel(1)
        print("ab added")
    else
        print("ab FAIL FUKLCCUFLUCFKCF")
    end]]
end



function CRubickQuidditchGameMode:_CheckForDefeat()
	
end