--sccripted and created by rising phoenix
function c100001187.initial_effect(c)
		--Activate
	local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(100001187,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c100001187.target)
	e1:SetOperation(c100001187.activate)
		e1:SetCost(c100001187.descon)
	c:RegisterEffect(e1)
		--Activate
	local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(100001187,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(c100001187.target2)
	e2:SetOperation(c100001187.activate2)
		e2:SetCost(c100001187.descon)
	c:RegisterEffect(e2)
end
function c100001187.filter(c,e,tp)
	return c:IsCode(74875003) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100001187.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_DECK+LOCATION_HAND) and c100001187.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c100001187.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c100001187.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c100001187.activate2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
	end
end
function c100001187.coffilter(c)
	return  (c:IsCode(100001186) or  c:IsCode(100001185) or  c:IsCode(100001183) or c:IsCode(10000040) or c:IsCode(10000020) or c:IsCode(10000000) or c:IsCode(10000010) or c:IsCode(10000090) or c:IsCode(10000080)) and not c:IsPublic()
end
function c100001187.descon(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.IsExistingMatchingCard(c100001187.coffilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c100001187.coffilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c100001187.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
	 and Duel.GetLocationCount(tp,LOCATION_MZONE)>2 and Duel.IsPlayerCanSpecialSummonMonster(tp,100001188,0,0x4011,1500,1500,4,RACE_SPELLCASTER,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,3,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,3,0,0)
end
function c100001187.activate(e,tp,eg,ep,ev,re,r,rp)
if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>2 and Duel.IsPlayerCanSpecialSummonMonster(tp,100001188,0,0x4011,1500,1500,4,RACE_SPELLCASTER,ATTRIBUTE_LIGHT) then
	for i=1,3 do
	local token=Duel.CreateToken(tp,100001188)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UNRELEASABLE_SUM)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(c100001187.recon)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			token:RegisterEffect(e1,true)
		end
			Duel.SpecialSummonComplete()
end
end
function c100001187.recon(e,c)
	return not (c:IsCode(100001185) or c:IsCode(100001186) or c:IsCode(100001183))
end
