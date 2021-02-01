--HN Broccoli
--Scripted by Raivost
function c99980590.initial_effect(c)
  aux.EnablePendulumAttribute(c)
  --Pendulum Effects
  --(1) Gain LP
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99980590,0))
  e1:SetCategory(CATEGORY_RECOVER)
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
  e1:SetCode(EVENT_PHASE+PHASE_END)
  e1:SetRange(LOCATION_PZONE)
  e1:SetCountLimit(1)
  e1:SetTarget(c99980590.rectg)
  e1:SetOperation(c99980590.recop)
  c:RegisterEffect(e1)
  --(2) Special Summon
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99980590,1))
  e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetRange(LOCATION_PZONE)
  e2:SetCountLimit(1,99980590)
  e2:SetCondition(c99980590.spcon)
  e2:SetTarget(c99980590.sptg)
  e2:SetOperation(c99980590.spop)
  c:RegisterEffect(e2)
  --Monster Effects
  --(1) Gain Lvl
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_SINGLE)
  e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCode(EFFECT_UPDATE_LEVEL)
  e3:SetValue(c99980590.lvlval)
  c:RegisterEffect(e3)
  --(2) Place in PZone
  local e4=Effect.CreateEffect(c)
  e4:SetDescription(aux.Stringid(99980590,2))
  e4:SetCategory(CATEGORY_ATKCHANGE)
  e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e4:SetCode(EVENT_TO_GRAVE)
  e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e4:SetCondition(c99980590.ppzcon)
  e4:SetTarget(c99980590.ppztg)
  e4:SetOperation(c99980590.ppzop)
  c:RegisterEffect(e4)
end
--(1) Gain LP
function c99980590.recfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x998) and c:IsType(TYPE_MONSTER)
end
function c99980590.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  local ct=Duel.GetMatchingGroupCount(c99980590.recfilter,tp,LOCATION_MZONE,0,nil)
  Duel.SetTargetPlayer(tp)
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ct*200)
end
function c99980590.recop(e,tp,eg,ep,ev,re,r,rp)
  local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
  local ct=Duel.GetMatchingGroupCount(c99980590.recfilter,p,LOCATION_MZONE,0,nil)
  if ct>0 then
    Duel.Recover(p,ct*200,REASON_EFFECT)
  end
end
--(2) Special Summon
function c99980590.spconfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x998) and c:IsType(TYPE_MONSTER) and c:GetLevel()>0
end
function c99980590.spcon(e,tp,eg,ep,ev,re,r,rp)
  local ct=Duel.GetMatchingGroupCount(c99980590.spconfilter,tp,LOCATION_MZONE,0,nil)
  return ct<Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE,nil)
end
function c99980590.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c99980590.spop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsRelateToEffect(e) then
    Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
  end
end
--Monster Effects
--(1) Gain Level
function c99980590.lvlval(e,c)
  return Duel.GetMatchingGroupCount(c99980590.spconfilter,c:GetControler(),LOCATION_MZONE,0,c)
end
--(2) Place in PZone
function c99980590.ppzcon(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  return c:IsReason(REASON_COST) and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_MONSTER)
  and c:IsPreviousLocation(LOCATION_OVERLAY) and re:GetHandler():IsSetCard(0x998)
end
function c99980590.atkfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x998) and c:IsType(TYPE_MONSTER) 
end
function c99980590.ppztg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) 
  and Duel.IsExistingMatchingCard(c99980590.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99980590.ppzop(e,tp,eg,ep,ev,re,r,rp)
  if e:GetHandler():IsRelateToEffect(e)
  and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then
    Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
    local g=Duel.GetMatchingGroup(c99980590.atkfilter,tp,LOCATION_MZONE,0,nil)  
    for tc in aux.Next(g) do
      local e1=Effect.CreateEffect(e:GetHandler())
      e1:SetType(EFFECT_TYPE_SINGLE)
      e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
      e1:SetCode(EFFECT_UPDATE_ATTACK)
      e1:SetValue(200)
      e1:SetReset(RESET_EVENT+0x1fe0000)
      tc:RegisterEffect(e1)
      local e2=e1:Clone()
      e2:SetCode(EFFECT_UPDATE_DEFENSE)
      tc:RegisterEffect(e2)
    end
  end
end