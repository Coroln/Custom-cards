--Kaiserwaffensaal
local s, id = GetID()

function s.initial_effect(c)
    -- Activate
    local e1 = Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND + CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_FZONE)
    e1:SetTarget(s.target)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)

    -- Todeck
    local e2 = Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id, 2))
    e2:SetCategory(CATEGORY_TOHAND + CATEGORY_SEARCH)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_FZONE)
    e2:SetCondition(aux.bdocon)
    e2:SetCost(s.cost)
    e2:SetTarget(s.tg)
    e2:SetOperation(s.op)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    c:RegisterEffect(e2)

    -- Send to Deck when banished
    local e3 = Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
    e3:SetValue(LOCATION_DECK)
    e3:SetCondition(s.banishCondition)
    c:RegisterEffect(e3)
end

s.listed_series = {0x69AA}
s.listed_names = {id}

function s.banishCondition(e, tp, eg, ep, ev, re, r, rp)
    return e:GetHandler():IsFaceup() and e:GetHandler():IsLocation(LOCATION_ONFIELD)
        and bit.band(e:GetHandler():GetReason(), REASON_BATTLE + REASON_EFFECT) ~= 0
end
function s.filter(c)
    return c:IsSetCard(0x69AA) and c:IsMonster() and c:IsAbleToHand() and c:IsLevelBelow(s.filter1(c))
end

function s.cfilter(c)
    return c:IsAbleToRemoveAsCost() and aux.SpElimFilter(c, true)
end

function s.cost(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return Duel.IsExistingMatchingCard(s.cfilter, tp, LOCATION_GRAVE, 0, 1, nil) end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_REMOVE)
    local g = Duel.SelectMatchingCard(tp, s.cfilter, tp, LOCATION_GRAVE, 0, 1, 1, nil)
    Duel.Remove(g, POS_FACEUP, REASON_COST)
end

function s.tg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return Duel.IsExistingMatchingCard(s.filter, tp, LOCATION_REMOVED, 0, 1, nil) end
    Duel.SetOperationInfo(0, CATEGORY_TOHDECK, nil, 1, tp, LOCATION_REMOVED)
end

function s.op(e, tp, eg, ep, ev, re, r, rp)
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOEDECK)
    local g = Duel.SelectMatchingCard(tp, s.filter, tp, LOCATION_REMOVED, 0, 1, 1, nil)
    if #g > 0 then
        Duel.SendtoDeck(g, nil, SEQ_DECKSHUFFLE, REASON_EFFECT)
        Duel.ConfirmCards(1 - tp, g)
    end
end

function s.filter1(c)
    -- Define a lambda function to get the level of the targeted monster (c)
    local getTargetLevel = function(tc) return tc:GetLevel() end
    return getTargetLevel
end

function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return Duel.IsExistingMatchingCard(s.filter, tp, LOCATION_DECK, 0, 1, nil) end
    Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_DECK)
end

function s.activate(e, tp, eg, ep, ev, re, r, rp)
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
    local g = Duel.SelectMatchingCard(tp, s.filter, tp, LOCATION_DECK, 0, 1, 1, nil)
    if #g > 0 then
        Duel.SendtoHand(g, nil, REASON_EFFECT)
        Duel.ConfirmCards(1 - tp, g)
    end
end