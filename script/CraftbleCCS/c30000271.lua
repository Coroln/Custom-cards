local s,id=GetID()
function s.initial_effect(c)
	--def
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCode(EFFECT_UPDATE_DEFENSE)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x2c))
	e1:SetValue(1800)
	c:RegisterEffect(e1)
end
s.listed_series={0x2c}