-- Oriental Entity East

local s, id = GetID()
function s.initial_effect(c)
    -- Fusion Material
    c:EnableReviveLimit()
    Fusion.AddProcMixN(c, true, true, s.matfilter1,1, s.matfilter2,1)
    -- Special Summon effect (Target banished Level 4 or lower)
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id, 0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DELAY + EFFECT_FLAG_CARD_TARGET)
    e1:SetCountLimit(1, id)
    e1:SetTarget(s.sptg)
    e1:SetOperation(s.spop)
    c:RegisterEffect(e1)

    -- Banish and Mill effect
    local e2 = Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id, 1))
    e2:SetCategory(CATEGORY_REMOVE + CATEGORY_DECKDES)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1, id + 1)
    e2:SetTarget(s.rmtg)
    e2:SetOperation(s.rmop)
    c:RegisterEffect(e2)
end

-- Material Filters
function s.matfilter1(c, fc, sumtype, tp)
    return c:IsRace(RACE_YOKAI)
end

function s.matfilter2(c, fc, sumtype, tp)
    return c:IsType(TYPE_SYNCHRO) or c:IsType(TYPE_XYZ)
end

-- E1: Special Summon from banished
function s.spfilter(c, e, tp)
    return c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e, 0, tp, false, false) and c:IsFaceup()
end

function s.sptg(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
    if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and s.spfilter(chkc, e, tp) end
    if chk == 0 then return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
        and Duel.IsExistingTarget(s.spfilter, tp, LOCATION_REMOVED, 0, 1, nil, e, tp) end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
    local g = Duel.SelectTarget(tp, s.spfilter, tp, LOCATION_REMOVED, 0, 1, 1, nil, e, tp)
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, g, 1, 0, 0)
end

function s.spop(e, tp, eg, ep, ev, re, r, rp)
    local tc = Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and Duel.SpecialSummonStep(tc, 0, tp, tp, false, false, POS_FACEUP) then
        -- Negate effects
        local e1 = Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_EVENT + RESETS_STANDARD)
        tc:RegisterEffect(e1)
        local e2 = Effect.CreateEffect(e:GetHandler())
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_DISABLE_EFFECT)
        e2:SetReset(RESET_EVENT + RESETS_STANDARD)
        tc:RegisterEffect(e2)
        Duel.SpecialSummonComplete()
    end
end

-- E2: Banish and Mill
function s.rmtg(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1 - tp) and chkc:IsAbleToRemove() end
    if chk == 0 then return Duel.IsExistingTarget(Card.IsAbleToRemove, tp, 0, LOCATION_GRAVE, 1, nil)
        and Duel.IsPlayerCanDiscardDeck(tp, 1) and Duel.IsPlayerCanDiscardDeck(1 - tp, 1) end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_REMOVE)
    local g = Duel.SelectTarget(tp, Card.IsAbleToRemove, tp, 0, LOCATION_GRAVE, 1, 1, nil)
    Duel.SetOperationInfo(0, CATEGORY_REMOVE, g, 1, 0, 0)
    Duel.SetOperationInfo(0, CATEGORY_DECKDES, nil, 0, PLAYER_ALL, 1)
end

function s.rmop(e, tp, eg, ep, ev, re, r, rp)
    local tc = Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and Duel.Remove(tc, POS_FACEUP, REASON_EFFECT) > 0 then
        Duel.BreakEffect()
        Duel.DiscardDeck(tp, 1, REASON_EFFECT)
        Duel.DiscardDeck(1 - tp, 1, REASON_EFFECT)
    end
end
