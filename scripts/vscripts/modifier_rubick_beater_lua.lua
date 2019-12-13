modifier_rubick_beater_lua = class({})

--------------------------------------------------------------------------------

function modifier_rubick_beater_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_rubick_beater_lua:GetModifierMoveSpeedBonus_Constant( params )
	return 100
end

--------------------------------------------------------------------------------

function modifier_rubick_beater_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_rubick_beater_lua:IsHidden()
	return true
end

--------------------------------------------------------------------------------