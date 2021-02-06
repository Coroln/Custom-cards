--SAO Asuna - SAO, Titania
--Scripted by Raivost
local s,id=GetID()
function s.initial_effect(c)
  --Synchro Summon
  Synchro.AddProcedure(c,nil,1,1,Synchro.NonTunerEx(Card.IsSetCard,0x999),1,99)
  c:EnableReviveLimit()
  --(1) Place Counter
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(id,0))
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e1:SetCategory(CATEGORY_COUNTER)
  e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e1:SetCode(EVENT_SPSUMMON_SUCCESS)
  e1:SetRange(LOCATION_MZONE)
  e1:SetCondition(s.pctcon)
  e1:SetTarget(s.pcttg)
  e1:SetOperation(s.pctop)
  c:RegisterEffect(e1)
  --(2) Make Tuner and Level 2
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(id,1))
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCountLimit(1,id)
  e2:SetTarget(s.tnlvtg)
  e2:SetOperation(s.tnlvop)
  c:RegisterEffect(e2)
end
s.listed_names={99990020}
--(1) Place Counter
function s.pctconfilter(c,tp)
  return c:IsFaceup() and c:IsSetCard(0x999) and c:GetSummonPlayer()==tp and c:IsType(TYPE_SYNCHRO)
end
function s.pctcon(e,tp,eg,ep,ev,re,r,rp)
  return eg:IsExists(s.pctconfilter,1,e:GetHandler(),tp)
end
function s.pcttg(e,tp,eg,ep,ev,re,r,rp,chk)
  local tc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
  if chk==0 then return tc and tc:IsFaceup() and tc:IsSetCard(0x999) end
  Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,0))
end
function s.pctop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
  if tc and tc:IsFaceup() and tc:IsSetCard(0x999) then
    tc:AddCounter(0x1999,1)
  end
end
--(2) Make Tuner and Level 2
function s.tnlvfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x999) and c:GetLevel()>0 and not (c:IsType(TYPE_TUNER) or c:GetLevel()==2)
end
function s.tnlvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingTarget(s.tnlvfilter,tp,LOCATION_MZONE,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,1))
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  Duel.SelectTarget(tp,s.tnlvfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function s.tnlvop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local tc=Duel.GetFirstTarget()
  if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_ADD_TYPE)
    e1:SetValue(TYPE_TUNER)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
    tc:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_CHANGE_LEVEL)
    e2:SetValue(2)
    e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
    tc:RegisterEffect(e2)
  end
end
