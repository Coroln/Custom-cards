local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(s.imcon1)
	e2:SetValue(s.efilter)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetCondition(s.imcon2)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetTargetRange(LOCATION_FZONE,0)
	e4:SetRange(LOCATION_SZONE)
	e4:SetValue(1)
	c:RegisterEffect(e4)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local op=Duel.SelectOption(tp,aux.Stringid(id,0),aux.Stringid(id,1))
	if op==1 then e:GetHandler():RegisterFlagEffect(id,RESET_EVENT|RESETS_STANDARD,0,2) end
end
function s.imcon1(e)
	return e:GetHandler():GetFlagEffect(id)==0
end
function s.imcon2(e)
	return e:GetHandler():GetFlagEffect(id)~=0
end
function s.efilter(e,te)
	return te:IsActiveType(TYPE_FIELD) and te:GetOwnerPlayer()==e:GetHandlerPlayer()
end