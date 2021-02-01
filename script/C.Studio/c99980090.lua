--HN CPU Candidate Uni
--Scripted by Raviost
function c99980090.initial_effect(c)
  --(1) Special Summon from hand
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetCode(EFFECT_SPSUMMON_PROC)
  e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
  e1:SetRange(LOCATION_HAND)
  e1:SetCountLimit(1,99980090)
  e1:SetCondition(c99980090.sphcon)
  c:RegisterEffect(e1)
  --(2) Special Summon
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99980090,0))
  e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e2:SetProperty(EFFECT_FLAG_DELAY)
  e2:SetCode(EVENT_TO_GRAVE)
  e2:SetCountLimit(1,99980091)
  e2:SetCondition(c99980090.spcon)
  e2:SetTarget(c99980090.sptg)
  e2:SetOperation(c99980090.spop)
  c:RegisterEffect(e2)
  --(3) Increase lvl
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99980090,1))
  e3:SetCategory(CATEGORY_LVCHANGE)
  e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e3:SetProperty(EFFECT_FLAG_DELAY)
  e3:SetCode(EVENT_SPSUMMON_SUCCESS)
  e3:SetCondition(c99980090.lvlcon)
  e3:SetTarget(c99980090.lvltg)
  e3:SetOperation(c99980090.lvlop)
  c:RegisterEffect(e3)
end
c99980090.listed_names={99980040}
--(1) Special Summon from hand
function c99980090.sphfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x1998) and not c:IsCode(99980090)
end
function c99980090.sphcon(e,c)
  if c==nil then return true end
  return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
  and Duel.IsExistingMatchingCard(c99980090.sphfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
--(2) Special Summon
function c99980090.spcon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c99980090.spfilter1(c,e,tp)
  return c:IsSetCard(0x998) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
  and Duel.IsExistingMatchingCard(c99980090.spfilter2,tp,LOCATION_GRAVE,0,1,nil,e,tp,c:GetLevel())
end
function c99980090.spfilter2(c,e,tp,lv)
  return c:IsSetCard(0x998) and c:IsType(TYPE_MONSTER) and c:GetLevel()==lv and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99980090.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99980090.spfilter1,tp,LOCATION_HAND,0,1,nil,e,tp) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c99980090.spop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
  local g1=Duel.SelectMatchingCard(tp,c99980090.spfilter1,tp,LOCATION_HAND,0,1,1,nil,e,tp)
  if g1:GetCount()==0 then return end
  Duel.ConfirmCards(1-tp,g1)
  Duel.ShuffleHand(tp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,c99980090.spfilter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,g1:GetFirst():GetLevel())
  if g:GetCount()>0 then
    Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
  end
end
--(3) Increase lvl
function c99980090.lvlcon(e,tp,eg,ep,ev,re,r,rp)
  return re and re:GetHandler():IsSetCard(0x998)
end
function c99980090.lvltg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99980090.lvlop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if c:IsRelateToEffect(e) and c:IsFaceup() then
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_LEVEL)
    e1:SetReset(RESET_EVENT+0x1ff0000)
    e1:SetValue(1)
    c:RegisterEffect(e1)
  end
end