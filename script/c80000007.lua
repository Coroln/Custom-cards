--Rubinius,Edelstein der Alchemie
function c80000007.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,80000007+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c80000007.condition)
	e1:SetCost(c80000007.cost)
	e1:SetTarget(c80000007.target)
	e1:SetOperation(c80000007.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(80000007,ACTIVITY_SPSUMMON,c80000007.counterfilter)
end
function c80000007.counterfilter(c)
	return c:IsSetCard(0x19ba)
end
function c80000007.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c80000007.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(80000007,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetLabelObject(e)
	e1:SetTarget(c80000007.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c80000007.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x19ba)
end
function c80000007.filter(c,e,tp)
	return c:IsLevelBelow(4) and c:IsSetCard(0x19ba) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c80000007.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c80000007.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK+LOCATION_HAND)
end
function c80000007.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c80000007.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
