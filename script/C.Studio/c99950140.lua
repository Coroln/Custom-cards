--MSMM Clara Dolls
--Scripted by Raivost
function c99950140.initial_effect(c)
  --(1) Send to GY
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99950140,0))
  e1:SetCategory(CATEGORY_TOGRAVE)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetTarget(c99950140.tgtg)
  e1:SetOperation(c99950140.tgop)
  c:RegisterEffect(e1)
  --(2) Place in S/T Zone
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99950140,1))
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetRange(LOCATION_FZONE)
  e2:SetCountLimit(1)
  e2:SetTarget(c99950140.stztg)
  e2:SetOperation(c99950140.stzop)
  c:RegisterEffect(e2)
  --(3) Destroy
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99950140,2))
  e3:SetCategory(CATEGORY_DESTROY)
  e3:SetType(EFFECT_TYPE_IGNITION)
  e3:SetRange(LOCATION_FZONE)
  e3:SetCondition(c99950140.descon)
  e3:SetTarget(c99950140.destg)
  e3:SetOperation(c99950140.desop)
  c:RegisterEffect(e3)
  --(4) Search
  local e4=Effect.CreateEffect(c)
  e4:SetDescription(aux.Stringid(99950140,3))
  e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e4:SetCode(EVENT_DESTROYED)
  e4:SetCondition(c99950140.thcon)
  e4:SetTarget(c99950140.thtg)
  e4:SetOperation(c99950140.thop)
  c:RegisterEffect(e4)
end
--(1) Send to GY
function c99950140.tgfilter(c)
  return c:IsAbleToGrave()
end
function c99950140.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,PLAYER_ALL,LOCATION_DECK)
end
function c99950140.tgop(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
  local g1=Duel.SelectMatchingCard(tp,c99950140.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
  Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
  local g2=Duel.SelectMatchingCard(1-tp,c99950140.tgfilter,1-tp,LOCATION_DECK,0,1,1,nil)
  g1:Merge(g2)
  Duel.SendtoGrave(g1,REASON_EFFECT)
end
--(2) Place in S/T Zone
function c99950140.stzfilter(c)
  return c:IsSetCard(0x995) and bit.band(c:GetOriginalType(),0x81)==0x81 and not c:IsForbidden()
end
function c99950140.stztg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingTarget(c99950140.stzfilter,tp,LOCATION_GRAVE,0,1,nil)
  and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  local g=Duel.SelectTarget(tp,c99950140.stzfilter,tp,LOCATION_GRAVE,0,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function c99950140.stzop(e,tp,eg,ep,ev,re,r,rp)
  local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
  if not e:GetHandler():IsRelateToEffect(e) or ft<=0 then return end
  local tc=Duel.GetFirstTarget()
  if tc then
    --Continuous Spell
    Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetCode(EFFECT_CHANGE_TYPE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetReset(RESET_EVENT+0x1fc0000)
    e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
    tc:RegisterEffect(e1)
    Duel.RaiseEvent(tc,EVENT_CUSTOM+99950150,e,0,tp,0,0)
  end
end
--(3) Destroy
function c99950140.desconfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x995) and bit.band(c:GetOriginalType(),0x81)==0x81 and c:GetLevel()==5
end
function c99950140.descon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.IsExistingMatchingCard(c99950140.desconfilter,tp,LOCATION_SZONE,0,3,nil)
end
function c99950140.destg(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
  if chk==0 then return c:IsDestructable() end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,c,1,0,0)
end
function c99950140.desop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if not c:IsRelateToEffect(e) then return end
  if c:IsRelateToEffect(e) then 
    Duel.Destroy(c,REASON_EFFECT)
  end
end
--(4) Search
function c99950140.thcon(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  return c:IsPreviousPosition(POS_FACEUP)
end
function c99950140.thfilter(c)
  return c:IsSetCard(0x995) and not c:IsCode(99950140) and c:IsAbleToHand()
end
function c99950140.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99950140.thop(e,tp,eg,ep,ev,re,r,rp)
  local ct=Duel.GetMatchingGroupCount(c99950140.desconfilter,tp,LOCATION_SZONE,0,nil)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,c99950140.thfilter,tp,LOCATION_DECK,0,1,ct,nil)
  if g:GetCount()>0 then
    Duel.SendtoHand(g,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,g)
  end
end