require("addon_game_mode")

bludger_passive_lua = class({})
LinkLuaModifier( "modifier_bludger_passive_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function bludger_passive_lua:OnUpgrade()
	self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_bludger_passive_lua", {duration="-1"} )
end

--------------------------------------------------------------------------------