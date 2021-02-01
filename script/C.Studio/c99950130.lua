--MSMM Wishful Pride
--Scripted by Raivost
function c99950130.initial_effect(c)
  --(1) Equip
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99950130,0))
  e1:SetCategory(CATEGORY_EQUIP)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetHintTiming(0,TIMING_BATTLE_START+TIMING_BATTLE_END)
  e1:SetCondition(c99950130.eqcon)
  e1:SetCost(aux.RemainFieldCost)
  e1:SetTarget(c99950130.eqtg)
  e1:SetOperation(c99950130.eqop)
  c:RegisterEffect(e1)
  --(2) Take
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99950130,1))
  e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e2:SetProperty(EFFECT_FLAG_DELAY)
  e2:SetCode(EVENT_LEAVE_FIELD)
  e2:SetCondition(c99950130.tkcon)
  e2:SetTarget(c99950130.tktg)
  e2:SetOperation(c99950130.tkop)
  c:RegisterEffect(e2)
end
--(1) Equip
function c99950130.eqcon(e,tp,eg,ep,ev,re,r,rp)
  return (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE)
end
function c99950130.eqfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x995) and bit.band(c:GetType(),0x81)==0x81
end
function c99950130.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return e:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsExistingTarget(c99950130.eqfilter,tp,LOCATION_MZONE,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
  local g=Duel.SelectTarget(tp,c99950130.eqfilter,tp,LOCATION_MZONE,0,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c99950130.eqop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if not c:IsLocation(LOCATION_SZONE) or not c:IsRelateToEffect(e) or c:IsStatus(STATUS_LEAVE_CONFIRMED) then return end
  local tc=Duel.GetFirstTarget()
  if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
    Duel.Equip(tp,c,tc)
    --(1.1) Gain ATK
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_EQUIP)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(1000)
    e1:SetReset(RESET_EVENT+0x1fe0000)
    c:RegisterEffect(e1)
    --(1.2) Equip limit
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_EQUIP_LIMIT)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e2:SetValue(c99950130.eqlimit)
    e2:SetReset(RESET_EVENT+0x1fe0000)
    c:RegisterEffect(e2)
    --(1.3) Destroy replace
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EFFECT_DESTROY_REPLACE)
    e3:SetRange(LOCATION_SZONE)
    e3:SetTarget(c99950130.dreptg)
    e3:SetValue(c99950130.drepval)
    e3:SetOperation(c99950130.drepop)
    e3:SetReset(RESET_EVENT+0x1fe0000)
    c:RegisterEffect(e3)
  else
    c:CancelToGrave(false)
  end
end
--(1.2) Equip limit
function c99950130.eqlimit(e,c)
  return c:IsSetCard(0x995) and bit.band(c:GetType(),0x81)==0x81
end
--(1.3) Destroy replace
function c99950130.drepfilter(c,tp)
  return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0x995) and bit.band(c:GetType(),0x81)==0x81
    and not c:IsReason(REASON_REPLACE) and c:IsReason(REASON_EFFECT+REASON_BATTLE)
end
function c99950130.dreptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():IsDestructable(e) and not e:GetHandler():IsStatus(STATUS_DESTROY_CONFIRMED) and eg:IsExists(c99950130.drepfilter,1,nil,tp) end
  return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c99950130.drepval(e,c)
  return c99950130.drepfilter(c,e:GetHandlerPlayer())
end
function c99950130.thfilter(c)
  return c:IsSetCard(0x995) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c99950130.drepop(e,tp,eg,ep,ev,re,r,rp)
  e:GetHandler():SetStatus(STATUS_DESTROY_CONFIRMED,false)
  Duel.Destroy(e:GetHandler(),REASON_EFFECT+REASON_REPLACE)
end
--(2) Take
function c99950130.tkcon(e,tp,eg,ep,ev,re,r,rp)
  return r&0x41==0x41 and e:GetHandler():GetEquipTarget()~=nil
end
function c99950130.tkfilter(c)
  return c:IsSetCard(0x995) and bit.band(c:GetType(),0x81)==0x81 and (c:IsAbleToHand() or c:IsAbleToGrave())
end
function c99950130.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99950130.tkfilter,tp,LOCATION_DECK,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
  Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c99950130.tkop(e,tp,eg,ep,ev,re,r,rp)
  local g=Duel.SelectMatchingCard(tp,c99950130.tkfilter,tp,LOCATION_DECK,0,1,1,nil)
  if g:GetCount()>0 then
    local tc=g:GetFirst()
    if tc and tc:IsAbleToHand() and (not tc:IsAbleToGrave() or Duel.SelectYesNo(tp,aux.Stringid(99950130,2))) then
      Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(99950130,3))
      Duel.SendtoHand(tc,nil,REASON_EFFECT)
      Duel.ConfirmCards(1-tp,tc)
    else
      Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(99950130,4))
      Duel.SendtoGrave(tc,REASON_EFFECT)
    end
  end
end