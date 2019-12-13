modifier_bludger_passive_mode_lua = class({})

--------------------------------------------------------------------------------

function modifier_bludger_passive_mode_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_bludger_passive_mode_lua:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_bludger_passive_mode_lua:CheckState()
	local state = {
	[MODIFIER_STATE_ROOTED] = true,
	}

	return state
end

--------------------------------------------------------------------------------

function modifier_bludger_passive_mode_lua:OnCreated( kv )
	if IsServer() then
		--self:GetParent():MoveToPosition(self:GetParent():GetAbsOrigin())
		self:GetParent().btarget=nil
	end
end

--------------------------------------------------------------------------------

function modifier_bludger_passive_mode_lua:OnDestroy( kv )
	if IsServer() then
		self:GetParent().btarget=nil
	end
end

--------------------------------------------------------------------------------
