--Hellcreature created and scripted by rising phoenix
function c100001178.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
local e2=Effect.CreateEffect(c)
	e2:SetCost(c100001178.spcost)
		e2:SetDescription(aux.Stringid(100001178,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,100001178+EFFECT_COUNT_CODE_OATH)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c100001178.rmtgr)
	e2:SetOperation(c100001178.rmopr)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCost(c100001178.spcost2)
		e3:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		e3:SetDescription(aux.Stringid(100001178,2))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTarget(c100001178.rmtgr2)
	e3:SetOperation(c100001178.rmopr2)
	c:RegisterEffect(e3)
end
function c100001178.rmtgr(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c100001178.rmopr(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c100001178.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then return Duel.IsExistingMatchingCard(c100001178.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c100001178.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
end
function c100001178.costfilter(c)
return c:IsSetCard(0x75B)
	and (c:IsLocation(LOCATION_HAND) or c:IsLocation(LOCATION_ONFIELD)) and c:IsAbleToGraveAsCost() and c:IsType(TYPE_MONSTER)
	end
	function c100001178.spcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100001178.costfilter2,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c100001178.costfilter2,1,1,REASON_COST+REASON_DISCARD)
end
function c100001178.costfilter2(c)
return c:IsSetCard(0x75B)
	and c:IsLocation(LOCATION_HAND) and c:IsDiscardable()
	end
	function c100001178.rmtgr2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:GetLocation()==LOCATION_ONFIELD and chkc:IsAbleToDeck() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c100001178.rmopr2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then end
		Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)
end