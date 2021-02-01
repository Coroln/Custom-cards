--OTNN Twintail Passion
--Scripted by Raivost
function c99930110.initial_effect(c)
  --(1) Special Summon
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99930110,0))
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,99930110+EFFECT_COUNT_CODE_OATH)
  e1:SetTarget(c99930110.sptg)
  e1:SetOperation(c99930110.spop)
  c:RegisterEffect(e1)
end
--(1) Special Summon
function c99930110.spfilter(c,e,tp)
  return c:IsSetCard(0x993) and c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99930110.attachfilter(c)
  return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_WARRIOR)
end
function c99930110.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingTarget(c99930110.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) 
  and Duel.IsExistingMatchingCard(c99930110.attachfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectTarget(tp,c99930110.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,LOCATION_GRAVE)
end
function c99930110.spop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c99930110.attachfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
    if g:GetCount()>0 and Duel.Overlay(tc,g)~=0 then
      local e1=Effect.CreateEffect(e:GetHandler())
      e1:SetType(EFFECT_TYPE_SINGLE)
      e1:SetCode(EFFECT_UPDATE_ATTACK)
      e1:SetValue(g:GetFirst():GetBaseAttack()/2)
      e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
      tc:RegisterEffect(e1)
    end
  end
end