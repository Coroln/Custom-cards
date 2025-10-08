local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetValue(s.vala)
		e1:SetTargetRange(LOCATION_MZONE,0)
		Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_BASE_DEFENSE)
	e2:SetValue(s.vald)
	Duel.RegisterEffect(e2,tp)
end
function s.vala(e,c)
return c:GetBaseAttack()+200 end
function s.vald(e,c)
return c:GetBaseDefense()+200 end