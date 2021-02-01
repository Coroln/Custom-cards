--BRS Through Anger And Fears
--Scripted by Raivost
function c99960210.initial_effect(c)
  --(1) Return to Extra Deck
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99960210,0))
  e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetHintTiming(TIMING_DAMAGE_STEP)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
  e1:SetTarget(c99960210.redtg)
  e1:SetOperation(c99960210.redop)
  c:RegisterEffect(e1)
  --(2) Reveal
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99960210,1))
  e2:SetCategory(CATEGORY_DAMAGE)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e2:SetCode(EVENT_TO_GRAVE)
  e2:SetCondition(c99960210.revcon)
  e2:SetTarget(c99960210.revtg)
  e2:SetOperation(c99960210.revop)
  c:RegisterEffect(e2)
end
--(1) Return to Extra Deck
function c99960210.redfilter(c,e,tp)
  local loc=0
  if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_GRAVE end
  if Duel.GetLocationCountFromEx(tp,tp,c)>0 then loc=loc+LOCATION_EXTRA end
  return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x996) and c:GetRank()==4 and c:IsAbleToExtra()
  and Duel.IsExistingMatchingCard(c99960210.spfilter,tp,loc,0,1,nil,e,tp)
end
function c99960210.spfilter(c,e,tp)
  return c:IsType(TYPE_XYZ) and c:IsSetCard(0x996) and c:GetRank()==5 and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c99960210.redtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingMatchingCard(c99960210.redfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
  local g=Duel.SelectTarget(tp,c99960210.redfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
  Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_GRAVE)
end
function c99960210.redop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  local loc=0
  if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_GRAVE end
  if Duel.GetLocationCountFromEx(tp,tp,tc)>0 then loc=loc+LOCATION_EXTRA end
  if loc==0 then return end
  if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_EXTRA) then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c99960210.spfilter),tp,loc,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
      Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP_ATTACK)
      local tc2=g:GetFirst()
      local e1=Effect.CreateEffect(e:GetHandler())
      e1:SetType(EFFECT_TYPE_SINGLE)
      e1:SetCode(EFFECT_UPDATE_ATTACK)
      e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
      e1:SetValue(1000)
      tc2:RegisterEffect(e1)  
    end
  end
end
--(2) Reveal
function c99960210.revcon(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  return c:IsReason(REASON_COST) and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_MONSTER)
  and c:IsPreviousLocation(LOCATION_OVERLAY) and re:GetHandler():IsSetCard(0x996) 
  and Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0
end
function c99960210.revtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return true end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99960210.revop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)==0 then return end
  Duel.ConfirmDecktop(1-tp,1)
  local g=Duel.GetDecktopGroup(1-tp,1)
  local tc=g:GetFirst()
  if tc:IsType(TYPE_MONSTER) then
    Duel.Damage(1-tp,1000,REASON_EFFECT)
  end
end