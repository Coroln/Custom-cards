--Created and scripted by Rising Phoenix
function c100000760.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c100000760.target)
	e1:SetOperation(c100000760.activate)
	c:RegisterEffect(e1)
end
function c100000760.filter(c)
	return c:IsSetCard(0x75A) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()  or c:IsAbleToExtra()
end
function c100000760.target(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.IsExistingMatchingCard(c100000760.filter,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.GetMatchingGroup(c100000760.filter,tp,LOCATION_GRAVE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c100000760.activate(e,tp,eg,ep,ev,re,r,rp)
		local g=Duel.GetMatchingGroup(c100000760.filter,tp,LOCATION_GRAVE,0,nil)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	local og=Duel.GetOperatedGroup()
			local ct=og:FilterCount(c100000760.filter,nil)
			if ct>0 then end
				Duel.Recover(tp,ct*100,REASON_EFFECT)
	end