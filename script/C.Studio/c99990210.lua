--SAO Sinon - GGO
--Scripted by Raivost
local s,id=GetID()
function s.initial_effect(c)
  --Xyz Summon
  aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x999),4,2)
  c:EnableReviveLimit()
  --(1) Destroy
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(id,0))
  e1:SetCategory(CATEGORY_DESTROY)
  e1:SetType(EFFECT_TYPE_QUICK_O)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetRange(LOCATION_MZONE)
  e1:SetCountLimit(1,id)
  e1:SetHintTiming(0,0x1e0)
  e1:SetCost(s.descost)
  e1:SetTarget(s.destg)
  e1:SetOperation(s.desop)
  c:RegisterEffect(e1)
  --(2) Direct attack
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(id,1))
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCountLimit(1)
  e2:SetCondition(s.dacon)
  e2:SetCost(s.dacost)
  e2:SetTarget(s.datg)
  e2:SetOperation(s.daop)
  c:RegisterEffect(e2,false,1)
end
--(1) Destroy
function s.descost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x1999,1,REASON_COST) end
  Duel.RemoveCounter(tp,1,0,0x1999,1,REASON_COST)
end
function s.desfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x999) and c:IsType(TYPE_MONSTER)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingTarget(s.desfilter,tp,LOCATION_MZONE,0,1,nil)
  and Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,0))
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
  local g1=Duel.SelectTarget(tp,s.desfilter,tp,LOCATION_MZONE,0,1,1,nil)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
  local g2=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
  g1:Merge(g2)
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,2,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
  local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
  if g:GetCount()>0 then
    Duel.Destroy(g,REASON_EFFECT)
  end
end
--(2) Direct attack
function s.dacon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.IsAbleToEnterBP()
end
function s.dacost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
  e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.datg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return true end
  Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,1))
end
function s.daop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if c:IsFaceup() and c:IsRelateToEffect(e) then
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_DIRECT_ATTACK)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
    c:RegisterEffect(e1)
    --(2.1) Reduce damage
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_PRE_BATTLE_DAMAGE)
    e2:SetCondition(s.rdcon)
    e2:SetOperation(s.rdop)
    e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
    c:RegisterEffect(e2)
  end
end
--(2.1) Reduce damage
function s.rdcon(e,tp,eg,ep,ev,re,r,rp)
  return ep~=tp and Duel.GetAttackTarget()==nil
  and e:GetHandler():IsHasEffect(EFFECT_DIRECT_ATTACK)
  and Duel.IsExistingMatchingCard(aux.NOT(Card.IsHasEffect),tp,0,LOCATION_MZONE,1,nil,EFFECT_IGNORE_BATTLE_TARGET)
end
function s.rdop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local effs={c:GetCardEffect(EFFECT_DIRECT_ATTACK)}
  local eg=Group.CreateGroup()
  for _,eff in ipairs(effs) do
    eg:AddCard(eff:GetOwner())
  end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
  local ec = #eg==1 and eg:GetFirst() or eg:Select(tp,1,1,nil):GetFirst()
  if c==ec then
    Duel.HalfBattleDamage(ep)
  end
end