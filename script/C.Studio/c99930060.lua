--OTNN Eremerian Onslaught
--Scripted by Raivost
function c99930060.initial_effect(c)
  --(1) Destroy
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99930060,0))
  e1:SetCategory(CATEGORY_DESTROY)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetCountLimit(1,99930060+EFFECT_COUNT_CODE_OATH)
  e1:SetCondition(c99930060.descon)
  e1:SetCost(c99930060.descost)
  e1:SetTarget(c99930060.destg)
  e1:SetOperation(c99930060.desop)
  c:RegisterEffect(e1)
  --(2) Indes by battle/effects
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99930060,1))
  e2:SetType(EFFECT_TYPE_QUICK_O)
  e2:SetRange(LOCATION_GRAVE)
  e2:SetCode(EVENT_FREE_CHAIN)
  e2:SetCondition(aux.exccon)
  e2:SetCost(c99930060.indcost)
  e2:SetTarget(c99930060.indtg)
  e2:SetOperation(c99930060.indop)
  c:RegisterEffect(e2)
end
--(1) Destroy
function c99930060.desconfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x993) and c:IsType(TYPE_XYZ)
end
function c99930060.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c99930060.desconfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c99930060.descost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_EFFECT) end
  Duel.RemoveOverlayCard(tp,1,0,1,99,REASON_EFFECT)
  local ct=Duel.GetOperatedGroup():GetCount()
  e:SetLabel(ct)
end
function c99930060.destg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) end
  local ct=e:GetLabel() 
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
  local g1=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,ct,e:GetHandler())
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,g1:GetCount(),0,0)
end
function c99930060.rkfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x993) and c:IsType(TYPE_XYZ)
end
function c99930060.desop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local g1=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
  local sg=g1:Filter(Card.IsRelateToEffect,nil,e)
  if Duel.Destroy(sg,REASON_EFFECT)~=0 then
    local g2=Duel.GetMatchingGroup(c99930060.rkfilter,tp,LOCATION_MZONE,0,nil)
    local tc=g2:GetFirst()
    while tc do
      local e1=Effect.CreateEffect(e:GetHandler())
      e1:SetType(EFFECT_TYPE_SINGLE)
      e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
      e1:SetCode(EFFECT_UPDATE_RANK)
      e1:SetValue(e:GetLabel())
      e1:SetReset(RESET_EVENT+0x1fe0000)
      tc:RegisterEffect(e1)
      tc=g2:GetNext()
    end
  end
end
--(2) Indes by battle/effects
function c99930060.indcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
  Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c99930060.indtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99930060.rkfilter,tp,LOCATION_MZONE,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99930060.indop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()           
  local g=Duel.GetMatchingGroup(c99930060.rkfilter,tp,LOCATION_MZONE,0,nil)
  local tc=g:GetFirst()
  while tc do
    --(2.1) Indes by effects
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetValue(c99930060.efilter)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
    tc:RegisterEffect(e1)
    --(2.2) Untargetable
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e2:SetValue(c99930060.tgval)
    e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
    tc:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e3:SetValue(1)
    e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
    tc:RegisterEffect(e3)
    tc=g:GetNext()
  end
end
--(2.1) Indes by effects
function c99930060.efilter(e,re)
  return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
--(2.2) Untargetable
function c99930060.tgval(e,re,rp)
  return rp~=e:GetOwnerPlayer()
end