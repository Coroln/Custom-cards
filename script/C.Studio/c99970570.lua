--DAL Close Re-Encounter
--Scripted by Raivost
function c99970570.initial_effect(c)
  --(1) Special Summon
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99970570,0))
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,99970570+EFFECT_COUNT_CODE_OATH)
  e1:SetCondition(c99970570.spcon)
  e1:SetTarget(c99970570.sptg)
  e1:SetOperation(c99970570.spop)
  c:RegisterEffect(e1)
end
--(1) Special Summon
function c99970570.spcon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
end
function c99970570.spfilter(c,e,tp)
  return c:IsSetCard(0xA97) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99970570.thfilter(c)
  return c:IsSetCard(0x997) and c:GetLevel()==3 and c:IsAbleToHand()
end
function c99970570.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingMatchingCard(c99970570.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c99970570.spop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,c99970570.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
  if g:GetCount()<=0 or Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)==0 then return end 
  if Duel.IsExistingMatchingCard(c99970570.thfilter,tp,LOCATION_DECK,0,1,nil) 
  and Duel.SelectYesNo(tp,aux.Stringid(99970570,1)) then
    Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(99970570,2))
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c99970570.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
      Duel.SendtoHand(g,nil,REASON_EFFECT)
      Duel.ConfirmCards(1-tp,g)
    end
  end
end