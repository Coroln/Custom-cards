local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetTarget(s.distg)
	c:RegisterEffect(e2)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetCode(EVENT_LEAVE_FIELD_P)
	e5:SetRange(LOCATION_SZONE)
	e5:SetOperation(s.addop2)
	c:RegisterEffect(e5)
end
function s.addop2(e,tp,eg,ep,ev,re,r,rp)
	local count=0
	for c in aux.Next(eg) do
		if c:IsPreviousControler(1-tp) and c:IsReason(REASON_DESTROY) and c:GetCounter(0x1009)~=0 then
			Duel.Damage(1-tp,500,REASON_EFFECT)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD_EXC_GRAVE)
			c:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD_EXC_GRAVE)
			c:RegisterEffect(e2)
		end
	end
end
function s.distg(e,c)
	return c:GetCounter(0x1009)>0
end