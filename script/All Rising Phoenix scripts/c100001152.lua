--created and scripted by rising phoenix
function c100001152.initial_effect(c)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100001152,0))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_SEARCH+CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(aux.exccon)
	e2:SetTarget(c100001152.drtg)
	e2:SetOperation(c100001152.drop)
	c:RegisterEffect(e2)
	end
	function c100001152.drfilter(c,e)
	return c:IsSetCard(0x756) and c:IsAbleToDeck() and c:IsCanBeEffectTarget(e)
end
function c100001152.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		if chkc then return false end
	local g=Duel.GetMatchingGroup(c100001152.drfilter,tp,LOCATION_GRAVE,0,e:GetHandler(),e)
		if chk==0 then return Duel.IsExistingMatchingCard(c100001152.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
		and g:GetClassCount(Card.GetCode)>6 end
	local sg=Group.CreateGroup()
	for i=1,7 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g1=g:Select(tp,1,1,nil)
		g:Remove(Card.IsCode,nil,g1:GetFirst():GetCode())
		sg:Merge(g1)
	end
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,7,0,0)
Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(7777)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,7777)
end
function c100001152.drop(e,tp,eg,ep,ev,re,r,rp)
		local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=7 then return end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct==7 then end
		Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100001152.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
			local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
	end
	end
	function c100001152.filter(c)
	return c:IsSetCard(0x755) and c:IsAbleToHand() and not c:IsCode(100001152)
end