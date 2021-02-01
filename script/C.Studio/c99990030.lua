--SAO Aincrad
--Scripted by Raivost
local s,id=GetID()
function s.initial_effect(c)
  --Enable counter(s)
  c:EnableCounterPermit(0x1999)
  --(0) Activate
  local e0=Effect.CreateEffect(c)
  e0:SetType(EFFECT_TYPE_ACTIVATE)
  e0:SetCode(EVENT_FREE_CHAIN)
  c:RegisterEffect(e0)
  --(1) Place counter(s)
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e1:SetRange(LOCATION_FZONE)
  e1:SetCode(EVENT_SUMMON_SUCCESS)
  e1:SetOperation(s.pctop)
  c:RegisterEffect(e1)
  local e2=e1:Clone()
  e2:SetCode(EVENT_SPSUMMON_SUCCESS)
  c:RegisterEffect(e2)
  --(2) Gain ATK/DEF
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_FIELD)
  e3:SetCode(EFFECT_UPDATE_ATTACK)
  e3:SetRange(LOCATION_FZONE)
  e3:SetTargetRange(LOCATION_MZONE,0)
  e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x999))
  e3:SetValue(s.atkval)
  c:RegisterEffect(e3)
  local e4=e3:Clone()
  e4:SetCode(EFFECT_UPDATE_DEFENSE)
  c:RegisterEffect(e4)
  --(3) Destroy replace
  local e5=Effect.CreateEffect(c)
  e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
  e5:SetCode(EFFECT_DESTROY_REPLACE)
  e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e5:SetRange(LOCATION_FZONE)
  e5:SetCountLimit(1)
  e5:SetTarget(s.dreptg)
  e5:SetOperation(s.drepop)
  c:RegisterEffect(e5)
end
--(1) Place counter(s)
function s.pctfilter(c,tp)
  return c:GetSummonPlayer()==tp and c:IsControler(tp)
end
function s.pctop(e,tp,eg,ep,ev,re,r,rp)
  local ct=eg:FilterCount(s.pctfilter,nil,1-tp)
  if ct>0 then
    e:GetHandler():AddCounter(0x1999,ct,true)
  end
end
--(2) Gain ATK/DEF
function s.atkval(e,c)
  return e:GetHandler():GetCounter(0x1999)*100
end
--(3) Destroy replace
function s.dreptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return not e:GetHandler():IsReason(REASON_REPLACE+REASON_RULE)
  and e:GetHandler():IsCanRemoveCounter(tp,0x1999,3,REASON_EFFECT) end
  return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function s.drepop(e,tp,eg,ep,ev,re,r,rp)
  e:GetHandler():RemoveCounter(tp,0x1999,3,REASON_EFFECT)
end