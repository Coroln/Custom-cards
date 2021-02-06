--SAO Hidden Potential Leafa - ALO
--Scripted by Raivost
local s,id=GetID()
function s.initial_effect(c)
  --Synchro Summon
  Synchro.AddProcedure(c,nil,1,1,Synchro.NonTunerEx(Card.IsSetCard,0x999),1,99)
  c:EnableReviveLimit()
  --(1) Gain LP
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(id,0))
  e1:SetCategory(CATEGORY_ATKCHANGE)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e1:SetProperty(EFFECT_FLAG_DELAY)
  e1:SetCode(EVENT_SPSUMMON_SUCCESS)
  e1:SetCondition(s.reccon)
  e1:SetTarget(s.rectg)
  e1:SetOperation(s.recop)
  c:RegisterEffect(e1)
  --(2) Gain effect this turn
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
  e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
  e2:SetCode(EVENT_SPSUMMON_SUCCESS)
  e2:SetOperation(s.geop)
  c:RegisterEffect(e2)
end
--(1) Gain LP
function s.reccon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function s.recfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x999) and c:GetAttack()>0
end
function s.rectg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingTarget(s.recfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  local g=Duel.SelectTarget(tp,s.recfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
  Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,g:GetFirst():GetAttack())
end
function s.recop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:GetAttack()>0 then
    local rec=Duel.Recover(tp,tc:GetAttack()/2,REASON_EFFECT)
    if c:IsRelateToEffect(e) and c:IsFaceup() and rec>0 then 
      local e1=Effect.CreateEffect(c)
      e1:SetType(EFFECT_TYPE_SINGLE)
      e1:SetCode(EFFECT_UPDATE_ATTACK)
      e1:SetValue(rec/2)
      e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,2)
      c:RegisterEffect(e1)
    end
  end
end
--(2) Gain effect this turn
function s.geop(e,tp,eg,ep,ev,re,r,rp)
  --(2.1) Return to Extra Deck
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetDescription(aux.Stringid(id,1))
  e1:SetCategory(CATEGORY_TOHAND)
  e1:SetType(EFFECT_TYPE_IGNITION)
  e1:SetRange(LOCATION_MZONE)
  e1:SetCountLimit(1,id)
  e1:SetCost(s.retcost)
  e1:SetTarget(s.rttg)
  e1:SetOperation(s.rtop)
  e1:SetReset(RESET_EVENT+0x16c0000+RESET_PHASE+PHASE_END)
  e:GetHandler():RegisterEffect(e1)
end
--(2.1) Return to Extra Deck
function s.retcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x1999,1,REASON_COST) end
  Duel.RemoveCounter(tp,1,0,0x1999,1,REASON_COST)
end
function s.rtfilter(c,e,tp)
  local mg=c:GetMaterial()
  local ct=mg:GetCount()
  local sumtype=c:GetSummonType()
  return c:IsFaceup() and c:IsSetCard(0x999) and c:IsType(TYPE_SYNCHRO)
  and c:IsAbleToExtra() and sumtype==SUMMON_TYPE_SYNCHRO
  and ct>0 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
  and ct<=Duel.GetLocationCount(tp,LOCATION_MZONE)+1
  and mg:FilterCount(aux.NecroValleyFilter(s.mgfilter),nil,e,tp,c)==ct
end
function s.rttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingTarget(s.rtfilter,tp,LOCATION_MZONE,0,1,e:GetHandler(),e,tp) end
  Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,1))
  local g=Duel.SelectTarget(tp,s.rtfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler(),e,tp)
  Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function s.mgfilter(c,e,tp,sync)
  return c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE)
  and bit.band(c:GetReason(),0x80008)==0x80008 and c:GetReasonCard()==sync
  and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.rtop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsFacedown() or not tc:IsRelateToEffect(e) then return end
  local mg=tc:GetMaterial()
  local ct=mg:GetCount()
  if Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_EXTRA) and ct>0 
  and not Duel.IsPlayerAffectedByEffect(tp,59822133) and ct<=Duel.GetLocationCount(tp,LOCATION_MZONE) 
  and mg:FilterCount(aux.NecroValleyFilter(s.mgfilter),nil,e,tp,tc)==ct then
    Duel.SpecialSummon(mg,0,tp,tp,false,false,POS_FACEUP)
  end
end
