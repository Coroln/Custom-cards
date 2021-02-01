--MSMM Kyubey
--Scripted by Raivost
function c99950180.initial_effect(c)
  --(1) Special Summon
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99950180,0))
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetType(EFFECT_TYPE_IGNITION)
  e1:SetRange(LOCATION_HAND)
  e1:SetCost(c99950180.spcost)
  e1:SetTarget(c99950180.sptg)
  e1:SetOperation(c99950180.spop)
  c:RegisterEffect(e1)
  --(2) Indes by battle
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE)
  e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
  e2:SetValue(1)
  c:RegisterEffect(e2)
  --(3) To hand
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99950180,1))
  e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e3:SetType(EFFECT_TYPE_IGNITION)
  e3:SetRange(LOCATION_GRAVE)
  e3:SetCondition(aux.exccon)
  e3:SetCost(aux.bfgcost)
  e3:SetTarget(c99950180.thtg)
  e3:SetOperation(c99950180.thop)
  c:RegisterEffect(e3)
end
--(1) Special Summon
function c99950180.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
  if chk==0 then return c:IsAbleToGraveAsCost() and c:IsDiscardable() end
  Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c99950180.spfilter(c,e,tp)
  return c:IsSetCard(0x995) and c:GetLevel()==5 and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c99950180.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingMatchingCard(c99950180.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c99950180.spop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,c99950180.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
  local tc=g:GetFirst()
  if tc and Duel.SpecialSummonStep(tc,0,tp,tp,true,false,POS_FACEUP) then
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_DISABLE)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
    tc:RegisterEffect(e1,true)
    local e2=Effect.CreateEffect(e:GetHandler())
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_DISABLE_EFFECT)
    e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
    tc:RegisterEffect(e2,true)
    Duel.SpecialSummonComplete()
  end
end
 --(3) To hand
function c99950180.thfilter(c)
  return c:IsSetCard(0x995) and c:GetType()==0x82 and c:IsAbleToHand()
end
function c99950180.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99950180.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c99950180.thop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c99950180.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
  if g:GetCount()>0 then
    Duel.SendtoHand(g,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,g)
  end
end