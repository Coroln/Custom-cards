--BRS LLWO
--Scripted by Raivost
function c99960280.initial_effect(c)
  --(1) Send to GY
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99960280,0))
  e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
  e1:SetType(EFFECT_TYPE_IGNITION)
  e1:SetRange(LOCATION_MZONE+LOCATION_HAND)
  e1:SetCost(c99960280.tgcost)
  e1:SetTarget(c99960280.tgtg)
  e1:SetOperation(c99960280.tgop)
  c:RegisterEffect(e1)
  --(2) Destroy
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99960280,1))
  e2:SetCategory(CATEGORY_DESTROY)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e2:SetCode(EVENT_TO_GRAVE)
  e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e2:SetCondition(c99960280.descon)
  e2:SetTarget(c99960280.destg)
  e2:SetOperation(c99960280.desop)
  c:RegisterEffect(e2)
end
--(1) Send to GY 1
function c99960280.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():IsReleasable() end
  Duel.Release(e:GetHandler(),REASON_COST)
end
function c99960280.tgfilter(c,e,tp)
  return c:GetLevel()==4 and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave() and Duel.GetLocationCountFromEx(tp,tp,c)>0 
  and Duel.IsExistingMatchingCard(c99960280.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
end
function c99960280.spfilter(c,e,tp)
  return c:IsSetCard(0x996) and c:GetRank()==4 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99960280.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99960280.tgfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,e:GetHandler(),e,tp) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_MZONE)
end
function c99960280.tgop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
  local g1=Duel.SelectMatchingCard(tp,c99960280.tgfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,e,tp)
  if Duel.GetLocationCountFromEx(tp,tp,g1:GetFirst())<=0 then return end
  if g1:GetCount()>0 and Duel.SendtoGrave(g1,REASON_EFFECT) then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g2=Duel.SelectMatchingCard(tp,c99960280.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
    if g2:GetCount()>0 then
      Duel.SpecialSummon(g2,0,tp,tp,false,false,POS_FACEUP)
    end
  end
end
--(2) Destroy
function c99960280.descon(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  return c:IsReason(REASON_COST) and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_MONSTER)
  and c:IsPreviousLocation(LOCATION_OVERLAY) and re:GetHandler():IsSetCard(0x996)
end
function c99960280.desfilter(c)
  return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c99960280.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingTarget(c99960280.desfilter,tp,0,LOCATION_ONFIELD,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
  local g=Duel.SelectTarget(tp,c99960280.desfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c99960280.desop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc and tc:IsRelateToEffect(e) then
    Duel.Destroy(tc,REASON_EFFECT)
  end
end