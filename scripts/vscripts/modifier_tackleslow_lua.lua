modifier_tackleslow_lua = class({})

--------------------------------------------------------------------------------

function modifier_tackleslow_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_tackleslow_lua:GetModifierMoveSpeedBonus_Constant( params )
	return -40
end

--------------------------------------------------------------------------------

function modifier_tackleslow_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_rubick_passive_lua:GetActivityTranslationModifiers( params )
	--if self:GetParent() == self:GetCaster() then
		return "firefly"
	--end

	--return 0
end

--------------------------------------------------------------------------------

function modifier_tackleslow_lua:OnCreated( kv )
	if IsServer() then
		--self:GetParent():StartGesture( ACT_DOTA_DISABLED )
	end
end

--------------------------------------------------------------------------------

function modifier_tackleslow_lua:OnDestroy( kv )
	if IsServer() then
		--self:GetParent():RemoveGesture( ACT_DOTA_DISABLED )
	end
end

--------------------------------------------------------------------------------

function modifier_tackleslow_lua:IsHidden()
	return false
end

--------------------------------------------------------------------------------
