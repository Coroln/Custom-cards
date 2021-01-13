function c100001136.initial_effect(c)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100001136,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c100001136.condition)
	e2:SetTarget(c100001136.destg)
	e2:SetOperation(c100001136.desop)
	c:RegisterEffect(e2)
end
function c100001136.cfilter(c)
	return c:IsFaceup() and c:IsCode(100001113)
end
function c100001136.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c100001136.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c100001136.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c100001136.filter(chkc,4-e:GetHandler():GetSequence()) end
	if chk==0 then return Duel.IsExistingTarget(c100001136.filter,tp,0,LOCATION_ONFIELD,1,nil,4-e:GetHandler():GetSequence()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c100001136.filter,tp,0,LOCATION_ONFIELD,1,1,nil,4-e:GetHandler():GetSequence())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c100001136.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c100001136.filter(c,seq)
	return c:GetSequence()==seq
end