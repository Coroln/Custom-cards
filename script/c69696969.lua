--Kaiserwaffe Black Marlin
local s, id = GetID()

function s.initial_effect(c)
    -- Effekt aktivieren
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id, 0))
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_CHAINING)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1, id)
    e1:SetCondition(s.condition1)
    e1:SetTarget(s.target1)
    e1:SetOperation(s.operation1)
    c:RegisterEffect(e1)
end
s.listed_series={0x69AA}
s.listed_names={id}
function s.condition1(e, tp, eg, ep, ev, re, r, rp)
    return Duel.GetChainInfo(ev, CHAININFO_TRIGGERING_LOCATION) == LOCATION_MZONE
        and Duel.GetChainInfo(ev, CHAININFO_TRIGGERING_CONTROLER) == 1 - tp
end

function s.target1(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
    if chkc then return chkc:IsOnField() and chkc:IsCanBeEffectTarget(ev) end
    if chk == 0 then return Duel.IsExistingTarget(Card.IsOnField, tp, 0, LOCATION_ONFIELD, 1, nil) end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TARGET)
    local g = Duel.SelectTarget(tp, Card.IsOnField, tp, 0, LOCATION_ONFIELD, 1, 1, nil)
    Duel.SetOperationInfo(0, CATEGORY_DESTROY, g, 1, 0, 0)
end

function s.operation1(e, tp, eg, ep, ev, re, r, rp)
    local tg = Duel.GetChainInfo(0, CHAININFO_TARGET_CARDS)
    local etc = tg:Filter(Card.IsRelateToEffect, nil, e)
    if #etc > 0 then
        Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TARGET)
        local g = Duel.SelectMatchingCard(tp, aux.TRUE, tp, LOCATION_ONFIELD, 0, 1, 1, nil)
        if #g > 0 then
            local tc = g:GetFirst()
            local newtg = Duel.GetChainInfo(ev, CHAININFO_TARGET_CARDS)
            newtg:Clear()
            newtg:AddCard(tc)
            Duel.ChangeTargetCard(ev, newtg)
        end
    end
end
