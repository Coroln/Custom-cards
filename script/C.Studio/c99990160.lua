--SAO Boos, The Skull Reaper
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
  --(2) Cannot targetr
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_FIELD)
  e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
  e2:SetRange(LOCATION_MZONE)
  e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
  e2:SetTargetRange(LOCATION_MZONE,0)
  e2:SetTarget(s.tgtg)
  e2:SetValue(aux.tgoval)
  c:RegisterEffect(e2)
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_FIELD)
  e3:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
  e3:SetRange(LOCATION_MZONE)
  e3:SetTargetRange(0,LOCATION_MZONE)
  e3:SetValue(s.tgtg)
  c:RegisterEffect(e3)
  --(3) Place Counter
  local e4=Effect.CreateEffect(c)
  e4:SetDescription(aux.Stringid(id,1))
  e4:SetCategory(CATEGORY_COUNTER)
  e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e4:SetProperty(EFFECT_FLAG_DELAY)
  e4:SetCode(EVENT_DESTROYED)
  e4:SetCondition(s.pctcon)
  e4:SetTarget(s.pcttg)
  e4:SetOperation(s.pctop)
  c:RegisterEffect(e4)
end
--(1) Special summon from hand
function s.hspcostfilter(c)
  return c:IsSetCard(0x999) and not c:IsSetCard(0x1999) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() and aux.SpElimFilter(c,true)
end
function s.hspcon(e,c)
  if c==nil then return true end
  local tp=c:GetControler()
  local rg=Duel.GetMatchingGroup(s.hspcostfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
  return Duel.GetLocationCount(tp,LOCATION_MZONE)>-3 and rg:GetCount()>2 and aux.SelectUnselectGroup(rg,e,tp,3,3,aux.ChkfMMZ(1),0)
end
function s.hspop(e,tp,eg,ep,ev,re,r,rp,c)
  local rg=Duel.GetMatchingGroup(s.hspcostfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
  local g=aux.SelectUnselectGroup(rg,e,tp,3,3,aux.ChkfMMZ(1),1,tp,HINTMSG_REMOVE)
  Duel.Remove(g,POS_FACEUP,REASON_COST)
end
--(2) Cannot targetr
function s.tgtg(e,c)
  return c:IsSetCard(0x999) and c:IsType(TYPE_MONSTER) and c~=e:GetHandler()
end
--(3) Place Counter
function s.pctcon(e,tp,eg,ep,ev,re,r,rp)
  return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0
end
function s.pcttg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,1))
end
function s.pctop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
  if tc and tc:IsFaceup() and tc:IsSetCard(0x999) then
    tc:AddCounter(0x1999,1)
  end
end