--Overlord Supreme One's Will
--Scripted by Raivost
function c99920070.initial_effect(c)
  --(1) Special Summon
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99920070,0))
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,99920070+EFFECT_COUNT_CODE_OATH)
  e1:SetCondition(c99920070.spcon)
  e1:SetCost(c99920070.spcost)
  e1:SetTarget(c99920070.sptg)
  e1:SetOperation(c99920070.spop)
  c:RegisterEffect(e1)
  --(2) Shuffle
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99920070,1))
  e2:SetCategory(CATEGORY_TODECK+CATEGORY_RECOVER)
  e2:SetType(EFFECT_TYPE_QUICK_O)
  e2:SetRange(LOCATION_GRAVE)
  e2:SetCode(EVENT_FREE_CHAIN)
  e2:SetCondition(aux.exccon)
  e2:SetCost(aux.bfgcost)
  e2:SetTarget(c99920070.tdtg)
  e2:SetOperation(c99920070.tdop)
  c:RegisterEffect(e2)
end
--(1) Special Summon
function c99920070.spcon(e,tp,eg,ep,ev,re,r,rp)
  return not Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil)
end
function c99920070.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c99920070.spfilter(c,e,tp)
  return c:IsSetCard(0x992) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end
function c99920070.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingMatchingCard(c99920070.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function c99920070.spop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,c99920070.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
  if g:GetCount()>0 then
    Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
  end
end
--(2) Shuffle
function c99920070.tdfilter(c)
  return c:IsSetCard(0x992) and c:IsType(TYPE_MONSTER)
end
function c99920070.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c99920070.tdfilter(chkc) end
  if chk==0 then return Duel.IsExistingTarget(c99920070.tdfilter,tp,LOCATION_GRAVE,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
  local g=Duel.SelectTarget(tp,c99920070.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
  Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
end
function c99920070.tdop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 then
    Duel.Recover(tp,1000,REASON_EFFECT)
  end
end