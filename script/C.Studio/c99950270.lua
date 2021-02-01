--MSMM Dropping the Cycles
--Scripted by Raivost
function c99950270.initial_effect(c)
  --(1) Place in Z/T Zone
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99950270,0))
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,99950270+EFFECT_COUNT_CODE_OATH)
  e1:SetCost(c99950270.stzcost)
  e1:SetTarget(c99950270.stztg)
  e1:SetOperation(c99950270.stzop)
  c:RegisterEffect(e1)
  Duel.AddCustomActivityCounter(99950270,ACTIVITY_SPSUMMON,c99950270.counterfilter)
end
function c99950270.counterfilter(c)
  return c:IsSetCard(0x995) and c:GetSummonType()~=SUMMON_TYPE_RITUAL
end
function c99950270.stzcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetCustomActivityCount(99950270,tp,ACTIVITY_SPSUMMON)==0 
  and Duel.GetActivityCount(tp,ACTIVITY_ATTACK)==0 end
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
  e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
  e1:SetReset(RESET_PHASE+PHASE_END)
  e1:SetTargetRange(1,0)
  e1:SetLabelObject(e)
  e1:SetTarget(c99950270.splimit)
  Duel.RegisterEffect(e1,tp)
  local e2=Effect.CreateEffect(e:GetHandler())
  e2:SetType(EFFECT_TYPE_FIELD)
  e2:SetCode(EFFECT_CANNOT_ATTACK)
  e2:SetProperty(EFFECT_FLAG_OATH+EFFECT_FLAG_IGNORE_IMMUNE)
  e2:SetTargetRange(LOCATION_MZONE,0)
  e2:SetReset(RESET_PHASE+PHASE_END)
  Duel.RegisterEffect(e2,tp)
end
function c99950270.splimit(e,c,tp,sumtp,sumpos)
  return c:IsSetCard(0x995) and bit.band(sumtp,SUMMON_TYPE_RITUAL)==SUMMON_TYPE_RITUAL
end
function c99950270.stzfilter(c)
  return c:IsSetCard(0x995) and c:GetLevel()==5 and bit.band(c:GetOriginalType(),0x81)==0x81 and not c:IsForbidden()
end
function c99950270.stztg(e,tp,eg,ep,ev,re,r,rp,chk)
  if e:GetHandler():IsLocation(LOCATION_HAND) then v=1 else v=0 end
  if chk==0 then return Duel.IsExistingTarget(c99950270.stzfilter,tp,LOCATION_DECK,0,1,nil) 
  and Duel.GetLocationCount(tp,LOCATION_SZONE)>v end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99950270.stzop(e,tp,eg,ep,ev,re,r,rp)
 local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
  if ft<=0 then return end
  if ft>3 then ft=3 end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  local g=Duel.SelectMatchingCard(tp,c99950270.stzfilter,tp,LOCATION_DECK,0,1,ft,nil)
  for tc in aux.Next(g) do
    Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    --Continuous Spell
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetCode(EFFECT_CHANGE_TYPE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetReset(RESET_EVENT+0x1fc0000)
    e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
    tc:RegisterEffect(e1)
  end
  Duel.RaiseEvent(g,EVENT_CUSTOM+99950150,e,0,tp,0,0)
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetCode(EFFECT_SKIP_BP)
  e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e1:SetTargetRange(0,1)
  e1:SetReset(RESET_PHASE+PHASE_BATTLE+RESET_OPPO_TURN,1)
  Duel.RegisterEffect(e1,tp)
end