--SAO The World Tree
--Scripted by Raivost
local s,id=GetID()
function s.initial_effect(c)
  --Enable counter(s)
  c:EnableCounterPermit(0x1999)
  --(0) Activate
  local e0=Effect.CreateEffect(c)
  e0:SetType(EFFECT_TYPE_ACTIVATE)
  e0:SetCode(EVENT_FREE_CHAIN)
  c:RegisterEffect(e0)
  --(1) Place counter(s)
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e1:SetRange(LOCATION_FZONE)
  e1:SetCode(EVENT_SPSUMMON_SUCCESS)
  e1:SetOperation(s.pctop)
  c:RegisterEffect(e1)
  --(2) Level
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetRange(LOCATION_FZONE)
  e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e2:SetCountLimit(2,id)
  e2:SetCost(s.levelcost)
  e2:SetTarget(s.lvltg)
  e2:SetOperation(s.lvlop)
  c:RegisterEffect(e2)
  --(3) Destroy replace
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
  e3:SetCode(EFFECT_DESTROY_REPLACE)
  e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e3:SetRange(LOCATION_FZONE)
  e3:SetCountLimit(1)
  e3:SetTarget(s.dreptg)
  e3:SetOperation(s.drepop)
  c:RegisterEffect(e3)
end
--(1) Place counter(s)
function s.pctfilter(c,tp)
  return c:IsFaceup() and c:IsSetCard(0x999) and c:GetSummonPlayer()==tp and c:IsPreviousLocation(LOCATION_EXTRA)
end
function s.pctop(e,tp,eg,ep,ev,re,r,rp)
  local ct=eg:FilterCount(s.pctfilter,nil,tp)
  if ct>0 then
    e:GetHandler():AddCounter(0x1999,ct,true)
  end
end
--(2) Level
function s.levelcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x1999,1,REASON_COST) end
  Duel.RemoveCounter(tp,1,0,0x1999,1,REASON_COST)
end
function s.lvlfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x999) and c:GetLevel()>0
end
function s.lvltg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingTarget(s.lvlfilter,tp,LOCATION_MZONE,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,0))
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  Duel.SelectTarget(tp,s.lvlfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function s.lvlop(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and tc:IsFaceup() then
    local lvl=tc:GetLevel()
    if lvl==1 or Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
      local lv=Duel.AnnounceLevel(tp,1,2)
      local e1=Effect.CreateEffect(e:GetHandler())
      e1:SetType(EFFECT_TYPE_SINGLE)
      e1:SetCode(EFFECT_UPDATE_LEVEL)
      e1:SetValue(lv)
      e1:SetReset(RESET_EVENT+0x1fe0000)
      tc:RegisterEffect(e1)
    elseif lvl==2 then
      local e1=Effect.CreateEffect(e:GetHandler())
      e1:SetType(EFFECT_TYPE_SINGLE)
      e1:SetCode(EFFECT_UPDATE_LEVEL)
      e1:SetValue(-1)
      e1:SetReset(RESET_EVENT+0x1fe0000)
      tc:RegisterEffect(e1)
    else
      local lv=Duel.AnnounceLevel(tp,1,2)
      local e1=Effect.CreateEffect(e:GetHandler())
      e1:SetType(EFFECT_TYPE_SINGLE)
      e1:SetCode(EFFECT_UPDATE_LEVEL)
      e1:SetValue(-lv)
      e1:SetReset(RESET_EVENT+0x1fe0000)
      tc:RegisterEffect(e1)
    end
  end
end
--(3) Destroy replace
function s.dreptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return not e:GetHandler():IsReason(REASON_REPLACE+REASON_RULE)
  and e:GetHandler():IsCanRemoveCounter(tp,0x1999,3,REASON_EFFECT) end
  return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function s.drepop(e,tp,eg,ep,ev,re,r,rp)
  e:GetHandler():RemoveCounter(tp,0x1999,3,REASON_EFFECT)
end