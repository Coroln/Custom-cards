function c100000933.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCondition(c100000933.hspcon)
	e1:SetTarget(c100000933.target)
	e1:SetOperation(c100000933.activate)
	c:RegisterEffect(e1)
end
function c100000933.filter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c100000933.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100000933.filter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c100000933.filter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function c100000933.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c100000933.filter,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		Duel.ChangePosition(g,POS_FACEDOWN_ATTACK,0,POS_FACEDOWN_DEFENSE,0)
	end
end
function c100000933.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x766)
end
function c100000933.hspcon(e,tp,eg,ep,ev,re,r,rp)
		return Duel.IsExistingMatchingCard(c100000933.cfilter,tp,LOCATION_MZONE,0,1,nil)
end