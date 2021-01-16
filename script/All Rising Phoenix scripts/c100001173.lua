--Created and scripted by Rising Phoenix
local s,id=GetID()
function s.initial_effect(c)
	--control
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_CHANGE_CONTROL)
	c:RegisterEffect(e1)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(s.splimit)
	c:RegisterEffect(e2)
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
	--special summon
	local e21=Effect.CreateEffect(c)
	e21:SetDescription(aux.Stringid(id,0))
	e21:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e21:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e21:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e21:SetCode(EVENT_SUMMON_SUCCESS)
	e21:SetTarget(s.sptg)
	e21:SetOperation(s.spop)
	c:RegisterEffect(e21)
end
function s.splimit(e,c)
	return not (c:IsSetCard(0x75A) or c:IsCode(100001193))
end
function s.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,true,false) and c:IsType(TYPE_MONSTER)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end
function s.splimit2(e,c,sump,sumtype,sumpos,targetp)
	return c:IsLocation(LOCATION_HAND) or c:IsLocation(LOCATION_DECK) or c:IsLocation(LOCATION_GRAVE)
end

