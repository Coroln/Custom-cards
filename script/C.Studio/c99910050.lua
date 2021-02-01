--YuYuYu Inubouzaki Itsuki
--Scripted by Raivost
function c99910050.initial_effect(c)
  c:EnableReviveLimit()
  aux.EnablePendulumAttribute(c)
  --Pendulum Effects
  --(1) Destroy 1
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99910050,0))
  e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
  e1:SetType(EFFECT_TYPE_IGNITION)
  e1:SetRange(LOCATION_PZONE)
  e1:SetCountLimit(1,99910050)
  e1:SetTarget(c99910050.destg)
  e1:SetOperation(c99910050.desop)
  c:RegisterEffect(e1)
  --(2) Return to hand
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99910050,1))
  e2:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e2:SetRange(LOCATION_PZONE)
  e2:SetCountLimit(1,99910051)
  e2:SetTarget(c99910050.rthtg)
  e2:SetOperation(c99910050.rthop)
  c:RegisterEffect(e2)
  --Monster Effects
  --(1) Search 1
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99910050,2))
  e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e3:SetType(EFFECT_TYPE_IGNITION)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCountLimit(1)
  e3:SetCost(c99910050.thcost1)
  e3:SetTarget(c99910050.thtg1)
  e3:SetOperation(c99910050.thop1)
  c:RegisterEffect(e3)
  --(2) Negate
  local e4=Effect.CreateEffect(c)
  e4:SetDescription(aux.Stringid(99910050,3))
  e4:SetCategory(CATEGORY_DISABLE)
  e4:SetType(EFFECT_TYPE_QUICK_O)
  e4:SetCode(EVENT_FREE_CHAIN)
  e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e4:SetRange(LOCATION_MZONE)
  e4:SetHintTiming(0,0x1c0)
  e4:SetCountLimit(1,99910052)
  e4:SetTarget(c99910050.negtg)
  e4:SetOperation(c99910050.negop)
  c:RegisterEffect(e4)
  --(3) Search 2
  local e5=Effect.CreateEffect(c)
  e5:SetDescription(aux.Stringid(99910050,2))
  e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e5:SetCode(EVENT_LEAVE_FIELD)
  e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e5:SetCondition(c99910050.thcon2)
  e5:SetTarget(c99910050.thtg2)
  e5:SetOperation(c99910050.thop2)
  c:RegisterEffect(e5)
end
--Pendulum Effects
--(1) Destroy
function c99910050.thfilter1(c)
  return c:IsSetCard(0x991) and bit.band(c:GetType(),0x82)==0x82 and c:IsAbleToHand()
end
function c99910050.destg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():IsDestructable() and Duel.IsExistingMatchingCard(c99910050.thfilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c99910050.desop(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  if Duel.Destroy(e:GetHandler(),REASON_EFFECT)~=0 then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c99910050.thfilter1),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
    if g:GetCount()>0 then
      Duel.SendtoHand(g,nil,REASON_EFFECT)
      Duel.ConfirmCards(1-tp,g)
    end
  end
end
--(2) Return to hand
function c99910050.rtdfilter(c)
  return c:IsAbleToDeck()
end
function c99910050.rthfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x991) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c99910050.rthtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingTarget(c99910050.rtdfilter,tp,0,LOCATION_ONFIELD,1,nil)
  and Duel.IsExistingMatchingCard(c99910050.rthfilter,tp,LOCATION_EXTRA,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
  local g=Duel.SelectTarget(tp,c99910050.rtdfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
  Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,1-tp,LOCATION_ONFIELD)
end
function c99910050.rthop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
  local g=Duel.SelectMatchingCard(tp,c99910050.rthfilter,tp,LOCATION_EXTRA,0,1,1,nil)
  if g:GetCount()>0 then
    Duel.SendtoHand(g,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,g)
    if tc:IsRelateToEffect(e) then
      Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
    end
  end
end
--Monster Effects
--(1) Search 1
function c99910050.thcost1(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():IsReleasable() end
  Duel.Release(e:GetHandler(),REASON_COST)
end
function c99910050.thfilter2(c)
  return c:IsSetCard(0x991) and bit.band(c:GetType(),0x81)==0x81 and not c:IsCode(99910050) and c:IsAbleToHand()
end
function c99910050.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99910050.thfilter2,tp,LOCATION_DECK,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99910050.thop1(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,c99910050.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
  if g:GetCount()>0 then
    Duel.SendtoHand(g,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,g)
  end
end
--(2) Negate
function c99910050.negtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingTarget(aux.disfilter1,tp,0,LOCATION_ONFIELD,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
  local g=Duel.SelectTarget(tp,aux.disfilter1,tp,0,LOCATION_ONFIELD,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c99910050.negop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local tc=Duel.GetFirstTarget()
  if tc and ((tc:IsFaceup() and not tc:IsDisabled()) or tc:IsType(TYPE_TRAPMONSTER)) and tc:IsRelateToEffect(e) then
    Duel.NegateRelatedChain(tc,RESET_TURN_SET)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetCode(EFFECT_DISABLE)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
    tc:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e2:SetCode(EFFECT_DISABLE_EFFECT)
    e2:SetValue(RESET_TURN_SET)
    e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
    tc:RegisterEffect(e2)
    if tc:IsType(TYPE_TRAPMONSTER) then
      local e3=Effect.CreateEffect(c)
      e3:SetType(EFFECT_TYPE_SINGLE)
      e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
      e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
      e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
      tc:RegisterEffect(e3)
    end
  end
end
--(3) Search 2
function c99910050.thcon2(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  return (c:IsReason(REASON_BATTLE) or (c:GetReasonPlayer()~=tp and c:IsReason(REASON_EFFECT)))
  and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_MZONE)
end
function c99910050.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99910050.thfilter1,tp,LOCATION_GRAVE,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c99910050.thop2(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,c99910050.thfilter1,tp,LOCATION_GRAVE,0,1,1,nil)
  if g:GetCount()>0 and Duel.SendtoHand(g,tp,REASON_EFFECT)>0 and g:GetFirst():IsLocation(LOCATION_HAND) then
    Duel.ConfirmCards(1-tp,g)
    Duel.Recover(tp,500,REASON_EFFECT)
  end
end