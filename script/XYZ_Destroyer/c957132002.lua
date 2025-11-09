local s,id=GetID()
function s.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_ATKCHANGE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetHintTiming(0,TIMING_END_PHASE)
    e1:SetCountLimit(1,id)
    e1:SetCost(s.cost)
    e1:SetTarget(s.target)
    e1:SetOperation(s.operation)
    c:RegisterEffect(e1)
end

function s.filterXyz(c)
    return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:GetOverlayCount()>0
end

function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then 
        return Duel.IsExistingMatchingCard(s.filterXyz,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVEXYZ)
    local g=Duel.SelectMatchingCard(tp,s.filterXyz,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
    local tc=g:GetFirst()
    if tc then
        local og=tc:GetOverlayGroup()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVEXYZ)
        local sg=og:Select(tp,1,1,nil)
        Duel.SendtoGrave(sg,REASON_COST)
        e:SetLabelObject(tc)
    end
end

function s.spfilter(c,e,tp)
    return c:IsMonster() and c:IsSetCard(0xCCC) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then 
        return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
            and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end

function s.operation(e,tp,eg,ep,ev,re,r,rp)
    local xyzMonster = e:GetLabelObject()
    if not (xyzMonster) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g = Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    local spMon = g:GetFirst()
    if spMon then
        Duel.SpecialSummon(spMon,0,tp,tp,false,false,POS_FACEUP)
    end

    local op = Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))
    local atkChange = (op==0) and 500 or -500
    local e1 = Effect.CreateEffect(e:GetHandler())

    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(atkChange)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD)
    xyzMonster:RegisterEffect(e1)
end
