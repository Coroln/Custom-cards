--Overlord Ruler of Death
--Scripted by Raivost
function c99920020.initial_effect(c)
  --Activate
  local e0=Effect.CreateEffect(c)
  e0:SetType(EFFECT_TYPE_ACTIVATE)  
  e0:SetCode(EVENT_FREE_CHAIN)
  c:RegisterEffect(e0)
  --(1) Cannot be targeted/destroyed
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
  e1:SetRange(LOCATION_FZONE)
  e1:SetCondition(c99920020.tgindcon)
  e1:SetValue(1)
  c:RegisterEffect(e1)
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE)
  e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e2:SetRange(LOCATION_FZONE)
  e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
  e2:SetCondition(c99920020.tgindcon)
  e2:SetValue(1)
  c:RegisterEffect(e2)
  --(2) Negate
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99920020,0))
  e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
  e3:SetType(EFFECT_TYPE_QUICK_O)
  e3:SetCode(EVENT_CHAINING)
  e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
  e3:SetRange(LOCATION_FZONE)
  e3:SetCondition(c99920020.negcon)
  e3:SetCost(c99920020.negcost)
  e3:SetTarget(c99920020.negtg)
  e3:SetOperation(c99920020.negop)
  c:RegisterEffect(e3)
  --(3) Gain LP
  local e4=Effect.CreateEffect(c)
  e4:SetDescription(aux.Stringid(99920020,1))
  e4:SetCategory(CATEGORY_RECOVER)
  e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
  e4:SetCode(EVENT_DESTROYED)
  e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e4:SetRange(LOCATION_FZONE)
  e4:SetTarget(c99920020.rectg)
  e4:SetOperation(c99920020.recop)
  c:RegisterEffect(e4)
end
--(1) Cannot be targeted/destroyed
function c99920020.ainzfilter(c)
  return c:IsFaceup() and c:IsCode(99920010)
end
function c99920020.tgindcon(e)
  return Duel.IsExistingMatchingCard(c99920020.ainzfilter,e:GetHandler():GetControler(),LOCATION_MZONE,0,1,nil)
end
--(2) Negate
function c99920020.tdfilter(c)
  return c:IsSetCard(0x992) and  c:IsSetCard(0xB92) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeckAsCost()
end
function c99920020.negcon(e,tp,eg,ep,ev,re,r,rp)
  return re:GetHandler()~=e:GetHandler() and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and rp~=tp
  and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c99920020.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99920020.tdfilter,tp,LOCATION_MZONE,0,1,nil) and e:GetHandler():GetFlagEffect(99920020)==0 end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
  local g=Duel.SelectMatchingCard(tp,c99920020.tdfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
  Duel.SendtoDeck(g,nil,2,REASON_COST)
  if Duel.IsExistingMatchingCard(c99920020.ainzfilter,tp,LOCATION_MZONE,0,1,nil) then
    Duel.SetChainLimit(c99920020.chlimit)
  end
  e:GetHandler():RegisterFlagEffect(99920020,RESET_CHAIN,0,1)
end
function c99920020.chlimit(e,ep,tp)
  return tp==ep
end
function c99920020.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
  if re:GetHandler():IsRelateToEffect(re) then
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
  end
end
function c99920020.negop(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
    Duel.Destroy(eg,REASON_EFFECT)
  end
end
function c99920020.recfilter(c,e,tp)
  return c:IsType(TYPE_MONSTER) and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==1-tp
  and c:IsReason(REASON_EFFECT+REASON_BATTLE)
end
function c99920020.rectg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return eg:IsExists(c99920020.recfilter,1,nil,e,tp) end
  local g=eg:Filter(c99920020.recfilter,nil,e,tp)
  local rec=0
  for tc in aux.Next(g) do
    rec=rec+math.floor(tc:GetBaseAttack()/2)
  end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetTargetPlayer(tp)
  Duel.SetTargetParam(rec)
  if Duel.IsExistingMatchingCard(c99920020.ainzfilter,tp,LOCATION_MZONE,0,1,nil) then
    Duel.SetChainLimit(c99920020.chlimit)
  end
  Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,rec)
end
function c99920020.recop(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
  Duel.Recover(p,d,REASON_EFFECT)
end