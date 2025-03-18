--Rank-Up-Magic Stellar Force
--Script by Coroln
local s,id=GetID()
function s.initial_effect(c)
    --Rank-Up Xyz Summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(s.target)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)
end
--Rank-Up Xyz Summon
function s.filter1(c,e,tp)
    return c:IsFaceup() and c:IsType(TYPE_XYZ)
        and Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c)
end
function s.filter2(c,e,tp,mc)
    local rk=mc:GetRank()
    return c:IsType(TYPE_XYZ) and c:IsAttribute(mc:GetAttribute()) and c:GetRank()<=rk+2
        and c:GetRank()>rk
        and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
        and mc:IsCanBeXyzMaterial(c)
        and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingTarget(s.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    Duel.SelectTarget(tp,s.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if not tc or not tc:IsRelateToEffect(e) or tc:IsFacedown() or not tc:IsControler(tp) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc)
    local sc=g:GetFirst()
    if sc then
        local mg=tc:GetOverlayGroup()
        if #mg>0 then
            Duel.Overlay(sc,mg)
        end
        sc:SetMaterial(Group.FromCards(tc))
        Duel.Overlay(sc,Group.FromCards(tc))
        Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
        sc:CompleteProcedure()
    end
end
