	--energy
function c100000877.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCountLimit(1,100000877+EFFECT_COUNT_CODE_OATH)
	e1:SetDescription(aux.Stringid(100000877,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c100000877.target)
	e1:SetOperation(c100000877.activate)
	e1:SetCondition(c100000877.condition)
	c:RegisterEffect(e1)
end
function c100000877.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x753) and c:IsType(TYPE_MONSTER)
end
function c100000877.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c100000877.cfilter,tp,LOCATION_GRAVE,0,1,nil)
end
function c100000877.filter(c)
	return c:IsSetCard(0x753) and c:IsAbleToRemove() and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c100000877.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and c100000877.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100000877.filter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(100000877,0))
	local g=Duel.SelectTarget(tp,c100000877.filter,tp,LOCATION_REMOVED,0,1,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
	if chkc then return chkc:GetLocation()==LOCATION_GRAVE and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(c100000877.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c100000877.filter,tp,LOCATION_GRAVE,0,1,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c100000877.activate(e,tp,eg,ep,ev,re,r,rp)
		local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=tg:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then end
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_RETURN)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e) 
	Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
end