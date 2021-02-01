--SAO LLENN - GGO
--Scripted by Raivost
local s,id=GetID()
function s.initial_effect(c)
  --Xyz Summon
  aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x999),4,2)
  c:EnableReviveLimit()
  --(1) Activate Spell/Trap
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
  e1:SetRange(LOCATION_MZONE)
  e1:SetTargetRange(LOCATION_HAND,0)
  e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x999))
  e1:SetCondition(s.handcon)
  c:RegisterEffect(e1)
  local e2=e1:Clone()
  e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
  c:RegisterEffect(e2)
  local e3=e1:Clone()
  e3:SetCode(id)
  c:RegisterEffect(e3)
  --Activate Cost
  local e4=Effect.CreateEffect(c)
  e4:SetType(EFFECT_TYPE_FIELD)
  e4:SetCode(EFFECT_ACTIVATE_COST)
  e4:SetRange(LOCATION_MZONE)
  e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e4:SetTargetRange(1,0)
  e4:SetCost(s.costchk)
  e4:SetTarget(s.costtg)
  e4:SetOperation(s.costop)
  c:RegisterEffect(e4)
  --(2) Additional attack(s)
  local e5=Effect.CreateEffect(c)
  e5:SetDescription(aux.Stringid(id,0))
  e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e5:SetCode(EVENT_BATTLE_DESTROYING)
  e5:SetCondition(s.aacon)
  e5:SetCost(s.aacost)
  e5:SetTarget(s.aatg)
  e5:SetOperation(s.aaop)
  c:RegisterEffect(e5,false,1)
end
--(1) Activate Spell/Trap
function s.handcon(e)
  return Duel.GetTurnPlayer()~=e:GetHandlerPlayer() and Duel.IsCanRemoveCounter(e:GetHandlerPlayer(),1,0,0x1999,2,REASON_COST)
end
function s.costchk(e,te_or_c,tp)
  return Duel.IsCanRemoveCounter(tp,1,0,0x1999,2,REASON_COST)
end
function s.costtg(e,te,tp)
  local tc=te:GetHandler()
  return Duel.GetTurnPlayer()~=e:GetHandlerPlayer()
    and tc:IsLocation(LOCATION_HAND) and tc:GetEffectCount(id)>0
    and ((tc:GetEffectCount(EFFECT_QP_ACT_IN_NTPHAND)<=tc:GetEffectCount(id) and tc:IsType(TYPE_QUICKPLAY))
    or (tc:GetEffectCount(EFFECT_TRAP_ACT_IN_HAND)<=tc:GetEffectCount(id) and tc:IsType(TYPE_TRAP)))
end
function s.costop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_CARD,0,id)
  Duel.RemoveCounter(tp,1,0,0x1999,2,REASON_COST)
end
--(2) Additional attack(s)
function s.aacon(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local bc=c:GetBattleTarget()
  return c==Duel.GetAttacker() and c:IsRelateToBattle() and c:IsStatus(STATUS_OPPO_BATTLE) and bc:IsType(TYPE_MONSTER) and c:IsChainAttackable(0)
end
function s.aacost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
  e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.aatg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return true end
  Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,0))
end
function s.aaop(e,tp,eg,ep,ev,re,r,rp)
  Duel.ChainAttack()
end