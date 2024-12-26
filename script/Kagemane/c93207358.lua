--Cursed Clan Weapon
--Script by Coroln and ChatGPT
local s, id = GetID()
function s.initial_effect(c)
    -- Activate
    local e1 = Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON + CATEGORY_FUSION_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(s.target)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)
end

function s.filter1(c, e)
    return not c:IsImmuneToEffect(e)
end

function s.filter2(c, e, tp, mg, chkf)
    return c:IsType(TYPE_FUSION) and c:IsRace(RACE_WARRIOR)
        and c:IsCanBeSpecialSummoned(e, SUMMON_TYPE_FUSION, tp, false, false)
        and c:CheckFusionMaterial(mg, nil, chkf)
end

function s.extra_filter(c)
    return c:IsSummonType(SUMMON_TYPE_SPECIAL) and c:IsLocation(LOCATION_MZONE)
end

function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        local chkf = tp
        local mg1 = Duel.GetFusionMaterial(tp)
        local mg2 = Group.CreateGroup()
        if Duel.IsExistingMatchingCard(s.extra_filter, tp, 0, LOCATION_MZONE, 1, nil) then
            mg2 = Duel.GetMatchingGroup(s.filter1, tp, LOCATION_DECK, 0, nil, e)
        end
        return Duel.IsExistingMatchingCard(s.filter2, tp, LOCATION_EXTRA, 0, 1, nil, e, tp, mg1 + mg2, chkf)
    end
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_EXTRA)
end

function s.activate(e, tp, eg, ep, ev, re, r, rp)
    local chkf = tp
    local mg1 = Duel.GetFusionMaterial(tp):Filter(s.filter1, nil, e)
    local mg2 = Duel.GetMatchingGroup(s.filter1, tp, LOCATION_DECK, 0, nil, e)
    local use_deck = false

    -- Check if opponent controls a Special Summoned monster from the Extra Deck
    if Duel.IsExistingMatchingCard(s.extra_filter, tp, 0, LOCATION_MZONE, 1, nil) then
        -- Allow the player to discard to use Deck materials
        if Duel.SelectYesNo(tp, aux.Stringid(id, 0)) then
            Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DISCARD)
            if Duel.DiscardHand(tp, nil, 1, 1, REASON_EFFECT + REASON_DISCARD) > 0 then
                mg1:Merge(mg2) -- Merge Deck materials with current materials
                use_deck = true
            end
        end
    end

    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
    local sg = Duel.SelectMatchingCard(tp, s.filter2, tp, LOCATION_EXTRA, 0, 1, 1, nil, e, tp, mg1, chkf)
    local tc = sg:GetFirst()
    if tc then
        Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_FMATERIAL)
        local mat = Duel.SelectFusionMaterial(tp, tc, mg1, nil, chkf)
        if use_deck and mat:IsExists(Card.IsLocation, 1, nil, LOCATION_DECK) then
            Duel.ConfirmCards(1 - tp, mat:Filter(Card.IsLocation, nil, LOCATION_DECK))
        end
        tc:SetMaterial(mat)
        Duel.SendtoGrave(mat, REASON_EFFECT + REASON_MATERIAL + REASON_FUSION)
        Duel.BreakEffect()
        Duel.SpecialSummon(tc, SUMMON_TYPE_FUSION, tp, tp, false, false, POS_FACEUP)
        tc:CompleteProcedure()
    end
end