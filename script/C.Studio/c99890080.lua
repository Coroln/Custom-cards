--Fate Caster, Medea
--Scripted by Raivost
function c99890080.initial_effect(c)
  c:EnableReviveLimit()
  --(1) Search
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99890080,0))
  e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e1:SetType(EFFECT_TYPE_IGNITION)
  e1:SetRange(LOCATION_HAND)
  e1:SetCountLimit(1,99890080)
  e1:SetCost(c99890080.thcost)
  e1:SetTarget(c99890080.thtg)
  e1:SetOperation(c99890080.thop)
  c:RegisterEffect(e1)
  --(2) Special Summon
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
  e2:SetCode(EVENT_SPSUMMON_SUCCESS)
  e2:SetOperation(c99890080.spreg)
  c:RegisterEffect(e2)
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99890080,1))
  e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
  e3:SetCondition(c99890080.spcon)
  e3:SetCost(c99890080.spcost)
  e3:SetTarget(c99890080.sptg)
  e3:SetOperation(c99890080.spop)
  e3:SetLabelObject(e2)
  c:RegisterEffect(e3)
  --(3) Inflict damage
  local e4=Effect.CreateEffect(c)
  e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e4:SetCode(EVENT_CHAIN_SOLVED)
  e4:SetRange(LOCATION_MZONE)
  e4:SetOperation(c99890080.damop)
  c:RegisterEffect(e4)
  --(4) Negate
  local e5=Effect.CreateEffect(c)
  e5:SetDescription(aux.Stringid(99890080,2))
  e5:SetCategory(CATEGORY_DISABLE)
  e5:SetType(EFFECT_TYPE_IGNITION)
  e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e5:SetRange(LOCATION_MZONE)
  e5:SetCountLimit(1)
  e5:SetTarget(c99890080.negtg)
  e5:SetOperation(c99890080.negop)
  c:RegisterEffect(e5)
end
c99890080.listed_names={99890090}
--(1) Search
function c99890080.thcostfiler(c)
  return c:IsSetCard(0x989) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c99890080.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
  if chk==0 then return not c:IsPublic() and Duel.IsExistingMatchingCard(c99890080.thcostfilter,tp,LOCATION_HAND,0,1,e:GetHandler())
  and Duel.IsExistingMatchingCard(c99890080.thcostfiler,tp,LOCATION_DECK,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
  local g=Duel.SelectMatchingCard(tp,c99890080.thcostfiler,tp,LOCATION_DECK,0,1,1,nil)
  Duel.SendtoGrave(g,REASON_COST)
  Duel.ShuffleHand(tp)
end
function c99890080.thfilter(c)
  return c:IsCode(99890010) and c:IsAbleToHand()
end
function c99890080.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99890080.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c99890080.thop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c99890080.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
  if g:GetCount()>0 then
    Duel.SendtoHand(g,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,g)
  end
end
--(2) Special Summon
function c99890080.spreg(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_STANDBY then
    e:SetLabel(Duel.GetTurnCount())
    c:RegisterFlagEffect(99890081,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,0,2)
  else
    e:SetLabel(0)
    c:RegisterFlagEffect(99890081,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,0,1)
  end
end
function c99890080.spcon(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  return e:GetLabelObject():GetLabel()~=Duel.GetTurnCount() and tp==Duel.GetTurnPlayer() and c:GetFlagEffect(99890081)>0
end
function c99890080.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
  Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c99890080.spfilter(c,e,tp)
  return c:IsCode(99890090) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c99890080.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
  and Duel.IsExistingMatchingCard(c99890080.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c99890080.spop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c99890080.spfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
  if g:GetCount()>0 then
    Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
  end
end
--(3) Inflict damage
function c99890080.damop(e,tp,eg,ep,ev,re,r,rp)
  if re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL) and rp==tp then
    Duel.Hint(HINT_CARD,0,99890080)
    Duel.Damage(1-tp,500,REASON_EFFECT)
  end
end
--(4) Negate
function c99890080.negfilter(c)
  return c:IsFaceup() and not c:IsDisabled()
end
function c99890080.negtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingTarget(c99890080.negfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  local g=Duel.SelectTarget(tp,c99890080.negfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())
  Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c99890080.negop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local tc=Duel.GetFirstTarget()
  if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
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
  end
end