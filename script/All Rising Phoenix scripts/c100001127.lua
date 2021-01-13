--HAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA!!! by Tobiz
function c100001127.initial_effect(c)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100001127,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c100001127.condition)
	e2:SetTarget(c100001127.destg)
	e2:SetOperation(c100001127.desop)
	c:RegisterEffect(e2)
end
function c100001127.cfilter(c)
	return c:IsFaceup() and c:IsCode(100001100) or c:IsFaceup() and c:IsCode(100001101) or c:IsFaceup() and c:IsCode(100001102) or c:IsFaceup() and c:IsCode(100001103) or c:IsFaceup() and c:IsCode(100001114) or c:IsFaceup() and c:IsCode(100001115) or c:IsFaceup() and c:IsCode(100001116) or c:IsFaceup() and c:IsCode(100001109) or c:IsFaceup() and c:IsCode(100001110) or c:IsFaceup() and c:IsCode(100001112) or c:IsFaceup() and c:IsCode(100001120) or c:IsFaceup() and c:IsCode(100001121) or c:IsFaceup() and c:IsCode(100001123) or c:IsFaceup() and c:IsCode(100001124) or c:IsFaceup() and c:IsCode(100001122) 
end
function c100001127.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c100001127.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c100001127.filter(c)
	return c:IsType(TYPE_MONSTER)
end
function c100001127.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c100001127.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100001127.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c100001127.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c100001127.desop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
