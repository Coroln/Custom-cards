--DAL Inverse Spirit - Demon Lord
--Scripted by Raivost
function c99970350.initial_effect(c)
  c:EnableReviveLimit()
  --(1) Special Summon from hand
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99970350,0))
  e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetRange(LOCATION_HAND)
  e1:SetCode(EFFECT_SPSUMMON_PROC)
  e1:SetCondition(c99970350.hspcon)
  e1:SetOperation(c99970350.hspop)
  c:RegisterEffect(e1)
  --(2) Destroy
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99970350,1))
  e2:SetCategory(CATEGORY_DESTROY)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e2:SetProperty(EFFECT_FLAG_DELAY)
  e2:SetCode(EVENT_SPSUMMON_SUCCESS)
  e2:SetCondition(c99970350.descon)
  e2:SetTarget(c99970350.destg)
  e2:SetOperation(c99970350.desop)
  c:RegisterEffect(e2)
  --(3) Destroy replace
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
  e3:SetCode(EFFECT_DESTROY_REPLACE)
  e3:SetCountLimit(1)
  e3:SetTarget(c99970350.dreptg)
  e3:SetOperation(c99970350.drepop)
  c:RegisterEffect(e3)
  --(4) Cannot activate S/T
  local e4=Effect.CreateEffect(c)
  e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
  e4:SetCode(EVENT_ATTACK_ANNOUNCE)
  e4:SetOperation(c99970350.acop)
  c:RegisterEffect(e4)
end
--(1) Special Summon from hand
function c99970350.hspconfilter(c,ft)
  return c:IsFaceup() and c:IsCode(99970030) and c:IsAbleToRemoveAsCost() and (ft>0 or c:GetSequence()<5)
end
function c99970350.hspcon(e,c)
  if c==nil then return true end
  local tp=c:GetControler()
  local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
  return ft>-1 and Duel.IsExistingMatchingCard(c99970350.hspconfilter,tp,LOCATION_MZONE,0,1,nil,ft)
end
function c99970350.hspop(e,tp,eg,ep,ev,re,r,rp,c)
  local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
  local g=Duel.SelectMatchingCard(tp,c99970350.hspconfilter,tp,LOCATION_MZONE,0,1,1,nil,ft)
  Duel.Remove(g,POS_FACEUP,REASON_COST)
end
--(2) Destroy
function c99970350.descon(e,tp,eg,ep,ev,re,r,rp)
  return re and re:GetHandler():IsSetCard(0x997) and not (e:GetHandler():GetSummonType()==SUMMON_TYPE_PENDULUM)
end
function c99970350.desfilter(c)
  return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c99970350.destg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99970350.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  local g=Duel.GetMatchingGroup(c99970350.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c99970350.desop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local g=Duel.GetMatchingGroup(c99970350.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
  local ct=Duel.Destroy(g,REASON_EFFECT)
  if ct>0 then
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(ct*300)
    e1:SetReset(RESET_EVENT+0x1ff0000)
    c:RegisterEffect(e1)
  end
end
--(3) Destroy replace
function c99970350.drepfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x997) and not c:IsStatus(STATUS_DESTROY_CONFIRMED)
end
function c99970350.dreptg(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
  if chk==0 then return not c:IsReason(REASON_REPLACE) and c:IsOnField() and c:IsFaceup()
  and Duel.IsExistingMatchingCard(c99970350.drepfilter,tp,LOCATION_ONFIELD,0,1,c) end
  if Duel.SelectEffectYesNo(tp,c,96) then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
    local g=Duel.SelectMatchingCard(tp,c99970350.drepfilter,tp,LOCATION_ONFIELD,0,1,1,c)
    Duel.SetTargetCard(g)
    g:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,true)
    return true
  else return false end
end
function c99970350.drepop(e,tp,eg,ep,ev,re,r,rp)
  local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
  g:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,false)
  Duel.Destroy(g,REASON_EFFECT+REASON_REPLACE)
end
--(4) Cannot activate S/T
function c99970350.acop(e,tp,eg,ep,ev,re,r,rp)
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e1:SetCode(EFFECT_CANNOT_ACTIVATE)
  e1:SetTargetRange(0,1)
  e1:SetValue(c99970350.aclimit)
  e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
  Duel.RegisterEffect(e1,tp)
end
function c99970350.aclimit(e,re,tp)
  return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end