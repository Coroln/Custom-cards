--万華鏡－華麗なる分身－
function c38583598.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c38583598.condition)
	e1:SetTarget(c38583598.target)
	e1:SetOperation(c38583598.activate)
	c:RegisterEffect(e1)
end
function c38583598.cfilter(c)
	return c:IsFaceup() and c:IsCode(48202661) or c:IsCode(60246171) or c:IsCode(69456283) or c:IsCode(57062206)
end
function c38583598.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c38583598.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
function c38583598.filter(c,e,tp)
	return c:IsCode(48202661) or c:IsCode(60246171) or c:IsCode(69456283) or c:IsCode(57062206,38583593,38583594,38583595) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c38583598.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c38583598.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c38583598.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c38583598.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)~=0 then
		tc:CompleteProcedure()
	end
end
