--SAO Limitless Combat
--Scripted by Raivost
local s,id=GetID()
function s.initial_effect(c)
  --(1) Additional attacks
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(id,0))
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
  e1:SetCondition(s.aacon)
  e1:SetCost(s.aacost)
  e1:SetTarget(s.aatg)
  e1:SetOperation(s.aaop)
  c:RegisterEffect(e1)
end
--(1) Additional attacks
function s.aacon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.IsAbleToEnterBP() or (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE)
end
function s.aacost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x1999,1,REASON_COST) end
  local ct=Duel.GetCounter(tp,1,0,0x1999)
  if ct>1 then
    local t={}
    for i=1,ct do t[i]=i end
    local ac=Duel.AnnounceNumber(tp,table.unpack(t))
    Duel.RemoveCounter(tp,1,0,0x1999,ac,REASON_COST)
    e:SetLabel(ac)
  else
    Duel.RemoveCounter(tp,1,0,0x1999,1,REASON_COST)
    e:SetLabel(1)
  end
end
function s.aafilter(c)
  return c:IsFaceup() and c:IsSetCard(0x999) and c:IsType(TYPE_MONSTER)
end
function s.aatg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingTarget(s.aafilter,tp,LOCATION_MZONE,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,0))
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  Duel.SelectTarget(tp,s.aafilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function s.aaop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsFaceup() and tc:IsRelateToEffect(e) then
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_EXTRA_ATTACK)
    e1:SetValue(e:GetLabel())
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
    tc:RegisterEffect(e1,true)
    local e2=Effect.CreateEffect(e:GetHandler())
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_NO_BATTLE_DAMAGE)
    e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
    tc:RegisterEffect(e2,true)
  end
end