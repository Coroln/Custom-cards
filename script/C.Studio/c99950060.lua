--MSMM Sakura Kyouko
--Scripted by Raivost
function c99950060.initial_effect(c)
  c:EnableReviveLimit()
  --(1) Special Summon condition
  local e1=Effect.CreateEffect(c)
  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_SPSUMMON_CONDITION)
  e1:SetValue(c99950060.splimit)
  c:RegisterEffect(e1)
  --(2) Gain ATK
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE)
  e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCode(EFFECT_UPDATE_ATTACK)
  e2:SetValue(c99950060.atkval)
  c:RegisterEffect(e2)
  --(3) Inflict damage 1
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99950060,0))
  e3:SetCategory(CATEGORY_DAMAGE)
  e3:SetType(EFFECT_TYPE_IGNITION)
  e3:SetRange(LOCATION_MZONE)
  e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_PLAYER_TARGET)
  e3:SetCountLimit(1)
  e3:SetTarget(c99950060.damtg1)
  e3:SetOperation(c99950060.damop1)
  c:RegisterEffect(e3)
  --(4) Pay or Destroy
  local e4=Effect.CreateEffect(c)
  e4:SetDescription(aux.Stringid(99950060,1))
  e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
  e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
  e4:SetRange(LOCATION_MZONE)
  e4:SetCountLimit(1)
  e4:SetCondition(c99950060.paycon)
  e4:SetOperation(c99950060.payop)
  c:RegisterEffect(e4)
  --(5) To hand
  local e5=Effect.CreateEffect(c)
  e5:SetDescription(aux.Stringid(99950060,2))
  e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e5:SetType(EFFECT_TYPE_IGNITION)
  e5:SetRange(LOCATION_HAND)
  e5:SetCost(c99950060.thcost)
  e5:SetTarget(c99950060.thtg)
  e5:SetOperation(c99950060.thop)
  c:RegisterEffect(e5)
  --(6) Place in S/T Zone
  local e6=Effect.CreateEffect(c)
  e6:SetType(EFFECT_TYPE_SINGLE)
  e6:SetCode(EFFECT_TO_GRAVE_REDIRECT_CB)
  e6:SetProperty(EFFECT_FLAG_UNCOPYABLE)
  e6:SetCondition(c99950060.stzcon)
  e6:SetOperation(c99950060.stzop)
  c:RegisterEffect(e6)
  --(7) Inflict damage 2
  local e7=Effect.CreateEffect(c)
  e7:SetDescription(aux.Stringid(99950060,3))
  e7:SetCategory(CATEGORY_DAMAGE)
  e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
  e7:SetCode(EVENT_BATTLED)
  e7:SetRange(LOCATION_SZONE)
  e7:SetCondition(c99950060.damcon2)
  e7:SetTarget(c99950060.damtg2)
  e7:SetOperation(c99950060.damop2)
  c:RegisterEffect(e7)
  --(8) Banish
  local e8=Effect.CreateEffect(c)
  e8:SetDescription(aux.Stringid(99950060,4))
  e8:SetCategory(CATEGORY_REMOVE)
  e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e8:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e8:SetCode(EVENT_TO_GRAVE)
  e8:SetCondition(c99950060.bancon)
  e8:SetTarget(c99950060.bantg)
  e8:SetOperation(c99950060.banop)
  c:RegisterEffect(e8)
end
--(1) Special Summon condition
function c99950060.splimit(e,se,sp,st)
  return se:GetHandler():IsSetCard(0x995)
end
--(2) Gain ATK
function c99950060.atkfilter(c)
  return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c99950060.atkval(e,c)
  return Duel.GetMatchingGroupCount(c99950060.atkfilter,c:GetControler(),0,LOCATION_REMOVED,nil)*100
end
--(3) Inflict damage
function c99950060.damfilter1(c)
  return c:IsFaceup() and c:IsSetCard(0x995)
end
function c99950060.damtg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingTarget(c99950060.damfilter1,tp,LOCATION_MZONE,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  local g=Duel.SelectTarget(tp,c99950060.damfilter1,tp,LOCATION_MZONE,0,1,1,nil)
  local atk=g:GetFirst():GetAttack()/2
  Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,atk)
end
function c99950060.damop1(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and tc:IsFaceup() then
    local atk=math.floor(tc:GetAttack()/2)
    if atk<0 then atk=0 end
    Duel.Damage(1-tp,atk,REASON_EFFECT)
  end
end
--(4) Pay or Destroy
function c99950060.paycon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetTurnPlayer()==tp
end
function c99950060.payop(e,tp,eg,ep,ev,re,r,rp)
  Duel.HintSelection(Group.FromCards(e:GetHandler()))
  if Duel.CheckLPCost(tp,300) and Duel.SelectYesNo(tp,aux.Stringid(99950060,1)) then
    Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(99950060,5))
    Duel.PayLPCost(tp,300)
  else
    Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(99950060,6))
    Duel.Destroy(e:GetHandler(),REASON_COST)
  end
end
--(5) To hand
function c99950060.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():IsDiscardable() end
  Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c99950060.thfilter(c)
  return c:IsSetCard(0x995) and c:GetType()==TYPE_SPELL+TYPE_RITUAL and c:IsAbleToHand()
end
function c99950060.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99950060.thfilter,tp,LOCATION_DECK,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99950060.thop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,c99950060.thfilter,tp,LOCATION_DECK,0,1,1,nil)
  if g:GetCount()>0 then
    Duel.SendtoHand(g,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,g)
  end
end
--(6) Place in S/T Zone
function c99950060.stzcon(e)
  local c=e:GetHandler()
  return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsReason(REASON_DESTROY)
end
function c99950060.stzop(e,tp,eg,ep,ev,re,r,rp)
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
--(7) Inflict damage 2
function c99950060.damcon2(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsType(TYPE_SPELL+TYPE_CONTINUOUS) and not e:GetHandler():IsType(TYPE_EQUIP)
end
function c99950060.check(c,tp)
  return c and c:IsControler(tp) and c:IsSetCard(0x995)
end
function c99950060.damfilter2(c)
  return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c99950060.damtg2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetAttackTarget()~=nil
  and (c99950060.check(Duel.GetAttacker(),tp) or c99950060.check(Duel.GetAttackTarget(),tp)) end
  local val=Duel.GetMatchingGroupCount(c99950060.damfilter2,tp,0,LOCATION_REMOVED,nil)
  Duel.SetTargetPlayer(1-tp)
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,val*100)
end
function c99950060.damop2(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
  local val=Duel.GetMatchingGroupCount(c99950060.damfilter2,tp,0,LOCATION_REMOVED,nil)
  Duel.Damage(p,val*100,REASON_EFFECT)
end
--(8) Banish
function c99950060.bancon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsReason(REASON_EFFECT) and e:GetHandler():GetPreviousLocation()==LOCATION_DECK
end
function c99950060.banfilter(c)
  return c:IsFaceup() and c:IsAbleToRemove()
end
function c99950060.bantg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
  local g=Duel.SelectTarget(tp,c99950060.banfilter,tp,0,LOCATION_MZONE,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c99950060.banop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc and tc:IsRelateToEffect(e) then
    Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
  end
end