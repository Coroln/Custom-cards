--BRS Insanity Rage
--Scripted by Raivost
function c99960330.initial_effect(c)
  --(1) Double damage
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,99960330+EFFECT_COUNT_CODE_OATH)
  e1:SetCost(c99960330.ddcost)
  e1:SetOperation(c99960330.ddop)
  c:RegisterEffect(e1)
  --(2) Unaffected
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99960330,0))
  e2:SetCategory(CATEGORY_DAMAGE)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e2:SetCode(EVENT_TO_GRAVE)
  e2:SetCondition(c99960330.unfcon)
  e2:SetTarget(c99960330.unftg)
  e2:SetOperation(c99960330.unfop)
  c:RegisterEffect(e2)
end
--(1) Double damage
function c99960330.ddcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.CheckLPCost(tp,1000) end
  Duel.PayLPCost(tp,1000)
end
function c99960330.ddop(e,tp,eg,ep,ev,re,r,rp)
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetCode(EFFECT_CHANGE_DAMAGE)
  e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e1:SetTargetRange(0,1)
  e1:SetCondition(c99960330.ddcon)
  e1:SetValue(c99960330.ddval)
  e1:SetReset(RESET_PHASE+PHASE_END,1)
  Duel.RegisterEffect(e1,tp)
end
function c99960330.ddcon(e,tp,eg,ep,ev,re,r,rp)
  return rp==tp
end
function c99960330.ddval(e,re,dam,r,rp,rc)
  if bit.band(r,REASON_EFFECT)~=0 and re:GetHandler():IsSetCard(0x996) then
    return dam*2
  else 
    return dam 
  end
end
--(2) Unaffected
function c99960330.unfcon(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  return c:IsReason(REASON_COST) and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_MONSTER)
  and c:IsPreviousLocation(LOCATION_OVERLAY) and re:GetHandler():IsSetCard(0x996)
end
function c99960330.unffilter(c)
  return c:IsFaceup() and c:IsSetCard(0x996) and c:IsType(TYPE_MONSTER)
end
function c99960330.unftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingTarget(c99960330.unffilter,tp,LOCATION_MZONE,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  Duel.SelectTarget(tp,c99960330.unffilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c99960330.unfop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and tc:IsFaceup() then
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetDescription(aux.Stringid(99960330,0))
    e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_IMMUNE_EFFECT)
    e1:SetValue(c99960330.efilter)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
    tc:RegisterEffect(e1)
  end
end
function c99960330.efilter(e,re)
  return e:GetHandler()~=re:GetOwner()
end