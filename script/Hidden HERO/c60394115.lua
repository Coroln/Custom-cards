--Hidden HERO Darkest Wingman
--Coroln
local s,id=GetID()
Duel.LoadScript("proc_trick2.lua")
function s.initial_effect(c)
	Trick.AddProcedure(c,nil,nil,{{s.tfilter,1,1}},{{s.tfilter2,1,1}})
	c:EnableReviveLimit()
	--atk gain
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.hcondition)
	e2:SetOperation(s.hoperation)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	e3:SetCondition(s.hcondition2)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--protect
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(38572779,0))
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_CHAINING)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e5:SetHintTiming(0,TIMING_SUMMON+TIMING_SPSUMMON+TIMING_FLIPSUMMON)
	e5:SetCountLimit(1)
	e5:SetCondition(s.condition2)
	e5:SetTarget(s.imtg)
	e5:SetOperation(s.imop)
	c:RegisterEffect(e5)
	--Special Summon 1 Level 4 or lower "HERO" monster from your hand, GY, or Banishment
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,1))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCode(EVENT_DESTROYED)
	e6:SetCountLimit(1,GetID())
	e6:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return r&(REASON_BATTLE|REASON_EFFECT)>0 end)
	e6:SetTarget(s.dmsptg)
	e6:SetOperation(s.dmspop)
	c:RegisterEffect(e6)
end
s.listed_series={0x8}
--Trick Summon
--Monster filter
function s.tfilter(c)
	return c:IsSetCard(0x8) and not c:IsTrick()
end
--Trap filter
function s.tfilter2(c)
	return c:IsTrap()
end
--atk gain
function s.hcondition(e,tp,eg,ep,ev,re,r,rp)
	return eg and eg:IsExists(Card.IsSummonPlayer,1,nil,1-tp)
end
function s.hcondition2(e,tp,eg,ep,ev,re,r,rp)
	return eg and eg:IsExists(Card.IsControler,1,nil,1-tp)
end
function s.filter(c)
	return c:IsSetCard(0x8) and c:IsMonster()
end
function s.hoperation(e,tp)
	Duel.Hint(HINT_CARD,0,id)
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_MZONE,0,nil)
	if #g>0 then
		for sc in aux.Next(g) do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(100)
			sc:RegisterEffect(e1)
		end
	end
end
--protect
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function s.imtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsOnField,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.SelectTarget(tp,Card.IsOnField,tp,LOCATION_ONFIELD,0,1,1,nil)
end
function s.imop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_ONFIELD)
		e1:SetValue(s.efilter2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetOwnerPlayer(tp)
		tc:RegisterEffect(e1)
	end
end
function s.efilter2(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
--Special Summon 1 Level 4 or lower "HERO" monster from your hand, GY, or Banishment
function s.dmspfilter(c,e,tp)
	return c:IsSetCard(0x8) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.dmsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.dmspfilter,tp,LOCATION_HAND|LOCATION_REMOVED|LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND|LOCATION_REMOVED|LOCATION_GRAVE)
end
function s.dmspop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.dmspfilter),tp,LOCATION_HAND|LOCATION_REMOVED|LOCATION_GRAVE,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end