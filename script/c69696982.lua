--69696982 Kaiserwaffe Susanoo
local s, id = GetID()
function s.initial_effect(c)
    --atk
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetValue(s.atkval)
    c:RegisterEffect(e1)
    --material
    local e2 = Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetTarget(s.target)
    e2:SetOperation(s.operation)
    c:RegisterEffect(e2)
    --special summon
    local e3 = Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id, 0))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_O)
    e3:SetRange(LOCATION_GRAVE)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetCondition(s.spcon)
    e3:SetTarget(s.sptg)
    e3:SetOperation(s.spop)
    c:RegisterEffect(e3)
    --equip
    local e4 = Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(id, 0))
    e4:SetCategory(CATEGORY_EQUIP)
    e4:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
    e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e4:SetCode(EVENT_SPSUMMON_SUCCESS)
    e4:SetCondition(s.mcondition)
    e4:SetTarget(s.mtarget)
    e4:SetOperation(s.moperation)
    c:RegisterEffect(e4)
end

s.listed_series = {0x69AA}
s.listed_names = {id}

function s.atkval(e, c)
    return c:GetOverlayCount() * 200
end

function s.filter(c, tp)
    return c:IsPosition(POS_FACEUP_ATTACK) and not c:IsType(TYPE_TOKEN)
        and (c:IsControler(tp) or c:IsAbleToChangeControler())
end

function s.target(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.filter(chkc, tp) and chkc ~= e:GetHandler() end
    if chk == 0 then return e:GetHandler():IsType(TYPE_XYZ)
        and Duel.IsExistingTarget(s.filter, tp, LOCATION_MZONE, LOCATION_MZONE, 1, e:GetHandler(), tp) end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TARGET)
    Duel.SelectTarget(tp, s.filter, tp, LOCATION_MZONE, LOCATION_MZONE, 1, 1, e:GetHandler(), tp)
end

function s.operation(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    local tc = Duel.GetFirstTarget()
    if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
        Duel.Overlay(c, tc, true)
    end
end

function s.mcondition(e, tp, eg, ep, ev, re, r, rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end

function s.mfilter(c, e, tp, ec)
    return c:IsCanBeEffectTarget(e) and c:CheckEquipTarget(ec)
end

function s.mtarget(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
    local c = e:GetHandler()
    local g = Duel.GetMatchingGroup(s.mfilter, tp, LOCATION_GRAVE, 0, nil, e, tp, c)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and s.filter(chkc, e, tp, c) end
    Duel.SetTargetCard(eg)
    Duel.SetOperationInfo(0, CATEGORY_LEAVE_GRAVE, eg, #eg, 0, 0)
end

function s.moperation(e, tp, eg, ep, ev, re, r, rp)
    local ft = Duel.GetLocationCount(tp, LOCATION_MZONE)
    local g = Duel.GetTargetCards(e)
    if #g == 0 or ft < #g then return end
    local c = e:GetHandler()
    if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
    for tc in g:Iter() do
        Duel.Equip(tp, tc, c, true, true)
    end
    Duel.EquipComplete()
end
