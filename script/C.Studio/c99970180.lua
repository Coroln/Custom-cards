--DAL Zaphkiel - Emperor of Time
--Scripted by Raivost
function c99970180.initial_effect(c)
  --(1) Unaffected
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99970180,0))
  e1:SetCategory(CATEGORY_REMOVE)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetTarget(c99970180.unftg)
  e1:SetOperation(c99970180.unfop)
  c:RegisterEffect(e1)
  --(2) Negate
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99970180,3))
  e2:SetCategory(CATEGORY_DISABLE)
  e2:SetType(EFFECT_TYPE_QUICK_O)
  e2:SetRange(LOCATION_GRAVE)
  e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e2:SetCode(EVENT_FREE_CHAIN)
  e2:SetCondition(aux.exccon)
  e2:SetCost(aux.bfgcost)
  e2:SetTarget(c99970180.negtg)
  e2:SetOperation(c99970180.negop)
  c:RegisterEffect(e2)
end
--(1) Unaffected
function c99970180.unffilter(c)
  return c:IsFaceup() and c:IsSetCard(0x997) 
end
function c99970180.banfilter(c)
  return c:IsSetCard(0x997) and not c:IsCode(99970180) and c:IsAbleToRemove()
end
function c99970180.unftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingTarget(c99970180.unffilter,tp,LOCATION_MZONE,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  Duel.SelectTarget(tp,c99970180.unffilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c99970180.unfop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsImmuneToEffect(e) then
  	local e1=Effect.CreateEffect(e:GetHandler())
  	e1:SetDescription(aux.Stringid(99970180,0))
  	e1:SetType(EFFECT_TYPE_SINGLE)
  	e1:SetCode(EFFECT_IMMUNE_EFFECT)
  	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
  	e1:SetRange(LOCATION_MZONE)
  	e1:SetValue(c99970180.unfilter)
  	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
  	e1:SetOwnerPlayer(tp)
  	tc:RegisterEffect(e1)
  end
  if Duel.IsExistingTarget(c99970180.banfilter,tp,LOCATION_DECK,0,1,nil) and
  Duel.SelectYesNo(tp,aux.Stringid(99970180,1)) then
    Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(99970180,2))
  	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
  	local g=Duel.SelectMatchingCard(tp,c99970180.banfilter,tp,LOCATION_DECK,0,1,1,nil)
  	local tg=g:GetFirst()
  	if not tg or Duel.Remove(tg,POS_FACEDOWN,REASON_EFFECT)==0 then return end
  	--(1.1) To hand
  	local e1=Effect.CreateEffect(e:GetHandler())
  	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  	e1:SetRange(LOCATION_REMOVED)
  	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
  	e1:SetCountLimit(1)
  	e1:SetCondition(c99970180.thcon)
  	e1:SetOperation(c99970180.thop)
  	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
  	tg:RegisterEffect(e1)
  end
end
function c99970180.unfilter(e,re)
  return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
--(1.1) To hand
function c99970180.thcon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetTurnPlayer()==tp
end
function c99970180.thop(e,tp,eg,ep,ev,re,r,rp)
  Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
end
--(2) Negate
function c99970180.negtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingTarget(aux.disfilter1,tp,0,LOCATION_ONFIELD,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  local g=Duel.SelectTarget(tp,aux.disfilter1,tp,0,LOCATION_ONFIELD,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c99970180.negop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local tc=Duel.GetFirstTarget()
  if ((tc:IsFaceup() and not tc:IsDisabled()) or tc:IsType(TYPE_TRAPMONSTER)) and tc:IsRelateToEffect(e) then
  	Duel.NegateRelatedChain(tc,RESET_TURN_SET)
  	local e1=Effect.CreateEffect(c)
  	e1:SetType(EFFECT_TYPE_SINGLE)
  	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
  	e1:SetCode(EFFECT_DISABLE)
  	e1:SetReset(RESET_EVENT+0x1fe0000)
  	tc:RegisterEffect(e1)
  	local e2=Effect.CreateEffect(c)
  	e2:SetType(EFFECT_TYPE_SINGLE)
  	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
  	e2:SetCode(EFFECT_DISABLE_EFFECT)
  	e2:SetValue(RESET_TURN_SET)
  	e2:SetReset(RESET_EVENT+0x1fe0000)
  	tc:RegisterEffect(e2)
  	if tc:IsType(TYPE_TRAPMONSTER) then
  	local e3=Effect.CreateEffect(c)
  	e3:SetType(EFFECT_TYPE_SINGLE)
  	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
  	e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
  	e3:SetReset(RESET_EVENT+0x1fe0000)
  	tc:RegisterEffect(e3)
  end
  end
end