--SAO Kobold Sentinels
--Scripted by Raivost
local s,id=GetID()
function s.initial_effect(c)
  --(1) Special Summon 1
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(id,0))
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
  e1:SetTarget(s.sptg1)
  e1:SetOperation(s.spop1)
  c:RegisterEffect(e1)
  --(2) Special Summon 2
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(id,0))
  e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetRange(LOCATION_GRAVE)
  e2:SetCountLimit(1)
  e2:SetCost(s.spcost2)
  e2:SetTarget(s.sptg2)
  e2:SetOperation(s.spop2)
  c:RegisterEffect(e2)
end
--(1) Special Summon 1
function s.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsPlayerCanSpecialSummonMonster(tp,99990385,0x999,0x4011,1000,1000,4,RACE_BEASTWARRIOR,ATTRIBUTE_DARK) end
  Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,0))
  Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function s.spop1(e,tp,eg,ep,ev,re,r,rp)
  local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
  local ct1=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
  local ct2=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
  if ft<=0 then return end
  if not Duel.IsPlayerCanSpecialSummonMonster(tp,99990385,0x999,0x4011,1000,1000,4,RACE_BEASTWARRIOR,ATTRIBUTE_DARK) then return end
  ft=1
  local ctn=true
  while ft>0 and ctn do
    local token=Duel.CreateToken(tp,99990385)
    Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
    ct1=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
    ct2=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
    ft=ct2-ct1
    if ft<=0 or not Duel.SelectYesNo(tp,aux.Stringid(id,1)) or Duel.IsPlayerAffectedByEffect(tp,59822133) then ctn=false end
  end
  if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetTargetRange(1,0)
    e1:SetTarget(s.splimit)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
  end
end
function s.splimit(e,c)
  return not c:IsSetCard(0x999)
end
--(2) Special Summon 2
function s.spcost2(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
  if chk==0 then return aux.exccon(e,tp,eg,ep,ev,re,r,rp,0) and Duel.IsCanRemoveCounter(tp,1,0,0x1999,1,REASON_COST)  end
  Duel.Remove(c,POS_FACEUP,REASON_COST)
  Duel.RemoveCounter(tp,1,0,0x1999,1,REASON_COST)
end
function s.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsPlayerCanSpecialSummonMonster(tp,99990385,0x999,0x4011,1000,1000,4,RACE_BEASTWARRIOR,ATTRIBUTE_DARK) end
  Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,0))
  Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function s.spop2(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
    and Duel.IsPlayerCanSpecialSummonMonster(tp,99990385,0x999,0x4011,1000,1000,4,RACE_BEASTWARRIOR,ATTRIBUTE_DARK) then
    local token=Duel.CreateToken(tp,99990385)
    Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
  end
end