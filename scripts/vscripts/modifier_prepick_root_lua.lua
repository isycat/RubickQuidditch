modifier_prepick_root_lua = class({})

--------------------------------------------------------------------------------

function modifier_prepick_root_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_prepick_root_lua:CheckState()
	local state = {
	[MODIFIER_STATE_ROOTED] = true,
	}

	return state
end

--------------------------------------------------------------------------------

function modifier_prepick_root_lua:IsHidden()
	return true
end

--------------------------------------------------------------------------------
