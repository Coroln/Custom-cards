--Heilige Ruine der Ozeanherrscher
function c80000035.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Atk/def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsAttribute,ATTRIBUTE_WATER))
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetValue(400)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(80000035,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1)
	e3:SetCondition(c80000035.condition)
	e3:SetTarget(c80000035.target)
	e3:SetOperation(c80000035.operation)
	c:RegisterEffect(e3)
end
function c80000035.condition(e,tp,eg,ep,ev,re,r,rp)
	local lv=0
	local tc=eg:GetFirst()
	while tc do
		if tc:IsReason(REASON_DESTROY) and tc:IsSetCard(0x1864) and not tc:IsPreviousLocation(LOCATION_SZONE) then
			local tlv=tc:GetLevel()
			if tlv>lv then lv=tlv end
		end
		tc=eg:GetNext()
	end
	if lv>0 then e:SetLabel(lv) end
	return lv>0
end
function c80000035.spfilter(c,e,tp,lv)
	return c:IsLevelBelow(lv) and c:IsSetCard(0x1864) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c80000035.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) and not e:GetHandler():IsStatus(STATUS_CHAINING)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c80000035.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,e:GetLabel()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c80000035.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c80000035.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,e:GetLabel())
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
