--YuYuYu Nogi Sonoko
--Scripted by Raivost
function c99910120.initial_effect(c)
  c:EnableReviveLimit()
  aux.EnablePendulumAttribute(c)
  --Pendulum Effects
  --(1) Destroy
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99910120,0))
  e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
  e1:SetType(EFFECT_TYPE_IGNITION)
  e1:SetRange(LOCATION_PZONE)
  e1:SetCountLimit(1,99910120)
  e1:SetTarget(c99910120.destg)
  e1:SetOperation(c99910120.desop)
  c:RegisterEffect(e1)
  --(2) Add to Extra Deck
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99910120,1))
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetRange(LOCATION_PZONE)
  e2:SetCountLimit(1,99910121)
  e2:SetTarget(c99910120.aedtg)
  e2:SetOperation(c99910120.aedop)
  c:RegisterEffect(e2)
  --Monster Effects
  --(1) Search 1
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99910120,2))
  e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e3:SetType(EFFECT_TYPE_IGNITION)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCountLimit(1)
  e3:SetCost(c99910120.thcost1)
  e3:SetTarget(c99910120.thtg1)
  e3:SetOperation(c99910120.thop1)
  c:RegisterEffect(e3)
  --(2) Gain ATK
  local e4=Effect.CreateEffect(c)
  e4:SetDescription(aux.Stringid(99910120,3))
  e4:SetCategory(CATEGORY_ATKCHANGE)
  e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e4:SetCode(EVENT_BATTLE_DESTROYING)
  e4:SetCondition(c99910120.atkcon1)
  e4:SetTarget(c99910120.atktg)
  e4:SetOperation(c99910120.atkop)
  c:RegisterEffect(e4)
  local e5=Effect.CreateEffect(c)
  e5:SetDescription(aux.Stringid(99910120,3))
  e5:SetCategory(CATEGORY_DRAW)
  e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e5:SetCode(EVENT_DESTROYED)
  e5:SetRange(LOCATION_MZONE)
  e5:SetCondition(c99910120.atkcon2)
  e5:SetTarget(c99910120.atktg)
  e5:SetOperation(c99910120.atkop)
  c:RegisterEffect(e5)
  --(3) Search 2
  local e6=Effect.CreateEffect(c)
  e6:SetDescription(aux.Stringid(99910120,2))
  e6:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e6:SetCode(EVENT_LEAVE_FIELD)
  e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e6:SetCondition(c99910120.thcon2)
  e6:SetTarget(c99910120.thtg2)
  e6:SetOperation(c99910120.thop2)
  c:RegisterEffect(e6)
end
--Pendulum Effects
--(1) Destroy
function c99910120.thfilter1(c)
  return c:IsSetCard(0x991) and bit.band(c:GetType(),0x82)==0x82 and c:IsAbleToHand()
end
function c99910120.destg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():IsDestructable() and Duel.IsExistingMatchingCard(c99910120.thfilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c99910120.desop(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  if Duel.Destroy(e:GetHandler(),REASON_EFFECT)~=0 then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c99910120.thfilter1),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
    if g:GetCount()>0 then
      Duel.SendtoHand(g,nil,REASON_EFFECT)
      Duel.ConfirmCards(1-tp,g)
    end
  end
end
--(2) Add to Extra Deck
function c99910120.ppzfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x991) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c99910120.aedtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingTarget(c99910120.ppzfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectTarget(tp,c99910120.ppzfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c99910120.aedop(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  local tc=Duel.GetFirstTarget()
  if Duel.SendtoExtraP(e:GetHandler(),nil,REASON_EFFECT)~=0 then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
    if tc then
      Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
    end
  end
end
--Monster Effects
--(1) Search 1
function c99910120.thcost1(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():IsReleasable() end
  Duel.Release(e:GetHandler(),REASON_COST)
end
function c99910120.thfilter2(c)
  return c:IsSetCard(0x991) and bit.band(c:GetType(),0x81)==0x81 and not c:IsCode(99910120) and c:IsAbleToHand()
end
function c99910120.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99910120.thfilter2,tp,LOCATION_DECK,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99910120.thop1(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,c99910120.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
  if g:GetCount()>0 then
    Duel.SendtoHand(g,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,g)
  end
end
--(2) Gain ATK
function c99910120.atkcon1(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsRelateToBattle()
end
function c99910120.atkcon2(e,tp,eg,ep,ev,re,r,rp)
  return bit.band(r,REASON_EFFECT)~=0 and re:GetHandler()==e:GetHandler()
end
function c99910120.atkfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x991) and bit.band(c:GetType(),0x81)==0x81
end
function c99910120.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingTarget(c99910120.atkfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  Duel.SelectTarget(tp,c99910120.atkfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
end
function c99910120.atkop(e,tp,eg,ep,ev,re,r,rp,chk)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and tc:IsFaceup() then
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(600)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
    tc:RegisterEffect(e1)
  end
end
--(3) Search 2
function c99910120.thcon2(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  return (c:IsReason(REASON_BATTLE) or (c:GetReasonPlayer()~=tp and c:IsReason(REASON_EFFECT)))
  and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_MZONE)
end
function c99910120.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99910120.thfilter1,tp,LOCATION_GRAVE,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c99910120.thop2(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,c99910120.thfilter1,tp,LOCATION_GRAVE,0,1,1,nil)
  if g:GetCount()>0 and Duel.SendtoHand(g,tp,REASON_EFFECT)>0 and g:GetFirst():IsLocation(LOCATION_HAND) then
    Duel.ConfirmCards(1-tp,g)
    Duel.Recover(tp,500,REASON_EFFECT)
  end
end