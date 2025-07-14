--Voyager Assault Barrage
--Script by Coroln
local s,id=GetID()
function s.initial_effect(c)
	--destroy then equip
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DESTROY+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(Cost.Discard())
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
--destroy then equip
function s.confilter(c)
	return c:IsFaceup() and c:IsType(TYPE_LINK)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.confilter,tp,LOCATION_MZONE,0,1,nil)
end
function s.filter(c)
	return c:IsAttackBelow(2000) and c:IsMonster()
end
function s.eqfilter(c)
    return c:IsType(TYPE_UNION) and c:IsMonster() and not c:IsForbidden()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,0,LOCATION_MZONE,1,e:GetHandler())end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dg=Duel.SelectTarget(tp,s.filter,tp,0,LOCATION_MZONE,1,3,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,1,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local ct=Duel.SelectTarget(tp,s.confilter,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
		local eqc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.eqfilter),tp,LOCATION_GRAVE,0,1,1,nil):GetFirst()
		if not eqc then return end
		if Duel.Equip(tp,eqc,ct) then
			aux.SetUnionState(eqc)
		end
	end
end