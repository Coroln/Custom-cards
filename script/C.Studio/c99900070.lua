--Re:C CM: Representation Exposition
--Scripted by Raivost
function c99900070.initial_effect(c)
  --(1) Negate attack
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99900070,0))
  e1:SetCategory(CATEGORY_RECOVER)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_ATTACK_ANNOUNCE)
  e1:SetCondition(c99900070.nacon)
  e1:SetTarget(c99900070.natg)
  e1:SetOperation(c99900070.naop)
  c:RegisterEffect(e1)
  --(2) Negate effect
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99900070,1))
  e2:SetCategory(CATEGORY_NEGATE+CATEGORY_RECOVER)
  e2:SetType(EFFECT_TYPE_ACTIVATE)
  e2:SetCode(EVENT_CHAINING)
  e2:SetCondition(c99900070.negcon)
  e2:SetTarget(c99900070.negtg)
  e2:SetOperation(c99900070.negop)
  c:RegisterEffect(e2)
end
--(1) Negate attack
function c99900070.acconfilter(c)
  return c:IsFaceup() and c:IsCode(99900010)
end
function c99900070.nacon(e,tp,eg,ep,ev,re,r,rp)
  local at=Duel.GetAttacker()
  return at:GetControler()~=tp and Duel.IsExistingMatchingCard(c99900070.acconfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c99900070.natg(e,tp,eg,ep,ev,re,r,rp,chk)
  local at=Duel.GetAttacker()
  if chk==0 then return at and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99900070.naop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)~=0 then
    local ct=Duel.GetMatchingGroupCount(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
    if Duel.NegateAttack()~=0 and ct>0 then
      Duel.Recover(tp,ct*500,REASON_EFFECT)
    end
  end
end
--(2) Negate effect
function c99900070.negconfilter(c,tp)
  return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
end
function c99900070.negcon(e,tp,eg,ep,ev,re,r,rp)
  if not (rp==1-tp and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET)) then return false end
  local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
  return g and g:IsExists(c99900070.negconfilter,1,nil,tp) and Duel.IsChainDisablable(ev) 
  and Duel.IsExistingMatchingCard(c99900070.acconfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c99900070.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c99900070.negop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)~=0 then
    local ct=Duel.GetMatchingGroupCount(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
    if Duel.NegateEffect(ev)~=0 and ct>0 then
      Duel.Recover(tp,ct*500,REASON_EFFECT)
    end
  end
end