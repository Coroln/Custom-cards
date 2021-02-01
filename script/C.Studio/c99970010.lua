--DAL Spacequake
--Scripted by Raivost
function c99970010.initial_effect(c)
  --(1) Destroy
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99970010,0))
  e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetCountLimit(1,99970010)
  e1:SetTarget(c99970010.destg)
  e1:SetOperation(c99970010.desop)
  c:RegisterEffect(e1)
end
--(1) Destroy
function c99970010.spfilter(c,e,tp)
  return c:IsSetCard(0xA97) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99970010.destg(e,tp,eg,ep,ev,re,r,rp,chk)
  local g1=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,0,e:GetHandler())
  local g2=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
  if chk==0 then return ((g1:GetCount()>0 and g2:GetCount()>0) or Duel.GetLocationCount(tp,LOCATION_MZONE)>0)
  and Duel.IsExistingMatchingCard(c99970010.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
  if g1:GetCount()>0 and g2:GetCount()>0 then
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,2,0,LOCATION_ONFIELD)
  else
    Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(99970010,1))
  end
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK+LOCATION_HAND)
end
function c99970010.desop(e,tp,eg,ep,ev,re,r,rp)
  local g1=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,0,e:GetHandler())
  local g2=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil) 
  if g1:GetCount()>0 and g2:GetCount()>0  then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local dg1=g1:Select(tp,1,1,nil)
    Duel.HintSelection(dg1)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local dg2=g2:Select(tp,1,1,nil)
    Duel.HintSelection(dg2)
    dg1:Merge(dg2)
    Duel.Destroy(dg1,REASON_EFFECT) 
  end
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g3=Duel.SelectMatchingCard(tp,c99970010.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
  if g3:GetCount()>0 then
    Duel.SpecialSummon(g3,0,tp,tp,false,false,POS_FACEUP)
  end
  if e:GetHandler():IsRelateToEffect(e) and e:IsHasType(EFFECT_TYPE_ACTIVATE) then
    e:GetHandler():CancelToGrave()
    Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
  end
end