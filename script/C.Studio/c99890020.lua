--Fate Saber, Artoria Pendragon
--Scripted by Raivost
function c99890020.initial_effect(c)
  c:EnableReviveLimit()
  --(1) Search
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99890020,0))
  e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e1:SetType(EFFECT_TYPE_IGNITION)
  e1:SetRange(LOCATION_HAND)
  e1:SetCountLimit(1,99890020)
  e1:SetCost(c99890020.thcost)
  e1:SetTarget(c99890020.thtg)
  e1:SetOperation(c99890020.thop)
  c:RegisterEffect(e1)
  --(2) Special Summon
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
  e2:SetCode(EVENT_SPSUMMON_SUCCESS)
  e2:SetOperation(c99890020.spreg)
  c:RegisterEffect(e2)
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99890020,1))
  e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
  e3:SetCondition(c99890020.spcon)
  e3:SetCost(c99890020.spcost)
  e3:SetTarget(c99890020.sptg)
  e3:SetOperation(c99890020.spop)
  e3:SetLabelObject(e2)
  c:RegisterEffect(e3)
  --(3) Gain ATK/DEF
  local e4=Effect.CreateEffect(c)
  e4:SetType(EFFECT_TYPE_FIELD)
  e4:SetCode(EFFECT_UPDATE_ATTACK)
  e4:SetRange(LOCATION_MZONE)
  e4:SetTargetRange(LOCATION_MZONE,0)
  e4:SetCondition(c99890020.atkcon)
  e4:SetTarget(c99890020.atktg)
  e4:SetValue(500)
  c:RegisterEffect(e4)
  local e5=e4:Clone()
  e5:SetCode(EFFECT_UPDATE_DEFENSE)
  c:RegisterEffect(e5)
  --(4) Indes by Spell
  local e6=Effect.CreateEffect(c)
  e6:SetType(EFFECT_TYPE_SINGLE)
  e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e6:SetRange(LOCATION_MZONE)
  e6:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
  e6:SetCountLimit(1)
  e6:SetValue(c99890020.indesval)
  c:RegisterEffect(e6)
end
c99890020.listed_names={99890030}
--(1) Search
function c99890020.thcostfiler(c)
  return c:IsSetCard(0x989) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c99890020.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
  if chk==0 then return not c:IsPublic() and Duel.IsExistingMatchingCard(c99890020.thcostfilter,tp,LOCATION_HAND,0,1,e:GetHandler())
  and Duel.IsExistingMatchingCard(c99890020.thcostfiler,tp,LOCATION_DECK,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
  local g=Duel.SelectMatchingCard(tp,c99890020.thcostfiler,tp,LOCATION_DECK,0,1,1,nil)
  Duel.SendtoGrave(g,REASON_COST)
  Duel.ShuffleHand(tp)
end
function c99890020.thfilter(c)
  return c:IsCode(99890010) and c:IsAbleToHand()
end
function c99890020.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99890020.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c99890020.thop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c99890020.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
  if g:GetCount()>0 then
    Duel.SendtoHand(g,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,g)
  end
end
--(2) Special Summon
function c99890020.spreg(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_STANDBY then
    e:SetLabel(Duel.GetTurnCount())
    c:RegisterFlagEffect(99890021,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,0,2)
  else
    e:SetLabel(0)
    c:RegisterFlagEffect(99890021,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,0,1)
  end
end
function c99890020.spcon(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  return e:GetLabelObject():GetLabel()~=Duel.GetTurnCount() and tp==Duel.GetTurnPlayer() and c:GetFlagEffect(99890021)>0
end
function c99890020.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
  Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c99890020.spfilter(c,e,tp)
  return c:IsCode(99890030) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c99890020.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
  and Duel.IsExistingMatchingCard(c99890020.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c99890020.spop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c99890020.spfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
  if g:GetCount()>0 then
    Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
  end
end
--(3) Gain ATK/DEF
function c99890020.atkcon(e)
  return e:GetHandler():IsAttackPos()
end
function c99890020.atktg(e,c)
  return c:IsSetCard(0x989) and c~=e:GetHandler()
end
--(4) Indes by Spell
function c99890020.indesval(e,re,r,rp)
  return bit.band(r,REASON_EFFECT)~=0 and re:IsActiveType(TYPE_SPELL)
end