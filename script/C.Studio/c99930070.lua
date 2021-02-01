--OTNN Tails Emergency
--Scripted by Raivost
function c99930070.initial_effect(c)
  --(1) Special Summon
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99930070,0))
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,99930070+EFFECT_COUNT_CODE_OATH)
  e1:SetTarget(c99930070.sptg)
  e1:SetOperation(c99930070.spop)
  c:RegisterEffect(e1)
end
--(1) Special Summon
function c99930070.spfilter1(c,e,tp)
  return c:IsRace(RACE_WARRIOR) and c:GetLevel()>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
  and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
  and Duel.IsExistingTarget(c99930070.spfilter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,c,c:GetLevel(),e,tp)
end
function c99930070.spfilter2(c,lv,e,tp)
  return c:IsRace(RACE_WARRIOR) and c:GetLevel()==lv and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
  and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99930070.xyzfilter(c,mg)
  return c:IsXyzSummonable(mg,2,2) and c:IsSetCard(0x993)
end
function c99930070.mfilter1(c,mg,exg)
  return mg:IsExists(c99930070.mfilter2,1,c,c,exg)
end
function c99930070.mfilter2(c,mc,exg)
  return exg:IsExists(Card.IsXyzSummonable,1,nil,Group.FromCards(c,mc))
end
function c99930070.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return false end
  local mg=Duel.GetMatchingGroup(c99930070.spfilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
  local exg=Duel.GetMatchingGroup(c99930070.xyzfilter,tp,LOCATION_EXTRA,0,nil,mg)
  if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2)
  and not Duel.IsPlayerAffectedByEffect(tp,59822133)
  and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
  and exg:GetCount()>0 end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local atk=0
  local sg1=mg:FilterSelect(tp,c99930070.mfilter1,1,1,nil,mg,exg)
  local tc1=sg1:GetFirst()
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local sg2=mg:FilterSelect(tp,c99930070.mfilter2,1,1,tc1,tc1,exg)
  local tc2=sg2:GetFirst()
  atk=tc1:GetOriginalLevel()+tc2:GetOriginalLevel()
  sg1:Merge(sg2)
  e:SetLabel(atk)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg1,2,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c99930070.filter2(c,e,tp)
  return c:IsRelateToEffect(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99930070.spop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
  local ex,g=Duel.GetOperationInfo(0,CATEGORY_SPECIAL_SUMMON)
  if g:GetCount()<2 then return end
  Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
  Duel.BreakEffect()
  local xyzg=Duel.GetMatchingGroup(c99930070.xyzfilter,tp,LOCATION_EXTRA,0,nil,g)
  if xyzg:GetCount()>0 then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
    if Duel.XyzSummon(tp,xyz,g)~=0 then
      local e1=Effect.CreateEffect(e:GetHandler())
      e1:SetType(EFFECT_TYPE_SINGLE)
      e1:SetCode(EFFECT_UPDATE_ATTACK)
      e1:SetValue(e:GetLabel()*100)
      e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
      xyz:RegisterEffect(e1)
    end
  end
end