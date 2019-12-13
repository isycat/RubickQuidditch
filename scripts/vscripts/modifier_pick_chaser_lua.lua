modifier_pick_chaser_lua = class({})

--------------------------------------------------------------------------------

function modifier_pick_chaser_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_pick_chaser_lua:CheckState()
	local state = {
	[MODIFIER_STATE_STUNNED] = true,
	[MODIFIER_STATE_SILENCED] = true,
	}

	return state
end

--------------------------------------------------------------------------------

function modifier_pick_chaser_lua:IsHidden()
	return true
end

--------------------------------------------------------------------------------
