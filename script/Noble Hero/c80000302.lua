--Noble Hero Cú
local s,id=GetID()
function s.initial_effect(c)
	--shift lv
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	--pierce
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_PIERCE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(s.dircon)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xBDF))
	c:RegisterEffect(e2)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(76922029,0))
		local op=Duel.SelectOption(tp,aux.Stringid(82693917,0),aux.Stringid(17643265,0))
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
		if op==0 then
			e1:SetValue(1)
		else
			e1:SetValue(-1)
		end
		c:RegisterEffect(e1)
	end
end
function s.dircon(e)
	return Duel.IsEnvironment(80000315)
end
