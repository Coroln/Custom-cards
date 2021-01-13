--scripted and created by rising phoenix
function c100001135.initial_effect(c)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100001135,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c100001135.condition)
	e2:SetTarget(c100001135.destg)
	e2:SetOperation(c100001135.desop)
	c:RegisterEffect(e2)
end
function c100001135.cfilter(c)
	return c:IsFaceup() and c:IsCode(100001112) 
	end
function c100001135.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c100001135.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c100001135.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c100001135.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c100001135.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100001135.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c100001135.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c100001135.desop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
