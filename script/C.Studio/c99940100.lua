--NGNL Materialization Shiritori
--Scripted by Raivost
function c99940100.initial_effect(c)
  --(1) Negate Summon (Summon)
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99940100,0))
  e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_REMOVE)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_SPSUMMON)
  e1:SetCondition(c99940100.nscon1)
  e1:SetTarget(c99940100.nstg1)
  e1:SetOperation(c99940100.nsop1)
  c:RegisterEffect(e1)
  --(1) Negate Summon (Effect)
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99940100,0))
  e2:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
  e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
  e2:SetType(EFFECT_TYPE_ACTIVATE)
  e2:SetCode(EVENT_CHAINING)
  e2:SetCondition(c99940100.nscon2)
  e2:SetTarget(c99940100.nstg2)
  e2:SetOperation(c99940100.nsop2)
  c:RegisterEffect(e2)
  --(2) Activate in hand
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_SINGLE)
  e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
  e3:SetCondition(c99940100.handcon)
  c:RegisterEffect(e3)
  --(3) Return to hand
  local e4=Effect.CreateEffect(c)
  e4:SetDescription(aux.Stringid(99940100,1))
  e4:SetCategory(CATEGORY_TOHAND)
  e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e4:SetProperty(EFFECT_FLAG_DELAY)
  e4:SetCode(EVENT_TO_GRAVE)
  e4:SetCondition(c99940100.rthcon)
  e4:SetTarget(c99940100.rthtg)
  e4:SetOperation(c99940100.rthop)
  c:RegisterEffect(e4)
end
--(1) Negate Summon (Summon)
function c99940100.nscon1(e,tp,eg,ep,ev,re,r,rp)
  return tp~=ep and Duel.GetCurrentChain()==0
end
function c99940100.spfilter(c,e,tp)
  return c:IsSetCard(0x994) and c:IsType(TYPE_PENDULUM) and (c:IsLocation(LOCATION_DECK) or c:IsFaceup())
    and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99940100.setfilter(c)
  return c:IsCode(99940100) and c:IsSSetable()
end
function c99940100.nstg1(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingMatchingCard(c99940100.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,e,tp) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
  Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,eg:GetCount(),0,0)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function c99940100.nsop1(e,tp,eg,ep,ev,re,r,rp)
  Duel.NegateSummon(eg)
  if Duel.Remove(eg,POS_FACEDOWN,REASON_EFFECT)~=0 then
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.BreakEffect()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g1=Duel.SelectMatchingCard(tp,c99940100.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,e,tp)
    if g1:GetCount()>0 and Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)~=0 
    and Duel.IsExistingMatchingCard(c99940100.setfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(99940100,2)) then
      Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
      local g2=Duel.SelectMatchingCard(tp,c99940100.setfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
      local tc=g2:GetFirst()
      if tc then
        Duel.SSet(tp,tc)
        Duel.ConfirmCards(1-tp,tc)
      end
    end
  end
end
--(1) Negate Summon (Effect)
function c99940100.nscon2(e,tp,eg,ep,ev,re,r,rp)
  if not Duel.IsChainNegatable(ev) then return false end
  if not re:IsActiveType(TYPE_MONSTER) and not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
  return re:IsHasCategory(CATEGORY_SPECIAL_SUMMON) and ep~=tp
end
function c99940100.nstg2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingMatchingCard(c99940100.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,e,tp)  end
  Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
  if re:GetHandler():IsAbleToRemove() and re:GetHandler():IsRelateToEffect(re) then
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
  end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function c99940100.nsop2(e,tp,eg,ep,ev,re,r,rp)
  if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) and Duel.Remove(eg,POS_FACEDOWN,REASON_EFFECT)~=0 then
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.BreakEffect()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g1=Duel.SelectMatchingCard(tp,c99940100.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,e,tp)
    if g1:GetCount()>0 and Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)~=0  
    and Duel.IsExistingMatchingCard(c99940100.setfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(99940100,2)) then
      Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(99940100,3))
      Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
      local g2=Duel.SelectMatchingCard(tp,c99940100.setfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
      local tc=g2:GetFirst()
      if tc then
        Duel.SSet(tp,tc)
        Duel.ConfirmCards(1-tp,tc)
      end
    end
  end
end
--(2) Activate in hand
function c99940100.handcon(e)
  local tp=e:GetHandlerPlayer()
  local tc1=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
  local tc2=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
  return tc1 and tc1:IsSetCard(0x994) and tc2 and tc2:IsSetCard(0x994)
end
--(3) Return to hand
function c99940100.rthcon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsReason(REASON_EFFECT) 
  and (e:GetHandler():GetPreviousLocation()==LOCATION_DECK or e:GetHandler():GetPreviousLocation()==LOCATION_HAND)
end
function c99940100.rthtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():IsAbleToHand() end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,tp,LOCATION_GRAVE)
end
function c99940100.rthop(e,tp,eg,ep,ev,re,r,rp)
  if e:GetHandler():IsRelateToEffect(e) and Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)~=0 
  and Duel.ConfirmCards(1-tp,e:GetHandler())~=0 then
    Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+99940060,e,0,tp,0,0)
  end
end