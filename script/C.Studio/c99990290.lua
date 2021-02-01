--SAO Phantom Bullet
--Scripted by Raivost
local s,id=GetID()
function s.initial_effect(c)
  --(1) Negate activation
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(id,0))
  e1:SetCategory(CATEGORY_NEGATE)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_CHAINING)
  e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
  e1:SetCondition(s.negcon)
  e1:SetCost(s.negcost)
  e1:SetTarget(s.negtg)
  e1:SetOperation(s.negop)
  c:RegisterEffect(e1)
end
--(1) Negate activation
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
  return rp~=tp and Duel.IsChainNegatable(ev)
end
function s.negcostfilter(c)
  return c:IsSetCard(0x999) and c:IsType(TYPE_MONSTER) and (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsAbleToGraveAsCost()
end
function s.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
  local b1=Duel.IsCanRemoveCounter(tp,1,0,0x1999,2,REASON_COST)
  local b2=Duel.IsExistingMatchingCard(s.negcostfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil)
  if chk==0 then return b1 or b2 end
  if b1 and ((not b2) or Duel.SelectYesNo(tp,aux.Stringid(id,1))) then
    Duel.RemoveCounter(tp,1,0,0x1999,2,REASON_COST)
  else
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,s.negcostfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
    Duel.SendtoGrave(g,REASON_COST)
  end
end
function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,0))
  Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.NegateActivation(ev) then
    local cd=re:GetHandler():GetCode()
    local g=Duel.GetMatchingGroup(Card.IsCode,rp,LOCATION_DECK+LOCATION_HAND,0,nil,cd)
    if g:GetCount()>0 then
      Duel.SendtoGrave(g,REASON_EFFECT)
    end
  end
end