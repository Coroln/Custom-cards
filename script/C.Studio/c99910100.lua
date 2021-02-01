--YuYuYu Into Jukai
--Scripted by Raivost
function c99910100.initial_effect(c)
  --(1) Special Summon
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99910100,0))
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCondition(c99910100.spcon)
  e1:SetTarget(c99910100.sptg)
  e1:SetOperation(c99910100.spop)
  c:RegisterEffect(e1)
  --(2) Activate
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99910100,1))
  e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e2:SetType(EFFECT_TYPE_ACTIVATE)
  e2:SetCode(EVENT_FREE_CHAIN)
  e2:SetCondition(c99910100.accon)
  e2:SetTarget(c99910100.actg)
  e2:SetOperation(c99910100.acop)
  c:RegisterEffect(e2)
end
--(1) Special Summon
function c99910100.spcon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.IsEnvironment(99910070)
end
function c99910100.spfilter(c,e,tp)
  return c:IsSetCard(0x991) and c:IsType(TYPE_PENDULUM) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99910100.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCountFromEx(tp)>0
  and Duel.IsExistingMatchingCard(c99910100.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c99910100.spop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCountFromEx(tp)<=0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,c99910100.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
  if g:GetCount()>0 then
    Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
  end
end
--(2) Activate
function c99910100.accon(e,tp,eg,ep,ev,re,r,rp)
  return not Duel.IsEnvironment(99910070)
end
function c99910100.acfilter(c,tp)
  return c:IsCode(99910070) and c:GetActivateEffect() and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function c99910100.thfilter(c)
  return c:IsSetCard(0x991) and c:IsRace(RACE_FAIRY) and c:IsAbleToHand()
end
function c99910100.actg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99910100.acfilter,tp,LOCATION_DECK,0,1,nil,tp) 
  and Duel.IsExistingMatchingCard(c99910100.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c99910100.acop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
  local tc=Duel.SelectMatchingCard(tp,c99910100.acfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
  if tc then
    local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
    if fc then
      Duel.SendtoGrave(fc,REASON_RULE)
      Duel.BreakEffect()
    end
    Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    local te=tc:GetActivateEffect()
    local tep=tc:GetControler()
    local cost=te:GetCost()
    if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
    Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c99910100.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
    if g:GetCount()>0 then
      Duel.SendtoHand(g,nil,REASON_EFFECT)
      Duel.ConfirmCards(1-tp,g)
    end
  end
end