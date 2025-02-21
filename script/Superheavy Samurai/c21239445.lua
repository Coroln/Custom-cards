--Superheavy Samurai Giant Daidarabotchi
--Script by Coroln
local s,id=GetID()
function s.initial_effect(c)
    c:EnableReviveLimit()
	--Synchro Summon procedure
	Synchro.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsRace,RACE_MACHINE),1,1,Synchro.NonTuner(nil),1,99)
    --spsummon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCountLimit(1,id)
    e1:SetCondition(s.hspcon)
    e1:SetTarget(s.sptg)
    e1:SetOperation(s.spop)
    c:RegisterEffect(e1)
    --special summon (from PZONE)
	local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,{id,1})
	e2:SetCost(s.pspcost)
	e2:SetTarget(s.psptg)
	e2:SetOperation(s.pspop)
	c:RegisterEffect(e2)
    --defense attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DEFENSE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(s.atktg)
	e3:SetValue(1)
	c:RegisterEffect(e3)
    --negate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetCountLimit(1,id)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetRange(LOCATION_MZONE)
    e4:SetCost(s.discost)
	e4:SetCondition(s.discon)
	e4:SetTarget(s.distg)
	e4:SetOperation(s.disop)
	c:RegisterEffect(e4)
end
s.listed_series={0x9A}
--spsummon
function s.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function s.hspcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_GRAVE,0,1,nil)
end
function s.spfilter(c,e,tp)
    return c:IsSetCard(0x9A) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    if #g>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end
--special summon (from PZONE)
function s.pspfilter(c)
    return c:IsRace(RACE_MACHINE)
end
function s.pspcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupCost(tp,s.pspfilter,2,false,aux.ReleaseCheckMMZ,nil) end
	local g=Duel.SelectReleaseGroupCost(tp,s.pspfilter,2,2,false,aux.ReleaseCheckMMZ,nil)
	Duel.Release(g,REASON_COST)
end
function s.psptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.pspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
--defense attack
function s.atktg(e,c)
	return c:IsSetCard(0x9a)
end
--negate
function s.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckPendulumZones(tp) end
	if not Duel.CheckPendulumZones(tp) then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
    end
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
    if c==nil then return true end
	local tp=c:GetControler()
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and not Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_GRAVE,0,1,nil)
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end