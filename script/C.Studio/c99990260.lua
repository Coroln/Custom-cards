--SAO Counteract
--Scripted by Raivost
local s,id=GetID()
function s.initial_effect(c)
  --(1) Negate attack
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(id,0))
  e1:SetCategory(CATEGORY_DESTROY)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_ATTACK_ANNOUNCE)
  e1:SetCountLimit(1,id)
  e1:SetCondition(s.ngatkcon)
  e1:SetTarget(s.ngatktg)
  e1:SetOperation(s.ngatkop)
  c:RegisterEffect(e1)
  --(2) Halve battle damage
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(id,1))
  e2:SetType(EFFECT_TYPE_QUICK_O)
  e2:SetRange(LOCATION_GRAVE)
  e2:SetCode(EVENT_FREE_CHAIN)
  e2:SetCountLimit(1,id+1)
  e2:SetCost(s.hbdcost)
  e2:SetTarget(s.hbdtg)
  e2:SetOperation(s.hbdop)
  c:RegisterEffect(e2)
  --(3) Activate in hand
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_SINGLE)
  e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
  e3:SetCondition(c99990260.handcon)
  c:RegisterEffect(e3)
end
--(1) Negate attack
function s.negconfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x999)
end
function s.ngatkcon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetAttacker():IsControler(1-tp) and Duel.IsExistingMatchingCard(c99990260.negconfilter,tp,LOCATION_MZONE,0,1,nil)
end
function s.ngatktg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,0))
end
function s.ngatkop(e,tp,eg,ep,ev,re,r,rp)
  local at=Duel.GetAttacker()
  if Duel.NegateAttack()~=0 then
    Duel.Destroy(at,REASON_EFFECT)   
  end
end
--(2) Halve battle damage
function s.hbdcost(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
  if chk==0 then return aux.exccon(e,tp,eg,ep,ev,re,r,rp,0) and Duel.IsCanRemoveCounter(tp,1,0,0x1999,1,REASON_COST)  end
  Duel.Remove(c,POS_FACEUP,REASON_COST)
  Duel.RemoveCounter(tp,1,0,0x1999,1,REASON_COST)
end
function s.hbdtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,1))
end
function s.hbdop(e,tp,eg,ep,ev,re,r,rp)
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
  e1:SetCondition(s.damcon)
  e1:SetOperation(s.dop)
  e1:SetReset(RESET_PHASE+PHASE_END)
  Duel.RegisterEffect(e1,tp)
end
function s.damcon(e,tp,eg,ep,ev,re,r,rp)
  return ep==tp
end
function s.dop(e,tp,eg,ep,ev,re,r,rp)
  Duel.HalfBattleDamage(ep)
end
--(3) Activate in hand
function c99990260.handcon(e)
  return Duel.IsExistingMatchingCard(c99990260.negconfilter,tp,LOCATION_MZONE,0,2,nil) 
end