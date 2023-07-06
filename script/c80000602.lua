--Celtic Guard of Royal Arts
--Script by Coroln
local s,id=GetID()
function s.initial_effect(c)
	--summon with 3 tribute
	local e1=aux.AddNormalSummonProcedure(c,true,true,3,3,SUMMON_TYPE_TRIBUTE+1,aux.Stringid(id,0))
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(s.descon)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCondition(s.descon)
	e2:SetTarget(s.target)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_TRIBUTE+1
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0,nil)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
--equip
function s.eqfilter(c,g)
	return c:IsType(TYPE_EQUIP) and g:IsExists(s.eqcheck,1,nil,c)
end
function s.eqcheck(c,ec)
	return ec:CheckEquipTarget(c)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return false end
		local g=Duel.GetMatchingGroup(aux.FaceupFilter(Card.IsRace,RACE_WARRIOR),tp,LOCATION_MZONE,0,nil)
		return Duel.IsExistingMatchingCard(s.eqfilter,tp,LOCATION_GRAVE,0,1,nil,g)
	end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,LOCATION_GRAVE)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ft<=0 then return end
	local g=Duel.GetMatchingGroup(aux.FaceupFilter(Card.IsRace,RACE_WARRIOR),tp,LOCATION_MZONE,0,nil)
	local eq=Duel.GetMatchingGroup(s.eqfilter,tp,LOCATION_GRAVE,0,nil,g)
	if ft>#eq then ft=#eq end
	if ft==0 then return end
	for i=1,ft do
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
		local ec=eq:Select(tp,1,1,nil):GetFirst()
		eq:RemoveCard(ec)
		local tc=g:FilterSelect(tp,s.eqcheck,1,1,nil,ec):GetFirst()
		Duel.Equip(tp,ec,tc,true,true)
	end
	Duel.EquipComplete()
end