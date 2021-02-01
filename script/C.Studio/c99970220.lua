--DAL Force Switch
--Scripted by Raivost
function c99970220.initial_effect(c)
  --(1) Return to hand
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99970220,0))
  e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetTarget(c99970220.rthtg)
  e1:SetOperation(c99970220.rthop)
  c:RegisterEffect(e1)
 end
 --(1) Return to hand
function c99970220.rthfilter(c,e,tp)
  local loc1=0
  if Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 then loc1=loc1+LOCATION_DECK+LOCATION_HAND end
  local loc2=0
  if Duel.GetLocationCountFromEx(tp,tp,c)>0 then loc2=loc2+LOCATION_EXTRA end
  return c:IsFaceup() and c:IsSetCard(0x997) and c:IsAbleToHand()
  and (( not (c:IsSetCard(0xA97) or c:IsType(TYPE_XYZ)) and Duel.IsExistingMatchingCard(c99970220.spfilter1,tp,loc1,0,1,nil,e,tp,c:GetCode()))
  or (c:IsSetCard(0xA97) and Duel.IsExistingMatchingCard(c99970220.spfilter2,tp,loc1,0,1,nil,e,tp,c:GetCode()))
  or (c:IsType(TYPE_XYZ) and Duel.IsExistingMatchingCard(c99970220.spfilter3,tp,loc2,0,1,nil,e,tp,c:GetCode())))
end
function c99970220.spfilter1(c,e,tp,code)
  return c:IsSetCard(0x997) and c:GetLevel()==3 and not c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99970220.spfilter2(c,e,tp,code)
  return c:IsSetCard(0xA97) and not c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99970220.spfilter3(c,e,tp,code)
  return c:IsSetCard(0x997) and c:IsType(TYPE_XYZ) and not c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99970220.rthtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingTarget(c99970220.rthfilter,tp,LOCATION_MZONE,0,1,e:GetHandler(),e,tp) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
  local g=Duel.SelectTarget(tp,c99970220.rthfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler(),e,tp)
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
  local tc=g:GetFirst()
  if tc:IsSetCard(0xA97) or (tc:IsSetCard(0x997) and tc:GetLevel()==3) then
  	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK+LOCATION_HAND)
  else
  	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_EXTRA)
  end
end
function c99970220.rthop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()    
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and tc:IsFaceup() and not (tc:IsSetCard(0xA97) or tc:IsType(TYPE_XYZ)) and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end  
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local sg=Duel.SelectMatchingCard(tp,c99970220.spfilter1,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp,tc:GetCode())
    local tc2=sg:GetFirst()
    if Duel.SpecialSummon(tc2,0,tp,tp,false,false,POS_FACEUP)~=0 then
      Duel.Recover(tp,700,REASON_EFFECT)
    end
  elseif tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsSetCard(0xA97) and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end  
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local sg=Duel.SelectMatchingCard(tp,c99970220.spfilter2,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp,tc:GetCode())
    local tc2=sg:GetFirst()
    if Duel.SpecialSummon(tc2,0,tp,tp,false,false,POS_FACEUP)~=0 then
      local e1=Effect.CreateEffect(e:GetHandler())
      e1:SetType(EFFECT_TYPE_SINGLE)
      e1:SetCode(EFFECT_UPDATE_ATTACK)
      e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
      e1:SetValue(500)
      tc2:RegisterEffect(e1)
    end
  elseif tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsType(TYPE_XYZ) and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
    if Duel.GetLocationCountFromEx(tp)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local sg=Duel.SelectMatchingCard(tp,c99970220.spfilter3,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc:GetCode())
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
    local tc2=sg:GetFirst()
    if Duel.SpecialSummon(tc2,0,tp,tp,false,false,POS_FACEUP)~=0 and c:IsRelateToEffect(e) then
      c:CancelToGrave()
      Duel.Overlay(tc2,Group.FromCards(c))
    end
  end
end