--Kaiserwaffe Black Marlin
local s, id = GetID()

function s.initial_effect(c)
    --Upon normal summon, add 1 "Kaiserwaffe" monster
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,0))
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetTarget(s.thtg)
    e2:SetOperation(s.thop)
    c:RegisterEffect(e2)
    --Set 2 Spells (from deck and GY) with different names
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,{id,1})
    e2:SetCost(aux.selfreleasecost)
    e2:SetTarget(s.target)
    e2:SetOperation(s.operation)
    c:RegisterEffect(e2)
end
s.listed_series={0x69AA}
s.listed_names={id}
-- e1:
function s.filter(c)
    return c:IsMonster() and c:IsSetCard(0x69AA) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil)
    if #g>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
-- e2:
    --Check for "Hole" normal traps
function s.setfilter(c)
    return c:IsSpell() and c:IsSSetable() and c:IsSetCard(0x69AA)
end
    --The 2 cards have different names from each other
function s.setcheck(sg,e,tp,mg)
    return sg:GetClassCount(Card.GetLocation)>=#sg and sg:GetClassCount(Card.GetCode)>=#sg
end
    --Activation legality
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local sg=Duel.GetMatchingGroup(s.setfilter,tp,LOCATION_DECK|LOCATION_GRAVE,0,nil)
        return Duel.GetLocationCount(tp,LOCATION_SZONE)>=2
            and aux.SelectUnselectGroup(sg,e,tp,2,2,s.setcheck,0) end
    Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,0)
end
    --Set 2 spells with different names from deck and GY, banish them when they leave
function s.operation(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<2 then return end
    local sg=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.setfilter),tp,LOCATION_DECK|LOCATION_GRAVE,0,nil)
    if #sg==0 then return end
    local rg=aux.SelectUnselectGroup(sg,e,tp,2,2,s.setcheck,1,tp,HINTMSG_SET,s.setcheck)
    if #rg>0 then
        Duel.SSet(tp,rg)
        for tc in rg:Iter() do
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
            e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
            e1:SetValue(LOCATION_REMOVED)
            e1:SetReset(RESET_EVENT|RESETS_REDIRECT)
            tc:RegisterEffect(e1)
        end
    end
end
