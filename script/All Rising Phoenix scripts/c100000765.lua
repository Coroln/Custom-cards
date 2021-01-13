--Created and scripted by Rising Phoenix
function c100000765.initial_effect(c)
c:EnableUnsummonable()
	--control
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e10:SetRange(LOCATION_MZONE)
	e10:SetCode(EFFECT_CANNOT_CHANGE_CONTROL)
	c:RegisterEffect(e10)
		--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c100000765.splimit)
	c:RegisterEffect(e2)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100000765,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_F)
	e1:SetRange(LOCATION_DECK)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c100000765.spcon)
	e1:SetTarget(c100000765.sptg)
	e1:SetOperation(c100000765.spop)
	e1:SetCountLimit(1,100000765)
	c:RegisterEffect(e1)
		--cannot release
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_FIELD)
	e12:SetRange(LOCATION_MZONE)
	e12:SetCode(EFFECT_CANNOT_RELEASE)
	e12:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e12:SetTargetRange(1,0)
	c:RegisterEffect(e12)
		--cannot special summon
	local e11=Effect.CreateEffect(c)
	e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_SPSUMMON_CONDITION)
	e11:SetValue(aux.FALSE)
	c:RegisterEffect(e11)
end
function c100000765.splimit(e,c)
	return not (c:IsSetCard(0x75A) or c:IsCode(100001193))
end
function c100000765.spcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsType(TYPE_TRAP)
end
function c100000765.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c100000765.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		and c:IsCanBeSpecialSummoned(e,0,tp,true,false) then
		Duel.SendtoGrave(c,REASON_RULE)
	end
end
