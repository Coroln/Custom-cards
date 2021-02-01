--Fate Traces of Dreams
--Scripted by Raivost
function c99890160.initial_effect(c)
  --(1) Search
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_TOGRAVE)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,99890160+EFFECT_COUNT_CODE_OATH)
  e1:SetTarget(c99890160.target)
  e1:SetOperation(c99890160.activate)
  c:RegisterEffect(e1)
end
--(1) Search
function c99890160.banfilter1(c,tp)
  return c:IsSetCard(0x989) and c:IsAbleToRemove() and aux.SpElimFilter(c,true)
  and Duel.IsExistingMatchingCard(c99890160.thfilter,tp,LOCATION_DECK,0,1,c,c:GetCode())
end
function c99890160.thfilter1(c,code)
  return c:IsCode(code) and c:IsAbleToHand()
end
function c99890160.banfilter2(c,tp)
  local rtype=bit.band(c:GetType(),0x7)
  return c:IsSetCard(0x989) and c:IsAbleToRemove() and aux.SpElimFilter(c,true)
  and Duel.IsExistingMatchingCard(c99890160.thfilter,tp,LOCATION_DECK,0,1,c,rtype)
end
function c99890160.thfilter2(c,rtype)
  return c:IsSetCard(0x989) and c:IsType(rtype) and c:IsAbleToHand() 
end
function c99890160.riderfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x989) and c:IsSetCard(0xF59) 
end
function c99890160.target(e,tp,eg,ep,ev,re,r,rp,chk)
  if Duel.IsExistingMatchingCard(c99890160.riderfilter,tp,LOCATION_MZONE,0,1,nil) then v=1 else v=0 end
  e:SetLabel(v)
  if chk==0 then return (Duel.IsExistingMatchingCard(c99890160.banfilter1,tp,LOCATION_GRAVE,0,1,nil,tp) and v==0) 
  or (Duel.IsExistingMatchingCard(c99890160.banfilter2,tp,LOCATION_GRAVE,0,1,nil,tp) and v==1) end
  if v==0 then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectTarget(tp,c99890160.banfilter1,tp,LOCATION_GRAVE,0,1,1,nil,tp)
  else
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectTarget(tp,c99890160.banfilter2,tp,LOCATION_GRAVE,0,1,1,nil,tp)
  end
  Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c99890160.activate(e,tp,eg,ep,ev,re,r,rp)
  local v=e:GetLabel()
  local tc=Duel.GetFirstTarget()
  if tc and tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 then
    if v==0 then
      Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
      local sg=Duel.SelectMatchingCard(tp,c99890160.thfilter1,tp,LOCATION_DECK,0,1,1,nil,tc:GetCode())
      if sg:GetCount()>0 then
        Duel.SendtoHand(sg,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,sg)
      end
    else
      local rtype=bit.band(tc:GetType(),0x7)
      Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
      local sg=Duel.SelectMatchingCard(tp,c99890160.thfilter2,tp,LOCATION_DECK,0,1,1,nil,rtype)
      if sg:GetCount()>0 then
        Duel.SendtoHand(sg,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,sg)
      end
    end
  end
end