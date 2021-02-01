--MSMM Ending Pride
--Scripted by Raivost
function c99950170.initial_effect(c)
  --(1) Negate attack 1
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99950170,0))
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_ATTACK_ANNOUNCE)
  e1:SetCondition(c99950170.negcon1)
  e1:SetTarget(c99950170.negtg1)
  e1:SetOperation(c99950170.negop1)
  c:RegisterEffect(e1)
  --(2) Negate attack 2
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99950170,1))
  e2:SetCategory(CATEGORY_TOGRAVE)
  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e2:SetCode(EVENT_ATTACK_ANNOUNCE)
  e2:SetRange(LOCATION_HAND)
  e2:SetCondition(c99950170.negcon2)
  e2:SetCost(c99950170.negcost)
  e2:SetTarget(c99950170.negtg2)
  e2:SetOperation(c99950170.negop2)
  c:RegisterEffect(e2)
end
--(1) Negate attack 1
function c99950170.negcon1(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetAttacker()
  local at=Duel.GetAttackTarget()
  if not at or tc:IsFacedown() or at:IsFacedown() then return false end
  if tc:IsControler(1-tp) then tc=at end
  return tc:IsControler(tp) and tc:IsLocation(LOCATION_MZONE) and tc:IsSetCard(0x995)
end
function c99950170.negtg1(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 
  and Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0 end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,PLAYER_ALL,LOCATION_DECK)
end
function c99950170.negop1(e,tp,eg,ep,ev,re,r,rp)
  if Duel.NegateAttack() then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g1=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_DECK,0,1,1,nil)
    Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
    local g2=Duel.SelectMatchingCard(1-tp,Card.IsAbleToGrave,1-tp,LOCATION_DECK,0,1,1,nil)
    g1:Merge(g2)
    Duel.SendtoGrave(g1,REASON_EFFECT)
  end 
end
--(2) Negate attack 2
function c99950170.negcon2(e,tp,eg,ep,ev,re,r,rp)
  local at=Duel.GetAttacker()
  return at:GetControler()~=tp and Duel.GetAttackTarget()==nil
end
function c99950170.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():IsDiscardable() end
  Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c99950170.negfilter(c)
  return c:IsSetCard(0x995) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c99950170.negtg2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99950170.negfilter,tp,LOCATION_DECK,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c99950170.negop2(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
  local g=Duel.SelectMatchingCard(tp,c99950170.negfilter,tp,LOCATION_DECK,0,1,1,nil)
  local tc=g:GetFirst()
  if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE) then
    Duel.NegateAttack()
  end
end