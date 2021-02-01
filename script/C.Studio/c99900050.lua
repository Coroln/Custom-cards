--RE:C Mamika Kirameki
--Scripted by Raivost
function c99900050.initial_effect(c)
  --(1) Special Summon from hand
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99900050,0))
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetType(EFFECT_TYPE_IGNITION)
  e1:SetRange(LOCATION_HAND)
  e1:SetCountLimit(1)
  e1:SetTarget(c99900050.hsptg)
  e1:SetOperation(c99900050.hspop)
  c:RegisterEffect(e1)
  --(2) Excavate
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99900050,1))
  e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DECKDES)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e2:SetCode(EVENT_DISCARD)
  e2:SetCondition(c99900050.excacon)
  e2:SetTarget(c99900050.excatg)
  e2:SetOperation(c99900050.excaop)
  c:RegisterEffect(e2)
  --(3) Inflict damage
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
  e3:SetCode(EVENT_CHAINING)
  e3:SetRange(LOCATION_MZONE)
  e3:SetOperation(aux.chainreg)
  c:RegisterEffect(e3)
  local e4=Effect.CreateEffect(c)
  e4:SetDescription(aux.Stringid(99900050,2))
  e4:SetCategory(CATEGORY_DAMAGE)
  e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
  e4:SetCode(EVENT_CHAIN_SOLVED)
  e4:SetRange(LOCATION_MZONE)
  e4:SetCondition(c99900050.damcon)
  e4:SetTarget(c99900050.damtg)
  e4:SetOperation(c99900050.damop)
  c:RegisterEffect(e4)
  --(4) Effect gain
  local e5=Effect.CreateEffect(c)
  e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
  e5:SetCode(EVENT_BE_MATERIAL)
  e5:SetCondition(c99900050.efgcon)
  e5:SetOperation(c99900050.efgop)
  c:RegisterEffect(e5)
end
--(1) Special Summon from hand
function c99900050.hspfilter(c)
  return c:IsDiscardable(REASON_EFFECT)
end
function c99900050.hsptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99900050.hspfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) 
  and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c99900050.hspop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.DiscardHand(tp,c99900050.hspfilter,1,1,REASON_EFFECT+REASON_DISCARD,e:GetHandler())~=0 and e:GetHandler():IsRelateToEffect(e) 
  and Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)~=0 then
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetCode(EFFECT_CANNOT_ATTACK)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
    e:GetHandler():RegisterEffect(e1)
  end
end
--(2) Reveal
function c99900050.excacon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsReason(REASON_EFFECT)
end
function c99900050.excatg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1) 
  and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_DECK,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99900050.excaop(e,tp,eg,ep,ev,re,r,rp)
  if not Duel.IsPlayerCanDiscardDeck(tp,1) then return end
  Duel.ConfirmDecktop(tp,1)
  local g=Duel.GetDecktopGroup(tp,1)
  local tc=g:GetFirst()
  if tc:IsSetCard(0x990) and tc:IsAbleToHand() then
    Duel.DisableShuffleCheck()
    Duel.SendtoHand(tc,nil,REASON_EFFECT)
    Duel.ShuffleHand(tp)
  else
    Duel.DisableShuffleCheck()
    Duel.SendtoGrave(tc,REASON_EFFECT+REASON_REVEAL)
  end
end
--(3) Inflict damage
function c99900050.damcon(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  return  re:IsHasType(EFFECT_TYPE_ACTIVATE) and ep~=tp and c:GetFlagEffect(1)>0
end
function c99900050.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.SetTargetPlayer(1-tp)
  Duel.SetTargetParam(700)
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,700)
end
function c99900050.damop(e,tp,eg,ep,ev,re,r,rp)
  local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
  Duel.Damage(p,d,REASON_EFFECT)
end
--(4) Effect gain
function c99900050.efgcon(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  return r==REASON_LINK and c:GetReasonCard():IsSetCard(0x990)
end
function c99900050.efgop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetFlagEffect(tp,99900050)~=0 then return end
  local c=e:GetHandler()
  local rc=c:GetReasonCard()
  if not rc then return end
  --(4.1) Destroy
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99900050,3))
  e1:SetCategory(CATEGORY_DESTROY)
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
  e1:SetCode(EVENT_SPSUMMON_SUCCESS)
  e1:SetRange(LOCATION_MZONE)
  e1:SetCountLimit(1)
  e1:SetCondition(c99900050.descon)
  e1:SetTarget(c99900050.destg)
  e1:SetOperation(c99900050.desop)
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
  rc:RegisterFlagEffect(0,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(99900050,4))
  Duel.RegisterFlagEffect(tp,99900050,RESET_PHASE+PHASE_END,0,1)
end
--(4.1) Destroy
function c99900050.descon(e,tp,eg,ep,ev,re,r,rp)
  if eg:GetCount()~=1 then return false end
  local tc=eg:GetFirst()
  return tc~=e:GetHandler() and tc:GetSummonPlayer()==1-tp
end
function c99900050.destg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end 
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg:GetFirst(),1,0,0)
end
function c99900050.desop(e,tp,eg,ep,ev,re,r,rp)
  local tc=eg:GetFirst()
  if tc:IsLocation(LOCATION_MZONE) and not tc:IsImmuneToEffect(e) then
   Duel.Destroy(tc,REASON_EFFECT)
  end
end