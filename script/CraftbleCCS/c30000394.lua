local s,id=GetID()
function s.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e0:SetCode(EVENT_SUMMON_SUCCESS)
	e0:SetOperation(s.moneop)
	e0:SetCondition(s.monecon)
	e0:SetCost(s.monecost)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetOperation(s.moneop)
	e1:SetCondition(s.mtwocon)
	c:RegisterEffect(e1)
end
s.listed_names={36607978}
function s.monecon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPhase(PHASE_MAIN1)
end
function s.mtwocon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPhase(PHASE_MAIN2)
end
function s.monecost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,nil)
end
function s.moneop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local token=Duel.CreateToken(tp,30000381)
	Duel.SendtoHand(token,nil,REASON_EFFECT)
end