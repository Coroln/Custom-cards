--Voyager Attack Squad T101
--Script by Coroln
local s,id=GetID()
function s.initial_effect(c)
    --Effect on Normal or Special Summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetCountLimit(1,id)
    e1:SetTarget(s.tg)
    e1:SetOperation(s.op)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e2)
    --Effect when used as material for Voyager Link Summon
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,1))
    e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_BE_MATERIAL)
    e3:SetCountLimit(1,{id,1})
    e3:SetCondition(s.linkcon)
    e3:SetOperation(s.linkop)
    c:RegisterEffect(e3)
end
s.listed_names={id}
s.listed_sersies={0x943}
-- Check if card is a Union equipped to something
function s.is_equipped_union(c,tp)
    return c:IsType(TYPE_UNION) and c:IsLocation(LOCATION_SZONE) and c:GetEquipTarget() and c:IsControler(tp)
end
-- Targeting for summon effect
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() end
    if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if not tc or not tc:IsRelateToEffect(e) then return end
    if s.is_equipped_union(tc,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
        if Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
            Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
            return
        end
    end
    Duel.Destroy(tc,REASON_EFFECT)
end
-- Check Link Summon condition for Voyager
function s.linkcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return r==REASON_LINK and c:GetReasonCard():IsSetCard(0x943) and c:GetReasonCard():IsType(TYPE_LINK)
end
function s.linkop(e,tp,eg,ep,ev,re,r,rp)
    -- Boost all Link monsters you control
    local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE,0,nil,TYPE_LINK)
    if #g>0 then
        local tc=g:GetFirst()
        while tc do
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_UPDATE_ATTACK)
            e1:SetValue(800)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
            tc:RegisterEffect(e1)
            tc=g:GetNext()
        end
    end
    -- Optionally destroy an opponent's monster
    local dg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
    if #dg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
        local sg=dg:Select(tp,1,1,nil)
        Duel.Destroy(sg,REASON_EFFECT)
    end
end
