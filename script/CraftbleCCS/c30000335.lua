local s,id=GetID()
function s.initial_effect(c)
	--cost
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	--summon with 1 tribute
	local e2=aux.AddNormalSummonProcedure(c,true,true,1,1,SUMMON_TYPE_TRIBUTE,aux.Stringid(id,0),s.otfilter)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(s.reptg)
	c:RegisterEffect(e3)
end
s.listed_names={36623431}
function s.otfilter(c,tp)
	return c:IsSetCard(SET_KOAKI_MEIRU) and (c:IsControler(tp) or c:IsFaceup())
end
function s.cfilter1(c)
	return c:IsCode(36623431) and c:IsAbleToGraveAsCost()
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g1=Duel.GetMatchingGroup(s.cfilter1,tp,LOCATION_HAND,0,nil)
	if chk==0 then return not c:IsReason(REASON_REPLACE) and c:IsOnField() and c:IsFaceup()
		and #g1>0 end
	if Duel.SelectEffectYesNo(tp,c,96) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=g1:Select(tp,1,1,nil)
		Duel.SendtoGrave(g,REASON_COST|REASON_REPLACE)
		return true
	else return false end
end
function s.filter2(c,tp)
	return c:GetOwner()==tp and c:IsCode(36623431)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local d2=eg:FilterCount(s.filter2,nil,tp)*1000
	Duel.Damage(1-tp,d2,REASON_EFFECT,true)
	Duel.RDComplete()
end