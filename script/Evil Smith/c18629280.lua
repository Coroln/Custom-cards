--Evil Smith Master Kayenn
--Script by Coroln
Duel.LoadScript("proc_trick2.lua")
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
    --Trick matlimit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_CANNOT_BE_MATERIAL)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(aux.cannotmatfilter(SUMMON_TYPE_FUSION,SUMMON_TYPE_SYNCHRO,SUMMON_TYPE_XYZ,SUMMON_TYPE_LINK,SUMMON_TYPE_TRICK))
	c:RegisterEffect(e0)
	--Special Summon condition
	local e0a=Effect.CreateEffect(c)
	e0a:SetType(EFFECT_TYPE_SINGLE)
	e0a:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0a:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0a:SetValue(aux.FALSE)
	c:RegisterEffect(e0a)
    --cannot release
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UNRELEASABLE_SUM)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e2)
    --Must be Special Summoned
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(s.selfspcon)
	e3:SetTarget(s.selfsptg)
	e3:SetOperation(s.selfspop)
	c:RegisterEffect(e3)
    --Special Summon 1 "Evil Smith" monster
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,3))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetHintTiming(0,TIMING_END_PHASE)
	e4:SetCountLimit(1,id)
	e4:SetTarget(s.sptg)
	e4:SetOperation(s.spop)
	c:RegisterEffect(e4)
    --Discard
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,4))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCountLimit(1,{id,1})
	e5:SetOperation(s.dcop)
	c:RegisterEffect(e5)
    --Destroy
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,5))
	e6:SetCategory(CATEGORY_DESTROY)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e6:SetCountLimit(1,{id,2})
    e6:SetCondition(s.con)
	e6:SetTarget(s.destg)
	e6:SetOperation(s.desop)
	c:RegisterEffect(e6)
end
s.listed_series={0x467}
s.listed_names={id,7581560}
--Must be Special Summoned
function s.selfspconfilter(c)
	return c:IsSetCard(0x467) and c:IsPreviousLocation(LOCATION_GRAVE) and c:IsSummonType(SUMMON_TYPE_SPECIAL) and c:IsFaceup() and c:IsAbleToRemoveAsCost()
end
function s.selfspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(s.selfspconfilter,tp,LOCATION_MZONE,0,nil)
	return #g>0 and Duel.GetMZoneCount(tp,g)>0
end
function s.selfsptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local rg=Duel.GetMatchingGroup(s.selfspconfilter,tp,LOCATION_MZONE,0,nil)
	local g=aux.SelectUnselectGroup(rg,e,tp,1,1,aux.ChkfMMZ(1),1,tp,HINTMSG_REMOVE,nil,nil,true)
	if #g>0 then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	end
	return false
end
function s.selfspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	if not g then return end
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	g:DeleteGroup()
end
--Special Summon 1 "Evil Smith" monster
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x467) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,s.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
	local b2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
	local op=0
	Duel.Hint(HINT_SELECTMSG,tp,0)
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(id,1))
	elseif b2 then
		op=Duel.SelectOption(tp,aux.Stringid(id,2))+1
	else return end
	if op==0 then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	else
		Duel.SpecialSummon(tc,0,tp,1-tp,false,false,POS_FACEUP)
	end
end
--Discard
function s.dcfilter(c)
    return c:IsMonster() and c:IsDiscardable(d)
end
function s.dcop(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
		g:RemoveCard(e:GetHandler())
		return #g>0 and g:FilterCount(s.dcfilter,nil)==#g
	end
	local g=Duel.GetMatchingGroup(s.dcfilter,tp,LOCATION_HAND,0,nil)
	Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
	e:SetLabel(#g)
end
--Destroy
function s.envfilter(c)
	return c:IsCode(7581560)
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.envfilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,1,nil)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetCards(e)
	if #g>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
