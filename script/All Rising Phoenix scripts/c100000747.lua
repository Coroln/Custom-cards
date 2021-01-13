function c100000747.initial_effect(c)
	--Activate(effect)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_ACTIVATE)
	e4:SetCode(EVENT_CHAINING)
	e4:SetCondition(c100000747.condition)
	e4:SetTarget(c100000747.target2)
	e4:SetOperation(c100000747.activate2)
	c:RegisterEffect(e4)
end
function c100000747.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re:GetHandler():IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function c100000747.activate2(e,tp,eg,ep,ev,re,r,rp)
if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEDOWN,REASON_EFFECT)
	end
end
function c100000747.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x754) and c:IsType(TYPE_EQUIP)
end
function c100000747.condition(e,tp,eg,ep,ev,re,r,rp)
	return (re:IsHasType(EFFECT_TYPE_ACTIVATE) or re:IsActiveType(TYPE_MONSTER)) and Duel.IsChainNegatable(ev)
		and Duel.IsExistingMatchingCard(c100000747.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
