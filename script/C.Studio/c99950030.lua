--MSMM Akemi Homura
--Scripted by Raivost
function c99950030.initial_effect(c)
  c:EnableReviveLimit()
  --(1) Special Summon condition
  local e1=Effect.CreateEffect(c)
  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_SPSUMMON_CONDITION)
  e1:SetValue(c99950030.splimit)
  c:RegisterEffect(e1)
  --(2) Gain ATK
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE)
  e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCode(EFFECT_UPDATE_ATTACK)
  e2:SetValue(c99950030.atkval)
  c:RegisterEffect(e2)
  --(3) Excavate
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99950030,0))
  e2:SetCategory(CATEGORY_DECKDES)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCountLimit(1)
  e2:SetTarget(c99950030.excatg)
  e2:SetOperation(c99950030.excaop)
  c:RegisterEffect(e2)
  --(4) Pay or Destroy
  local e4=Effect.CreateEffect(c)
  e4:SetDescription(aux.Stringid(99950030,1))
  e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
  e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
  e4:SetRange(LOCATION_MZONE)
  e4:SetCountLimit(1)
  e4:SetCondition(c99950030.paycon)
  e4:SetOperation(c99950030.payop)
  c:RegisterEffect(e4)
  --(5) To hand
  local e5=Effect.CreateEffect(c)
  e5:SetDescription(aux.Stringid(99950030,2))
  e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e5:SetType(EFFECT_TYPE_IGNITION)
  e5:SetRange(LOCATION_HAND)
  e5:SetCost(c99950030.thcost)
  e5:SetTarget(c99950030.thtg)
  e5:SetOperation(c99950030.thop)
  c:RegisterEffect(e5)
  --(6) Place in S/T Zone
  local e6=Effect.CreateEffect(c)
  e6:SetType(EFFECT_TYPE_SINGLE)
  e6:SetCode(EFFECT_TO_GRAVE_REDIRECT_CB)
  e6:SetProperty(EFFECT_FLAG_UNCOPYABLE)
  e6:SetCondition(c99950030.stzcon)
  e6:SetOperation(c99950030.stzop)
  c:RegisterEffect(e6)
  --(7) Unaffected
  local e7=Effect.CreateEffect(c)
  e7:SetDescription(aux.Stringid(99950030,3))
  e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e7:SetCode(EVENT_PHASE+PHASE_END)
  e7:SetRange(LOCATION_SZONE)
  e7:SetCountLimit(1)
  e7:SetCondition(c99950030.unfcon)
  e7:SetTarget(c99950030.unftg)
  e7:SetOperation(c99950030.unfop)
  c:RegisterEffect(e7)
  --(8) Banish
  local e8=Effect.CreateEffect(c)
  e8:SetDescription(aux.Stringid(99950030,4))
  e8:SetCategory(CATEGORY_REMOVE)
  e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e8:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e8:SetCode(EVENT_TO_GRAVE)
  e8:SetCondition(c99950030.bancon)
  e8:SetTarget(c99950030.bantg)
  e8:SetOperation(c99950030.banop)
  c:RegisterEffect(e8)
end
--(1) Special Summon condition
function c99950030.splimit(e,se,sp,st)
  return se:GetHandler():IsSetCard(0x995)
end
--(2) Gain ATK
function c99950030.atkfilter(c)
  return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c99950030.atkval(e,c)
  return Duel.GetMatchingGroupCount(c99950030.atkfilter,c:GetControler(),0,LOCATION_REMOVED,nil)*100
end
--(3) Excavate
function c99950030.excatg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsPlayerCanDiscardDeck(1-tp,3) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_DECKDES,0,0,1-tp,1)
end
function c99950030.tgfilter(c)
  return c:IsType(TYPE_MONSTER)
end
function c99950030.excaop(e,tp,eg,ep,ev,re,r,rp)
  if not Duel.IsPlayerCanDiscardDeck(1-tp,3) then return end
  Duel.ConfirmDecktop(1-tp,3)
  local g=Duel.GetDecktopGroup(1-tp,3)
  local sg=g:Filter(c99950030.tgfilter,nil)
  if sg:GetCount()>0 then
    Duel.DisableShuffleCheck()
    Duel.SendtoGrave(sg,REASON_EFFECT+REASON_REVEAL)
    for tc in aux.Next(sg) do
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_CANNOT_TRIGGER)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
    e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
    tc:RegisterEffect(e1)
    end
  end
  Duel.ShuffleDeck(1-tp)
end
--(4) Pay or Destroy
function c99950030.paycon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetTurnPlayer()==tp
end
function c99950030.payop(e,tp,eg,ep,ev,re,r,rp)
  Duel.HintSelection(Group.FromCards(e:GetHandler()))
  if Duel.CheckLPCost(tp,300) and Duel.SelectYesNo(tp,aux.Stringid(99950030,1)) then
    Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(99950030,5))
    Duel.PayLPCost(tp,300)
  else
    Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(99950030,6))
    Duel.Destroy(e:GetHandler(),REASON_COST)
  end
end
--(5) To hand
function c99950030.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():IsDiscardable() end
  Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c99950030.thfilter(c)
  return c:IsSetCard(0x995) and c:GetType()==TYPE_SPELL+TYPE_RITUAL and c:IsAbleToHand()
end
function c99950030.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99950030.thfilter,tp,LOCATION_DECK,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99950030.thop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,c99950030.thfilter,tp,LOCATION_DECK,0,1,1,nil)
  if g:GetCount()>0 then
    Duel.SendtoHand(g,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,g)
  end
end
--(6) Place in S/T Zone
function c99950030.stzcon(e)
  local c=e:GetHandler()
  return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsReason(REASON_DESTROY)
end
function c99950030.stzop(e,tp,eg,ep,ev,re,r,rp)
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
--(7) Unaffected
function c99950030.unfcon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsType(TYPE_SPELL+TYPE_CONTINUOUS) and not e:GetHandler():IsType(TYPE_EQUIP)
  and Duel.GetTurnPlayer()==tp
end
function c99950030.unffilter(c)
  return c:IsFaceup() and c:IsSetCard(0x995)
end
function c99950030.unftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingTarget(c99950030.unffilter,tp,LOCATION_MZONE,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  Duel.SelectTarget(tp,c99950030.unffilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c99950030.unfop(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsControler(tp) then
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetDescription(aux.Stringid(99950030,3))
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_IMMUNE_EFFECT)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
    e1:SetRange(LOCATION_MZONE)
    e1:SetValue(c99950030.unfilter)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
    e1:SetOwnerPlayer(tp)
    tc:RegisterEffect(e1)
  end
end
function c99950030.unfilter(e,re)
  return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
--(8) Banish
function c99950030.bancon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsReason(REASON_EFFECT) and e:GetHandler():GetPreviousLocation()==LOCATION_DECK
end
function c99950030.banfilter(c)
  return c:IsFaceup() and c:IsAbleToRemove()
end
function c99950030.bantg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
  local g=Duel.SelectTarget(tp,c99950030.banfilter,tp,0,LOCATION_MZONE,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c99950030.banop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc and tc:IsRelateToEffect(e) then
    Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
  end
end