--HN A CPU Valentine
--Scripted by Raivost
function c99980270.initial_effect(c)
  --(1) Special Summon
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99980270,0))
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,99980270+EFFECT_COUNT_CODE_OATH)
  e1:SetTarget(c99980270.sptg)
  e1:SetOperation(c99980270.spop)
  c:RegisterEffect(e1)
end
--(1) Special Summon
function c99980270.spfilter(c,e,tp)
  return c:IsSetCard(0x998) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99980270.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingMatchingCard(c99980270.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
  local ct=Duel.GetMatchingGroupCount(Card.IsCode,tp,LOCATION_GRAVE,0,nil,99980270)
  Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(99980270,0))
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
  Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,1-tp,1000-(300*ct))
end
function c99980270.spop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,c99980270.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
  if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
    local ct=Duel.GetMatchingGroupCount(Card.IsCode,tp,LOCATION_GRAVE,0,nil,99980270)
    Duel.Recover(1-tp,1000-(300*ct),REASON_EFFECT)
  end
end