--BRS The Little Bird Of Colors
--Scripted by Raivost
function c99960150.initial_effect(c)
  --Activate
  local e0=Effect.CreateEffect(c)
  e0:SetType(EFFECT_TYPE_ACTIVATE)
  e0:SetCode(EVENT_FREE_CHAIN)
  c:RegisterEffect(e0)
  --(1) Gain LP
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_RECOVER)
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e1:SetRange(LOCATION_FZONE)
  e1:SetCode(EVENT_DAMAGE)
  e1:SetCondition(c99960150.reccon)
  e1:SetOperation(c99960150.recop)
  c:RegisterEffect(e1)
  --(2) Place in Spell/Trap Zone
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99960150,0))
  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e2:SetProperty(EFFECT_FLAG_DELAY)
  e2:SetCode(EVENT_SPSUMMON_SUCCESS)
  e2:SetRange(LOCATION_FZONE)
  e2:SetCondition(c99960150.stzcon)
  e2:SetTarget(c99960150.stztg)
  e2:SetOperation(c99960150.stzop)
  c:RegisterEffect(e2)
  --(3) Gain effects
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99960150,1))
  e3:SetType(EFFECT_TYPE_IGNITION)
  e3:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
  e3:SetRange(LOCATION_FZONE)
  e3:SetCountLimit(1)
  e3:SetCondition(c99960150.gecon)
  e3:SetCost(c99960150.gecost)
  e3:SetTarget(c99960150.getg)
  e3:SetOperation(c99960150.geop)
  c:RegisterEffect(e3)
end
--(1) Gain LP
function c99960150.reccon(e,tp,eg,ep,ev,re,r,rp)
  return ep~=tp and r&REASON_BATTLE==0 and re and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0x996)
end
function c99960150.recop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_CARD,0,99960150)
  Duel.Recover(tp,ev/2,REASON_EFFECT)
end
--(2) Place in Spell/Trap Zone
function c99960150.stzconfilter(c,tp)
  return c:IsFaceup() and c:IsSetCard(0x996) 
  and c:GetSummonPlayer()==tp and c:IsType(TYPE_XYZ)
end
function c99960150.stzcon(e,tp,eg,ep,ev,re,r,rp)
  return eg:IsExists(c99960150.stzconfilter,1,nil,tp)
end
function c99960150.stzfilter(c,tp)
  return c:GetType()==TYPE_SPELL+TYPE_CONTINUOUS and c:IsSetCard(0x1996) and not c:IsForbidden()
end
function c99960150.stztg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
  and Duel.IsExistingMatchingCard(c99960150.stzfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99960150.stzop(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
  local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c99960150.stzfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
  if tc then
    Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
  end
end
--(3) Gain effects
function c99960150.geconfilter(c)
  return c:GetType()==TYPE_SPELL+TYPE_CONTINUOUS and c:IsSetCard(0x1996)
end
function c99960150.gecon(e,tp,eg,ep,ev,re,r,rp)
  local g=Duel.GetMatchingGroup(c99960150.geconfilter,e:GetHandler():GetControler(),LOCATION_SZONE,0,nil)
  local ct=g:GetClassCount(Card.GetCode)
  return ct>4
end
function c99960150.gecostfilter(c)
  return c:GetType()==TYPE_SPELL+TYPE_CONTINUOUS and c:IsSetCard(0x1996) and c:IsAbleToGraveAsCost()
end
function c99960150.gecost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99960150.gecostfilter,tp,LOCATION_SZONE,0,1,nil) end
  local g=Duel.GetMatchingGroup(c99960150.gecostfilter,tp,LOCATION_SZONE,0,nil)
  Duel.SendtoGrave(g,REASON_COST)
end
function c99960150.getg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99960150.geop(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  local c=e:GetHandler()
  --(2.1) Gain ATK/DEF
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetRange(LOCATION_FZONE)
  e1:SetTargetRange(LOCATION_MZONE,0)
  e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x996))
  e1:SetValue(500)
  e1:SetReset(RESET_EVENT+0x1fe0000)
  c:RegisterEffect(e1)
  local e2=e1:Clone()
  e2:SetCode(EFFECT_UPDATE_DEFENSE)
  c:RegisterEffect(e2)
  --(2.2) Add to hand
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99960150,2))
  e3:SetCategory(CATEGORY_TOHAND)
  e3:SetType(EFFECT_TYPE_IGNITION)
  e3:SetRange(LOCATION_FZONE)
  e3:SetCountLimit(1)
  e3:SetCost(c99960150.thcost)
  e3:SetTarget(c99960150.thtg)
  e3:SetOperation(c99960150.thop)
  e3:SetReset(RESET_EVENT+0x1fe0000)
  c:RegisterEffect(e3)
  --(2.3) Destroy replace
  local e4=Effect.CreateEffect(c)
  e4:SetCategory(EFFECT_DESTROY_REPLACE)
  e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e4:SetCode(EFFECT_DESTROY_REPLACE)
  e4:SetRange(LOCATION_FZONE)
  e4:SetCountLimit(1)
  e4:SetTarget(c99960150.dreptg)
  e4:SetValue(c99960150.drepval)
  e4:SetReset(RESET_EVENT+0x1fe0000)
  c:RegisterEffect(e4)
end
--(2.2) Add to hand
function c99960150.thcfilter(c)
  return c:GetType()==TYPE_SPELL+TYPE_CONTINUOUS and c:IsSetCard(0x1996) and c:IsAbleToRemoveAsCost() and aux.SpElimFilter(c,true)
end
function c99960150.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99960150.thcfilter,tp,LOCATION_GRAVE,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
  local g=Duel.SelectMatchingCard(tp,c99960150.thcfilter,tp,LOCATION_GRAVE,0,1,1,nil)
  Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c99960150.thfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x996) and c:IsType(TYPE_XYZ) and c:GetOverlayCount()~=0
end
function c99960150.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingTarget(c99960150.thfilter,tp,LOCATION_MZONE,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  local g=Duel.SelectTarget(tp,c99960150.thfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c99960150.thop(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  local tc=Duel.GetFirstTarget()
  if tc:GetOverlayCount()==0 then return end
  local ct=tc:GetOverlayGroup()
  if Duel.SendtoHand(ct,nil,REASON_EFFECT)~=0 then
    Duel.Damage(1-tp,ct:GetCount()*500,REASON_EFFECT)
  end
end
--(2.3) Destroy replace
function c99960150.drepcfilter(c)
  return c:GetType()==TYPE_SPELL+TYPE_CONTINUOUS and c:IsSetCard(0x1996) and c:IsAbleToRemoveAsCost() and aux.SpElimFilter(c,true)
end
function c99960150.drepfilter(c,tp)
  return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) 
  and c:IsSetCard(0x996) and c:IsReason(REASON_EFFECT+REASON_BATTLE) 
end
function c99960150.dreptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return eg:IsExists(c99960150.drepfilter,1,nil,tp) end
  if Duel.IsExistingMatchingCard(c99960150.drepcfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
  local g=Duel.SelectMatchingCard(tp,c99960150.drepcfilter,tp,LOCATION_GRAVE,0,1,1,nil)
  Duel.Remove(g,POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
  return true
  else return false end
end
function c99960150.drepval(e,c)
  return c99960150.drepfilter(c,e:GetHandlerPlayer())
end