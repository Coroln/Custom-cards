--HN Next White
--Scripted by Raivost
function c99980460.initial_effect(c)
  --Xyz Summon
  aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x998),5,3)
  c:EnableReviveLimit()
  --(1) Gain additional effect
  local e0=Effect.CreateEffect(c)
  e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
  e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
  e0:SetCode(EVENT_SPSUMMON_SUCCESS)
  e0:SetCondition(c99980460.gaecon)
  e0:SetOperation(c99980460.gaeop)
  c:RegisterEffect(e0)
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_MATERIAL_CHECK)
  e1:SetValue(c99980460.valcheck)
  e1:SetLabelObject(e0)
  c:RegisterEffect(e1)
  --(1.1) Cannot chain
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e2:SetCode(EVENT_CHAINING)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCondition(c99980460.cccon)
  e2:SetOperation(c99980460.ccop)
  c:RegisterEffect(e2)
  --(2) Destroy
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99980460,1))
  e3:SetCategory(CATEGORY_DESTROY)
  e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e3:SetCode(EVENT_BATTLE_CONFIRM)
  e3:SetCountLimit(1)
  e3:SetCondition(c99980460.descon)
  e3:SetCost(c99980460.descost)
  e3:SetTarget(c99980460.destg)
  e3:SetOperation(c99980460.desop)
  c:RegisterEffect(e3,false,1)
  --(3) Special Summon
  local e4=Effect.CreateEffect(c)
  e4:SetDescription(aux.Stringid(99980460,2))
  e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e4:SetCode(EVENT_DAMAGE_STEP_END)
  e4:SetCondition(c99980460.spcon)
  e4:SetTarget(c99980460.sptg)
  e4:SetOperation(c99980460.spop)
  c:RegisterEffect(e4)
end
c99980460.listed_names={99980120}
--(1) Gain additional effect
function c99980460.gaecon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) and e:GetLabel()==1
end
function c99980460.gaeop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  c:RegisterFlagEffect(99980460,RESET_EVENT+0x1fe0000,0,1)
  c:RegisterFlagEffect(0,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(99980460,0))
end
function c99980460.valcheck(e,c)
  local g=c:GetMaterial()
  if g:IsExists(Card.IsCode,1,nil,99980120) then
    e:GetLabelObject():SetLabel(1)
  else
    e:GetLabelObject():SetLabel(0)
  end
end
--(1.1) Cannot chain
function c99980460.cccon(e)
  return e:GetHandler():GetFlagEffect(99980460)>0
end
function c99980460.ccop(e,tp,eg,ep,ev,re,r,rp)
  if  re:GetHandler()==e:GetHandler() then
    Duel.SetChainLimit(c99980460.chlimit)
  end
end
function c99980460.chlimit(e,ep,tp)
  return ep==tp
end
--(2) Destroy
function c99980460.descon(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local bc=c:GetBattleTarget()
  return c:IsRelateToBattle() and bc and bc:IsRelateToBattle()
end
function c99980460.descost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
  e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c99980460.destg(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
  local bc=c:GetBattleTarget()
  local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,bc)
  if chk==0 then return g:GetCount()>0 end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c99980460.desop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local bc=c:GetBattleTarget()
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
  local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,2,bc)
  if g:GetCount()>0 then
    Duel.HintSelection(g)
    Duel.Destroy(g,REASON_EFFECT)
  end
end
--(3) Special Summon
function c99980460.spcon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetAttacker()==e:GetHandler() and Duel.GetAttackTarget() and e:GetHandler():GetOverlayCount()>0
end
function c99980460.spfilter(c,e,tp)
  return c:IsCode(99980120) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99980460.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingMatchingCard(c99980460.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c99980460.spop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,c99980460.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
  local tc=g:GetFirst()
  if tc and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0
  and c:IsFaceup() and c:IsRelateToEffect(e) then
    local mg=c:GetOverlayGroup()
    if #mg>0 then Duel.Overlay(tc,mg) end
    Duel.Overlay(tc,Group.FromCards(c))
  end
end