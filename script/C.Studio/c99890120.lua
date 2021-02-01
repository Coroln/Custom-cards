--Fate Heaven’s Ascendancy
--Scripted by Raivost
function c99890120.initial_effect(c)
  --(1) Special Summon
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99890120,0))
  e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,99890120+EFFECT_COUNT_CODE_OATH)
  e1:SetTarget(c99890120.tgtg)
  e1:SetOperation(c99890120.tgop)
  c:RegisterEffect(e1)
end
--(1) Special Summon
function c99890120.tgfilter(c,e,tp,ft)
  return c:IsSetCard(0x989) and c:IsAbleToGrave() and (ft>0 or c:GetSequence()<5)
  and Duel.IsExistingMatchingCard(c99890120.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp,c:GetCode())
end
function c99890120.spfilter(c,e,tp,code)
  return c:IsSetCard(0x989) and aux.IsCodeListed(c,code) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c99890120.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
  if chk==0 then return ft>-1 and Duel.IsExistingMatchingCard(c99890120.tgfilter,tp,LOCATION_MZONE,0,1,nil,e,tp,ft) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
  local g=Duel.SelectTarget(tp,c99890120.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp,ft)
  Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c99890120.tgop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c99890120.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp,tc:GetCode())
    if g:GetCount()>0 then
      Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
    end
  end
end