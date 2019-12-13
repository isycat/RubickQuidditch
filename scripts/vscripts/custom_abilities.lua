require("addon_game_mode")

-- modifier applying item
moditem = nil
function getModItem(caster)
    if not moditem then
        moditem = CreateItem( "item_apply_modifiers", caster, caster )
    end
    return moditem
end

function learnyourfuckingspells(keys)
    learnabilities(keys.target)
end

function learnabilities(unit)
    if unit==nil then 
        return nil;
    end
    if not unit:IsAlive() then
        return nil;
    end

    for aaaai=0, unit:GetAbilityCount()-1 do
        local aab = unit:GetAbilityByIndex(aaaai)
        if aab ~= nil then
            if aab:GetLevel() <1 then
                aab:SetLevel(1)
            end
        end
    end
end


--used for cosmetic pets in a thinker
function followcaster(keys)
    if keys.target == nil then
        return nil
    end
    if keys.caster == nil then
        keys.target:RemoveSelf()
        return
    end
    if not keys.caster:IsAlive() then
        keys.target:RemoveSelf()
        return
    end
    
    local dist = CalcDistanceBetweenEntityOBB(keys.caster,keys.target);
    if dist > 500 then
        FindClearSpaceForUnit( keys.target, keys.caster:GetAbsOrigin(), true )
    end

    --keys.target:MoveToNPC(keys.caster)
    keys.target:MoveToPosition(keys.caster:GetAbsOrigin())
end


function setAilityTarget(keys)
    keys.ability.target=keys.target
end


function PopupNumbers(target, pfx, color, lifetime, number, presymbol, postsymbol)
    local pfxPath = string.format("particles/msg_fx/msg_%s.vpcf", pfx)
    local pidx = ParticleManager:CreateParticle(pfxPath, PATTACH_ABSORIGIN_FOLLOW, target) -- target:GetOwner()

    local digits = 0
    if number ~= nil then
        digits = #tostring(number)
    end
    if presymbol ~= nil then
        digits = digits + 1
    end
    if postsymbol ~= nil then
        digits = digits + 1
    end

    ParticleManager:SetParticleControl(pidx, 1, Vector(tonumber(presymbol), tonumber(number), tonumber(postsymbol)))
    ParticleManager:SetParticleControl(pidx, 2, Vector(lifetime, digits, 0))
    ParticleManager:SetParticleControl(pidx, 3, color)
end

function tprint (tbl, indent)
    if not indent then indent = 0 end
    for k, v in pairs(tbl) do
        formatting = string.rep("  ", indent) .. k .. ": "
        print(formatting)
    end
end