--RE:C Selesia Upitiria
--Scripted by Raivost
function c99900020.initial_effect(c)
  --(1) Special Summon from hand
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99900020,0))
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetType(EFFECT_TYPE_IGNITION)
  e1:SetRange(LOCATION_HAND)
  e1:SetCountLimit(1)
  e1:SetTarget(c99900020.hsptg)
  e1:SetOperation(c99900020.hspop)
  c:RegisterEffect(e1)
  --(2) Reveal
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99900020,1))
  e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DECKDES)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e2:SetCode(EVENT_DISCARD)
  e2:SetCondition(c99900020.excacon)
  e2:SetTarget(c99900020.excatg)
  e2:SetOperation(c99900020.excaop)
  c:RegisterEffect(e2)
  --(3) Gain ATK
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_FIELD)
  e3:SetCode(EFFECT_UPDATE_ATTACK)
  e3:SetRange(LOCATION_MZONE)
  e3:SetTargetRange(LOCATION_MZONE,0)
  e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x990))
  e3:SetCondition(c99900020.atkcon)
  e3:SetValue(700)
  c:RegisterEffect(e3)
  --(4) Effect gain
  local e4=Effect.CreateEffect(c)
  e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
  e4:SetCode(EVENT_BE_MATERIAL)
  e4:SetCondition(c99900020.efgcon)
  e4:SetOperation(c99900020.efgop)
  c:RegisterEffect(e4)
end
--(1) Special Summon from hand
function c99900020.hspfilter(c)
  return c:IsDiscardable(REASON_EFFECT)
end
function c99900020.hsptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99900020.hspfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) 
  and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c99900020.hspop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.DiscardHand(tp,c99900020.hspfilter,1,1,REASON_EFFECT+REASON_DISCARD,e:GetHandler())~=0 and e:GetHandler():IsRelateToEffect(e) 
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
function c99900020.excacon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsReason(REASON_EFFECT)
end
function c99900020.excatg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1) 
  and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_DECK,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99900020.excaop(e,tp,eg,ep,ev,re,r,rp)
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
--(3) Gain ATK
function c99900020.atkcon(e)
  local ph=Duel.GetCurrentPhase()
  return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
--(4) Effect gain
function c99900020.efgcon(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  return r==REASON_LINK and c:GetReasonCard():IsSetCard(0x990)
end
function c99900020.efgop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetFlagEffect(tp,99900020)~=0 then return end
  local c=e:GetHandler()
  local rc=c:GetReasonCard()
  if not rc then return end
  --(4.1) Double damage
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
  e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
  e1:SetCondition(c99900020.damcon)
  e1:SetOperation(c99900020.damop)
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
  rc:RegisterFlagEffect(0,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(99900020,2))
  Duel.RegisterFlagEffect(tp,99900020,RESET_PHASE+PHASE_END,0,1)
end
--(4.1) Double damage
function c99900020.damcon(e,tp,eg,ep,ev,re,r,rp)
  return ep~=tp and e:GetHandler():GetBattleTarget()~=nil
end
function c99900020.damop(e,tp,eg,ep,ev,re,r,rp)
  local dam=Duel.GetBattleDamage(ep)
  Duel.ChangeBattleDamage(ep,dam*2)
end