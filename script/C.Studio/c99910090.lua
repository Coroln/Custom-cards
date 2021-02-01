--YuYuYu Aobozu
--Scripted by Raivost
function c99910090.initial_effect(c)
  --(1) Give effect
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
  e1:SetCode(EVENT_BE_MATERIAL)
  e1:SetCountLimit(1,99910090)
  e1:SetCondition(c99910090.mtcon)
  e1:SetOperation(c99910090.mtop)
  c:RegisterEffect(e1)
  --(2) Destroy replace
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e2:SetCode(EFFECT_DESTROY_REPLACE)
  e2:SetRange(LOCATION_GRAVE)
  e2:SetTarget(c99910090.dreptg)
  e2:SetValue(c99910090.drepval)
  e2:SetOperation(c99910090.drepop)
  c:RegisterEffect(e2)
end
--(2) Give effect
function c99910090.mtcon(e,tp,eg,ep,ev,re,r,rp)
  return r==REASON_RITUAL
end
function c99910090.mtop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local g=eg:Filter(Card.IsSetCard,nil,0x991)
  local rc=g:GetFirst()
  if not rc then return end
  --(1.1) Negate attack
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99910090,1))
  e1:SetCategory(CATEGORY_DESTROY)
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e1:SetCode(EVENT_ATTACK_ANNOUNCE)
  e1:SetRange(LOCATION_MZONE)
  e1:SetCountLimit(1)
  e1:SetCondition(c99910090.nacon)
  e1:SetTarget(c99910090.natg)
  e1:SetOperation(c99910090.naop)
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
  rc:RegisterFlagEffect(0,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(99910090,0))
end
--(1.1) Negate attack
function c99910090.nacon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetAttacker():GetControler()~=tp
end
function c99910090.desfilter(c,atk)
  return c:IsFaceup() and c:IsAttackBelow(atk)
end
function c99910090.natg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  local atk=Duel.GetAttacker():GetAttack()
  if chk==0 then return Duel.IsExistingMatchingCard(c99910090.desfilter,tp,0,LOCATION_MZONE,1,nil,atk)  end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  local g=Duel.GetMatchingGroup(c99910090.desfilter,tp,0,LOCATION_MZONE,nil,atk)
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c99910090.naop(e,tp,eg,ep,ev,re,r,rp,chk)
  if Duel.NegateAttack() then
    local atk=Duel.GetAttacker():GetAttack()
    local g=Duel.SelectMatchingCard(tp,c99910090.desfilter,tp,0,LOCATION_MZONE,1,1,nil,atk)
    if g:GetCount()>0 then
      Duel.HintSelection(g)
      Duel.Destroy(g,REASON_EFFECT)
    end
  end
end
--(2) Destroy replace
function c99910090.drepfilter(c,tp)
  return c:IsFaceup() and c:IsSetCard(0x991) and bit.band(c:GetType(),0x81)==0x81 and c:IsControler(tp)
  and c:IsLocation(LOCATION_MZONE) and not c:IsReason(REASON_REPLACE) and c:IsReason(REASON_EFFECT+REASON_BATTLE)
end
function c99910090.dreptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c99910090.drepfilter,1,nil,tp) and eg:GetCount()==1 
  and Duel.GetFlagEffect(tp,99910091)==0 end
  return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c99910090.drepval(e,c)
  return c99910090.drepfilter(c,e:GetHandlerPlayer())
end
function c99910090.drepop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
  Duel.RegisterFlagEffect(tp,99910091,RESET_PHASE+PHASE_END,0,1)
end