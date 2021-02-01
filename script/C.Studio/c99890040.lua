--Fate Archer, Emiya Shirou
--Scripted by Raivost
function c99890040.initial_effect(c)
  c:EnableReviveLimit()
  --(1) Search
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99890040,0))
  e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e1:SetType(EFFECT_TYPE_IGNITION)
  e1:SetRange(LOCATION_HAND)
  e1:SetCountLimit(1,99890040)
  e1:SetCost(c99890040.thcost)
  e1:SetTarget(c99890040.thtg)
  e1:SetOperation(c99890040.thop)
  c:RegisterEffect(e1)
  --(2) Special Summon
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
  e2:SetCode(EVENT_SPSUMMON_SUCCESS)
  e2:SetOperation(c99890040.spreg)
  c:RegisterEffect(e2)
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99890040,1))
  e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
  e3:SetCondition(c99890040.spcon)
  e3:SetCost(c99890040.spcost)
  e3:SetTarget(c99890040.sptg)
  e3:SetOperation(c99890040.spop)
  e3:SetLabelObject(e2)
  c:RegisterEffect(e3)
  --(3) Direct attack
  local e4=Effect.CreateEffect(c)
  e4:SetType(EFFECT_TYPE_SINGLE)
  e4:SetCode(EFFECT_DIRECT_ATTACK)
  c:RegisterEffect(e4)
  --(4) Reduce damage
  local e5=Effect.CreateEffect(c)
  e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
  e5:SetCode(EVENT_PRE_BATTLE_DAMAGE)
  e5:SetCondition(c99890040.rdcon)
  e5:SetOperation(c99890040.rdop)
  c:RegisterEffect(e5)
  --(5) Change position
  local e6=Effect.CreateEffect(c)
  e6:SetDescription(aux.Stringid(99890040,2))
  e6:SetCategory(CATEGORY_POSITION)
  e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e6:SetType(EFFECT_TYPE_IGNITION)
  e6:SetRange(LOCATION_MZONE)
  e6:SetCountLimit(1)
  e6:SetTarget(c99890040.postg)
  e6:SetOperation(c99890040.posop)
  c:RegisterEffect(e6)
end
c99890040.listed_names={99890050}
--(1) Search
function c99890040.thcostfiler(c)
  return c:IsSetCard(0x989) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c99890040.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
  if chk==0 then return not c:IsPublic() and Duel.IsExistingMatchingCard(c99890040.thcostfilter,tp,LOCATION_HAND,0,1,e:GetHandler())
  and Duel.IsExistingMatchingCard(c99890040.thcostfiler,tp,LOCATION_DECK,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
  local g=Duel.SelectMatchingCard(tp,c99890040.thcostfiler,tp,LOCATION_DECK,0,1,1,nil)
  Duel.SendtoGrave(g,REASON_COST)
  Duel.ShuffleHand(tp)
end
function c99890040.thfilter(c)
  return c:IsCode(99890010) and c:IsAbleToHand()
end
function c99890040.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99890040.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c99890040.thop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c99890040.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
  if g:GetCount()>0 then
    Duel.SendtoHand(g,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,g)
  end
end
--(2) Special Summon
function c99890040.spreg(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_STANDBY then
    e:SetLabel(Duel.GetTurnCount())
    c:RegisterFlagEffect(99890041,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,0,2)
  else
    e:SetLabel(0)
    c:RegisterFlagEffect(99890041,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,0,1)
  end
end
function c99890040.spcon(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  return e:GetLabelObject():GetLabel()~=Duel.GetTurnCount() and tp==Duel.GetTurnPlayer() and c:GetFlagEffect(99890041)>0
end
function c99890040.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
  Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c99890040.spfilter(c,e,tp)
  return c:IsCode(99890050) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c99890040.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
  and Duel.IsExistingMatchingCard(c99890040.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c99890040.spop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c99890040.spfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
  if g:GetCount()>0 then
    Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
  end
end
--(4) Reduce damage
function c99890040.rdcon(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  return ep~=tp and Duel.GetAttackTarget()==nil
  and c:GetEffectCount(EFFECT_DIRECT_ATTACK)<2 and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
end
function c99890040.rdop(e,tp,eg,ep,ev,re,r,rp)
  Duel.ChangeBattleDamage(ep,ev/2)
end
--(5) Change position
function c99890040.posfilter(c)
  return c:IsCanChangePosition()
end
function c99890040.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingTarget(c99890040.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
  local g=Duel.SelectTarget(tp,c99890040.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c99890040.posop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc and tc:IsRelateToEffect(e) then
    Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
  end
end