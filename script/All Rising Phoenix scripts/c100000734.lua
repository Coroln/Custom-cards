--Created and scripted by Rising Phoenix
function c100000734.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(100000734,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)	
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,100000734)
	e1:SetTarget(c100000734.sptg)
	e1:SetOperation(c100000734.spop)
	c:RegisterEffect(e1)
		--Activate
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_ACTIVATE)
	e11:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e11)
end
function c100000734.spfilter(c,e,tp)
	return c:IsSetCard(0x75A) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c100000734.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c100000734.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c100000734.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c100000734.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end