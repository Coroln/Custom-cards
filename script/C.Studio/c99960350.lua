--BRS Otherworld Star Call
--Scripted by Raivost
function c99960350.initial_effect(c)
  --(1) Send to GY
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99960350,0))
  e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,99960350+EFFECT_COUNT_CODE_OATH)
  e1:SetCost(c99960350.tgcost)
  e1:SetTarget(c99960350.tgtg)
  e1:SetOperation(c99960350.tgop)
  c:RegisterEffect(e1)
  --(2) Return to Deck
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99960350,1))
  e2:SetCategory(CATEGORY_TOHAND)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e2:SetCode(EVENT_TO_GRAVE)
  e2:SetCondition(c99960350.tdcon)
  e2:SetCost(c99960350.tdcost)
  e2:SetTarget(c99960350.tdtg)
  e2:SetOperation(c99960350.tdop)
  c:RegisterEffect(e2)
end
--(1) Send to GY
function c99960350.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.CheckLPCost(tp,700) end
  Duel.PayLPCost(tp,700)
end
function c99960350.tgfilter(c)
  return c:IsType(TYPE_MONSTER) and c:GetLevel()==4  and c:IsAbleToGrave()
end
function c99960350.spfilter(c,e,tp)
  return c:IsSetCard(0x996) and c:IsType(TYPE_XYZ) and c:GetRank()==4
  and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99960350.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99960350.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) 
  and Duel.IsExistingMatchingCard(c99960350.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) 
  and Duel.GetLocationCountFromEx(tp)>0 end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
  Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c99960350.tgop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
  local g1=Duel.SelectMatchingCard(tp,c99960350.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
  if g1:GetCount()>0 then
    Duel.SendtoGrave(g1,REASON_EFFECT)
    if not g1:GetFirst():IsLocation(LOCATION_GRAVE) then return end
    Duel.BreakEffect()
    if Duel.GetLocationCountFromEx(tp)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g2=Duel.SelectMatchingCard(tp,c99960350.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    if g2:GetCount()>0 and Duel.SpecialSummon(g2,0,tp,tp,false,false,POS_FACEUP)~=0 then
      Duel.Draw(tp,1,REASON_EFFECT)
    end
  end
end
--(2) Return to Deck
function c99960350.tdcon(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  return c:IsReason(REASON_COST) and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_MONSTER)
  and c:IsPreviousLocation(LOCATION_OVERLAY) and re:GetHandler():IsSetCard(0x996) 
end
function c99960350.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.CheckLPCost(tp,300) end
  Duel.PayLPCost(tp,300)
end
function c99960350.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c99960350.tdop(e,tp,eg,ep,ev,re,r,rp)
  if e:GetHandler():IsRelateToEffect(e) then
    Duel.SendtoDeck(e:GetHandler(),nil,0,REASON_EFFECT)
  end
end