modifier_bludger_slow_lua = class({})

--------------------------------------------------------------------------------

function modifier_bludger_slow_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_bludger_slow_lua:GetModifierMoveSpeedBonus_Constant( params )
	return -150
end

--------------------------------------------------------------------------------

function modifier_bludger_slow_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_bludger_slow_lua:OnCreated( kv )
	if IsServer() then
		--self:GetParent():StartGesture( ACT_DOTA_DISABLED )
	end
end

--------------------------------------------------------------------------------

function modifier_bludger_slow_lua:OnDestroy( kv )
	if IsServer() then
		--self:GetParent():RemoveGesture( ACT_DOTA_DISABLED )
	end
end

--------------------------------------------------------------------------------

function modifier_bludger_slow_lua:IsHidden()
	return false
end

--------------------------------------------------------------------------------
