local s, id = GetID()
function s.initial_effect(c)
    c:EnableReviveLimit()
    Link.AddProcedure(c,nil,2,nil,s.procFilter)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCost(s.spcost)
    e1:SetTarget(s.sptarget)
    e1:SetOperation(s.spop)
    c:RegisterEffect(e1)

    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,{id,1},EFFECT_COUNT_CODE_OATH)
    e2:SetTarget(s.switchtg)
    e2:SetOperation(s.optg)
    c:RegisterEffect(e2)
end

function s.procFilter(g,lc,sumtype,tp)
    return g:CheckDifferentPropertyBinary(Card.GetAttribute,lc,sumtype,tp) and g:CheckSameProperty(Card.GetRace,lc,sumtype,tp)
end

--e1

function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.CheckReleaseGroupCost(tp,s.spcostfilter,1,false,nil,nil,e,tp)
	end
	local g=Duel.SelectReleaseGroupCost(tp,s.spcostfilter,1,1,false,nil,nil,e,tp)
	Duel.Release(g,REASON_COST)
	e:SetLabelObject(g:GetFirst())
end
function s.spcostfilter(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_NORMAL) and c:HasLevel() and c:GetOriginalLevel()<=6 and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,c,e,tp)
end
function s.spfilter(c,tc,e,tp)
	return c:GetOriginalLevel()==tc:GetOriginalLevel()
		and c:GetOriginalRace()==tc:GetOriginalRace()
		and c:GetOriginalAttribute()~=tc:GetOriginalAttribute()
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
	local tc=e:GetLabelObject()
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if not tc then return end

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,tc,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

--e2


function s.switchtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chkc then return chkc:IsControler(tp) and chkc:IsFaceup() and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingMatchingCard(s.switchfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,s.switchfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function s.switchfilter(c)
	return c:IsFaceup() and c:HasDefense()
end
function s.optg(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
    local e1=Effect.CreateEffect(tc)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SWAP_BASE_AD)
    e1:SetReset(RESETS_STANDARD_PHASE_END)
    if tc:RegisterEffect(e1) ~= nil then
        local atk = tc:GetBaseAttack()
        local def = tc:GetBaseDefense()
        local dif = math.abs(atk-def)
        Duel.Recover(tp,dif,REASON_EFFECT)
    end
end
