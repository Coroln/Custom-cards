--Created and scripted by Rising Phoenix
function c100000759.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c100000759.cost)
	e1:SetTarget(c100000759.target)
	e1:SetOperation(c100000759.activate)
	c:RegisterEffect(e1)
end
function c100000759.cfilter(c)
	return c:IsSetCard(0x75A) and c:IsAbleToDeckAsCost() and c:IsType(TYPE_MONSTER)
end
function c100000759.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100000759.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c100000759.cfilter,tp,LOCATION_HAND,0,1,99,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c100000759.filter(c)
	return c:IsSetCard(0x75A) and c:IsAbleToHand() and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP))
end
function c100000759.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_DECK) and c100000759.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100000759.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c100000759.filter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c100000759.activate(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then end
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
end