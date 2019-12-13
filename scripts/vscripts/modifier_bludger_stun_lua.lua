modifier_bludger_stun_lua = class({})

--------------------------------------------------------------------------------

function modifier_bludger_stun_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_bludger_stun_lua:CheckState()
	local state = {
	[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end

--------------------------------------------------------------------------------

function modifier_bludger_stun_lua:IsHidden()
	return true
end

--------------------------------------------------------------------------------
