--DAL Spirit Summon
--Scripted by Raivost
function c99970520.initial_effect(c)
  --(1) Send to GY
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99970520,0))
  e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,99970520+EFFECT_COUNT_CODE_OATH)
  e1:SetTarget(c99970520.tgtg)
  e1:SetOperation(c99970520.tgop)
  c:RegisterEffect(e1)
end
--(1) Send to GY
function c99970520.tgfilter(c,e,tp)
  return c:IsSetCard(0x997) and c:GetLevel()==3 and c:IsAbleToGrave()
  and Duel.IsExistingMatchingCard(c99970520.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp,c:GetCode())
end
function c99970520.spfilter(c,e,tp,code)
  local class=_G["c"..code]
  return class and class.listed_namescount~=nil and c:IsCode(class.listed_names[1]) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99970520.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99970520.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c99970520.tgop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
  local g=Duel.SelectMatchingCard(tp,c99970520.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
  local tc=g:GetFirst()
  if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE) then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g2=Duel.SelectMatchingCard(tp,c99970520.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp,tc:GetCode())
    if g2:GetCount()>0 then
      Duel.SpecialSummon(g2,0,tp,tp,false,false,POS_FACEUP)
    end
  end
end