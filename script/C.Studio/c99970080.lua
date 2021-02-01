--DAL Sandalphon - Throne of Annihilation
--Scripted by Raivost
function c99970080.initial_effect(c)
  --(1) Gain ATK
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99970080,0))
  e1:SetCategory(CATEGORY_ATKCHANGE)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,99970080+EFFECT_COUNT_CODE_OATH)
  e1:SetTarget(c99970080.atktg)
  e1:SetOperation(c99970080.atkop)
  c:RegisterEffect(e1)
end
--(1) Gain ATK
function c99970080.atkfilter(c)
  return c:IsFaceup() and c:IsSetCard(0xA97)
end
function c99970080.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingTarget(c99970080.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  Duel.SelectTarget(tp,c99970080.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c99970080.atkop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsImmuneToEffect(e) then
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(1000)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
    tc:RegisterEffect(e1)
    --(1.1) Second attack
    local e2=Effect.CreateEffect(e:GetHandler())
    e2:SetDescription(aux.Stringid(99970080,1))
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_BATTLE_DESTROYING)
    e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
    e2:SetCondition(c99970080.sacon)
    e2:SetTarget(c99970080.satg)
    e2:SetOperation(c99970080.saop)
    e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
    tc:RegisterEffect(e2,true)
    --(1.2) Double damage
    local e3=Effect.CreateEffect(e:GetHandler())
    e3:SetDescription(aux.Stringid(99970080,2))
    e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
    e3:SetCode(EVENT_PRE_BATTLE_DAMAGE)
    e3:SetProperty(EFFECT_FLAG_CLIENT_HINT)
    e3:SetCondition(c99970080.ddcon)
    e3:SetOperation(c99970080.ddop)
    e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
    tc:RegisterEffect(e3,true)
    if not tc:IsType(TYPE_EFFECT) then
      local e4=Effect.CreateEffect(e:GetHandler())
      e4:SetType(EFFECT_TYPE_SINGLE)
      e4:SetCode(EFFECT_ADD_TYPE)
      e4:SetValue(TYPE_EFFECT)
      e4:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
      tc:RegisterEffect(e4,true)
    end
  end
end
--(1.1) Second attack
function c99970080.sacon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetAttacker()==e:GetHandler() and aux.bdcon(e,tp,eg,ep,ev,re,r,rp)
  and not e:GetHandler():IsHasEffect(EFFECT_EXTRA_ATTACK)
end
function c99970080.satg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():IsRelateToBattle() end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99970080.saop(e,tp,eg,ep,ev,re,r,rp)
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_EXTRA_ATTACK)
  e1:SetValue(1)
  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
  e:GetHandler():RegisterEffect(e1)
end
--(1.2) Double damage
function c99970080.ddcon(e,tp,eg,ep,ev,re,r,rp)
  return ep~=tp and e:GetHandler():GetBattleTarget()~=nil
end
function c99970080.ddop(e,tp,eg,ep,ev,re,r,rp)
  Duel.ChangeBattleDamage(ep,ev*2)
end