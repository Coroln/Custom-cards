function c100000934.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCondition(c100000934.hspcon)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c100000934.target)
	e1:SetOperation(c100000934.activate)
	c:RegisterEffect(e1)
	--disable spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetCode(EFFECT_CANNOT_TRIGGER)
	e3:SetTargetRange(0,LOCATION_SZONE)
	c:RegisterEffect(e3)
end
function c100000934.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x766)
end
function c100000934.hspcon(e,tp,eg,ep,ev,re,r,rp)
		return Duel.IsExistingMatchingCard(c100000934.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c100000934.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	c:SetTurnCounter(0)
	local g=Duel.GetMatchingGroup(Card.IsCanTurnSet,tp,0,LOCATION_SZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(c100000934.descon)
	e1:SetOperation(c100000934.desop)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_SELF_TURN,1)
	c:RegisterEffect(e1)
end
function c100000934.descon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function c100000934.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	ct=ct+1
	c:SetTurnCounter(ct)
	if ct==1 then
		Duel.Destroy(c,REASON_RULE)
	end
end
function c100000934.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(Card.IsCanTurnSet,tp,0,LOCATION_SZONE,nil)
	if g:GetCount()>0 then end
		Duel.ChangePosition(g,POS_FACEDOWN)
	end