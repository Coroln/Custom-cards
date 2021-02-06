--SAO Silica ALO
--Scripted by Raivost
local s,id=GetID()
function s.initial_effect(c)
  --Synchro Summon
  Synchro.AddProcedure(c,nil,1,1,Synchro.NonTunerEx(Card.IsSetCard,0x999),1,99)
  c:EnableReviveLimit()
  --(1) Equip
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(id,0))
  e1:SetCategory(CATEGORY_EQUIP)
  e1:SetType(EFFECT_TYPE_QUICK_O)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetRange(LOCATION_MZONE)
  e1:SetCountLimit(1,id)
  e1:SetHintTiming(0,0x1e0)
  e1:SetCost(s.eqcost)
  e1:SetTarget(s.eqtg)
  e1:SetOperation(s.eqop)
  c:RegisterEffect(e1)
  --(2) Cannot activate Spells/Traps
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_FIELD)
  e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e2:SetCode(EFFECT_CANNOT_ACTIVATE)
  e2:SetRange(LOCATION_MZONE)
  e2:SetTargetRange(0,1)
  e2:SetValue(s.aclimit)
  e2:SetCondition(s.actcon)
  c:RegisterEffect(e2)
end
--(1) Equip
function s.eqcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x1999,1,REASON_COST) end
  Duel.RemoveCounter(tp,1,0,0x1999,1,REASON_COST)
end
function s.eqtgfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x999) and c:IsType(TYPE_MONSTER) 
end
function s.eqfilter(c,tp)
  return c:IsCode(99990110) and not c:IsForbidden()
end
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingTarget(s.eqtgfilter,tp,LOCATION_MZONE,0,1,nil)
  and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
  and Duel.IsExistingMatchingCard(s.eqfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) end
  Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,0))
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  Duel.SelectTarget(tp,s.eqtgfilter,tp,LOCATION_MZONE,0,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsControler(tp) then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.eqfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tc,tp)
    if g:GetCount()>0 then
      --(1.1) Keep alive
      s.equipop(tc,e,tp,g:GetFirst())
    end
  end
end
--(1.1) Keep alive
function s.equipop(c,e,tp,tc)
  if not aux.EquipByEffectAndLimitRegister(c,e,tp,tc,nil,true) then return end
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_EQUIP_LIMIT)
  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
  e1:SetValue(s.eqlimit)
  e1:SetReset(RESET_EVENT+0x1fe0000)
  tc:RegisterEffect(e1)
end
function s.eqlimit(e,c)
  return c:GetControler()==e:GetHandlerPlayer()
end
--(2)  Cannot activate Spells/Traps
function s.aclimit(e,re,tp)
  local rc=re:GetHandler()
  return re:IsHasType(EFFECT_TYPE_ACTIVATE) and rc:IsLocation(LOCATION_ONFIELD)
end
function s.actcon(e)
  local tp=e:GetHandlerPlayer()
  local tc=Duel.GetAttacker()
  local bc=Duel.GetAttackTarget()
  if not bc then return false end
  if bc:IsControler(1-tp) then bc=tc end
  return bc:IsFaceup() and bc:IsSetCard(0x999) and bc:IsControler(tp)
end
