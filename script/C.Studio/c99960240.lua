--BRS Sanity Break
--Scripted by Raivost
function c99960240.initial_effect(c)
  --(1) Special Summon
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99960240,0))
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_DESTROYED)
  e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e1:SetCondition(c99960240.spcon)
  e1:SetTarget(c99960240.sptg)
  e1:SetOperation(c99960240.spop)
  c:RegisterEffect(e1)
  --(2) Destroy 1
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99960240,3))
  e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e2:SetCode(EVENT_TO_GRAVE)
  e2:SetCondition(c99960240.descon1)
  e2:SetTarget(c99960240.destg1)
  e2:SetOperation(c99960240.desop1)
  c:RegisterEffect(e2)
end
function c99960240.spconfilter(c,tp)
  return c:IsSetCard(0x996) and c:GetRank()==4 and c:IsReason(REASON_BATTLE+REASON_EFFECT) 
  and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp
end
function c99960240.spcon(e,tp,eg,ep,ev,re,r,rp)
  return eg:IsExists(c99960240.spconfilter,1,nil,tp)
end
function c99960240.spfilter(c,e,tp)
  return c:IsSetCard(0x996) and c:GetRank()==5 and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c99960240.desfilter(c,atk)
  return c:IsFaceup() and c:IsAttackBelow(atk)
end
function c99960240.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCountFromEx(tp)>0
  and Duel.IsExistingMatchingCard(c99960240.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c99960240.spop(e,tp,eg,ep,ev,re,r,rp) 
  if Duel.GetLocationCountFromEx(tp)<=0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,c99960240.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
  if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)~=0 then
    local tc=g:GetFirst()
    local dg1=Duel.GetMatchingGroup(c99960240.desfilter,tp,0,LOCATION_MZONE,nil,tc:GetAttack())
    if dg1:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(99960240,1)) then
      Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(99960240,2))
      Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
      local dg2=Duel.SelectTarget(tp,c99960240.desfilter,tp,0,LOCATION_MZONE,1,1,nil,tc:GetAttack())
      local tc=dg2:GetFirst()
      if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
        Duel.HintSelection(dg2)
        Duel.Destroy(tc,REASON_EFFECT)
      end
    end
  end
end
--(2) Destroy 1
function c99960240.descon1(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  return c:IsReason(REASON_COST) and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_MONSTER)
  and c:IsPreviousLocation(LOCATION_OVERLAY) and re:GetHandler():IsSetCard(0x996) 
end
function c99960240.desfilter1(c)
  return c:IsFaceup() and c:IsSetCard(0x996) and c:IsType(TYPE_MONSTER)
end
function c99960240.destg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return true end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  Duel.SelectTarget(tp,c99960240.desfilter1,tp,LOCATION_MZONE,0,1,1,nil)
end
function c99960240.desop1(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc and tc:IsRelateToEffect(e) then
  --(2.1) Destroy 2
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e1:SetRange(LOCATION_MZONE)
  e1:SetCode(EVENT_PHASE+PHASE_END)
  e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
  e1:SetCountLimit(1)
  e1:SetCondition(c99960240.descon2)
  e1:SetOperation(c99960240.desop2)
  e1:SetLabelObject(tc)
  Duel.RegisterEffect(e1,tp)
  tc:RegisterFlagEffect(99960240,RESET_EVENT+0x1fe0000,0,1)
  end
end
--(2.1) Destroy 2
function c99960240.descon2(e,tp,eg,ep,ev,re,r,rp)
  local tc=e:GetLabelObject()
  if tc:GetFlagEffect(99960240)==0 then
    e:Reset()
  return false
  end
  return true
end
function c99960240.desop2(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_CARD,0,99960240)
  local tc=e:GetLabelObject()
  local atk=tc:GetAttack()
  if Duel.Destroy(tc,REASON_EFFECT)~=0 then
    Duel.Damage(tp,atk/2,REASON_EFFECT,true)
    Duel.Damage(1-tp,atk/2,REASON_EFFECT,true)
    Duel.RDComplete()
  end
end