--SAO Confront Battle
--Scripted by Raivost
local s,id=GetID()
function s.initial_effect(c)
  --(1) Gain ATK
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(id,0))
  e1:SetCategory(CATEGORY_ATKCHANGE)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
  e1:SetCondition(s.atkcon)
  e1:SetTarget(s.atktg)
  e1:SetOperation(s.atkop)
  c:RegisterEffect(e1)
end
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
  local a=Duel.GetAttacker()
  local d=Duel.GetAttackTarget()
  if a:IsControler(1-tp) then a=Duel.GetAttackTarget() d=Duel.GetAttacker() end
  return a and d and a:IsSetCard(0x999)
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,0))
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
  local a=Duel.GetAttacker()
  local d=Duel.GetAttackTarget()
  if a:IsControler(1-tp) then a=Duel.GetAttackTarget() d=Duel.GetAttacker() end
  if not a:IsRelateToBattle() or a:IsFacedown() or not d:IsRelateToBattle() or d:IsFacedown() then return end
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE)
  e1:SetValue(d:GetAttack()/2)
  a:RegisterEffect(e1)
  local e2=Effect.CreateEffect(e:GetHandler())
  e2:SetType(EFFECT_TYPE_SINGLE)
  e2:SetCode(EFFECT_UPDATE_ATTACK)
  e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE)
  e2:SetValue(Duel.GetCounter(tp,1,0,0x1999)*100)
  a:RegisterEffect(e2)
end