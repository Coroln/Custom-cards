--PM Donnerblitz
function c19962008.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c19962008.condition)
	e1:SetTarget(c19962008.target)
	e1:SetOperation(c19962008.activate)
	c:RegisterEffect(e1)
end
function c19962008.cfilter(c)
	return c:IsFaceup() and c:IsCode(19962000)
end
function c19962008.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c19962008.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c19962008.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,sg:GetCount()*500)
end
function c19962008.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	local sg=Duel.Destroy(sg,REASON_EFFECT)
	Duel.Damage(1-tp,sg*500,REASON_EFFECT)
end
