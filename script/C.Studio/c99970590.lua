--DAL Sonogami Rio
--Scripted by Raivost
function c99970590.initial_effect(c)
  --Link Summon
  aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x997),2,2)
  c:EnableReviveLimit()
   --(1) Special Summon 1
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99970590,0))
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e1:SetCode(EVENT_SPSUMMON_SUCCESS)
  e1:SetProperty(EFFECT_FLAG_DELAY)
  e1:SetCountLimit(1,99970590)
  e1:SetCondition(c99970590.spcon1)
  e1:SetTarget(c99970590.sptg1)
  e1:SetOperation(c99970590.spop1)
  c:RegisterEffect(e1)
  --(2) Cannot target
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_FIELD)
  e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
  e2:SetRange(LOCATION_MZONE)
  e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
  e2:SetTarget(c99970590.untartg)
  e2:SetValue(c99970590.untarval)
  c:RegisterEffect(e2)
  --(3) Special Summon 2
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99970590,0))
  e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e3:SetCode(EVENT_DESTROYED)
  e3:SetCondition(c99970590.spcon2)
  e3:SetTarget(c99970590.sptg2)
  e3:SetOperation(c99970590.spop2)
  c:RegisterEffect(e3)
end
--(1) Special Summon 1
function c99970590.spcon1(e,tp,eg,ep,ev,re,r,rp)
  return (re and re:GetHandler():IsSetCard(0x997)) or e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c99970590.spfiler1(c,e,tp)
  return c:IsSetCard(0x997) and c:GetLevel()==3 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99970590.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingMatchingCard(c99970590.spfiler1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c99970590.spop1(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c99970590.spfiler1),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
  if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.IsPlayerCanDraw(tp,1) then
    Duel.Draw(tp,1,REASON_EFFECT)
  end
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
  e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e1:SetTargetRange(1,0)
  e1:SetTarget(c99970590.splimit)
  e1:SetReset(RESET_PHASE+PHASE_END)
  Duel.RegisterEffect(e1,tp)
end
function c99970590.splimit(e,c)
  return not c:IsSetCard(0x997)
end
--(2) Cannot target
function c99970590.untartg(e,c)
  return c:IsSetCard(0x997) and e:GetHandler():GetLinkedGroup():IsContains(c)
end
function c99970590.untarval(e,re,rp)
  return rp~=e:GetHandlerPlayer()
end
--(3) Special Summon 2
function c99970590.spcon2(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsReason(REASON_EFFECT)
end
function c99970590.spfilter2(c,e,tp)
  return c:IsSetCard(0x997) and c:GetLevel()==3 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99970590.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingMatchingCard(c99970590.spfilter2,tp,LOCATION_HAND,0,1,nil,e,tp) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c99970590.spop2(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,c99970590.spfilter2,tp,LOCATION_HAND,0,1,1,nil,e,tp)
  if g:GetCount()>0 then
    Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
  end
end