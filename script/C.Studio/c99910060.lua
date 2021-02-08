--YuYuYu Miyoshi Karin
--Scripted by Raivost
function c99910060.initial_effect(c)
  c:EnableReviveLimit()
  Pendulum.AddProcedure(c)
  --Pendulum Effects
  --(1) Destroy 1
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99910060,0))
  e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
  e1:SetType(EFFECT_TYPE_IGNITION)
  e1:SetRange(LOCATION_PZONE)
  e1:SetCountLimit(1,99910060)
  e1:SetTarget(c99910060.destg)
  e1:SetOperation(c99910060.desop)
  c:RegisterEffect(e1)
  --(2) Return to hand
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99910060,1))
  e2:SetCategory(CATEGORY_TOHAND)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetRange(LOCATION_PZONE)
  e2:SetCountLimit(1,99910061)
  e2:SetTarget(c99910060.rthtg)
  e2:SetOperation(c99910060.rthop)
  c:RegisterEffect(e2)
  --Monster Effects
  --(1) Search 1
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99910060,2))
  e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e3:SetType(EFFECT_TYPE_IGNITION)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCountLimit(1)
  e3:SetCost(c99910060.thcost1)
  e3:SetTarget(c99910060.thtg1)
  e3:SetOperation(c99910060.thop1)
  c:RegisterEffect(e3)
  --(2) Double damage
  local e4=Effect.CreateEffect(c)
  e4:SetDescription(aux.Stringid(99910060,3))
  e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e4:SetCode(EVENT_ATTACK_ANNOUNCE)
  e4:SetCountLimit(1)
  e4:SetCost(c99910060.ddcost)
  e4:SetTarget(c99910060.ddtg)
  e4:SetOperation(c99910060.ddop)
  c:RegisterEffect(e4)
  --(3) Search 2
  local e5=Effect.CreateEffect(c)
  e5:SetDescription(aux.Stringid(99910060,2))
  e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e5:SetCode(EVENT_LEAVE_FIELD)
  e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e5:SetCondition(c99910060.thcon2)
  e5:SetTarget(c99910060.thtg2)
  e5:SetOperation(c99910060.thop2)
  c:RegisterEffect(e5)
end
--Pendulum Effects
--(1) Destroy
function c99910060.thfilter1(c)
  return c:IsSetCard(0x991) and bit.band(c:GetType(),0x82)==0x82 and c:IsAbleToHand()
end
function c99910060.destg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():IsDestructable() and Duel.IsExistingMatchingCard(c99910060.thfilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c99910060.desop(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  if Duel.Destroy(e:GetHandler(),REASON_EFFECT)~=0 then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c99910060.thfilter1),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
    if g:GetCount()>0 then
      Duel.SendtoHand(g,nil,REASON_EFFECT)
      Duel.ConfirmCards(1-tp,g)
    end
  end
end
--(2) Return to hand
function c99910060.ppzfilter(c)
  return c:IsFaceup()and c:IsSetCard(0x991) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c99910060.rthtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():IsAbleToHand()
  and Duel.IsExistingMatchingCard(c99910060.ppzfilter,tp,LOCATION_EXTRA,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c99910060.rthop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)~=0 then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
    local g=Duel.SelectMatchingCard(tp,c99910060.ppzfilter,tp,LOCATION_EXTRA,0,1,1,nil)
    if g:GetCount()>0 then
      Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
    end
  end
end
--Monster Effects
--(1) Search 1
function c99910060.thcost1(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():IsReleasable() end
  Duel.Release(e:GetHandler(),REASON_COST)
end
function c99910060.thfilter2(c)
  return c:IsSetCard(0x991) and bit.band(c:GetType(),0x81)==0x81 and not c:IsCode(99910060) and c:IsAbleToHand()
end
function c99910060.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99910060.thfilter2,tp,LOCATION_DECK,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99910060.thop1(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,c99910060.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
  if g:GetCount()>0 then
    Duel.SendtoHand(g,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,g)
  end
end
--(2) Double damage
function c99910060.ddcostfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x991)and c:IsType(TYPE_PENDULUM) and c:IsAbleToDeckAsCost()
end
function c99910060.ddcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99910060.ddcostfilter,tp,LOCATION_EXTRA,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
  local g=Duel.SelectMatchingCard(tp,c99910060.ddcostfilter,tp,LOCATION_EXTRA,0,1,1,nil)
  Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c99910060.ddtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99910060.ddop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if not c:IsRelateToBattle() then return end
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
  e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
  e1:SetCondition(c99910060.damcon)
  e1:SetOperation(c99910060.damop)
  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
  c:RegisterEffect(e1)
end
function c99910060.damcon(e,tp,eg,ep,ev,re,r,rp)
  return ep~=tp and e:GetHandler():GetBattleTarget()~=nil
end
function c99910060.damop(e,tp,eg,ep,ev,re,r,rp)
  local dam=Duel.GetBattleDamage(ep)
  Duel.ChangeBattleDamage(ep,dam*2)
end
--(3) Search 2
function c99910060.thcon2(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  return (c:IsReason(REASON_BATTLE) or (c:GetReasonPlayer()~=tp and c:IsReason(REASON_EFFECT)))
  and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_MZONE)
end
function c99910060.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99910060.thfilter1,tp,LOCATION_GRAVE,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c99910060.thop2(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,c99910060.thfilter1,tp,LOCATION_GRAVE,0,1,1,nil)
  if g:GetCount()>0 and Duel.SendtoHand(g,tp,REASON_EFFECT)>0 and g:GetFirst():IsLocation(LOCATION_HAND) then
    Duel.ConfirmCards(1-tp,g)
    Duel.Recover(tp,500,REASON_EFFECT)
  end
end
