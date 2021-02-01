--MSMM Witch, Walpurgisnacht
--Scripted by Raivost
function c99950290.initial_effect(c)
  c:EnableReviveLimit()
  --Canoot Special Summon
  local e0=Effect.CreateEffect(c)
  e0:SetType(EFFECT_TYPE_SINGLE)
  e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
  e0:SetCode(EFFECT_SPSUMMON_CONDITION)
  c:RegisterEffect(e0)
  --(1) Special Summon from hand
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99950290,0))
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e1:SetCode(EVENT_DESTROYED)
  e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e1:SetRange(LOCATION_HAND)
  e1:SetCondition(c99950290.hspcon)
  e1:SetCost(c99950290.hspcost)
  e1:SetTarget(c99950290.hsptg)
  e1:SetOperation(c99950290.hspop)
  c:RegisterEffect(e1)
  --(2) Indes by battle
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE)
  e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
  e2:SetValue(1)
  c:RegisterEffect(e2)
  --(3) Take control 1
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99950290,1))
  e3:SetCategory(CATEGORY_CONTROL)
  e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e3:SetCode(EVENT_SPSUMMON_SUCCESS)
  e3:SetTarget(c99950290.tctg1)
  e3:SetOperation(c99950290.tcop1)
  c:RegisterEffect(e3)
  --(4) Destroy
  local e4=Effect.CreateEffect(c)
  e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
  e4:SetCode(EVENT_LEAVE_FIELD)
  e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
  e4:SetOperation(c99950290.desop)
  c:RegisterEffect(e4)
  --(5) Special Summon
  local e5=Effect.CreateEffect(c)
  e5:SetDescription(aux.Stringid(99950290,0))
  e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e5:SetType(EFFECT_TYPE_IGNITION)
  e5:SetRange(LOCATION_MZONE)
  e5:SetCountLimit(1)
  e5:SetTarget(c99950290.sptg)
  e5:SetOperation(c99950290.spop)
  c:RegisterEffect(e5)
  --(6) Destroy replace
  local e6=Effect.CreateEffect(c)
  e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
  e6:SetCode(EFFECT_DESTROY_REPLACE)
  e6:SetCountLimit(1)
  e6:SetTarget(c99950290.dreptg)
  e6:SetOperation(c99950290.drepop)
  c:RegisterEffect(e6)
  --(7) Shuffle
  local e7=Effect.CreateEffect(c)
  e7:SetDescription(aux.Stringid(99950290,2))
  e7:SetCategory(CATEGORY_TODECK)
  e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e7:SetCode(EVENT_TO_GRAVE)
  e7:SetCondition(c99950290.tdcon)
  e7:SetTarget(c99950290.tdtg)
  e7:SetOperation(c99950290.tdop)
  c:RegisterEffect(e7)
end
--(1) Special Summon
function c99950290.hspconfilter(c,tp)
  return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsSetCard(0x995) and c:GetLevel()==5 and bit.band(c:GetOriginalType(),0x81)==0x81
  and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousControler()==tp
end
function c99950290.hspcon(e,tp,eg,ep,ev,re,r,rp)
  return eg:IsExists(c99950290.hspconfilter,1,nil,tp)
end
function c99950290.hspcostfilter(c)
  return c:GetLevel()==5 and c:IsSetCard(0x995) and bit.band(c:GetOriginalType(),0x81)==0x81 and c:IsAbleToRemoveAsCost()
end
function c99950290.hspcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99950290.hspcostfilter,tp,LOCATION_GRAVE+LOCATION_SZONE,0,3,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
  local g=Duel.SelectMatchingCard(tp,c99950290.hspcostfilter,tp,LOCATION_GRAVE+LOCATION_SZONE,0,3,3,nil)
  Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c99950290.hsptg(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,true,false) end
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c99950290.hspop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsRelateToEffect(e) then
    Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
  end
end
--(3) Take control
function c99950290.tcfilter1(c)
  return c:IsControlerCanBeChanged()
