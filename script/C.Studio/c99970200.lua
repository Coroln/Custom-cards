--DAL Nightmare Shot
--Scripted by Raivost
function c99970200.initial_effect(c)
  --(1) Negate
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99970200,0))
  e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_CHAINING)
  e1:SetCondition(c99970200.negcon)
  e1:SetTarget(c99970200.negtg)
  e1:SetOperation(c99970200.negop)
  c:RegisterEffect(e1)
end
--(1) Negate
function c99970200.negconfilter(c)
  return c:IsFaceup() and c:IsSetCard(0xA97)
end
function c99970200.negcon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.IsChainNegatable(ev) and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE))
  and Duel.IsExistingMatchingCard(c99970200.negconfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c99970200.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
  if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
  	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
  end
end
function c99970200.negop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler() 
  if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
  	Duel.Destroy(eg,REASON_EFFECT)
  end
  if c:IsRelateToEffect(e) and c:IsCanTurnSet() and e:IsHasType(EFFECT_TYPE_ACTIVATE) 
  and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0) 
  and Duel.SelectYesNo(tp,aux.Stringid(99970200,1)) then
  	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(99970200,2))
  	c:CancelToGrave()
  	Duel.ChangePosition(c,POS_FACEDOWN)
  	Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
  end
end