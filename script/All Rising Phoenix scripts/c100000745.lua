 --Created and coded by Rising Phoenix
function c100000745.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c100000745.target)
	e1:SetOperation(c100000745.activate)
	c:RegisterEffect(e1)
end
function c100000745.spfilter(c,code,lv,e,tp)
	return c:GetLevel()==lv and c:IsSetCard(0x754) and not c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c100000745.filter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x754)  and c:IsAbleToDeck()
		and Duel.IsExistingMatchingCard(c100000745.spfilter,tp,LOCATION_EXTRA+LOCATION_DECK,0,1,nil,c:GetCode(),c:GetOriginalLevel(),e,tp)
end
function c100000745.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c100000745.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingTarget(c100000745.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c100000745.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_DECK)
end
function c100000745.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local code=tc:GetCode()
	local lv=tc:GetOriginalLevel()
	if Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c100000745.spfilter,tp,LOCATION_EXTRA+LOCATION_DECK,0,1,1,nil,code,lv,e,tp)
	if g:GetCount()>0 then
		Duel.BreakEffect()
		local tc=g:GetFirst()
	if tc then end
		Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
