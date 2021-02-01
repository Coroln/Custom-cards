--MSMM Rain Of Vain
--Scripted by Raivost
function c99950110.initial_effect(c)
  --(1) Negate attack
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99950110,0))
  e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DRAW)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_BE_BATTLE_TARGET)
  e1:SetCountLimit(1,99950110+EFFECT_COUNT_CODE_OATH)
  e1:SetCondition(c99950110.negcon1)
  e1:SetTarget(c99950110.negtg1)
  e1:SetOperation(c99950110.negop1)
  c:RegisterEffect(e1)
  --(2) Negate effect
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99950110,1))
  e2:SetCategory(CATEGORY_DISABLE+CATEGORY_ATKCHANGE+CATEGORY_DRAW)
  e2:SetType(EFFECT_TYPE_ACTIVATE)
  e2:SetCode(EVENT_BECOME_TARGET)
  e2:SetCountLimit(1,99950110+EFFECT_COUNT_CODE_OATH)
  e2:SetCondition(c99950110.negcon2)
  e2:SetTarget(c99950110.negtg2)
  e2:SetOperation(c99950110.negop2)
  c:RegisterEffect(e2)
end
--(1) Negate attack
function c99950110.negconfilter(c,tp)
  return c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c:IsSetCard(0x995) and bit.band(c:GetType(),0x81)==0x81
end
function c99950110.negcon1(e,tp,eg,ep,ev,re,r,rp)
  return eg:IsExists(c99950110.negconfilter,1,nil,tp)
end
function c99950110.negtg1(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99950110.atkfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x995) and bit.band(c:GetOriginalType(),0x81)==0x81
end
function c99950110.negop1(e,tp,eg,ep,ev,re,r,rp)
  Duel.NegateAttack()
  Duel.BreakEffect()
  if Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) 
  and Duel.IsExistingMatchingCard(c99950110.atkfilter,tp,LOCATION_SZONE,0,1,nil) then
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
    local atk=Duel.GetMatchingGroupCount(c99950110.atkfilter,e:GetHandlerPlayer(),LOCATION_SZONE,0,nil)*300
    for tc in aux.Next(g) do
      local e1=Effect.CreateEffect(e:GetHandler())
      e1:SetType(EFFECT_TYPE_SINGLE)
      e1:SetCode(EFFECT_UPDATE_ATTACK)
      e1:SetValue(-atk)
      e1:SetReset(RESET_EVENT+0x1fe0000)
      tc:RegisterEffect(e1)
    end
  end
  --(1.1) Draw
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e1:SetCode(EVENT_PHASE+PHASE_END)
  e1:SetReset(RESET_PHASE+PHASE_END)
  e1:SetCountLimit(1)
  e1:SetTarget(c99950110.drtg)
  e1:SetOperation(c99950110.drop)
  Duel.RegisterEffect(e1,tp)
end
--(1.1) Draw
function c99950110.drfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x995) and bit.band(c:GetType(),0x81)==0x81
end
function c99950110.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  local ct=Duel.GetMatchingGroupCount(c99950110.drfilter,tp,LOCATION_MZONE,0,nil)
  Duel.SetTargetPlayer(tp)
  Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function c99950110.drop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_CARD,0,99950110)
  local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
  local d=Duel.GetMatchingGroupCount(c99950110.drfilter,tp,LOCATION_MZONE,0,nil)
  Duel.Draw(p,d,REASON_EFFECT)
end
--(2) Negate effect
function c99950110.negcon2(e,tp,eg,ep,ev,re,r,rp)
  return rp~=tp and eg:IsExists(c99950110.negconfilter,1,nil,tp)
end
function c99950110.negtg2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c99950110.negop2(e,tp,eg,ep,ev,re,r,rp)
  Duel.NegateActivation(ev)
  Duel.BreakEffect()
  if Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) 
  and Duel.IsExistingMatchingCard(c99950110.atkfilter,tp,LOCATION_SZONE,0,1,nil) then
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
    local atk=Duel.GetMatchingGroupCount(c99950110.atkfilter,e:GetHandlerPlayer(),LOCATION_SZONE,0,nil)*300
    for tc in aux.Next(g) do
      local e1=Effect.CreateEffect(e:GetHandler())
      e1:SetType(EFFECT_TYPE_SINGLE)
      e1:SetCode(EFFECT_UPDATE_ATTACK)
      e1:SetValue(-atk)
      e1:SetReset(RESET_EVENT+0x1fe0000)
      tc:RegisterEffect(e1)
    end
  end
  --(1.1) Draw
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e1:SetCode(EVENT_PHASE+PHASE_END)
  e1:SetReset(RESET_PHASE+PHASE_END)
  e1:SetCountLimit(1)
  e1:SetTarget(c99950110.drtg)
  e1:SetOperation(c99950110.drop)
  Duel.RegisterEffect(e1,tp)
end