--Voyager XJ-03T
--Script by Coroln
local s,id=GetID()
function s.initial_effect(c)
	--Union procedure
	aux.AddUnionProcedure(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.spcon)
	c:RegisterEffect(e1)
	--equip another Voyager Union+optional Galaxy summon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,0))
    e2:SetCategory(CATEGORY_EQUIP+CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCountLimit(1,id)
    e2:SetCondition(aux.IsUnionState)
    e2:SetTarget(s.eqtg)
    e2:SetOperation(s.eqop)
    c:RegisterEffect(e2)
end
s.listed_names={id}
s.listed_series={0x943}
--special summon
function s.spfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_GALAXY)
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_MZONE,0,1,nil)
end
--equip another Voyager Union+optional Galaxy summon
function s.voyagerfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x943) and c:IsMonster()
end
function s.eqfilter(c)
    return c:IsSetCard(0x943) and c:IsType(TYPE_UNION) and c:IsMonster() and not c:IsForbidden()
end
function s.galaxyfilter(c,e,tp)
    return c:IsRace(RACE_GALAXY) and not c:IsCode(id) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        return Duel.IsExistingTarget(s.voyagerfilter,tp,LOCATION_MZONE,0,1,nil)
            and Duel.IsExistingMatchingCard(s.eqfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil)
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    Duel.SelectTarget(tp,s.voyagerfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if not tc or not tc:IsRelateToEffect(e) or not tc:IsFaceup() then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    local eqc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.eqfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil):GetFirst()
    if not eqc then return end
    if Duel.Equip(tp,eqc,tc) then
        aux.SetUnionState(eqc)
        if tc:IsType(TYPE_LINK) and Duel.IsExistingMatchingCard(s.galaxyfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) then
            if Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
                local sg=Duel.SelectMatchingCard(tp,s.galaxyfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
                if #sg>0 then
                    Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
                end
            end
        end
    end
end