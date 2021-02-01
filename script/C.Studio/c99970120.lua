--DAL CR-unit - Origami
--Scripted by Raivost
function c99970120.initial_effect(c)
  --Xyz Summon
  aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x997),3,2)
  c:EnableReviveLimit()
  --(1) To hand
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99970120,0))
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e1:SetCode(EVENT_SPSUMMON_SUCCESS)
  e1:SetCondition(c99970120.thcon)
  e1:SetTarget(c99970120.thtg)
  e1:SetOperation(c99970120.thop)
  c:RegisterEffect(e1)
  --(2) Send to GY
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99970120,1))
  e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
  e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetCountLimit(1)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCost(c99970120.tgcost)
  e2:SetTarget(c99970120.tgtg)
  e2:SetOperation(c99970120.tgop)
  c:RegisterEffect(e2,false,1)
end
--(1) To hand
function c99970120.thcon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c99970120.thfilter(c)
  return c:IsCode(99970130) and c:IsAbleToHand()
end
function c99970120.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99970120.thfilter,tp,LOCATION_DECK,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99970120.thop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,c99970120.thfilter,tp,LOCATION_DECK,0,1,1,nil)
  if g:GetCount()>0 then
    Duel.SendtoHand(g,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,g)
  end
end
--(2) Send to GY
function c99970120.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
  e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c99970120.tgfilter(c,e,tp,ft)
  return c:IsSetCard(0x997) and c:GetLevel()==3 and c:IsAbleToGrave() and (ft>0 or c:GetSequence()<5)
  and Duel.IsExistingMatchingCard(c99970120.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp,c:GetCode())
end
function c99970120.spfilter(c,e,tp,code)
  local class=_G["c"..code]
  return class and class.listed_namescount~=nil and c:IsSetCard(0xA97) and c:IsCode(class.listed_names[1]) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99970120.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
  if chk==0 then return ft>-1 and Duel.IsExistingTarget(c99970120.tgfilter,tp,LOCATION_MZONE,0,1,nil,e,tp,ft) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
  local g=Duel.SelectTarget(tp,c99970120.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp,ft)
  Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c99970120.tgop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) then
    if Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE)
    and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
    and Duel.IsExistingMatchingCard(c99970120.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp,tc:GetCode()) then
      Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
      local g=Duel.SelectMatchingCard(tp,c99970120.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp,tc:GetCode())
      if g:GetCount()>0 then
        Duel.BreakEffect()
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
      end
    end
  end
end