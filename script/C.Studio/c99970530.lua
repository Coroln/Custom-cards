--DAL Spirits' Defender
--Scripted by Raivost
function c99970530.initial_effect(c)
  --(1) Activate
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99970530,0))
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCost(c99970530.accost)
  e1:SetOperation(c99970530.accop)
  c:RegisterEffect(e1)
  --(2) Act in hand
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE)
  e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
  e2:SetCondition(c99970530.handcon)
  c:RegisterEffect(e2)
end
--(1) Activate
function c99970530.accostfilter(c)
  return c:IsCode(99970090) and c:IsAbleToRemoveAsCost()
end
function c99970530.accost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99970530.accostfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
  local g=Duel.SelectMatchingCard(tp,c99970530.accostfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
  local tg=g:GetFirst()
  Duel.Remove(g,POS_FACEUP,REASON_COST)
  --(1.1) To hand
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e1:SetRange(LOCATION_REMOVED)
  e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
  e1:SetCountLimit(1)
  e1:SetCondition(c99970530.tdcon)
  e1:SetOperation(c99970530.tdop)
  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
  tg:RegisterEffect(e1)
end
--(1.1) To hand
function c99970530.tdcon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetTurnPlayer()==tp
end
function c99970530.tdop(e,tp,eg,ep,ev,re,r,rp)
  Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
end
function c99970530.accop(e,tp,eg,ep,ev,re,r,rp)
  --(1.2) Effect indes 
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
  e1:SetTargetRange(LOCATION_PZONE,0)
  e1:SetTarget(c99970530.indtg)
  e1:SetValue(c99970530.indval)
  e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
  Duel.RegisterEffect(e1,tp)
  --(1.3) Cannot target
  local e2=e1:Clone()
  e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
  e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
  e2:SetValue(aux.tgoval)
  Duel.RegisterEffect(e2,tp)
end
--(1.2) Effect indes 
function c99970530.indtg(e,c)
  return c:IsSetCard(0x997)
end
function c99970530.indval(e,re,rp)
  return rp~=e:GetHandlerPlayer()
end
--(2) Act in hand
function c99970530.handcon(e)
  local tp=e:GetHandlerPlayer()
  local tc1=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
  local tc2=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
  return (tc1 and tc1:IsSetCard(0x2A97)) or (tc2 and tc2:IsSetCard(0x2A97)) 
end