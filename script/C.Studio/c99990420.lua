--SAO Tense Strategy
--Scripted by Raivost
local s,id=GetID()
function s.initial_effect(c)
  --(1) Apply effects
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(id,0))
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
  e1:SetCost(s.aecost)
  e1:SetTarget(s.aetg)
  e1:SetOperation(s.aeop)
  c:RegisterEffect(e1)
end
--(1) Apply effects
function s.aecostfilter(c)
  return c:GetCounter(0x1999)>0
end
function s.aecost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetCounter(tp,1,0,0x1999)>0 end
  local g=Duel.GetMatchingGroup(s.aecostfilter,tp,LOCATION_ONFIELD,0,nil)
  local ct=0
  for tc in aux.Next(g) do
    local sct=tc:GetCounter(0x1999)
    tc:RemoveCounter(tp,0x1999,sct,0)
    ct=ct+sct
  end
  e:SetLabel(ct)
end
function s.aetg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,0))
end
function s.atkfilter(e,c)
  return c:IsSetCard(0x999) and c:IsType(TYPE_MONSTER)
end
function s.aeop(e,tp,eg,ep,ev,re,r,rp)
  local ct=e:GetLabel()
  --(1.1) Gain ATK
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetTargetRange(LOCATION_MZONE,0)
  e1:SetTarget(s.atkfilter)
  e1:SetValue(ct*200)
  e1:SetReset(RESET_PHASE+PHASE_END)
  Duel.RegisterEffect(e1,tp)
  if ct>=3 then
    --(1.2) Cannot be destroyed
    local e2=Effect.CreateEffect(e:GetHandler())
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x999))
    e2:SetValue(1)
    e2:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e2,tp)
  end
  if ct>=5 then
    --(1.3) Cannot activate
    local e3=Effect.CreateEffect(e:GetHandler())
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetCode(EFFECT_CANNOT_ACTIVATE)
    e3:SetTargetRange(0,1)
    e3:SetCondition(s.actcon)
    e3:SetValue(s.actlimit)
    e3:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e3,tp)
  end
end
--(1.3) Cannot activate
function s.actfilter(c,tp)
  return c:IsFaceup() and c:IsSetCard(0x999) and c:IsControler(tp)
end
function s.actcon(e)
  local tp=e:GetHandlerPlayer()
  local a=Duel.GetAttacker()
  local d=Duel.GetAttackTarget()
  return (a and s.actfilter(a,tp)) or (d and s.actfilter(d,tp))
end
function s.actlimit(e,re,tp)
  return not re:GetHandler():IsImmuneToEffect(e)
end