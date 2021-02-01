--DAL Lancelot - Artemisia
--Scripted by Raivost
function c99970600.initial_effect(c)
  --Xyz Summon
  aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x997),3,3)
  c:EnableReviveLimit()
  --(1) Negate
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99970600,0))
  e1:SetCategory(CATEGORY_DISABLE)
  e1:SetType(EFFECT_TYPE_QUICK_O)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetRange(LOCATION_MZONE)
  e1:SetCountLimit(1,99970600)
  e1:SetCost(c99970600.negcost)
  e1:SetTarget(c99970600.negtg)
  e1:SetOperation(c99970600.negop)
  c:RegisterEffect(e1,false,1)
  --(2) Destroy
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99970600,1))
  e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
  e2:SetType(EFFECT_TYPE_QUICK_O)
  e2:SetCode(EVENT_FREE_CHAIN)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCountLimit(1)
  e2:SetTarget(c99970600.destg)
  e2:SetOperation(c99970600.desop)
  c:RegisterEffect(e2)
end
--(1) Negate
function c99970600.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
  e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c99970600.negfilter(c,atk)
  return aux.disfilter1(c) and c:GetAttack()<atk
end
function c99970600.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99970600.negfilter,tp,0,LOCATION_MZONE,1,nil,e:GetHandler():GetAttack()) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99970600.negop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
  local g=Duel.GetMatchingGroup(c99970600.negfilter,tp,0,LOCATION_MZONE,nil,c:GetAttack())
  for tc in aux.Next(g) do
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_DISABLE)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
    tc:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_DISABLE_EFFECT)
    e2:SetValue(RESET_TURN_SET)
    e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
    tc:RegisterEffect(e2)
    Duel.NegateRelatedChain(tc,RESET_TURN_SET)
  end
end
--(2) Destroy
function c99970600.desfilter(c)
  return c:IsSetCard(0x997)
end
function c99970600.destg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99970600.desfilter,tp,LOCATION_HAND,0,1,nil) end
  local g=Duel.GetMatchingGroup(nil,tp,LOCATION_HAND,0,nil)
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c99970600.desop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
  local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_HAND,0,1,1,nil)
  if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT)~=0 then
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetTargetRange(0,LOCATION_MZONE)
    e1:SetValue(-600)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_UPDATE_DEFENSE)
    Duel.RegisterEffect(e2,tp)
    if Duel.IsPlayerCanDraw(tp,1) and g:GetFirst():IsSetCard(0xA97) 
    and Duel.SelectYesNo(tp,aux.Stringid(99970600,2)) then
      Duel.BreakEffect()
      Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(99970600,3))
	  Duel.Draw(tp,1,REASON_EFFECT) 
	end
  end
end