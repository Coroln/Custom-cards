--DAL Spirit Comrade
--Scripted by Raivost
function c99970260.initial_effect(c)
  c:SetUniqueOnField(1,0,99970260)
  --Activate
  local e0=Effect.CreateEffect(c)
  e0:SetType(EFFECT_TYPE_ACTIVATE)
  e0:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
  e0:SetHintTiming(TIMING_DAMAGE_STEP)
  e0:SetCode(EVENT_FREE_CHAIN)
  c:RegisterEffect(e0)
  --(1) Gain ATK/DEF
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetRange(LOCATION_SZONE)
  e1:SetTargetRange(LOCATION_MZONE,0)
  e1:SetTarget(c99970260.atktg)
  e1:SetValue(c99970260.atkval)
  c:RegisterEffect(e1)
  local e2=e1:Clone()
  e2:SetCode(EFFECT_UPDATE_DEFENSE)
  c:RegisterEffect(e2)
  --(2) Battle Indes
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_FIELD)
  e3:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
  e3:SetRange(LOCATION_SZONE)
  e3:SetTargetRange(LOCATION_MZONE,0)
  e3:SetCondition(c99970260.indcon)
  e3:SetTarget(c99970260.indtarget)
  e3:SetValue(c99970260.indct)
  c:RegisterEffect(e3)
  --(3) Set Trap
  local e4=Effect.CreateEffect(c)
  e4:SetDescription(aux.Stringid(99970260,0))
  e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e4:SetProperty(EFFECT_FLAG_DELAY)
  e4:SetCode(EVENT_DESTROYED)
  e4:SetCondition(c99970260.settcon)
  e4:SetTarget(c99970260.setttg)
  e4:SetOperation(c99970260.settop)
  c:RegisterEffect(e4)
end
--(1) Gain ATK
function c99970260.atktg(e,c)
  return c:IsSetCard(0xA97)
end
function c99970260.atkfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x997)
end
function c99970260.atkval(e,c)
  return Duel.GetMatchingGroupCount(c99970260.atkfilter,c:GetControler(),LOCATION_MZONE,0,nil)*300
end
--(2) Battle Indes
function c99970260.indfilter(c)
  return c:IsFaceup() and c:IsSetCard(0xA97)
end
function c99970260.indcon(e)
  return Duel.IsExistingMatchingCard(c99970260.indfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,2,nil)
end
function c99970260.indtarget(e,c)
  return c:IsSetCard(0xA97)
end
function c99970260.indct(e,re,r,rp)
  if bit.band(r,REASON_BATTLE)~=0 then
    return 1
  else return 0 end
end
--(3) Set Trap
function c99970260.settcon(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  return c:IsPreviousPosition(POS_FACEUP)
end
function c99970260.settfilter(c)
  return c:IsSetCard(0x997) and c:IsType(TYPE_TRAP) and c:IsSSetable() and not c:IsCode(99970260)
end
function c99970260.setttg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99970260.settfilter,tp,LOCATION_DECK,0,1,nil,false) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99970260.settop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  local g=Duel.SelectMatchingCard(tp,c99970260.settfilter,tp,LOCATION_DECK,0,1,1,nil,false)
  local tc=g:GetFirst()
  if tc then
    Duel.SSet(tp,tc)
    Duel.ConfirmCards(1-tp,tc)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
    e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e1:SetReset(RESET_EVENT+0x1fe0000)
    tc:RegisterEffect(e1)
  end
end