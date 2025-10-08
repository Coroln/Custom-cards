local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,73216412,46821314)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_REMOVE)
	e2:SetTarget(s.target)
	e2:SetCondition(s.tgcon)
	e2:SetOperation(s.tgop)
	c:RegisterEffect(e2)
end
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return tc:IsControler(tp)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_REMOVED)
end
function s.filter(c)
	return not c:IsType(TYPE_TOKEN)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local lp=Duel.GetLP(1-tp)
	local ct=eg:FilterCount(s.filter,nil)*100
	for tc in eg:Iter() do
		local token=Duel.CreateToken(tp,tc:GetOriginalCode())
		Duel.SendtoDeck(token,nil,0,REASON_EFFECT)
	end
	Duel.SetLP(1-tp,(lp<=ct) and 0 or (lp-ct))
	Duel.ShuffleDeck(tp)
end