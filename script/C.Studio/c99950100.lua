--MSMM Witch Devastation
--Scripted by Raivost
function c99950100.initial_effect(c)
  --(1) Destroy
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99950100,0))
  e1:SetCategory(CATEGORY_DESTROY)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,99950100+EFFECT_COUNT_CODE_OATH)
  e1:SetCost(c99950100.descost)
  e1:SetTarget(c99950100.destg)
  e1:SetOperation(c99950100.desop)
  c:RegisterEffect(e1)
end
--(1) Destroy
function c99950100.descostfilter(c)
  return c:IsSetCard(0x995) and bit.band(c:GetType(),0x81)==0x81 and c:IsAbleToGraveAsCost()
end
function c99950100.desfilter1(c)
  return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c99950100.desfilter2(c)
  return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c99950100.descost(e,tp,eg,ep,ev,re,r,rp,chk)
  local ct1=Duel.GetMatchingGroupCount(c99950100.desfilter1,tp,0,LOCATION_ONFIELD,nil)
  local ct2=Duel.GetMatchingGroupCount(c99950100.desfilter2,tp,0,LOCATION_MZONE,nil)
  local ct=ct1+ct2
  if ct>5 then ct=5 end
  if chk==0 then return Duel.IsExistingMatchingCard(c99950100.descostfilter,tp,LOCATION_DECK,0,ct,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
  local g=Duel.SelectMatchingCard(tp,c99950100.descostfilter,tp,LOCATION_DECK,0,1,ct,nil)
  local ctt=Duel.SendtoGrave(g,REASON_COST)
  e:SetLabel(ctt)
end
function c99950100.desfilter3(c)
  return (c:IsFaceup() and c:IsType(TYPE_MONSTER)) or c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c99950100.destg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99950100.desfilter3,tp,0,LOCATION_ONFIELD,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  local g=Duel.GetMatchingGroup(c99950100.desfilter3,tp,0,LOCATION_ONFIELD,nil)
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c99950100.desop(e,tp,eg,ep,ev,re,r,rp)
  local g=Duel.GetMatchingGroup(c99950100.desfilter3,tp,0,LOCATION_ONFIELD,nil)
  local ct=e:GetLabel()
  if ct>0 and g:GetCount()>0 then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local dg=g:Select(tp,1,ct,nil)
    Duel.HintSelection(dg)
    Duel.Destroy(dg,REASON_EFFECT)
  end
end