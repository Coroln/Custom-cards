--YuYuYu Gyuuki
--Scripted by Raivost
function c99910080.initial_effect(c)
  --(1) Give effect
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
  e1:SetCode(EVENT_BE_MATERIAL)
  e1:SetCountLimit(1,99910080)
  e1:SetCondition(c99910080.mtcon)
  e1:SetOperation(c99910080.mtop)
  c:RegisterEffect(e1)
  --(2) Destroy replace
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e2:SetCode(EFFECT_DESTROY_REPLACE)
  e2:SetRange(LOCATION_GRAVE)
  e2:SetTarget(c99910080.dreptg)
  e2:SetValue(c99910080.drepval)
  e2:SetOperation(c99910080.drepop)
  c:RegisterEffect(e2)
end
--(2) Give effect
function c99910080.mtcon(e,tp,eg,ep,ev,re,r,rp)
  return r==REASON_RITUAL
end
function c99910080.mtop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local g=eg:Filter(Card.IsSetCard,nil,0x991)
  local rc=g:GetFirst()
  if not rc then return end
  --(1.1) Gain ATK
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99910080,1))
  e1:SetCategory(CATEGORY_ATKCHANGE)
  e1:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
  e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
  e1:SetCondition(c99910080.atkcon)
  e1:SetTarget(c99910080.atktg)
  e1:SetOperation(c99910080.atkop)
  e1:SetReset(RESET_EVENT+0x1fe0000)
  rc:RegisterEffect(e1,true)
  if not rc:IsType(TYPE_EFFECT) then
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_ADD_TYPE)
    e2:SetValue(TYPE_EFFECT)
    e2:SetReset(RESET_EVENT+0x1fe0000)
    rc:RegisterEffect(e2,true)
  end
  rc:RegisterFlagEffect(0,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(99910080,0))
end
--(1.1) Gain ATK
function c99910080.atkcon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():GetBattleTarget()~=nil
end
function c99910080.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99910080.atkop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if c:IsFaceup() and c:IsRelateToEffect(e) then
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
    e1:SetValue(1000)
    c:RegisterEffect(e1)
  end
end
--(2) Destroy replace
function c99910080.drepfilter(c,tp)
  return c:IsFaceup() and c:IsSetCard(0x991) and bit.band(c:GetType(),0x81)==0x81 and c:IsControler(tp)
  and c:IsLocation(LOCATION_MZONE) and not c:IsReason(REASON_REPLACE) and c:IsReason(REASON_EFFECT+REASON_BATTLE)
end
function c99910080.dreptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c99910080.drepfilter,1,nil,tp) and eg:GetCount()==1 
  and Duel.GetFlagEffect(tp,99910081)==0 end
  return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c99910080.drepval(e,c)
  return c99910080.drepfilter(c,e:GetHandlerPlayer())
end
function c99910080.drepop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
  Duel.RegisterFlagEffect(tp,99910081,RESET_PHASE+PHASE_END,0,1)
end