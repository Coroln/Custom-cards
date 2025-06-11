--Hypercosmic Pathfinder (EdoPro)
local s,id=GetID()
function s.initial_effect(c)
    --pendulum summon
    Pendulum.AddProcedure(c)
    -- Ignition effect to choose monster name
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCountLimit(1,id)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetTarget(s.revealtg)
    e1:SetOperation(s.revealop)
    c:RegisterEffect(e1)

    -- Pendulum Summon restriction
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetRange(LOCATION_PZONE)
    e2:SetTargetRange(1,0)
    e2:SetTarget(s.splimit)
    c:RegisterEffect(e2)
end
-- Filter for monsters in hand
function s.revealfilter(c)
    return c:IsMonster()
end
-- Target 1 monster to reveal
function s.revealtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.revealfilter,tp,LOCATION_HAND,0,1,nil) end
end
-- Operation: reveal monster and store its code
function s.revealop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
    local g=Duel.SelectMatchingCard(tp,s.revealfilter,tp,LOCATION_HAND,0,1,1,nil)
    if #g>0 then
        local code=g:GetFirst():GetOriginalCode()
        Duel.ConfirmCards(1-tp,g)
        Duel.ShuffleHand(tp)
        -- Save the code as a flag effect with a label
        Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
        Duel.SetFlagEffectLabel(tp,id,code)
    end
end
-- Pendulum Summon restriction logic
function s.splimit(e,c,tp,sumtype,sumpos,targetp,se)
    if (sumtype & SUMMON_TYPE_PENDULUM) ~= SUMMON_TYPE_PENDULUM then return false end
    -- If ignition effect was not activated this turn
    if Duel.GetFlagEffect(tp,id)==0 then return true end
    local allowed_code = Duel.GetFlagEffectLabel(tp,id)
    return c:GetOriginalCode() ~= allowed_code
end