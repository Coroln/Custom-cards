--Antike Fee, Joan
function c80000069.initial_effect(c)
	--Special Summon (1)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(80000069,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,80000069)
	e1:SetCondition(c80000069.spcon)
	e1:SetTarget(c80000069.sptg)
	e1:SetOperation(c80000069.spop)
	c:RegisterEffect(e1)
	--effect gain (2)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCondition(c80000069.efcon)
	e2:SetOperation(c80000069.efop)
	c:RegisterEffect(e2)
end
--(1)
function c80000069.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x2c9c) or c:IsCode(25862681) or c:IsCode(4179255)
end
function c80000069.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c80000069.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c80000069.spfilter(c,e,tp)
	return c:IsSetCard(0x2c9c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c80000069.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c80000069.spfilter,tp,LOCATION_HAND,0,1,c,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND)
end
function c80000069.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 or Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c80000069.spfilter,tp,LOCATION_HAND,0,1,1,c,e,tp)
	if g:GetCount()>0 then
		g:AddCard(c)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
--(2)
function c80000069.efcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return r==REASON_SYNCHRO and c:GetReasonCard():IsAttribute(ATTRIBUTE_LIGHT)
end
function c80000069.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local p=rc:GetControler()
	local e1=Effect.CreateEffect(rc)
	e1:SetDescription(aux.Stringid(80000069,1))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(aux.tgoval)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	rc:RegisterEffect(e1,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		rc:RegisterEffect(e2,true)
	end
end
