--fight
function c100001157.initial_effect(c)
		--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c100001157.distg)
	e1:SetOperation(c100001157.activate)
		e1:SetCondition(c100001157.condition1)
	c:RegisterEffect(e1)
end
function c100001157.filter(c)
	return c:IsFaceup() and c:IsCode(100001155)
end
function c100001157.check()
	return Duel.IsExistingMatchingCard(c100001157.filter,0,LOCATION_ONFIELD,0,1,nil)
		or Duel.IsEnvironment(100001155)
end
function c100001157.condition1(e,tp,eg,ep,ev,re,r,rp)
	return c100001157.check()
end
function c100001157.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c100001157.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local tc=g:GetFirst()
	local c=e:GetHandler()
		while tc do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2)
			if tc:IsType(TYPE_TRAPMONSTER) then end
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
				e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3)
		tc=g:GetNext()
	end
end
function c100001157.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100001157.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
end
function c100001157.cfilter(c)
	return c:IsFaceup() and not c:IsSetCard(0x750)
end