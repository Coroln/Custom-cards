--Yu-Gi-Oh Pen and Paper
--Coroln
-- DnD Draw Engine (Rule Card)
local s,id=GetID()

function s.initial_effect(c)
    -- Register this card as a Duel Rule card
    aux.EnableExtraRules(c,s,s.init)
end

-- Initialize rule effects at duel start
function s.init(c)
    -- 1) Remove normal draw
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_DRAW_COUNT)
    e1:SetTargetRange(1,1)
    e1:SetValue(0)
    Duel.RegisterEffect(e1,0)

    --Turn player's draw becomes: 2d4 + modifier, excavate that many, add 1
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_PREDRAW)
    e2:SetOperation(s.drop)
    Duel.RegisterEffect(e2,0)
end

function s.drop(e,tp,eg,ep,ev,re,r,rp)
    ----------------------------------------------------------------------
    -- Roll 2d4
    ----------------------------------------------------------------------
    local d1 = math.random(1,4)
    local d2 = math.random(1,4)
    local base = d1 + d2

    Debug.ShowHint("Rolled 2d4 →  "..d1.."  and  "..d2.."  (total = "..base..")")

    ----------------------------------------------------------------------
    -- Modifier amount (0–4)
    ----------------------------------------------------------------------
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,0))
    local magnitude = Duel.AnnounceNumber(tp,0,1,2,3,4)

    ----------------------------------------------------------------------
    -- Modifier sign
    ----------------------------------------------------------------------
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
    local sign = Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3)) -- 0 neg, 1 pos

    local mod = (sign==0) and -magnitude or magnitude

    ----------------------------------------------------------------------
    -- Final total
    ----------------------------------------------------------------------
    local total = base + mod
    if total < 0 then total = 0 end

    Debug.ShowHint("Modifier applied: "..mod.."\nFinal excavation count: "..total)

    local deckct = Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
    if total > deckct then total = deckct end
    if total == 0 then return end

    ----------------------------------------------------------------------
    -- Excavation
    ----------------------------------------------------------------------
    Duel.ConfirmDecktop(tp,total)
    local g=Duel.GetDecktopGroup(tp,total)

    ----------------------------------------------------------------------
    -- Player chooses 1 card to take
    ----------------------------------------------------------------------
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local pick=g:Select(tp,1,1,nil):GetFirst()

    if pick then
        Duel.DisableShuffleCheck()
        Duel.SendtoHand(pick,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,pick)
        g:RemoveCard(pick)
    end

    ----------------------------------------------------------------------
    -- Put remaining cards back on top
    ----------------------------------------------------------------------
    Duel.SortDecktop(tp,tp,total-1)
end