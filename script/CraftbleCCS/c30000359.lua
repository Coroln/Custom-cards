local s,id=GetID()
function s.initial_effect(c)
	aux.AddEquipProcedure(c)
	--Pierce
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UNSTOPPABLE_ATTACK)
	c:RegisterEffect(e3)
end