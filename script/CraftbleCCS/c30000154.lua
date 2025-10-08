local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0,LOCATION_SZONE)
	e2:SetCondition(s.actcon)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_TRAP))
	c:RegisterEffect(e2)
end
s.listed_names={2468169}
function s.actcon(e)
	return Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,2468169),e:GetOwnerPlayer(),LOCATION_MZONE,0,1,nil)
end