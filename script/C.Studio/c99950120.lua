--MSMM Witch Suppression
--Scripted by Raivost
  --(1) Special Summon
function c99950120.initial_effect(c)
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99950120,0))
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,99950120+EFFECT_COUNT_CODE_OATH)
  e1:SetCondition(c99950120.spcon)
  e1:SetTarget(c99950120.sptg)
  e1:SetOperation(c99950120.spop)
  c:RegisterEffect(e1)
end
--(1) Special Summon
function c99950120.spcon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
end
function c99950120.spfilter(c,e,tp)
  return c:IsSetCard(0x995) and bit.band(c:GetType(),0x81)==0x81 and c:GetLevel()==5 and c:IsCanBeSpecialSummoned(e,0,tp,true,true,POS_FACEUP)
end
function c99950120.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingMatchingCard(c99950120.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  local g=Duel.GetMatchingGroup(c99950120.desfilter,tp,0,LOCATION_MZONE,nil)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c99950120.desfilter(c)
  return bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL
end
function c99950120.spop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
  local ct1=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)-Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
  local g=Duel.GetMatchingGroup(c99950120.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp)
  if ft<1 or ct1<1 or g:GetCount()==0 then return end
  if ft>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
  local ct2=math.min(ft,ct1)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g1=Duel.SelectMatchingCard(tp,c99950120.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,ct2,nil,e,tp)
  if g1:GetCount()>0 then
    for tc in aux.Next(g1) do
      Duel.SpecialSummonStep(tc,0,tp,tp,true,true,POS_FACEUP)
      local e1=Effect.CreateEffect(c)
      e1:SetType(EFFECT_TYPE_SINGLE)
      e1:SetCode(EFFECT_DISABLE)
      e1:SetReset(RESET_EVENT+0x1fe0000)
      tc:RegisterEffect(e1)
      local e2=Effect.CreateEffect(c)
      e2:SetType(EFFECT_TYPE_SINGLE)
      e2:SetCode(EFFECT_DISABLE_EFFECT)
      e2:SetReset(RESET_EVENT+0x1fe0000)
      tc:RegisterEffect(e2)
      local e3=Effect.CreateEffect(e:GetHandler())
	  e3:SetType(EFFECT_TYPE_SINGLE)
	  e3:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	  e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	  tc:RegisterEffect(e3)
    end
    Duel.SpecialSummonComplete()
  end
  local g2=Duel.GetMatchingGroup(c99950120.desfilter,tp,0,LOCATION_MZONE,nil)
  if g2:GetCount()>0 then
  	Duel.BreakEffect()
   	Duel.Destroy(g2,REASON_EFFECT)
  end
end