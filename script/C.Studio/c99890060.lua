--Fate Rider, Medusa
--Scripted by Raivost
function c99890060.initial_effect(c)
  c:EnableReviveLimit()
  --(1) Search
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99890060,0))
  e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e1:SetType(EFFECT_TYPE_IGNITION)
  e1:SetRange(LOCATION_HAND)
  e1:SetCountLimit(1,99890060)
  e1:SetCost(c99890060.thcost)
  e1:SetTarget(c99890060.thtg)
  e1:SetOperation(c99890060.thop)
  c:RegisterEffect(e1)
  --(2) Special Summon
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
  e2:SetCode(EVENT_SPSUMMON_SUCCESS)
  e2:SetOperation(c99890060.spreg)
  c:RegisterEffect(e2)
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99890060,1))
  e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
  e3:SetCondition(c99890060.spcon)
  e3:SetCost(c99890060.spcost)
  e3:SetTarget(c99890060.sptg)
  e3:SetOperation(c99890060.spop)
  e3:SetLabelObject(e2)
  c:RegisterEffect(e3)
  --(3) Negate
  local e4=Effect.CreateEffect(c)
  e4:SetType(EFFECT_TYPE_FIELD)
  e4:SetCode(EFFECT_DISABLE)
  e4:SetRange(LOCATION_MZONE)
  e4:SetTargetRange(0,LOCATION_MZONE)
  e4:SetCondition(c99890060.negcon)
  e4:SetTarget(c99890060.negtg)
  c:RegisterEffect(e4)
  --(4) Gain ATK
  local e5=Effect.CreateEffect(c)
  e5:SetDescription(aux.Stringid(99890060,2))
  e5:SetCategory(CATEGORY_ATKCHANGE)
  e5:SetType(EFFECT_TYPE_IGNITION)
  e5:SetRange(LOCATION_MZONE)
  e5:SetCountLimit(1)
  e5:SetTarget(c99890060.atktg)
  e5:SetOperation(c99890060.atkop)
  c:RegisterEffect(e5)
end
c99890060.listed_names={99890070}
--(1) Search
function c99890060.thcostfiler(c)
  return c:IsSetCard(0x989) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c99890060.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
  if chk==0 then return not c:IsPublic() and Duel.IsExistingMatchingCard(c99890060.thcostfilter,tp,LOCATION_HAND,0,1,e:GetHandler())
  and Duel.IsExistingMatchingCard(c99890060.thcostfiler,tp,LOCATION_DECK,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
  local g=Duel.SelectMatchingCard(tp,c99890060.thcostfiler,tp,LOCATION_DECK,0,1,1,nil)
  Duel.SendtoGrave(g,REASON_COST)
  Duel.ShuffleHand(tp)
end
function c99890060.thfilter(c)
  return c:IsCode(99890010) and c:IsAbleToHand()
end
function c99890060.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99890060.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c99890060.thop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c99890060.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
  if g:GetCount()>0 then
    Duel.SendtoHand(g,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,g)
  end
end
--(2) Special Summon
function c99890060.spreg(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_STANDBY then
    e:SetLabel(Duel.GetTurnCount())
    c:RegisterFlagEffect(99890061,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,0,2)
  else
    e:SetLabel(0)
    c:RegisterFlagEffect(99890061,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,0,1)
  end
end
function c99890060.spcon(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  return e:GetLabelObject():GetLabel()~=Duel.GetTurnCount() and tp==Duel.GetTurnPlayer() and c:GetFlagEffect(99890061)>0
end
function c99890060.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
  Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c99890060.spfilter(c,e,tp)
  return c:IsCode(99890070) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c99890060.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
  and Duel.IsExistingMatchingCard(c99890060.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c99890060.spop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c99890060.spfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
  if g:GetCount()>0 then
    Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
  end
end
--(3) Negate
function c99890060.negcon(e)
  local c=e:GetHandler()
  return Duel.GetAttacker()==c and c:GetBattleTarget()
  and (Duel.GetCurrentPhase()==PHASE_DAMAGE or Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL)
end
function c99890060.negtg(e,c)
  return c==e:GetHandler():GetBattleTarget()
end
--(4) Gain ATK
function c99890060.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
  local ct=Duel.GetMatchingGroupCount(Card.IsType,e:GetHandler():GetControler(),0,LOCATION_GRAVE,nil,TYPE_MONSTER)
  if chk==0 then return ct>0 end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99890060.atkop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if c:IsFaceup() and c:IsRelateToEffect(e) then
    local ct=Duel.GetMatchingGroupCount(Card.IsType,c:GetControler(),0,LOCATION_GRAVE,nil,TYPE_MONSTER)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(ct*200)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
    c:RegisterEffect(e1)
  end
end