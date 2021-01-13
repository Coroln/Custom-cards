--Bang Bang entwickelt sich zur Orgie by Orgie
function c100001131.initial_effect(c)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c100001131.condition)
	e2:SetTarget(c100001131.target)
	e2:SetOperation(c100001131.activate)
	c:RegisterEffect(e2)
end
function c100001131.cfilter(c)
	return c:IsFaceup() and c:IsCode(100001106) or c:IsFaceup() and c:IsCode(100001107)
end
function c100001131.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c100001131.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c100001131.filter(c,e)
	return c:IsCanBeEffectTarget(e)
end
function c100001131.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c100001131.filter(chkc,e) end
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c100001131.filter,tp,0,LOCATION_ONFIELD,nil,e)
	if g:GetCount()>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=g:Select(tp,2,2,nil)
		Duel.SetTargetCard(sg)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,2,0,0)
	end
end
function c100001131.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not g then return end
	local dg=g:Filter(Card.IsRelateToEffect,nil,e)
	Duel.Destroy(dg,REASON_EFFECT)
end