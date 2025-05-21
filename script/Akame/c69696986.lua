-- 69696986 Incursio (Monster)
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMixN(c,true,true,aux.FilterBoolFunctionEx(Card.IsSetCard,0x69AA),2)
    -- 1. Effect to change battle target and protect itself
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id, 0))
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetCode(EVENT_ATTACK_ANNOUNCE)
    e1:SetCondition(s.condition)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)

    -- 2. Effect to Special Summon this card from the GY
    local e2 = Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id, 1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON + CATEGORY_SEARCH + CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1, id)
    e2:SetCondition(s.spcon)
    e2:SetTarget(s.sptg)
    e2:SetOperation(s.spop)
    c:RegisterEffect(e2)
end

s.listed_series = {0x69AC}
s.listed_names = {id}

-- 1. Effect to change battle target and protect itself
function s.condition(e, tp, eg, ep, ev, re, r, rp)
    return Duel.GetAttacker():IsControler(1 - tp)
end

function s.activate(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    local g = Duel.GetMatchingGroup(aux.FilterBoolFunction(Card.IsFaceup), tp, LOCATION_MZONE, 0, nil)
    if #g > 0 then
        Duel.ChangePosition(g, POS_FACEUP_DEFENSE)
    end
    -- Protect itself from the attack
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(69937550, 0))
    e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_BE_BATTLE_TARGET)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCondition(s.protectcon)
    e1:SetOperation(s.protectop)
    c:RegisterEffect(e1)
end

function s.protectcon(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    local bt = eg:GetFirst()
    return r ~= REASON_REPLACE and c ~= bt and bt:IsFaceup() and bt:GetControler() == c:GetControler()
end

function s.protectop(e, tp, eg, ep, ev, re, r, rp)
    Duel.ChangeAttackTarget(e:GetHandler())
end

-- 2. Effect to Special Summon this card from the GY
function s.cfilter(c, tp)
    return c:IsCode(96969685)
end

function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil)
end

function s.sptg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return true end
    Duel.SetChainLimit(aux.FALSE)
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, e:GetHandler(), 1, 0, 0)
end

function s.spop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.SpecialSummon(c, 0, tp, tp, true, true, POS_FACEUP) ~= 0 then
        c:CompleteProcedure()
    end
end
