--Phantom Beast Chimera Elegent Tiger
function c53790728.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMixN(c,true,true,77207191,1,aux.FilterBoolFunctionEx(Card.IsSetCard,0x1B),2)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(53790728,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c53790728.negcon)
	e1:SetCost(c53790728.negcost)
	e1:SetTarget(c53790728.negtg)
	e1:SetOperation(c53790728.negop)
	c:RegisterEffect(e1)
end
function c53790728.negcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c53790728.cfilter(c,rtype)
	return c:IsType(rtype) and c:IsAbleToGraveAsCost()
end
function c53790728.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local rtype=bit.band(re:GetActiveType(),0x7)
	if chk==0 then return Duel.IsExistingMatchingCard(c53790728.cfilter,tp,LOCATION_HAND,0,1,nil,rtype) end
	Duel.DiscardHand(tp,c53790728.cfilter,1,1,REASON_COST,nil,rtype)
end
function c53790728.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re:GetHandler():IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function c53790728.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end
