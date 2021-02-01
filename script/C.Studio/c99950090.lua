--MSMM Duelist's Sonata
--Scripted by Raivost
function c99950090.initial_effect(c)
  --(1) Cannot activate Spell/Trap
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99950090,0))
  e1:SetCategory(CATEGORY_ATKCHANGE)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,99950090+EFFECT_COUNT_CODE_OATH)
  e1:SetTarget(c99950090.atktg)
  e1:SetOperation(c99950090.atkop)
  c:RegisterEffect(e1)
end
--(1) Gain ATK
function c99950090.atkfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x995) and bit.band(c:GetType(),0x81)==0x81 
end
function c99950090.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingTarget(c99950090.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  Duel.SelectTarget(tp,c99950090.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c99950090.atkop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsFaceup() and tc:IsRelateToEffect(e) then
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(math.floor(tc:GetAttack()/2))
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
    tc:RegisterEffect(e1)
  end
  --(1.1) Cannot activate Spell/Trap
  local e2=Effect.CreateEffect(e:GetHandler())
  e2:SetType(EFFECT_TYPE_FIELD)
  e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e2:SetCode(EFFECT_CANNOT_ACTIVATE)
  e2:SetTargetRange(0,1)
  e2:SetValue(c99950090.aclimit)
  e2:SetCondition(c99950090.actcon)
  e2:SetReset(RESET_PHASE+PHASE_END)
  Duel.RegisterEffect(e2,tp)
end
--(1.1) Cannot activate Spell/Trap
function c99950090.aclimit(e,re,tp)
  return re:IsHasType(EFFECT_TYPE_ACTIVATE) and not re:GetHandler():IsImmuneToEffect(e)
end
function c99950090.actcon(e)
  local tp=e:GetHandlerPlayer()
  local a=Duel.GetAttacker()
  return a and a:IsSetCard(0x995) and bit.band(a:GetType(),0x81)==0x81 and a:IsControler(tp)
end