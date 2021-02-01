--SAO Yuuki ALO
--Scripted by Raivost
local s,id=GetID()
function s.initial_effect(c)
  --Synchro Summon
  aux.AddSynchroProcedure(c,nil,1,1,aux.NonTuner(Card.IsSetCard,0x999),1,1)
  c:EnableReviveLimit()
  --(1) Lose ATK
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(id,0))
  e1:SetCategory(CATEGORY_ATKCHANGE)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e1:SetProperty(EFFECT_FLAG_DELAY)
  e1:SetCode(EVENT_SPSUMMON_SUCCESS)
  e1:SetCondition(s.atkcon)
  e1:SetTarget(s.atktg)
  e1:SetOperation(s.atkop)
  c:RegisterEffect(e1)
  --(2) Additional attacks
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(id,1))
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e2:SetCode(EVENT_BATTLE_DESTROYING)
  e2:SetCountLimit(1)
  e2:SetCondition(s.aacon)
  e2:SetCost(s.aacost)
  e2:SetTarget(s.aatg)
  e2:SetOperation(s.aaop)
  c:RegisterEffect(e2)
end
--(1) Lose ATK
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function s.atkfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x999) and c:IsType(TYPE_MONSTER)
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
  local ct=Duel.GetMatchingGroupCount(s.atkfilter,tp,LOCATION_MZONE,0,e:GetHandler())
  if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) and ct>0 end
  Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,0))
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
  local ct=Duel.GetMatchingGroupCount(s.atkfilter,tp,LOCATION_MZONE,0,e:GetHandler())
  local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
  for tc in aux.Next(g) do
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(-300*ct)
    e1:SetReset(RESET_EVENT+0x1fe0000)
    tc:RegisterEffect(e1)
  end
end
--(2) Additional attacks
function s.aacon(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local bc=c:GetBattleTarget()
  return c==Duel.GetAttacker() and c:IsRelateToBattle() and c:IsStatus(STATUS_OPPO_BATTLE) and bc:IsType(TYPE_MONSTER)
end
function s.aacost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x1999,1,REASON_COST) end
  local ct1=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
  local ct2=Duel.GetCounter(tp,1,0,0x1999)
  if ct1>ct2 then ct1=ct2 end
  if ct1>1 then
    local t={}
    for i=1,ct1 do t[i]=i end
    local ac=Duel.AnnounceNumber(tp,table.unpack(t))
    Duel.RemoveCounter(tp,1,0,0x1999,ac,REASON_COST)
    e:SetLabel(ac)
  else
    Duel.RemoveCounter(tp,1,0,0x1999,1,REASON_COST)
    e:SetLabel(1)
  end
end
function s.aatg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
  if chk==0 then return ct>0 end
  Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,1))
end
function s.aaop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if c:IsRelateToBattle() then
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
    e1:SetValue(e:GetLabel())
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
    c:RegisterEffect(e1)
  end
end