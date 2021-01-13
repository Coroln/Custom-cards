--unseal
function c100000876.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCountLimit(1,100000876+EFFECT_COUNT_CODE_OATH)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetTarget(c100000876.target)
	e1:SetOperation(c100000876.activate)
	e1:SetCondition(c100000876.condition2)
	c:RegisterEffect(e1)
end
function c100000876.filter(c,e,tp)
	return  c:IsCode(100000868) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c100000876.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c100000876.filter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_REMOVED)
end
function c100000876.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c100000876.filter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 then end
	Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
end
function c100000876.spfilter1(c)
	return (c:IsSetCard(0x753) and c:IsType(TYPE_MONSTER) and c:IsFaceup())
end
function c100000876.spfilter2(c)
	return c:IsCode(100000868) and c:IsFaceup()
end
function c100000876.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c100000876.spfilter1,tp,LOCATION_REMOVED,0,6,nil)
		and Duel.IsExistingMatchingCard(c100000876.spfilter2,tp,LOCATION_REMOVED,0,1,nil)
end