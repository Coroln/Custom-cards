--Mystical Chaos Sphere
local s,id=GetID()
function s.initial_effect(c)
    -- On Summon: Shuffle LIGHT/DARK Fairies, send 1 of different Attribute to GY
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_TODECK+CATEGORY_TOGRAVE)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCountLimit(1,id)
    e1:SetTarget(s.tdtg)
    e1:SetOperation(s.tdop)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e2)
    local e3=e1:Clone()
    e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
    c:RegisterEffect(e3)

    -- Effect 2: If sent from field to GY
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(id,3))
    e4:SetCategory(CATEGORY_TOHAND+CATEGORY_HANDES)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e4:SetCode(EVENT_TO_GRAVE)
    e4:SetProperty(EFFECT_FLAG_DELAY)
    e4:SetCountLimit(1,{id,1})
    e4:SetCondition(s.thcon)
    e4:SetCost(s.thcost)
    e4:SetTarget(s.thtg)
    e4:SetOperation(s.thop)
    c:RegisterEffect(e4)
end
--e1
function s.tdfilter(c,att)
    return c:IsRace(RACE_FAIRY) and c:IsAttribute(att) and c:IsAbleToDeck()
end
function s.tgfilter(c,att)
    return c:IsMonster() and c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK) and not c:IsAttribute(att) and c:IsAbleToGrave()
end

function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local g1=Duel.GetMatchingGroup(s.tdfilter,tp,LOCATION_GRAVE,0,nil,ATTRIBUTE_LIGHT)
    local g2=Duel.GetMatchingGroup(s.tdfilter,tp,LOCATION_GRAVE,0,nil,ATTRIBUTE_DARK)
    if chk==0 then return (#g1>=1 or #g2>=1) end
    Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end

function s.tdop(e,tp,eg,ep,ev,re,r,rp)
    local g1=Duel.GetMatchingGroup(s.tdfilter,tp,LOCATION_GRAVE,0,nil,ATTRIBUTE_LIGHT)
    local g2=Duel.GetMatchingGroup(s.tdfilter,tp,LOCATION_GRAVE,0,nil,ATTRIBUTE_DARK)
    local att=0
    if #g1>0 and (#g2==0 or Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))==0) then
        att=ATTRIBUTE_LIGHT
    elseif #g2>0 then
        att=ATTRIBUTE_DARK
    else return end

    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local sg=Duel.SelectMatchingCard(tp,s.tdfilter,tp,LOCATION_GRAVE,0,1,3,nil,att)
    if #sg>0 then
        Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
        Duel.ShuffleDeck(tp)
        Duel.BreakEffect()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
        local tg=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_DECK,0,1,1,nil,att)
        if #tg>0 then
            Duel.SendtoGrave(tg,REASON_EFFECT)
        end
    end
end

--e2

function s.thcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsPreviousLocation(LOCATION_ONFIELD)
end
function s.costfilter(c)
    return c:IsRace(RACE_FAIRY) and (c:IsAttribute(ATTRIBUTE_LIGHT) or c:IsAttribute(ATTRIBUTE_DARK))
        and c:IsDiscardable(REASON_COST) and not c:IsCode(id)
end
function s.thfilter(c,att)
    return c:IsRace(RACE_FAIRY) and (c:IsAttribute(ATTRIBUTE_LIGHT) or c:IsAttribute(ATTRIBUTE_DARK))
        and not c:IsAttribute(att) and c:IsAbleToHand() and not c:IsCode(id)
end
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_HAND,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
    local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_HAND,0,1,1,nil)
    e:SetLabel(g:GetFirst():GetAttribute())
    Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local att=e:GetLabel()
    if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_GRAVE,0,1,nil,att) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
    local att=e:GetLabel()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_GRAVE,0,1,1,nil,att)
    if #g>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end