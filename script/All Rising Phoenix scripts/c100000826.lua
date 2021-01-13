--offering
function c100000826.initial_effect(c)
		--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c100000826.op)
	e1:SetCost(c100000826.cost1)
	c:RegisterEffect(e1)
end
function c100000826.confilter(c)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0x758)and c:IsAbleToRemoveAsCost()
end
function c100000826.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100000826.confilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c100000826.confilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c100000826.op(e,tp,eg,ep,ev,re,r,rp)
	local lp1=Duel.GetLP(tp)
		local lp2=Duel.GetLP(1-tp)
		Duel.SetLP(tp,lp2)
		Duel.SetLP(1-tp,lp1)
			--reverse
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetOperation(c100000826.disop)
	Duel.RegisterEffect(e1,p)
end
function c100000826.disop(e,tp,eg,ep,ev,re,r,rp)
	local lp2=Duel.GetLP(tp)
		local lp1=Duel.GetLP(1-tp)
		Duel.SetLP(tp,lp1)
		Duel.SetLP(1-tp,lp2)
end


