--DAL Pool Party
--Scripted by Raivost
function c99970310.initial_effect(c)
  --(1) Special Summon 1
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99970310,0))
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,99970310+EFFECT_COUNT_CODE_OATH)
  e1:SetCondition(c99970310.spcon1)
  e1:SetTarget(c99970310.sptg1)
  e1:SetOperation(c99970310.spop1)
  c:RegisterEffect(e1)
  --(2) Special Summon 2
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99970310,0))
  e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e2:SetType(EFFECT_TYPE_ACTIVATE)
  e2:SetCode(EVENT_FREE_CHAIN)
  e2:SetCountLimit(1,99970310+EFFECT_COUNT_CODE_OATH)
  e2:SetCondition(c99970310.spcon2)
  e2:SetTarget(c99970310.sptg2)
  e2:SetOperation(c99970310.spop2)
  c:RegisterEffect(e2)
end
--(1) Special Summon 1
function c99970310.spconfilter(c)
  return c:IsFaceup() and c:IsCode(99970280)
end
function c99970310.spcon1(e)
  return not Duel.IsExistingMatchingCard(c99970310.spconfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function c99970310.spfilter(c,e,tp)
  return c:IsSetCard(0x997) and c:GetLevel()==3 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99970310.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingMatchingCard(c99970310.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK+LOCATION_HAND)
end
function c99970310.spop1(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,c99970310.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
  if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EFFECT_CANNOT_BP)
    e1:SetTargetRange(0,1)
    e1:SetCondition(c99970310.con)
    e1:SetLabel(Duel.GetTurnCount())
    if Duel.GetTurnPlayer()==tp then
      e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,1)
    else
      e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,2)
    end
    Duel.RegisterEffect(e1,tp)
  end
end
function c99970310.con(e)
  return Duel.GetTurnCount()~=e:GetLabel()
end
--(2) Special Summon 2
function c99970310.spcon2(e)
  return Duel.IsExistingMatchingCard(c99970310.spconfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function c99970310.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingMatchingCard(c99970310.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK+LOCATION_HAND)
end
function c99970310.spop2(e,tp,eg,ep,ev,re,r,rp,chk)
  local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
  if ft<=0 then return end
  if ft>2 then ft=2 end
  if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,c99970310.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,ft,nil,e,tp)
  if g:GetCount()~=0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EFFECT_CANNOT_BP)
    e1:SetTargetRange(0,1)
    e1:SetCondition(c99970310.con)
    e1:SetLabel(Duel.GetTurnCount())
    if Duel.GetTurnPlayer()==tp then
      e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,1)
    else
      e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,2)
    end
    Duel.RegisterEffect(e1,tp)
  end
end