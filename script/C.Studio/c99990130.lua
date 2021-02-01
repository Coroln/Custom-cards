--SAO Boos, Illfang The Kobold Lord
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
  --(2) Specail Summon
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(id,0))
  e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCountLimit(1)
  e2:SetTarget(s.sptg)
  e2:SetOperation(s.spop)
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
  return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and rg:GetCount()>0 and aux.SelectUnselectGroup(rg,e,tp,1,1,aux.ChkfMMZ(1),0)
end
function s.hspop(e,tp,eg,ep,ev,re,r,rp,c)
  local rg=Duel.GetMatchingGroup(s.hspcostfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
  local g=aux.SelectUnselectGroup(rg,e,tp,1,1,aux.ChkfMMZ(1),1,tp,HINTMSG_REMOVE)
  Duel.Remove(g,POS_FACEUP,REASON_COST)
end
--(2) Specail Summon
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsPlayerCanSpecialSummonMonster(tp,99990135,0x999,0x4011,1000,1000,4,RACE_BEASTWARRIOR,ATTRIBUTE_DARK) end
  local ct=math.min(2,Duel.GetLocationCount(tp,LOCATION_MZONE))
  if Duel.IsPlayerAffectedByEffect(tp,59822133) 
  or Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0,nil)>=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE,nil) then ct=1 end
  e:SetLabel(ct)
  Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,0))
  Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,ct,0,0)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,ct,tp,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
  local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
  local ct=e:GetLabel()
  if ft>ct then ft=ct end
  if ft<=0 then return end
  if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
  if not Duel.IsPlayerCanSpecialSummonMonster(tp,99990135,0x999,0x4011,1000,1000,4,RACE_BEASTWARRIOR,ATTRIBUTE_DARK) then return end
  local ctn=true
  while ft>0 and ctn do
    local token=Duel.CreateToken(tp,99990135)
    Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
    ft=ft-1
    if ft<=0 or not Duel.SelectYesNo(tp,aux.Stringid(id,1)) then ctn=false end
  end
  Duel.SpecialSummonComplete()
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