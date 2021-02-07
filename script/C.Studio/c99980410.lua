--HN Next Black
--Scripted by Raivost
local s,id=GetID()
function s.initial_effect(c)
  --Xyz Summon
  Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x998),5,3)
  c:EnableReviveLimit()
  --(1) Gain additional effect
  local e0=Effect.CreateEffect(c)
  e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
  e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
  e0:SetCode(EVENT_SPSUMMON_SUCCESS)
  e0:SetCondition(s.gaecon)
  e0:SetOperation(s.gaeop)
  c:RegisterEffect(e0)
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_MATERIAL_CHECK)
  e1:SetValue(s.valcheck)
  e1:SetLabelObject(e0)
  c:RegisterEffect(e1)
  --(1.1) Cannot chain
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e2:SetCode(EVENT_CHAINING)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCondition(s.cccon)
  e2:SetOperation(s.ccop)
  c:RegisterEffect(e2)
  --(2) Half ATK
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(id,1))
  e3:SetCategory(CATEGORY_ATKCHANGE)
  e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e3:SetCode(EVENT_BATTLE_CONFIRM)
  e3:SetCountLimit(1)
  e3:SetCondition(s.atkcon)
  e3:SetCost(s.atkcost)
  e3:SetTarget(s.atktg)
  e3:SetOperation(s.atkop)
  c:RegisterEffect(e3,false,1)
  --(3) Special Summon
  local e4=Effect.CreateEffect(c)
  e4:SetDescription(aux.Stringid(id,2))
  e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e4:SetCode(EVENT_DAMAGE_STEP_END)
  e4:SetCountLimit(1,id)
  e4:SetCondition(s.spcon)
  e4:SetTarget(s.sptg)
  e4:SetOperation(s.spop)
  c:RegisterEffect(e4)
end
s.listed_names={99980070}
--(1) Gain additional effect
function s.gaecon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) and e:GetLabel()==1
end
function s.gaeop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  c:RegisterFlagEffect(id,RESET_EVENT+0x1fe0000,0,1)
  c:RegisterFlagEffect(0,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,0))
end
function s.valcheck(e,c)
  local g=c:GetMaterial()
  if g:IsExists(Card.IsCode,1,nil,99980070) then
    e:GetLabelObject():SetLabel(1)
  else
    e:GetLabelObject():SetLabel(0)
  end
end
--(1.1) Cannot chain
function s.cccon(e)
  return e:GetHandler():GetFlagEffect(id)>0
end
function s.ccop(e,tp,eg,ep,ev,re,r,rp)
  if  re:GetHandler()==e:GetHandler() then
    Duel.SetChainLimit(s.chlimit)
  end
end
function s.chlimit(e,ep,tp)
  return ep==tp
end
--(2) Half ATK
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local bc=c:GetBattleTarget()
  return c:IsRelateToBattle() and bc and bc:IsFaceup() and bc:IsRelateToBattle()
end
function s.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
  e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  e:GetHandler():GetBattleTarget():CreateEffectRelation(e)
  Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,1))
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local tc=c:GetBattleTarget()
  if not c:IsRelateToEffect(e) or c:IsFacedown() or tc:IsFacedown() or not tc:IsRelateToEffect(e) then return end
  if tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SET_ATTACK_FINAL)
    e1:SetReset(RESET_EVENT+0x1fe0000)
    e1:SetValue(math.ceil(tc:GetAttack()/2))
    tc:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e2:SetValue(1)
    e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
    tc:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetCode(EFFECT_CHANGE_DAMAGE)
    e3:SetTargetRange(0,1)
    e3:SetValue(s.damval)
    e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE)
    Duel.RegisterEffect(e3,tp)
  end
end
function s.damval(e,re,val,r,rp,rc)
  local tp=e:GetHandlerPlayer()
  if r&REASON_BATTLE==0 then return val end
  return val*2
end
--(3) Special Summon
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetAttacker()==e:GetHandler() and Duel.GetAttackTarget() and e:GetHandler():GetOverlayCount()>0
end
function s.spfilter(c,e,tp)
  return c:IsCode(99980070) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
  Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,2))
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
  local tc=g:GetFirst()
  if tc and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0
  and c:IsFaceup() and c:IsRelateToEffect(e) then
    local mg=c:GetOverlayGroup()
    if #mg>0 then Duel.Overlay(tc,mg) end
    Duel.Overlay(tc,Group.FromCards(c))
  end
end
