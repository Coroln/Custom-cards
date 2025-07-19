--Fiendish Recaller
local s,id=GetID()
function s.initial_effect(c)
    Link.AddProcedure(c,s.matfilter,1,1)
   local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1,id)
    e1:SetTarget(s.target)
    e1:SetOperation(s.operation)
    c:RegisterEffect(e1)
end
function s.filter(c)
    return c:IsFaceup() and c:IsRace(RACE_FIEND)
end
function s.nsfilter(c)
    return c:IsRace(RACE_FIEND) and c:IsSummonable(true,nil)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then
        return Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,0,1,c)
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
    local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,0,1,1,c)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if not c:IsRelateToEffect(e) or not tc or not tc:IsRelateToEffect(e) then return end
    if Duel.SendtoHand(tc,nil,REASON_EFFECT)==0 then return end
    if Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)==0 then return end
    Duel.BreakEffect()
    if tc:IsLocation(LOCATION_HAND) and tc:IsSummonable(true,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
        Duel.Summon(tp,tc,true,nil)
    end
end
