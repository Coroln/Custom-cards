--Created and scripted by Rising Phoenix
function c100000710.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--quick
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100000710,0))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetLabel(1)
	e2:SetCondition(c100000710.condition)
	e2:SetCost(c100000710.cost)
	e2:SetOperation(c100000710.operation)
	c:RegisterEffect(e2)
	--Activate
	local e11=Effect.CreateEffect(c)
	e11:SetCategory(CATEGORY_TODECK)
	e11:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e11:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e11:SetCode(EVENT_DESTROYED)
	e11:SetTarget(c100000710.target)
	e11:SetOperation(c100000710.activate)
	c:RegisterEffect(e11)
end
function c100000710.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x75F) and c:IsAbleToDeck()
end
function c100000710.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and c100000710.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100000710.filter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(100000710,0))
	local g=Duel.SelectTarget(tp,c100000710.filter,tp,LOCATION_REMOVED,0,1,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c100000710.activate(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=tg:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
	end
end
function c100000710.cfilter(c)
	return c:IsSetCard(0x75F) and c:IsAbleToRemoveAsCost() and c:IsType(TYPE_MONSTER)
end
function c100000710.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 or not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.NegateAttack()
end
function c100000710.condition(e,tp,eg,ep,ev,re,r,rp)
	return  tp~=Duel.GetTurnPlayer()
end
function c100000710.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100000710.cfilter,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c100000710.cfilter,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end