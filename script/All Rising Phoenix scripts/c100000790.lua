function c100000790.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c100000790.spcon)
	e1:SetTarget(c100000790.target)
	e1:SetOperation(c100000790.activate)
	c:RegisterEffect(e1)
end
function c100000790.cfilter(c)
	return c:IsSetCard(0x754) and c:IsAbleToDeckAsCost() and c:IsCode(100000793)
end
function c100000790.cfilter2(c)
	return c:IsSetCard(0x754) and c:IsAbleToDeckAsCost() and c:IsCode(100000794)
end
function c100000790.cfilter3(c)
	return c:IsSetCard(0x754) and c:IsAbleToDeckAsCost() and c:IsCode(100000799)
end
function c100000790.spcon(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100000790.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_ONFIELD,0,1,nil) 
	and Duel.IsExistingMatchingCard(c100000790.cfilter2,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_ONFIELD,0,1,nil)
	and Duel.IsExistingMatchingCard(c100000790.cfilter3,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_ONFIELD,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c100000790.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_ONFIELD,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectMatchingCard(tp,c100000790.cfilter2,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_ONFIELD,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g2=Duel.SelectMatchingCard(tp,c100000790.cfilter3,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_ONFIELD,0,1,1,nil)
		g:Merge(g1)
	g:Merge(g2)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c100000790.filter(c,e,tp)
	return  c:IsCode(100000789) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) 
end
function c100000790.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c100000790.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_EXTRA)
end
function c100000790.activate(e,tp,eg,ep,ev,re,r,rp)
	if  Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c100000790.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then end
	Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
end