-- Custom Card: 2 Level 3 monsters
local s,id=GetID()
function s.initial_effect(c)
    -- Xyz Summon
    Xyz.AddProcedure(c,nil,3,2)
    c:EnableReviveLimit()

    -- Effect 1: Shuffle and Add
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetCost(s.cost)
    e1:SetTarget(s.target)
    e1:SetOperation(s.operation)
    c:RegisterEffect(e1)

    -- Effect 2: Gain ATK
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_ATKCHANGE)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_TO_GRAVE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCondition(s.atkcon)
    e2:SetOperation(s.atkop)
    c:RegisterEffect(e2)
end

-- Cost: Detach 1 material
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end

-- Filter for GY (Level 3 Tuner)
function s.filtergy(c)
    return c:IsType(TYPE_TUNER) and c:IsLevel(3) and c:IsAbleToDeck()
end

-- Filter for Deck (Level 3 Tuner, different name)
function s.filterdeck(c,name)
    return c:IsType(TYPE_TUNER) and c:IsLevel(3) and not c:IsCode(name) and c:IsAbleToHand()
end

-- Target logic
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.filtergy,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

-- Operation logic
function s.operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(tp,s.filtergy,tp,LOCATION_GRAVE,0,1,1,nil)
    if #g>0 then
        local tc=g:GetFirst()
        local name=tc:GetCode()
        if Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_DECK+LOCATION_EXTRA) then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
            local sg=Duel.SelectMatchingCard(tp,s.filterdeck,tp,LOCATION_DECK,0,1,1,nil,name)
            if #sg>0 then
                Duel.SendtoHand(sg,nil,REASON_EFFECT)
                Duel.ConfirmCards(1-tp,sg)
            end
        end
    end
end

-- ATK Gain Condition: Level 3 discarded to GY for its own effect
function s.atkfilter(c)
    return c:IsLevel(3) and c:IsReason(REASON_DISCARD) and c:IsPreviousLocation(LOCATION_HAND)
end

function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
    if not re then return false end
    local rc=re:GetHandler()
    return eg:IsContains(rc) and s.atkfilter(rc)
end

-- ATK Gain Operation
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and c:IsFaceup() then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(500)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
        c:RegisterEffect(e1)
    end
end
