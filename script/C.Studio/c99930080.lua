--OTNN Twoearle
--Scripted by Raivost
function c99930080.initial_effect(c)
  --(1) Special Summon from hand
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetCode(EFFECT_SPSUMMON_PROC)
  e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
  e1:SetRange(LOCATION_HAND)
  e1:SetCondition(c99930080.hspcon)
  c:RegisterEffect(e1)
  --(2) To Hand
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99930080,0))
  e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e2:SetCode(EVENT_TO_GRAVE)
  e2:SetTarget(c99930080.thtg)
  e2:SetOperation(c99930080.thop)
  c:RegisterEffect(e2)
  --(3) Special Summon
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99930080,1))
  e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e3:SetType(EFFECT_TYPE_IGNITION)
  e3:SetRange(LOCATION_MZONE)
  e3:SetTarget(c99930080.sptg)
  e3:SetOperation(c99930080.spop)
  c:RegisterEffect(e3)
  --(4) Gain rank
  local e4=Effect.CreateEffect(c)
  e4:SetCode(EFFECT_UPDATE_RANK)
  e4:SetType(EFFECT_TYPE_XMATERIAL)
  e4:SetCondition(c99930080.rankcon)
  e4:SetValue(c99930080.rankval)
  c:RegisterEffect(e4)
end
--(1) Special Summon from hand
function c99930080.hspcon(e,c)
  if c==nil then return true end
  return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
  and Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0,nil)<Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_MZONE,nil)
end
--(2) To Hand
function c99930080.thfilter(c)
  return c:IsSetCard(0x993) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c99930080.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99930080.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c99930080.thop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c99930080.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
  if g:GetCount()>0 then
    Duel.SendtoHand(g,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,g)
  end
end
--(3) Special Summon
function c99930080.spfilter(c,e,tp)
  return c:IsSetCard(0x993) and e:GetHandler():IsCanBeXyzMaterial(c,tp) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99930080.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCountFromEx(tp,tp,e:GetHandler())>0
  and Duel.IsExistingMatchingCard(c99930080.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c99930080.spop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if Duel.GetLocationCountFromEx(tp,tp,c)>0 and c:IsFaceup() and c:IsRelateToEffect(e) and c:IsControler(tp) and not c:IsImmuneToEffect(e) then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c99930080.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
    local sc=g:GetFirst()
    if sc then
      sc:SetMaterial(Group.FromCards(c))
      Duel.Overlay(sc,Group.FromCards(c))
      Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
    end
  end
end
--(4) Gain rank
function c99930080.rankcon(e)
  return e:GetHandler():IsSetCard(0x993)
end
function c99930080.rankval(e,c)
  return Duel.GetFieldGroupCount(0,LOCATION_MZONE,LOCATION_MZONE)
end