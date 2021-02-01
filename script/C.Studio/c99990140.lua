--SAO Boos, The Gleam Eyes
--Scritped by Raivost
local s,id=GetID()
function s.initial_effect(c)
  --SAO Boss
  c:SetUniqueOnField(1,0,aux.FilterBoolFunction(Card.IsSetCard,0x1999),LOCATION_MZONE)
  --(1) Special summon from hand
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(id,0))
  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetRange(LOCATION_HAND)
  e1:SetCode(EFFECT_SPSUMMON_PROC)
  e1:SetCountLimit(1,id)
  e1:SetCondition(s.hspcon)
  e1:SetOperation(s.hspop)
  c:RegisterEffect(e1)
  --(2) Destroy
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(id,1))
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
  e2:SetCode(EVENT_SPSUMMON_SUCCESS)
  e2:SetCondition(s.descon)
  e2:SetTarget(s.destg)
  e2:SetOperation(s.desop)
  c:RegisterEffect(e2)
  --(3) Place Counter
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(id,2))
  e3:SetCategory(CATEGORY_COUNTER)
  e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e3:SetProperty(EFFECT_FLAG_DELAY)
  e3:SetCode(EVENT_DESTROYED)
  e3:SetCondition(s.pctcon)
  e3:SetTarget(s.pcttg)
  e3:SetOperation(s.pctop)
  c:RegisterEffect(e3)
end
--(1) Special summon from hand
function s.hspcostfilter(c)
  return c:IsSetCard(0x999) and not c:IsSetCard(0x1999) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() and aux.SpElimFilter(c,true)
end
function s.hspcon(e,c)
  if c==nil then return true end
  local tp=c:GetControler()
  local rg=Duel.GetMatchingGroup(s.hspcostfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
  return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2 and rg:GetCount()>1 and aux.SelectUnselectGroup(rg,e,tp,2,2,aux.ChkfMMZ(1),0)
end
function s.hspop(e,tp,eg,ep,ev,re,r,rp,c)
  local rg=Duel.GetMatchingGroup(s.hspcostfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
  local g=aux.SelectUnselectGroup(rg,e,tp,2,2,aux.ChkfMMZ(1),1,tp,HINTMSG_REMOVE)
  Duel.Remove(g,POS_FACEUP,REASON_COST)
end
--(2) Destroy
function s.descon(e,tp,eg,ep,ev,re,r,rp)
  return re and re:GetHandler():IsSetCard(0x999)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,1))
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) then
    Duel.Destroy(tc,REASON_EFFECT)
  end
end
--(3) Place Counter
function s.pctcon(e,tp,eg,ep,ev,re,r,rp)
  return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0
end
function s.pcttg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,2))
end
function s.pctop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
  if tc and tc:IsFaceup() and tc:IsSetCard(0x999) then
    tc:AddCounter(0x1999,1)
  end
end