--Fate Legendary Influence
function c99890140.initial_effect(c)
  --(1) Unaffected
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99890140,0))
  e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetHintTiming(TIMING_DAMAGE_STEP)
  e1:SetCountLimit(1,99890140+EFFECT_COUNT_CODE_OATH)
  e1:SetCondition(c99890140.uncon)
  e1:SetTarget(c99890140.untg)
  e1:SetOperation(c99890140.unop)
  c:RegisterEffect(e1)
end
function c99890140.uncon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c99890140.unfilter(c)
  return c:IsSetCard(0x989) and c:IsFaceup()
end
function c99890140.lmfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x989) and c:IsSetCard(0xF29) 
end
function c99890140.untg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingTarget(c99890140.unfilter,tp,LOCATION_MZONE,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  Duel.SelectTarget(tp,c99890140.unfilter,tp,LOCATION_MZONE,0,1,1,nil)
  if Duel.IsExistingMatchingCard(c99890140.lmfilter,tp,LOCATION_MZONE,0,1,nil) and e:IsHasType(EFFECT_TYPE_ACTIVATE) then
  Duel.SetChainLimit(c99890140.chainlm)
  end
end
function c99890140.chainlm(e,rp,tp)
  return tp==rp
end
function c99890140.atkfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x989)
end
function c99890140.unop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local tc1=Duel.GetFirstTarget()
  if tc1:IsRelateToEffect(e) and tc1:IsFaceup() and tc1:IsControler(tp) then
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(99890140,0))
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_IMMUNE_EFFECT)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
    e1:SetRange(LOCATION_MZONE)
    e1:SetValue(c99890140.efilter)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
    e1:SetOwnerPlayer(tp)
    tc1:RegisterEffect(e1)
  end
  if Duel.IsExistingMatchingCard(c99890140.atkfilter,tp,LOCATION_MZONE,0,1,tc1) then
    local g=Duel.GetMatchingGroup(c99890140.atkfilter,tp,LOCATION_MZONE,0,tc1)
    for tc2 in aux.Next(g) do
      local e1=Effect.CreateEffect(c)
      e1:SetType(EFFECT_TYPE_SINGLE)
      e1:SetCode(EFFECT_UPDATE_ATTACK)
      e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
      e1:SetValue(500)
      tc2:RegisterEffect(e1)
      local e2=e1:Clone()
      e2:SetCode(EFFECT_UPDATE_DEFENSE)
      tc2:RegisterEffect(e2)
    end
  end
end
function c99890140.efilter(e,re)
  return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end