local s,id=GetID()
function s.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	--if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_SZONE,1,nil) end
	Duel.SetChainLimit(aux.FALSE)
	return true
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local g2=Duel.GetMatchingGroup(Card.IsFacedown,tp,0,LOCATION_SZONE,nil)
	local sg=Duel.GetMatchingGroup(Card.IsTrap,tp,0,LOCATION_SZONE,nil)
	Duel.ConfirmCards(tp,g2)
	if Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
	local g=sg:Select(tp,1,1,nil)
	Duel.Destroy(g,REASON_EFFECT)
	end
end