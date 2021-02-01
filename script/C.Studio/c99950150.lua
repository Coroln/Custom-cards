--MSMM Madness Regrets
--Scripted by Raivost
function c99950150.initial_effect(c)
  --(1) Destroy 1
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99950150,0))
  e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_CUSTOM+99950150)
  e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e1:SetCondition(c99950150.descon1)
  e1:SetTarget(c99950150.destg1)
  e1:SetOperation(c99950150.desop1)
  c:RegisterEffect(e1)  
  --(2) Special Summon
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99950150,1))
  e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e2:SetType(EFFECT_TYPE_QUICK_O)
  e2:SetCode(EVENT_FREE_CHAIN)
  e2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
  e2:SetRange(LOCATION_GRAVE)
  e2:SetCountLimit(1)
  e2:SetHintTiming(0,TIMING_END_PHASE)
  e2:SetCondition(aux.exccon)
  e2:SetCost(c99950150.spcost)
  e2:SetTarget(c99950150.sptg)
  e2:SetOperation(c99950150.spop)
  c:RegisterEffect(e2)
end
--(1) Destroy 1
function c99950150.descon1(e,tp,eg,ep,ev,re,r,rp)
  local tc=eg:GetFirst()
  return tc:IsFaceup() and tc:IsSetCard(0x995) 
  and tc:IsControler(tp) and bit.band(tc:GetOriginalType(),0x81)==0x81
end
function c99950150.destg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
  local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c99950150.desop1(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
  local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
  if g:GetCount()>0 then
    Duel.HintSelection(g)
    local atk=math.floor(g:GetFirst():GetTextAttack()/2)
    if atk<0 then atk=0 end
    if Duel.Destroy(g,REASON_EFFECT)~=0 then
      Duel.Damage(1-tp,atk,REASON_EFFECT)
    end
  end
end
--(2) Special Summon
function c99950150.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.CheckLPCost(tp,1000) end
  Duel.PayLPCost(tp,1000)
end
function c99950150.spfilter(c,e,tp)
  return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x995) and c:GetLevel()==5
  and bit.band(c:GetType(),0x81)==0x81 and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c99950150.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingMatchingCard(c99950150.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c99950150.spop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,c99950150.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
  local tc=g:GetFirst()
  if tc and Duel.SpecialSummonStep(tc,0,tp,tp,true,true,POS_FACEUP) then
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_DISABLE)
    e1:SetReset(RESET_EVENT+0x1fe0000)
    tc:RegisterEffect(e1,true)
    local e2=Effect.CreateEffect(e:GetHandler())
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_DISABLE_EFFECT)
    e2:SetReset(RESET_EVENT+0x1fe0000)
    tc:RegisterEffect(e2,true)
    local e3=Effect.CreateEffect(e:GetHandler())
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_UPDATE_ATTACK)
    e3:SetValue(tc:GetBaseAttack())
    e3:SetReset(RESET_EVENT+0x1fe0000)
    tc:RegisterEffect(e3)
    --(2.1) Destroy 2
    local e4=Effect.CreateEffect(e:GetHandler())
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EVENT_PHASE+PHASE_END)
    e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e4:SetCountLimit(1)
    e4:SetCondition(c99950150.descon2)
    e4:SetOperation(c99950150.desop2)
    e4:SetLabelObject(tc)
    Duel.RegisterEffect(e4,tp)
    tc:RegisterFlagEffect(99950150,RESET_EVENT+0x1fe0000,0,1)
    Duel.SpecialSummonComplete()
  end
end
--(2.1) Destroy 2
function c99950150.descon2(e,tp,eg,ep,ev,re,r,rp)
  local tc=e:GetLabelObject()
  if tc:GetFlagEffect(99950150)==0 then
    e:Reset()
    return false
  end
  return true
end
function c99950150.desop2(e,tp,eg,ep,ev,re,r,rp)
  local tc=e:GetLabelObject()
  Duel.Destroy(tc,REASON_EFFECT)
end