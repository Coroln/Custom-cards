function c100000738.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e1:SetCost(c100000738.spcost1)
	e1:SetTarget(c100000738.target)
	e1:SetOperation(c100000738.activate)
	c:RegisterEffect(e1)
	end
	function c100000738.spfilter(c,att)
	return c:IsCode(100000808) and c:IsAbleToRemoveAsCost()
end
	function c100000738.spfilter1(c,att)
	return c:IsCode(100000809) and c:IsAbleToRemoveAsCost()
end
function c100000738.spcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100000738.spfilter1,tp,LOCATION_GRAVE,0,1,nil,nil)
		and Duel.IsExistingMatchingCard(c100000738.spfilter,tp,LOCATION_GRAVE,0,1,nil,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,c100000738.spfilter1,tp,LOCATION_GRAVE,0,1,1,nil,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectMatchingCard(tp,c100000738.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,nil)
	g1:Merge(g2)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end
function c100000738.filter(c,e,tp)
	return c:IsSetCard(0x767) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not (c:IsCode(100000808) or c:IsCode(100000809) or c:IsType(TYPE_SYNCHRO))
end
function c100000738.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingMatchingCard(c100000738.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,2,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c100000738.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	local g=Duel.GetMatchingGroup(c100000738.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
	if g:GetCount()>=2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,2,2,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
