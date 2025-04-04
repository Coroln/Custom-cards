--Deity of the Aztecs (Tepeyollotl)
--Script by Coroln
local s,id=GetID()
function s.initial_effect(c)
	--synchro summon
	Synchro.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsRace,RACE_ROCK),1,1,Synchro.NonTunerEx(Card.IsRace,RACE_ROCK),1,99)
	c:EnableReviveLimit()
	--Double damage
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_CHANGE_DAMAGE)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e0:SetRange(LOCATION_MZONE)
	e0:SetTargetRange(0,1)
	e0:SetCondition(s.dcon)
	e0:SetValue(s.damop)
	c:RegisterEffect(e0)
    --Special Summon 1 Level 4 or lower OR Level 4 or higher Rock-Type monster from your GY
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER|TIMING_MAIN_END)
	e1:SetCountLimit(1,id)
	e1:SetCondition(function() return Duel.IsMainPhase() end)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
end
s.listed_series={0x39F}
s.listed_names={id,31812496}
--Double damage
function s.dcon(e)
	return Duel.GetAttackTarget()==e:GetHandler()
end
function s.damop(e,re,val,r,rp)
	return val*3
end
--Special Summon 1 Level 4 or lower OR Level 4 or higher Rock-Type monster from your GY
function s.spfilter(c,e,tp,ex)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsRace(RACE_ROCK) and (c:IsLevelBelow(4) or (ex and (c:IsLevelAbove(4))))
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ex=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and s.spfilter(chkc,e,tp,ex) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,ex) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,s.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,ex)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end