--DAL Eden's Flares
--Scripted by Raivost
function c99970450.initial_effect(c)
  --(1) Activate
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
  e1:SetCode(EVENT_DESTROYED)
  e1:SetCountLimit(1,99970450)
  e1:SetCondition(c99970450.accon)
  e1:SetOperation(c99970450.acop)
  c:RegisterEffect(e1)
  --(2) Return
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99970450,0))
  e2:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetRange(LOCATION_GRAVE)
  e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e2:SetCountLimit(1,99970451)
  e2:SetCondition(aux.exccon)
  e2:SetCost(aux.bfgcost)
  e2:SetTarget(c99970450.rttg)
  e2:SetOperation(c99970450.rtop)
  c:RegisterEffect(e2)
end
function c99970450.acfilter(c,tp)
  return (c:IsReason(REASON_BATTLE) or (c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()~=tp)) 
  and c:IsSetCard(0x997) and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp 
end
function c99970450.accon(e,tp,eg,ep,ev,re,r,rp)
  return eg:IsExists(c99970450.acfilter,1,nil,tp)
end
function c99970450.acop(e,tp,eg,ep,ev,re,r,rp)
  --(1.1) Destroy
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e1:SetCode(EVENT_PHASE+PHASE_END)
  e1:SetReset(RESET_PHASE+PHASE_END)
  e1:SetCountLimit(1)
  e1:SetTarget(c99970450.destg)
  e1:SetOperation(c99970450.desop)
  Duel.RegisterEffect(e1,tp)
end
--(1.1) Destroy
function c99970450.desfilter(c)
  return bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL
end
function c99970450.destg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99970450.desfilter,tp,0,LOCATION_MZONE,1,nil) end
  local g=Duel.GetMatchingGroup(c99970450.desfilter,tp,0,LOCATION_MZONE,nil)
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
  Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetCount()*1000)
end
function c99970450.damfilter(c)
  return c:IsSetCard(0x997) and c:IsType(TYPE_MONSTER)
end
function c99970450.desop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_CARD,0,99970450)
  local g=Duel.GetMatchingGroup(c99970450.desfilter,tp,0,LOCATION_MZONE,nil)
  Duel.Destroy(g,REASON_EFFECT)
end
--(2) Return
function c99970450.thfilter(c)
  return c:IsSetCard(0x997) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c99970450.tdfilter(c)
  return c:IsSetCard(0x997) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c99970450.rttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return false end
  if chk==0 then return Duel.IsExistingTarget(c99970450.thfilter,tp,LOCATION_GRAVE,0,1,nil)
  and Duel.IsExistingTarget(c99970450.tdfilter,tp,LOCATION_GRAVE,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g1=Duel.SelectTarget(tp,c99970450.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
  local g2=Duel.SelectTarget(tp,c99970450.tdfilter,tp,LOCATION_GRAVE,0,1,1,g1:GetFirst())
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,1,0,0)
  Duel.SetOperationInfo(0,CATEGORY_TODECK,g2,1,0,0)
end
function c99970450.rtop(e,tp,eg,ep,ev,re,r,rp)
  local ex,g1=Duel.GetOperationInfo(0,CATEGORY_TOHAND)
  local ex,g2=Duel.GetOperationInfo(0,CATEGORY_TODECK)
  if g1:GetFirst():IsRelateToEffect(e) then
    Duel.SendtoHand(g1,nil,REASON_EFFECT)
  end
  if g2:GetFirst():IsRelateToEffect(e) then
    Duel.SendtoDeck(g2,nil,2,REASON_EFFECT)
  end
end