end
function c99950290.tctg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingTarget(c99950290.tcfilter1,tp,0,LOCATION_MZONE,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
  local g=Duel.SelectTarget(tp,c99950290.tcfilter1,tp,0,LOCATION_MZONE,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c99950290.tcop1(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) then
  local fid=e:GetHandler():GetFieldID()
  tc:RegisterFlagEffect(99950290,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1,fid)
  --(3.1) Take control 2
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e1:SetCode(EVENT_PHASE+PHASE_END)
  e1:SetCountLimit(1)
  e1:SetLabel(fid)
  e1:SetLabelObject(tc)
  e1:SetReset(RESET_PHASE+PHASE_END)
  e1:SetCondition(c99950290.tccon2)
  e1:SetOperation(c99950290.tcop2)
  Duel.RegisterEffect(e1,tp)
  e:GetHandler():SetCardTarget(tc)
  end
end
--(3.1) Take control 2
function c99950290.tccon2(e,tp,eg,ep,ev,re,r,rp)
  local tc=e:GetLabelObject()
  return tc:GetFlagEffectLabel(99950290)==e:GetLabel()
end
function c99950290.tcop2(e,tp,eg,ep,ev,re,r,rp)
  local tc=e:GetLabelObject()
  Duel.GetControl(tc,tp)
end
--(4) Destroy
function c99950290.desop(e,tp,eg,ep,ev,re,r,rp)
  local tc=e:GetHandler():GetFirstCardTarget()
  if tc and tc:IsLocation(LOCATION_MZONE) then
    Duel.Destroy(tc,REASON_EFFECT)
  end
end
--(5) Special Summon
function c99950290.spfilter(c,e,tp)
  return c:IsFaceup() and c:IsSetCard(0x995) and bit.band(c:GetOriginalType(),0x81)==0x81
  and c:GetLevel()==5 and c:IsCanBeSpecialSummoned(e,0,tp,true,true) 
end
function c99950290.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingMatchingCard(c99950290.spfilter,tp,LOCATION_SZONE+LOCATION_GRAVE,0,1,nil,e,tp) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_SZONE+LOCATION_GRAVE)
end
function c99950290.spop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c99950290.spfilter),tp,LOCATION_SZONE+LOCATION_GRAVE,0,1,1,nil,e,tp)
  local tc=g:GetFirst()
  if not tc then return end
  if Duel.SpecialSummonStep(tc,0,tp,tp,true,true,POS_FACEUP) then
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_DISABLE)
    e1:SetReset(RESET_EVENT+0x1fe0000)
    tc:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_DISABLE_EFFECT)
    e2:SetReset(RESET_EVENT+0x1fe0000)
    tc:RegisterEffect(e2)
  end
  Duel.SpecialSummonComplete()
end
--(6) Destroy replace
function c99950290.drepfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x995) and bit.band(c:GetOriginalType(),0x81)==0x81 
  and c:GetLevel()==5 and not c:IsStatus(STATUS_DESTROY_CONFIRMED) and c:IsAbleToRemove()
end
function c99950290.dreptg(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
  if chk==0 then return not c:IsReason(REASON_REPLACE) and c:IsFaceup() and c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()~=tp
  and c:GetPreviousControler()==tp and Duel.IsExistingMatchingCard(c99950290.drepfilter,tp,LOCATION_MZONE,0,1,nil) end
  if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c99950290.drepfilter,tp,LOCATION_MZONE,0,1,1,nil)
    Duel.SetTargetCard(g)
    g:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,true)
    return true
  else 
    return  false 
  end
end
function c99950290.drepop(e,tp,eg,ep,ev,re,r,rp)
  local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
  g:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,false)
  Duel.Remove(g,POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
end
--(7) Shuffle
function c99950290.tdcon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsReason(REASON_DESTROY) and e:GetHandler():IsReason(REASON_BATTLE+REASON_EFFECT) 
  and e:GetHandler():IsPreviousLocation(LOCATION_MZONE)
end
function c99950290.tdfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x995) and bit.band(c:GetOriginalType(),0x81)==0x81 
  and c:GetLevel()==5 and c:IsAbleToDeck()
end
function c99950290.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99950290.tdfilter,tp,LOCATION_REMOVED,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_REMOVED)
end
function c99950290.tdop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
  local g=Duel.SelectMatchingCard(tp,c99950290.tdfilter,tp,LOCATION_REMOVED,0,1,3,nil)
  Duel.SendtoDeck(g,nil,2,REASON_COST)
end