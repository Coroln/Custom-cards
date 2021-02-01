--BRS Counter Star
--Scripted by Raivost
function c99960180.initial_effect(c)
  --(1) Negate Attack
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99960180,0))
  e1:SetCategory(CATEGORY_DESTROY)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_ATTACK_ANNOUNCE)
  e1:SetCondition(c99960180.negcon1)
  e1:SetTarget(c99960180.negtg1)
  e1:SetOperation(c99960180.negop1)
  c:RegisterEffect(e1)
  --(2) Negate Effect
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99960180,1))
  e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
  e2:SetType(EFFECT_TYPE_ACTIVATE)
  e2:SetCode(EVENT_CHAINING)
  e2:SetCondition(c99960180.negcon2)
  e2:SetTarget(c99960180.negtg2)
  e2:SetOperation(c99960180.negop2)
  c:RegisterEffect(e2)
  --(3) Set
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99960180,2))
  e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e3:SetCode(EVENT_TO_GRAVE)
  e3:SetCondition(c99960180.setcon)
  e3:SetTarget(c99960180.settg)
  e3:SetOperation(c99960180.setop)
  c:RegisterEffect(e3)
end
--(1) Negate Attack
function c99960180.negconfilter1(c)
  return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x996)
end
function c99960180.negcon1(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetAttacker():IsControler(1-tp) and Duel.IsExistingMatchingCard(c99960180.negconfilter1,tp,LOCATION_MZONE,0,1,nil)
end
function c99960180.negtg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return true end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99960180.negop1(e,tp,eg,ep,ev,re,r,rp)
  local a=Duel.GetAttacker()
  if Duel.NegateAttack(a) then
    Duel.Destroy(a,REASON_EFFECT)
  end
end
--(2) Negate effect
function c99960180.negcon2(e,tp,eg,ep,ev,re,r,rp)
  return Duel.IsExistingMatchingCard(c99960180.negconfilter1,tp,LOCATION_MZONE,0,1,nil)
  and rp~=tp and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c99960180.negtg2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
  if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
  end
end
function c99960180.negop2(e,tp,eg,ep,ev,re,r,rp)
  Duel.NegateActivation(ev)
  if re:GetHandler():IsRelateToEffect(re) then
    Duel.Destroy(eg,REASON_EFFECT)
  end
end
--(3) Set
function c99960180.setcon(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  return c:IsReason(REASON_COST) and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_MONSTER)
  and c:IsPreviousLocation(LOCATION_OVERLAY) and re:GetHandler():IsSetCard(0x996) 
end
function c99960180.settg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c99960180.setop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if c:IsRelateToEffect(e) and c:IsSSetable() then 
    Duel.SSet(tp,c)
    Duel.ConfirmCards(1-tp,c)
  end
end