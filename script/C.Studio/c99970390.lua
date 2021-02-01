--DAL Spirit - Ruler
--Scripted by Raivost
function c99970390.initial_effect(c)
  --(1) Cannot Normal Summon
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_CANNOT_SUMMON)
  c:RegisterEffect(e1)
  --(2) Special Summon from hand
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99970390,0))
  e2:SetType(EFFECT_TYPE_FIELD)
  e2:SetCode(EFFECT_SPSUMMON_PROC)
  e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
  e2:SetRange(LOCATION_HAND)
  e2:SetCondition(c99970390.hspcon)
  c:RegisterEffect(e2)
  --(3) Change to face-down
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99970390,1))
  e3:SetCategory(CATEGORY_POSITION+CATEGORY_TOHAND+CATEGORY_SEARCH)
  e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e3:SetCode(EVENT_SPSUMMON_SUCCESS)
  e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
  e3:SetCondition(c99970390.poscon)
  e3:SetTarget(c99970390.postg)
  e3:SetOperation(c99970390.postop)
  c:RegisterEffect(e3)
  --(4) Negate
  local e4=Effect.CreateEffect(c)
  e4:SetDescription(aux.Stringid(99970390,4))
  e4:SetCategory(CATEGORY_NEGATE)
  e4:SetType(EFFECT_TYPE_QUICK_O)
  e4:SetCode(EVENT_CHAINING)
  e4:SetCountLimit(1,99970390)
  e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
  e4:SetRange(LOCATION_MZONE)
  e4:SetCondition(c99970390.negcon)
  e4:SetTarget(c99970390.negtg)
  e4:SetOperation(c99970390.negop)
  c:RegisterEffect(e4)
  --(5) Special Summon
  local e5=Effect.CreateEffect(c)
  e5:SetDescription(aux.Stringid(99970390,5))
  e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e5:SetCode(EVENT_DESTROYED)
  e5:SetCondition(c99970390.spcon)
  e5:SetTarget(c99970390.sptg)
  e5:SetOperation(c99970390.spop)
  c:RegisterEffect(e5)
end
--(2) Special Summon from hand
function c99970390.hspconfilter(c)
  return c:IsFaceup() and c:IsSetCard(0xA97) and not c:IsCode(99970390)
end
function c99970390.hspcon(e,c)
  if c==nil then return true end
  return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
  Duel.IsExistingMatchingCard(c99970390.hspconfilter,c:GetControler(),LOCATION_MZONE,0,2,nil)
end
--(3) Change to face-down
function c99970390.poscon(e,tp,eg,ep,ev,re,r,rp)
  return re and re:GetHandler():IsSetCard(0x997) and not (e:GetHandler():GetSummonType()==SUMMON_TYPE_PENDULUM)
end
function c99970390.posfilter(c)
  return c:IsFaceup() and c:IsCanTurnSet()
end
function c99970390.postg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99970390.posfilter,tp,0,LOCATION_MZONE,1,nil) end
  local g=Duel.GetMatchingGroup(c99970390.posfilter,tp,0,LOCATION_MZONE,nil)
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c99970390.thfilter(c)
  return c:IsSetCard(0x997) and c:GetLevel()==3 and c:IsAbleToHand()
end
function c99970390.postop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  local g=Duel.SelectMatchingCard(tp,c99970390.posfilter,tp,0,LOCATION_MZONE,1,1,nil)
  if g:GetCount()>0 then
    Duel.HintSelection(g)
    if Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)~=0 and Duel.IsExistingMatchingCard(c99970390.thfilter,tp,LOCATION_DECK,0,1,nil)
    and Duel.SelectYesNo(tp,aux.Stringid(99970390,2)) then
      Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(99970390,3))
      Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
      local g=Duel.SelectMatchingCard(tp,c99970390.thfilter,tp,LOCATION_DECK,0,1,1,nil)
      if g:GetCount()>0 then
      Duel.SendtoHand(g,nil,REASON_EFFECT)
      Duel.ConfirmCards(1-tp,g)
      end
    end
  end
end
--(4) Negate
function c99970390.negcon(e,tp,eg,ep,ev,re,r,rp)
  return rp~=tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c99970390.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c99970390.negop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.NegateActivation(ev) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsRelateToEffect(re) then
    Duel.SendtoGrave(eg,REASON_EFFECT)
  end
end
--(5) Special Summon
function c99970390.spcon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsReason(REASON_EFFECT)
end
function c99970390.spfilter(c,e,tp)
  return c:IsSetCard(0x997) and c:GetLevel()==3 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99970390.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingMatchingCard(c99970390.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c99970390.spop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,c99970390.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
  if g:GetCount()>0 then
    Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
  end
end