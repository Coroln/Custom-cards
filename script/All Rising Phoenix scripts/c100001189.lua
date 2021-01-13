--sccripted and created by rising phoenix
function c100001189.initial_effect(c)
		--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100001189,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c100001189.cost)
	e1:SetTarget(c100001189.target)
	e1:SetOperation(c100001189.activate)
	c:RegisterEffect(e1)
		--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100001189,1))
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(c100001189.target2)
	e2:SetOperation(c100001189.activate2)
	c:RegisterEffect(e2)
	--Activate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100001189,2))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetTarget(c100001189.target3)
	e3:SetOperation(c100001189.activate3)
	c:RegisterEffect(e3)
end
function c100001189.filter2(c)
	return c:IsCode(74875003) and c:IsAbleToDeck()  
end
function c100001189.target3(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.IsExistingMatchingCard(c100001189.filter2,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.GetMatchingGroup(c100001189.filter2,tp,LOCATION_GRAVE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c100001189.activate3(e,tp,eg,ep,ev,re,r,rp)
		local g=Duel.GetMatchingGroup(c100001189.filter2,tp,LOCATION_GRAVE,0,nil)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
function c100001189.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>4 end
end
function c100001189.activate2(e,tp,eg,ep,ev,re,r,rp)
	Duel.SortDecktop(tp,tp,5)
end
function c100001189.filter(c)
	return (c:IsCode(100001186) or  c:IsCode(100001185) or  c:IsCode(100001183) or c:IsCode(10000040) or c:IsCode(10000020) or c:IsCode(10000000) or c:IsCode(10000010) or c:IsCode(10000090) or c:IsCode(10000080)) and c:IsDiscardable()
end
function c100001189.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100001189.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c100001189.filter,1,1,REASON_COST+REASON_DISCARD)
end
function c100001189.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c100001189.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
