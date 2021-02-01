--Overlord Making Strategies
--Scripted by Raivost
function c99920080.initial_effect(c)
  --(1) Activate
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99920080,0))
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetHintTiming(0,0x1e0)
  e1:SetTarget(c99920080.actg)
  c:RegisterEffect(e1)
  --(2) Gain LP
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99920080,0))
  e2:SetCategory(CATEGORY_RECOVER+CATEGORY_SPECIAL_SUMMON)
  e2:SetType(EFFECT_TYPE_QUICK_O)
  e2:SetCode(EVENT_FREE_CHAIN)
  e2:SetRange(LOCATION_SZONE)
  e2:SetHintTiming(0,0x1e0)
  e2:SetCost(c99920080.reccost)
  e2:SetTarget(c99920080.rectg)
  e2:SetOperation(c99920080.recop)
  c:RegisterEffect(e2)
end
--(1) Activate
function c99920080.actg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return false end
  if chk==0 then return true end
  if c99920080.reccost(e,tp,eg,ep,ev,re,r,rp,0) and c99920080.rectg(e,tp,eg,ep,ev,re,r,rp,0)
  and Duel.SelectYesNo(tp,94) then
    e:SetCategory(CATEGORY_RECOVER+CATEGORY_SPECIAL_SUMMON)
    c99920080.reccost(e,tp,eg,ep,ev,re,r,rp,1)
    c99920080.rectg(e,tp,eg,ep,ev,re,r,rp,1)
    e:SetOperation(c99920080.recop)
  else
    e:SetCategory(0)
    e:SetProperty(0)
    e:SetOperation(nil)
  end
end
--(2) Gain LP
function c99920080.reccostfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x992) and not c:IsCode(99920010) and c:IsAbleToGraveAsCost()
end
function c99920080.reccost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetFlagEffect(tp,99920080)==0 
  and Duel.IsExistingMatchingCard(c99920080.reccostfilter,tp,LOCATION_MZONE,0,1,nil) end
  Duel.RegisterFlagEffect(tp,99920080,RESET_PHASE+PHASE_END,0,1)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
  local g=Duel.SelectMatchingCard(tp,c99920080.reccostfilter,tp,LOCATION_MZONE,0,1,1,nil)
  e:SetLabel(g:GetFirst():GetAttack()/2)
  Duel.SendtoGrave(g,REASON_COST)
end
function c99920080.spfilter(c,e,tp)
  return c:IsSetCard(0x992) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99920080.rectg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return true end
  Duel.SetTargetPlayer(tp)
  Duel.SetTargetParam(e:GetLabel())
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,e:GetLabel())
end
function c99920080.recop(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
  if Duel.Recover(p,d,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c99920080.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
  and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(99920080,1)) then
    Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(99920080,2))
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c99920080.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
      Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
  end
end