local s, id = GetID()
Duel.LoadScript("proc_trick2.lua")
function s.initial_effect(c)
    Trick.AddProcedure(c,nil,nil,{{s.tfilter,1,1}},{{s.tfilter2,1,1}})
    -- Quick Effect: Discard to Copy
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id, 2))
    e1:SetCategory(CATEGORY_LVCHANGE)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetCost(s.copycost)
    e1:SetTarget(s.copytg)
    e1:SetOperation(s.copyop)
    c:RegisterEffect(e1)
end
--Trick Summon
--Monster filter
function s.tfilter(c)
	return c:IsLevelAbove(5)
end
--Trap filter
function s.tfilter2(c)
	return c:IsTrap()
end
-- Cost: Discard 1 Monster
function s.costfilter(c)
    return c:IsMonster() and c:IsDiscardable()
end

function s.copycost(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return Duel.IsExistingMatchingCard(s.costfilter, tp, LOCATION_HAND, 0, 1, nil) end
    Duel.DiscardHand(tp, s.costfilter, 1, 1, REASON_COST + REASON_DISCARD)
    local tc = Duel.GetOperatedGroup():GetFirst()
    e:SetLabelObject(tc) -- Speichere die abgeworfene Karte temporär
end

function s.copytg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return true end
end

function s.copyop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    local tc = e:GetLabelObject()
    if not c:IsRelateToEffect(e) or c:IsFacedown() then return end

    -- 1. Change Level, Type, Attribute
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetCode(EFFECT_CHANGE_LEVEL)
    e1:SetValue(tc:GetOriginalLevel())
    e1:SetReset(RESET_EVENT + RESETS_STANDARD + RESET_PHASE + PHASE_END)
    c:RegisterEffect(e1)

    local e2 = e1:Clone()
    e2:SetCode(EFFECT_CHANGE_RACE)
    e2:SetValue(tc:GetOriginalRace())
    c:RegisterEffect(e2)

    local e3 = e1:Clone()
    e3:SetCode(EFFECT_CHANGE_ATTRIBUTE)
    e3:SetValue(tc:GetOriginalAttribute())
    c:RegisterEffect(e3)

    -- 2. Change Name
    local e4 = e1:Clone()
    e4:SetCode(EFFECT_CHANGE_CODE)
    e4:SetValue(tc:GetOriginalCode())
    c:RegisterEffect(e4)

    -- 3. Gain Original Effects
    c:CopyEffect(tc:GetOriginalCode(), RESET_EVENT + RESETS_STANDARD + RESET_PHASE + PHASE_END, 1)

    -- 4. Draw if destroys by battle
    local e5 = Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(id, 3))
    e5:SetCategory(CATEGORY_DRAW)
    e5:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_F)
    e5:SetCode(EVENT_BATTLE_DESTROYING)
    e5:SetCondition(aux.bdogcon)
    e5:SetTarget(s.drawtg)
    e5:SetOperation(s.drawop)
    e5:SetReset(RESET_EVENT + RESETS_STANDARD + RESET_PHASE + PHASE_END)
    c:RegisterEffect(e5)
end

-- Draw Helper Functions
function s.drawtg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return true end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1)
    Duel.SetOperationInfo(0, CATEGORY_DRAW, nil, 0, tp, 1)
end

function s.drawop(e, tp, eg, ep, ev, re, r, rp)
    local p, d = Duel.GetChainInfo(0, CHAININFO_TARGET_PLAYER, CHAININFO_TARGET_PARAM)
    Duel.Draw(p, d, REASON_EFFECT)
end
