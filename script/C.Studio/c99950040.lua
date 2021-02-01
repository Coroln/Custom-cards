--MSMM Miki Sayaka
--Scripted by Raivost
function c99950040.initial_effect(c)
  c:EnableReviveLimit()
  --(1) Special Summon condition
  local e1=Effect.CreateEffect(c)
  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_SPSUMMON_CONDITION)
  e1:SetValue(c99950040.splimit)
  c:RegisterEffect(e1)
  --(2) Gain ATK 1
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE)
  e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCode(EFFECT_UPDATE_ATTACK)
  e2:SetValue(c99950040.atkval1)
  c:RegisterEffect(e2)
  --(3) Send to GY
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99950040,3))
  e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_ATKCHANGE)
  e3:SetType(EFFECT_TYPE_IGNITION)
  e3:SetRange(LOCATION_MZONE)
  e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e3:SetCountLimit(1)
  e3:SetTarget(c99950040.tgtg)
  e3:SetOperation(c99950040.tgop)
  c:RegisterEffect(e3)
  --(4) Pay or Destroy
  local e4=Effect.CreateEffect(c)
  e4:SetDescription(aux.Stringid(99950040,1))
  e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
  e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
  e4:SetRange(LOCATION_MZONE)
  e4:SetCountLimit(1)
  e4:SetCondition(c99950040.paycon)
  e4:SetOperation(c99950040.payop)
  c:RegisterEffect(e4)
  --(5) To hand
  local e5=Effect.CreateEffect(c)
  e5:SetDescription(aux.Stringid(99950040,2))
  e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e5:SetType(EFFECT_TYPE_IGNITION)
  e5:SetRange(LOCATION_HAND)
  e5:SetCost(c99950040.thcost)
  e5:SetTarget(c99950040.thtg)
  e5:SetOperation(c99950040.thop)
  c:RegisterEffect(e5)
  --(6) Place in S/T Zone
  local e6=Effect.CreateEffect(c)
  e6:SetType(EFFECT_TYPE_SINGLE)
  e6:SetCode(EFFECT_TO_GRAVE_REDIRECT_CB)
  e6:SetProperty(EFFECT_FLAG_UNCOPYABLE)
  e6:SetCondition(c99950040.stzcon)
  e6:SetOperation(c99950040.stzop)
  c:RegisterEffect(e6)
  --(7) Gain ATK 3
  local e7=Effect.CreateEffect(c)
  e7:SetType(EFFECT_TYPE_FIELD)
  e7:SetRange(LOCATION_SZONE)
  e7:SetCode(EFFECT_UPDATE_ATTACK)
  e7:SetTargetRange(LOCATION_MZONE,0)
  e7:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x995))
  e7:SetCondition(c99950040.atkcon3)
  e7:SetValue(500)
  c:RegisterEffect(e7)
  --(8) Banish
  local e8=Effect.CreateEffect(c)
  e8:SetDescription(aux.Stringid(99950040,4))
  e8:SetCategory(CATEGORY_REMOVE)
  e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e8:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e8:SetCode(EVENT_TO_GRAVE)
  e8:SetCondition(c99950040.bancon)
  e8:SetTarget(c99950040.bantg)
  e8:SetOperation(c99950040.banop)
  c:RegisterEffect(e8)
end
--(1) Special Summon condition
function c99950040.splimit(e,se,sp,st)
  return se:GetHandler():IsSetCard(0x995)
end
--(2) Gain ATK 1
function c99950040.atkfilter1(c)
  return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c99950040.atkval1(e,c)
  return Duel.GetMatchingGroupCount(c99950040.atkfilter1,c:GetControler(),0,LOCATION_REMOVED,nil)*100
end
--(3) Send to GY
function c99950040.atkfilter2(c)
  return c:IsFaceup() and c:IsSetCard(0x995)
end
function c99950040.tgfilter(c)
  return c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c99950040.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingTarget(c99950040.atkfilter2,tp,LOCATION_MZONE,0,1,nil)
  and Duel.IsExistingMatchingCard(c99950040.tgfilter,tp,LOCATION_DECK,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  Duel.SelectTarget(tp,c99950040.atkfilter2,tp,LOCATION_MZONE,0,1,1,nil)
end
function c99950040.tgop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
  local g=Duel.SelectMatchingCard(tp,c99950040.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
  if g:GetCount()>0 then
    local gc=g:GetFirst()
    if Duel.SendtoGrave(gc,REASON_EFFECT)~=0 and gc:IsLocation(LOCATION_GRAVE) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
      local e1=Effect.CreateEffect(e:GetHandler())
      e1:SetType(EFFECT_TYPE_SINGLE)
      e1:SetCode(EFFECT_UPDATE_ATTACK)
      e1:SetValue(math.floor(tc:GetAttack()/2))
      e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
      tc:RegisterEffect(e1)
    end
  end
end
--(4) Pay or Destroy
function c99950040.paycon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetTurnPlayer()==tp
end
function c99950040.payop(e,tp,eg,ep,ev,re,r,rp)
  Duel.HintSelection(Group.FromCards(e:GetHandler()))
  if Duel.CheckLPCost(tp,300) and Duel.SelectYesNo(tp,aux.Stringid(99950040,1)) then
    Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(99950040,5))
    Duel.PayLPCost(tp,300)
  else
    Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(99950040,6))
    Duel.Destroy(e:GetHandler(),REASON_COST)
  end
end
--(5) To hand
function c99950040.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():IsDiscardable() end
  Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c99950040.thfilter(c)
  return c:IsSetCard(0x995) and c:GetType()==TYPE_SPELL+TYPE_RITUAL and c:IsAbleToHand()
end
function c99950040.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99950040.thfilter,tp,LOCATION_DECK,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99950040.thop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,c99950040.thfilter,tp,LOCATION_DECK,0,1,1,nil)
  if g:GetCount()>0 then
    Duel.SendtoHand(g,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,g)
  end
end
--(6) Place in S/T Zone
function c99950040.stzcon(e)
  local c=e:GetHandler()
  return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsReason(REASON_DESTROY)
end
function c99950040.stzop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  --Continuous Spell
  local e1=Effect.CreateEffect(c)
  e1:SetCode(EFFECT_CHANGE_TYPE)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
  e1:SetReset(RESET_EVENT+0x1fc0000)
  e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
  c:RegisterEffect(e1)
  Duel.RaiseEvent(c,EVENT_CUSTOM+99950150,e,0,tp,0,0)
end
--(7) Gain ATK 3
function c99950040.atkcon3(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsType(TYPE_SPELL+TYPE_CONTINUOUS) and not e:GetHandler():IsType(TYPE_EQUIP)
end
--(8) Banish
function c99950040.bancon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsReason(REASON_EFFECT) and e:GetHandler():GetPreviousLocation()==LOCATION_DECK
end
function c99950040.banfilter(c)
  return c:IsFaceup() and c:IsAbleToRemove()
end
function c99950040.bantg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
  local g=Duel.SelectTarget(tp,c99950040.banfilter,tp,0,LOCATION_MZONE,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c99950040.banop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc and tc:IsRelateToEffect(e) then
    Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
  end
end