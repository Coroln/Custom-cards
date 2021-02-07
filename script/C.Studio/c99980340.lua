--HN Next Purple
--Scripted by Raivost
function c99980340.initial_effect(c)
  --Xyz Summon
  Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x998),5,3)
  c:EnableReviveLimit()
  --(1) Gain additional effect
  local e0=Effect.CreateEffect(c)
  e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
  e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
  e0:SetCode(EVENT_SPSUMMON_SUCCESS)
  e0:SetCondition(c99980340.gaecon)
  e0:SetOperation(c99980340.gaeop)
  c:RegisterEffect(e0)
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_MATERIAL_CHECK)
  e1:SetValue(c99980340.valcheck)
  e1:SetLabelObject(e0)
  c:RegisterEffect(e1)
  --(1.1) Cannot chain
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e2:SetCode(EVENT_CHAINING)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCondition(c99980340.cccon)
  e2:SetOperation(c99980340.ccop)
  c:RegisterEffect(e2)
  --(2) Gain ATK
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99980340,1))
  e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DRAW)
  e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e3:SetCode(EVENT_BATTLE_CONFIRM)
  e3:SetCountLimit(1)
  e3:SetCondition(c99980340.atkcon)
  e3:SetCost(c99980340.atkcost)
  e3:SetTarget(c99980340.atktg)
  e3:SetOperation(c99980340.atkop)
  c:RegisterEffect(e3,false,1)
  --(3) Special Summon
  local e4=Effect.CreateEffect(c)
  e4:SetDescription(aux.Stringid(99980340,2))
  e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e4:SetCode(EVENT_DAMAGE_STEP_END)
  e4:SetCondition(c99980340.spcon)
  e4:SetTarget(c99980340.sptg)
  e4:SetOperation(c99980340.spop)
  c:RegisterEffect(e4)
end
c99980340.listed_names={99980020}
--(1) Gain additional effect
function c99980340.gaecon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) and e:GetLabel()==1
end
function c99980340.gaeop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  c:RegisterFlagEffect(99980340,RESET_EVENT+0x1fe0000,0,1)
  c:RegisterFlagEffect(0,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(99980340,0))
end
function c99980340.valcheck(e,c)
  local g=c:GetMaterial()
  if g:IsExists(Card.IsCode,1,nil,99980020) then
    e:GetLabelObject():SetLabel(1)
  else
    e:GetLabelObject():SetLabel(0)
  end
end
--(1.1) Cannot chain
function c99980340.cccon(e)
  return e:GetHandler():GetFlagEffect(99980340)>0
end
function c99980340.ccop(e,tp,eg,ep,ev,re,r,rp)
  if  re:GetHandler()==e:GetHandler() then
    Duel.SetChainLimit(c99980340.chlimit)
  end
end
function c99980340.chlimit(e,ep,tp)
  return ep==tp
end
--(2) Gain ATK
function c99980340.atkcon(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local bc=c:GetBattleTarget()
  return c:IsRelateToBattle() and bc and bc:IsFaceup() and bc:IsRelateToBattle() and bc:GetBaseAttack()>0
end
function c99980340.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
  e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c99980340.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
  local bc=c:GetBattleTarget()
  local ct=math.floor(bc:GetBaseAttack()/1500)
  if chk==0 then return Duel.IsPlayerCanDraw(tp,ct) end
  e:GetHandler():GetBattleTarget():CreateEffectRelation(e)
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99980340.atkop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local tc=c:GetBattleTarget()
  if not c:IsRelateToEffect(e) or c:IsFacedown() or tc:IsFacedown() then return end
  if c:IsRelateToEffect(e) and c:IsFaceup() then
    local atk=tc:GetBaseAttack()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE_CAL)
    e1:SetValue(atk)
    c:RegisterEffect(e1)
    local ct=math.floor(atk/1500)
    if ct>0 then
      Duel.Draw(tp,ct,REASON_EFFECT)
    end
  end
end
--(3) Special Summon
function c99980340.spcon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetAttacker()==e:GetHandler() and Duel.GetAttackTarget() and e:GetHandler():GetOverlayCount()>0
end
function c99980340.spfilter(c,e,tp)
  return c:IsCode(99980020) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99980340.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingMatchingCard(c99980340.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c99980340.spop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,c99980340.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
  local tc=g:GetFirst()
  if tc and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0
  and c:IsFaceup() and c:IsRelateToEffect(e) then
    local mg=c:GetOverlayGroup()
    if #mg>0 then Duel.Overlay(tc,mg) end
    Duel.Overlay(tc,Group.FromCards(c))
  end
end
