function c100000787.initial_effect(c)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(100000787,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetTarget(c100000787.sptg)
	e4:SetOperation(c100000787.spop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e6)
end
function c100000787.filter(c,e,tp)
	return c:IsSetCard(0x754)  and c:IsType(TYPE_NORMAL) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100000787.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE) and chkc:IsControler(tp) and c100000787.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c100000787.filter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c100000787.filter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c100000787.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then end
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
end	