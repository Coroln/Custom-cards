local s,id=GetID()
function s.initial_effect(c
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(s.discon)
	e2:SetCost(aux.bfgcost)
	e2:SetOperation(s.disop)
	c:RegisterEffect(e2)
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and Duel.IsChainDisablable(ev)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.CountHeads(Duel.TossCoin(tp,1))==1 then
	Duel.NegateEffect(ev)
	end
end