--DAL Licorice Assault
--Scripted by Raivost
function c99970250.initial_effect(c)
  --(1) Destroy 1
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99970250,0))
  e1:SetCategory(CATEGORY_DESTROY)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCost(c99970250.descost1)
  e1:SetTarget(c99970250.destg1)
  e1:SetOperation(c99970250.desop1)
  c:RegisterEffect(e1)
  --(2) Destroy 2
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99970250,0))
  e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
  e2:SetType(EFFECT_TYPE_QUICK_O)
  e2:SetRange(LOCATION_GRAVE)
  e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e2:SetCode(EVENT_FREE_CHAIN)
  e2:SetCondition(aux.exccon)
  e2:SetCost(aux.bfgcost)
  e2:SetTarget(c99970250.destg2)
  e2:SetOperation(c99970250.desop2)
  c:RegisterEffect(e2)
end
--(1) Destroy 1
function c99970250.descost1(e,tp,eg,ep,ev,re,r,rp,chk)
  e:SetLabel(1)
  return true
end
function c99970250.descostfilter1(c,e,dg,tp)
  if not (c:IsFaceup() and c:IsSetCard(0x997) and c:IsType(TYPE_XYZ)) then return false end
  local a=0
  if dg:IsContains(c) then a=1 end
  if c:GetEquipCount()==0 then return dg:GetCount()-a>=1 end
  local eg=c:GetEquipGroup()
  for tc in aux.Next(eg) do
  	if dg:IsContains(tc) then a=a+1 end
  end
  return dg:GetCount()-a>=1
end
function c99970250.desfilter(c,e)
  return c:IsCanBeEffectTarget(e)
end
function c99970250.destg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then
  	if chkc then return chkc:IsOnField() end
  	if e:GetLabel()==1 then
  	  e:SetLabel(0)
  	  local rg=Duel.GetReleaseGroup(tp)
  	  local dg=Duel.GetMatchingGroup(c99970250.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler(),e)
  	  local res=rg:IsExists(c99970250.descostfilter1,1,e:GetHandler(),e,dg)
  	  return res
    else
  	  return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler())
    end
  end
  if e:GetLabel()==1 then
  	e:SetLabel(0)
  	local rg=Duel.GetReleaseGroup(tp)
  	local dg=Duel.GetMatchingGroup(c99970250.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler(),e)
  	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
  	local sg=rg:FilterSelect(tp,c99970250.descostfilter1,1,1,e:GetHandler(),e,dg)
  	Duel.Release(sg,REASON_COST)
  end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
  local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,2,e:GetHandler())
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c99970250.desop1(e,tp,eg,ep,ev,re,r,rp)
  local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
  local sg=g:Filter(Card.IsRelateToEffect,nil,e)
  Duel.Destroy(sg,REASON_EFFECT)
end
--(2) Destroy 2
function c99970250.desfilter2(c)
  return c:IsFaceup() and c:IsSetCard(0x997) and c:IsType(TYPE_XYZ)
end
function c99970250.destg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingTarget(c99970250.desfilter2,tp,LOCATION_MZONE,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
  local g=Duel.SelectTarget(tp,c99970250.desfilter2,tp,LOCATION_MZONE,0,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
  Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetFirst():GetAttack()/2)
end
function c99970250.desop2(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) then
  	local dam=tc:GetAttack()/2
  	if dam<0 or tc:IsFacedown() then dam=0 end
  	if Duel.Destroy(tc,REASON_EFFECT)~=0 then
  	  Duel.Damage(1-tp,dam,REASON_EFFECT)
  	end
  end
end