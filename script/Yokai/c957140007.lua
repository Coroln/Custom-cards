local s,id=GetID()
function s.initial_effect(c)
    -- Quick Effect: Discard this card to check a set monster and possibly destroy it
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_MSET)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(s.setcon)
    e1:SetCost(s.setcost)
    e1:SetTarget(s.settg)
    e1:SetOperation(s.setop)
    c:RegisterEffect(e1)
    -- Treat this card as 2 Tributes for Tribute Summon of a Yokai monster
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_DOUBLE_TRIBUTE)
    e2:SetValue(s.dtval)
    c:RegisterEffect(e2)
end

-- Condition: An opponent sets at least 1 monster
function s.setcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(Card.IsControler,1,nil,1-tp)
end

-- Cost: Discard this card
function s.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsDiscardable() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end

function s.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return eg:IsExists(Card.IsControler,1,nil,1-tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
    local g=eg:FilterSelect(tp,Card.IsControler,1,1,nil,1-tp)
    Duel.SetTargetCard(g)
end

function s.setop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) then
        if tc:IsFacedown() then
            Duel.ConfirmCards(tp,tc)
        end
        if tc:IsType(TYPE_FLIP) or tc:GetAttack()>1800 or tc:GetDefense()>1800 then
            Duel.Destroy(tc,REASON_EFFECT)
        end
    end
end

function s.dtval(e,c)
    if c and c:IsRace(RACE_YOKAI) then
        return 1
    else
        return 0
    end
end
