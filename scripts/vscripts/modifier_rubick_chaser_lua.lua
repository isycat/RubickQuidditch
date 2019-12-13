modifier_rubick_chaser_lua = class({})
LinkLuaModifier( "modifier_cant_hold_ball_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tackleslow_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function modifier_rubick_chaser_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_rubick_chaser_lua:IsHidden()
	return true
end

--------------------------------------------------------------------------------