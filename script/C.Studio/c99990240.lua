--SAO Klein - ALO
--Scripted by Raivost
local s,id=GetID()
function s.initial_effect(c)
  --Synchro Summon
  Synchro.AddProcedure(c,nil,1,1,Synchro.NonTunerEx(Card.IsSetCard,0x999),1,99)
  c:EnableReviveLimit()
  --(1) Gain effect this turn
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
  e1:SetCode(EVENT_SPSUMMON_SUCCESS)
  e1:SetOperation(s.geop)
  c:RegisterEffect(e1)
  --(2) Equip
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(id,2))
  e2:SetCategory(CATEGORY_EQUIP)
  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e2:SetCode(EVENT_SPSUMMON_SUCCESS)
  e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CHAIN_UNIQUE+EFFECT_FLAG_DELAY)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCondition(s.eqcon)
  e2:SetCost(s.eqcost)
  e2:SetTarget(s.eqtg)
  e2:SetOperation(s.eqop)
  c:RegisterEffect(e2)
end
--(1) Gain effect this turn
function s.geop(e,tp,eg,ep,ev,re,r,rp)
  --(1.1) Draw
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetDescription(aux.Stringid(id,0))
  e1:SetCategory(CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON)
  e1:SetType(EFFECT_TYPE_IGNITION)
  e1:SetRange(LOCATION_MZONE)
  e1:SetCountLimit(1,id)
  e1:SetTarget(s.drtg)
  e1:SetOperation(s.drop)
  e1:SetReset(RESET_EVENT+0x16c0000+RESET_PHASE+PHASE_END)
  e:GetHandler():RegisterEffect(e1)
end
--(1.1) Draw
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
  Duel.SetTargetPlayer(tp)
  Duel.SetTargetParam(1)
  Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,0))
  Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
  local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
  if Duel.Draw(p,d,REASON_EFFECT)~=0 then
    local tc=Duel.GetOperatedGroup():GetFirst()
    Duel.ConfirmCards(1-tp,tc)
    Duel.BreakEffect()
    if tc:IsType(TYPE_MONSTER) and tc:IsSetCard(0x999) and not tc:IsSetCard(0x1999) then
      if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
      and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
      end
    end
    Duel.ShuffleHand(tp)
  end
end
--(2) Equip
function s.eqconfilter(c,tp)
  return c:IsFaceup() and c:IsSetCard(0x999) and c:IsType(TYPE_MONSTER) and c:GetSummonPlayer()==tp
end
function s.eqcon(e,tp,eg,ep,ev,re,r,rp)
  return eg:IsExists(s.eqconfilter,1,e:GetHandler(),tp)
end
function s.eqcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x1999,1,REASON_COST) end
  Duel.RemoveCounter(tp,1,0,0x1999,1,REASON_COST)
end
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return eg:IsExists(s.eqconfilter,1,nil,tp) end
  Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,2))
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  local sg=eg:FilterSelect(tp,s.eqconfilter,1,1,nil,tp)
  Duel.SetTargetCard(sg)
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local tc=Duel.GetFirstTarget()
  if not tc then return end
  if not c:IsRelateToEffect(e) or c:IsLocation(LOCATION_SZONE) or c:IsFacedown() then return end
  if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:IsFacedown() or not tc:IsRelateToEffect(e) then
    Duel.SendtoGrave(c,REASON_EFFECT)
    return
  end
  Duel.Equip(tp,c,tc)
  --(2.1) Equio limit
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_EQUIP_LIMIT)
  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
  e1:SetValue(s.eqlimit)
  e1:SetLabelObject(tc)
  e1:SetReset(RESET_EVENT+0x1fe0000)
  c:RegisterEffect(e1)
  --(2.2) Gain ATK
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_EQUIP)
  e2:SetCode(EFFECT_UPDATE_ATTACK)
  e2:SetValue(c:GetBaseAttack()/2)
  e2:SetReset(RESET_EVENT+0x1fe0000)
  c:RegisterEffect(e2)
end
function s.eqlimit(e,c)
  return c==e:GetLabelObject()
end
