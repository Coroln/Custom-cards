--DAL Mayuri
--Scripted by Raivost
function c99970560.initial_effect(c)
  --(1) Cannot Normal Summon
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_CANNOT_SUMMON)
  c:RegisterEffect(e1)
  --(2) Special Summon from hand
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99970560,0))
  e2:SetType(EFFECT_TYPE_FIELD)
  e2:SetCode(EFFECT_SPSUMMON_PROC)
  e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
  e2:SetRange(LOCATION_HAND)
  e2:SetCondition(c99970560.hspcon)
  c:RegisterEffect(e2)
  --(3) Search
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99970560,1))
  e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e3:SetProperty(EFFECT_FLAG_DELAY)
  e3:SetCode(EVENT_SPSUMMON_SUCCESS)
  e3:SetCountLimit(1,99970560)
  e3:SetTarget(c99970560.thtg)
  e3:SetOperation(c99970560.thop)
  c:RegisterEffect(e3)
  --(4) Special Summon
  local e4=Effect.CreateEffect(c)
  e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e4:SetCode(EVENT_CHAINING)
  e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
  e4:SetRange(LOCATION_MZONE)
  e4:SetOperation(aux.chainreg)
  c:RegisterEffect(e4)
  local e5=Effect.CreateEffect(c)
  e5:SetDescription(aux.Stringid(99970560,1))
  e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e5:SetCode(EVENT_CHAIN_SOLVED)
  e5:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
  e5:SetRange(LOCATION_MZONE)
  e5:SetCondition(c99970560.spcon)
  e5:SetCost(c99970560.spcost)
  e5:SetTarget(c99970560.sptg)
  e5:SetOperation(c99970560.spop)
  c:RegisterEffect(e5)
end
c99970560.listed_namescount=1
c99970560.listed_names={99970550}
--(2) Special Summon from hand
function c99970560.hspconfilter(c)
  return c:IsFaceup() and c:IsSetCard(0xA97)
end
function c99970560.hspcon(e,c)
  if c==nil then return true end
  return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
  Duel.IsExistingMatchingCard(c99970560.hspconfilter,c:GetControler(),LOCATION_MZONE,0,2,nil)
end
--(3) Search
function c99970560.thfilter(c)
  return c:IsCode(99970010) and c:IsAbleToHand()
end
function c99970560.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99970560.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c99970560.thop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c99970560.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
  if g:GetCount()>0 then
    Duel.SendtoHand(g,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,g)
  end
end
--(4) Special Summon
function c99970560.spcon(e,tp,eg,ep,ev,re,r,rp)
  return rp~=tp
end
function c99970560.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():IsReleasable() end
  Duel.Release(e:GetHandler(),REASON_COST)
end
function c99970560.spfilter(c,e,tp)
  return c:IsCode(99970550) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99970560.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCountFromEx(tp,tp,e:GetHandler())>0
  and Duel.IsExistingMatchingCard(c99970560.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c99970560.spop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCountFromEx(tp)<=0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,c99970560.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
  if g:GetCount()>0 then
    Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
  end
end