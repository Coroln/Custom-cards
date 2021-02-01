--Fate Ascended Caster, Medea
--Scripted by Raivost
function c99890090.initial_effect(c)
  c:EnableReviveLimit()
  --Special Summon condition
  local e0=Effect.CreateEffect(c)
  e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
  e0:SetType(EFFECT_TYPE_SINGLE)
  e0:SetCode(EFFECT_SPSUMMON_CONDITION)
  e0:SetValue(aux.FALSE)
  c:RegisterEffect(e0)
  --(1) Search
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99890090,0))
  e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e1:SetCode(EVENT_LEAVE_FIELD)
  e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e1:SetTarget(c99890090.thtg)
  e1:SetOperation(c99890090.thop)
  c:RegisterEffect(e1)
  --(2) Inflict damage
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e2:SetCode(EVENT_CHAIN_SOLVED)
  e2:SetRange(LOCATION_MZONE)
  e2:SetOperation(c99890090.damop)
  c:RegisterEffect(e2)
  --(3) Negate
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99890090,1))
  e3:SetCategory(CATEGORY_DISABLE)
  e3:SetType(EFFECT_TYPE_IGNITION)
  e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCountLimit(1)
  e3:SetTarget(c99890090.negtg)
  e3:SetOperation(c99890090.negop)
  c:RegisterEffect(e3)
end
c99890090.listed_names={99890080}
--(1) Search
function c99890090.thfilter(c)
  return c:IsSetCard(0x989) and bit.band(c:GetType(),0x81)==0x81 and not c:IsCode(99890080) and c:IsAbleToHand()
end
function c99890090.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99890090.thfilter,tp,LOCATION_DECK,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99890090.thop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,c99890090.thfilter,tp,LOCATION_DECK,0,1,1,nil)
  if g:GetCount()>0 then
    Duel.SendtoHand(g,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,g)
  end
end
--(2) Inflict damage
function c99890090.damop(e,tp,eg,ep,ev,re,r,rp)
  if re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL) and rp==tp then
    Duel.Hint(HINT_CARD,0,99890090)
    Duel.Damage(1-tp,500,REASON_EFFECT)
  end
end
--(3) Negate
function c99890090.negfilter(c)
  return c:IsFaceup() and not c:IsDisabled()
end
function c99890090.negtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingMatchingCard(c99890090.negfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99890090.negop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
  local g=Duel.SelectMatchingCard(tp,c99890090.negfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,c)
  local tc=g:GetFirst()
  if tc then
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SET_ATTACK_FINAL)
    e1:SetValue(0)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
    tc:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
    tc:RegisterEffect(e2)
    Duel.NegateRelatedChain(tc,RESET_TURN_SET)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_DISABLE)
    e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
    tc:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_DISABLE_EFFECT)
    e4:SetValue(RESET_TURN_SET)
    e4:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
    tc:RegisterEffect(e4)
    if tc:IsType(TYPE_TRAPMONSTER) then
      local e5=Effect.CreateEffect(c)
      e5:SetType(EFFECT_TYPE_SINGLE)
      e5:SetCode(EFFECT_DISABLE_TRAPMONSTER)
      e5:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
      tc:RegisterEffect(e5)
    end
    if not tc:IsImmuneToEffect(e) then
      Duel.Recover(tp,tc:GetBaseAttack()/2,REASON_EFFECT)
    end
  end
end