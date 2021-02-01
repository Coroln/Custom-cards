--MSMM Tomoe Mami
--Scripted by Raivost
function c99950050.initial_effect(c)
  c:EnableReviveLimit()
  --(1) Special Summon condition
  local e1=Effect.CreateEffect(c)
  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_SPSUMMON_CONDITION)
  e1:SetValue(c99950050.splimit)
  c:RegisterEffect(e1)
  --(2) Gain ATK
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE)
  e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCode(EFFECT_UPDATE_ATTACK)
  e2:SetValue(c99950050.atkval)
  c:RegisterEffect(e2)
  --(3) To hand 1
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99950050,0))
  e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e3:SetType(EFFECT_TYPE_IGNITION)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCountLimit(1)
  e3:SetTarget(c99950050.thtg1)
  e3:SetOperation(c99950050.thop1)
  c:RegisterEffect(e3)
  --(4) Pay or Destroy
  local e4=Effect.CreateEffect(c)
  e4:SetDescription(aux.Stringid(99950050,1))
  e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
  e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
  e4:SetRange(LOCATION_MZONE)
  e4:SetCountLimit(1)
  e4:SetCondition(c99950050.paycon)
  e4:SetOperation(c99950050.payop)
  c:RegisterEffect(e4)
  --(5) To hand 2
  local e5=Effect.CreateEffect(c)
  e5:SetDescription(aux.Stringid(99950050,2))
  e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e5:SetType(EFFECT_TYPE_IGNITION)
  e5:SetRange(LOCATION_HAND)
  e5:SetCost(c99950050.thcost2)
  e5:SetTarget(c99950050.thtg2)
  e5:SetOperation(c99950050.thop2)
  c:RegisterEffect(e5)
  --(6) Place in S/T Zone
  local e6=Effect.CreateEffect(c)
  e6:SetType(EFFECT_TYPE_SINGLE)
  e6:SetCode(EFFECT_TO_GRAVE_REDIRECT_CB)
  e6:SetProperty(EFFECT_FLAG_UNCOPYABLE)
  e6:SetCondition(c99950050.stzcon)
  e6:SetOperation(c99950050.stzop)
  c:RegisterEffect(e6)
  --(7) Banish 1
  local e7=Effect.CreateEffect(c)
  e7:SetDescription(aux.Stringid(99950050,3))
  e7:SetCategory(CATEGORY_REMOVE)
  e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e7:SetRange(LOCATION_SZONE)
  e7:SetCode(EVENT_PHASE+PHASE_STANDBY)
  e7:SetCountLimit(1)
  e7:SetCondition(c99950050.bancon1)
  e7:SetTarget(c99950050.bantg1)
  e7:SetOperation(c99950050.banop1)
  c:RegisterEffect(e7)
  --(8) Banish 2
  local e8=Effect.CreateEffect(c)
  e8:SetDescription(aux.Stringid(99950050,4))
  e8:SetCategory(CATEGORY_REMOVE)
  e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e8:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e8:SetCode(EVENT_TO_GRAVE)
  e8:SetCondition(c99950050.bancon2)
  e8:SetTarget(c99950050.bantg2)
  e8:SetOperation(c99950050.banop2)
  c:RegisterEffect(e8)
end
--(1) Special Summon condition
function c99950050.splimit(e,se,sp,st)
  return se:GetHandler():IsSetCard(0x995)
end
--(2) Gain ATK
function c99950050.atkfilter(c)
  return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c99950050.atkval(e,c)
  return Duel.GetMatchingGroupCount(c99950050.atkfilter,c:GetControler(),0,LOCATION_REMOVED,nil)*100
end
--(3) To hand 1
function c99950050.thfilter1(c)
  return c:IsSetCard(0x995) and c:IsAbleToHand()
end
function c99950050.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99950050.thfilter1,tp,LOCATION_DECK,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99950050.thop1(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,c99950050.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
  if g:GetCount()>0 then
    Duel.SendtoHand(g,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,g)
  end
end
--(4) Pay or Destroy
function c99950050.paycon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetTurnPlayer()==tp
end
function c99950050.payop(e,tp,eg,ep,ev,re,r,rp)
  Duel.HintSelection(Group.FromCards(e:GetHandler()))
  if Duel.CheckLPCost(tp,300) and Duel.SelectYesNo(tp,aux.Stringid(99950050,1)) then
    Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(99950050,5))
    Duel.PayLPCost(tp,300)
  else
    Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(99950050,6))
    Duel.Destroy(e:GetHandler(),REASON_COST)
  end
end
--(5) To hand 2
function c99950050.thcost2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():IsDiscardable() end
  Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c99950050.thfilter2(c)
  return c:IsSetCard(0x995) and c:GetType()==TYPE_SPELL+TYPE_RITUAL and c:IsAbleToHand()
end
function c99950050.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99950050.thfilter2,tp,LOCATION_DECK,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99950050.thop2(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,c99950050.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
  if g:GetCount()>0 then
    Duel.SendtoHand(g,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,g)
  end
end
--(6) Place in Spell/Trap Zone
function c99950050.stzcon(e)
  local c=e:GetHandler()
  return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsReason(REASON_DESTROY)
end
function c99950050.stzop(e,tp,eg,ep,ev,re,r,rp)
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
--(7) Banish 1
function c99950050.bancon1(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsType(TYPE_SPELL+TYPE_CONTINUOUS) and not e:GetHandler():IsType(TYPE_EQUIP) 
  and Duel.GetTurnPlayer()==tp
end
function c99950050.bantg1(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_HAND)
end
function c99950050.banop1(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
  if g:GetCount()==0 then return end
  local sg=g:RandomSelect(tp,1)
  Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
end
--(8) Banish 2
function c99950050.bancon2(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsReason(REASON_EFFECT) and e:GetHandler():GetPreviousLocation()==LOCATION_DECK
end
function c99950050.banfilter2(c)
  return c:IsFaceup() and c:IsAbleToRemove()
end
function c99950050.bantg2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
  local g=Duel.SelectTarget(tp,c99950050.banfilter2,tp,0,LOCATION_MZONE,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c99950050.banop2(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc and tc:IsRelateToEffect(e) then
    Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
  end
end