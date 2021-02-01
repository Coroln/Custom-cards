--HN Candidate's Training
--Scripted by Raivost
function c99980380.initial_effect(c)
  --(1) Send to GY
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99980380,0))
  e1:SetCategory(CATEGORY_TOGRAVE)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,99980380+EFFECT_COUNT_CODE_OATH)
  e1:SetTarget(c99980380.sptg)
  e1:SetOperation(c99980380.spop)
  c:RegisterEffect(e1)
end
--(1) Send to GY
function c99980380.tgfilter(c,e,tp)
  return c:IsSetCard(0x1998) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
  and Duel.IsExistingMatchingCard(c99980380.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetCode())
end
function c99980380.spfilter(c,e,tp,code)
  return c:IsSetCard(0x1998) and c:IsType(TYPE_MONSTER) and aux.IsCodeListed(c,99980040) 
  and not c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99980380.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingMatchingCard(c99980380.tgfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c99980380.spop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
  local g=Duel.SelectMatchingCard(tp,c99980380.tgfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
  local tc=g:GetFirst()
  if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE) then
  	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c99980380.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,tc:GetCode())
	if g:GetCount()>0 then
	  Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
  end
end