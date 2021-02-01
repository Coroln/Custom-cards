--DAL Shadows in Time
function c99970580.initial_effect(c)
  --(1) Shuffle
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99970580,0))
  e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetTarget(c99970580.tdtg)
  e1:SetOperation(c99970580.tdop)
  c:RegisterEffect(e1)
end
--(1) Shuffle
function c99970580.tdfilter(c,e,tp,ft)
  return c:IsSetCard(0xA97) and c:IsAbleToDeck()
  and Duel.IsExistingMatchingCard(c99970580.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,c:GetCode())
  and (ft>0 or c:GetSequence()<5)
end
function c99970580.spfilter(c,e,tp,code)
  return c:IsSetCard(0x997) and c:GetLevel()==3 and aux.IsCodeListed(c,code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99970580.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
  if chk==0 then return ft>-1 and Duel.IsExistingTarget(c99970580.tdfilter,tp,LOCATION_MZONE,0,1,nil,e,tp,ft) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
  local g=Duel.SelectTarget(tp,c99970580.tdfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp,ft)
  Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c99970580.setfilter(c)
  return c:IsSetCard(0x997) and c:IsType(TYPE_TRAP) and c:IsSSetable()
end
function c99970580.tdop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local tc1=Duel.GetFirstTarget()
  if tc1:IsRelateToEffect(e) then
    if Duel.SendtoDeck(tc1,nil,2,REASON_EFFECT)~=0 and tc1:IsLocation(LOCATION_DECK) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
    and Duel.IsExistingMatchingCard(c99970580.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,tc1:GetCode()) then
      Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
      local g1=Duel.SelectMatchingCard(tp,c99970580.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,tc1:GetCode())
      if g1:GetCount()>0 and Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)~=0 
      and Duel.IsExistingMatchingCard(c99970580.setfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(99970580,1)) then    
        Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(99970580,2))
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
        local g2=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c99970580.setfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
        if g2:GetCount()>0 then
          local tc2=g2:GetFirst()
          Duel.SSet(tp,tc2)
          Duel.ConfirmCards(1-tp,tc2)
          local e1=Effect.CreateEffect(e:GetHandler())
          e1:SetType(EFFECT_TYPE_SINGLE)
          e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
          e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
          e1:SetReset(RESET_EVENT+0x1fe0000)
          tc2:RegisterEffect(e1)
        end
      end
    end
  end
end