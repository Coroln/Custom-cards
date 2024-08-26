--Morralis, Ober-Ozeanherrscher der Leviatahne
function c80000042.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMixN(c,true,true,c80000042.ffilter,4)
	Fusion.AddContactProc(c,c80000042.contactfil,c80000042.contactop,c80000042.splimit)		
	--destroy all
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(80000042,1))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetTarget(c80000042.destg)
	e4:SetOperation(c80000042.desop)
	c:RegisterEffect(e4)
	--Immune
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(aux.tgoval)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e6:SetValue(c80000042.tgvalue)
	c:RegisterEffect(e6)
	--special summon
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(80000042,2))
	e7:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_BATTLE_DESTROYING)
	e7:SetCondition(aux.bdocon)
	e7:SetTarget(c80000042.sptg)
	e7:SetOperation(c80000042.spop)
	c:RegisterEffect(e7)
	--defense attack
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_DEFENSE_ATTACK)
	e8:SetValue(1)
	c:RegisterEffect(e8)
end
function c80000042.ffilter(c,fc,sumtype,tp)
	return c:IsSetCard(0x1864,fc,sumtype,tp)
end
function c80000042.splimit(e,se,sp,st)
	return (st&SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c80000042.contactfil(tp)
	return Duel.GetReleaseGroup(tp)
end
function c80000042.contactop(g)
	Duel.Release(g,REASON_COST+REASON_MATERIAL)
end
function c80000042.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c80000042.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c80000042.tgvalue(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
function c80000042.spfilter(c,e,tp)
	return c:IsSetCard(0x1864) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c80000042.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c80000042.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c80000042.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c80000042.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end