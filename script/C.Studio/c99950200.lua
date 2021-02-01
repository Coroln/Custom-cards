--MSMM Contract's Wish
--Scripted by Raivost
function c99950200.initial_effect(c)
  --(1) Special Summon
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99950200,0))
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,99950200+EFFECT_COUNT_CODE_OATH)
  e1:SetCondition(c99950200.spcon)
  e1:SetCost(c99950200.spcost)
  e1:SetTarget(c99950200.sptg)
  e1:SetOperation(c99950200.spop)
  c:RegisterEffect(e1)
  --(2) To hand
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99950200,1))
  e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetRange(LOCATION_GRAVE)
  e2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
  e2:SetCountLimit(1)
  e2:SetCondition(aux.exccon)
  e2:SetTarget(c99950200.thtg)
  e2:SetOperation(c99950200.thop)
  c:RegisterEffect(e2)
end
--(1) Special Summon
function c99950200.spconfilter(c)
  return bit.band(c:GetType(),0x81)==0x81 and c:IsSetCard(0x995) and c:GetLevel()==5
end
function c99950200.spcon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.IsExistingMatchingCard(c99950200.spconfilter,tp,LOCATION_GRAVE,0,5,nil,e,tp) 
end
function c99950200.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c99950200.spfilter(c,e,tp)
  return c:IsSetCard(0x995) and c:GetLevel()==10 and bit.band(c:GetOriginalType(),0x81)==0x81 
  and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c99950200.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingMatchingCard(c99950200.spfilter,tp,LOCATION_HAND+LOCATION_SZONE,0,1,nil,e,tp) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_SZONE)
end
function c99950200.spop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,c99950200.spfilter,tp,LOCATION_HAND+LOCATION_SZONE,0,1,1,nil,e,tp)
  local tc=g:GetFirst()
  if tc and Duel.SpecialSummonStep(tc,0,tp,tp,true,true,POS_FACEUP) then
    tc:RegisterFlagEffect(99950200,RESET_EVENT+0x1fe0000,0,1,Duel.GetTurnCount())
    local ct=Duel.GetMatchingGroup(c99950200.spconfilter,tp,LOCATION_GRAVE,0,nil)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(ct:GetCount()*500)
    e1:SetReset(RESET_EVENT+0x1fe0000)
    tc:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_UPDATE_DEFENSE)
    tc:RegisterEffect(e2)
    local e3=Effect.CreateEffect(e:GetHandler())
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e3:SetCode(EVENT_PHASE+PHASE_END)
    e3:SetLabel(Duel.GetTurnCount())
    e3:SetLabelObject(tc)
    e3:SetCondition(c99950200.tdcon)
    e3:SetOperation(c99950200.tdop)
    e3:SetReset(RESET_PHASE+PHASE_END,2)
    e3:SetCountLimit(1)
    Duel.RegisterEffect(e3,tp)
    Duel.SpecialSummonComplete()
  end
end
function c99950200.tdcon(e,tp,eg,ep,ev,re,r,rp)
  local tc=e:GetLabelObject()
  return Duel.GetTurnCount()~=e:GetLabel() and tc:GetFlagEffectLabel(99950200)==e:GetLabel()
  and Duel.GetTurnPlayer()~=tp
end
function c99950200.tdop(e,tp,eg,ep,ev,re,r,rp)
  local tc=e:GetLabelObject()
  Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
end
--(2) To hand
function c99950200.thfilter1(c,tp)
  return c:IsSetCard(0x995) and c:GetType()==0x82 and c:IsAbleToHand()
  and Duel.IsExistingMatchingCard(c99950200.thfilter2,tp,LOCATION_DECK,0,1,c)
end
function c99950200.thfilter2(c)
  return c:IsSetCard(0x995) and bit.band(c:GetType(),0x81)==0x81 and c:GetLevel()==10 and c:IsAbleToHand()
end
function c99950200.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99950200.thfilter1,tp,LOCATION_DECK,0,1,nil,tp) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c99950200.thop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g1=Duel.SelectMatchingCard(tp,c99950200.thfilter1,tp,LOCATION_DECK,0,1,1,nil,tp)
  if g1:GetCount()>0 then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g2=Duel.SelectMatchingCard(tp,c99950200.thfilter2,tp,LOCATION_DECK,0,1,1,g1:GetFirst())
    g1:Merge(g2)
    Duel.SendtoHand(g1,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,g1)
  end
end