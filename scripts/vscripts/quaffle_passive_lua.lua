require("addon_game_mode")

quaffle_passive_lua = class({})
LinkLuaModifier( "modifier_quaffle_passive_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function quaffle_passive_lua:OnUpgrade()
	self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_quaffle_passive_lua", {duration="-1"} )
end

--------------------------------------------------------------------------------