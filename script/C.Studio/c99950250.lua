--MSMM Past Disorder
--Scripted by Raivost
function c99950250.initial_effect(c)
  --(1) Place in S/T Zone
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99950250,0))
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetTarget(c99950250.stztg)
  e1:SetOperation(c99950250.stzop)
  c:RegisterEffect(e1)
  --(2) Special Summon
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99950250,1))
  e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetRange(LOCATION_GRAVE)
  e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_NO_TURN_RESET)
  e2:SetCountLimit(1)
  e2:SetCondition(aux.exccon)
  e2:SetTarget(c99950250.sptg)
  e2:SetOperation(c99950250.spop)
  c:RegisterEffect(e2)
end
--(1) Place in S/T Zone
function c99950250.stzfilter(c)
  return c:IsSetCard(0x995) and bit.band(c:GetType(),0x81)==0x81  and not c:IsForbidden()
end
function c99950250.tgfilter(c)
  return c:IsSetCard(0x995) and bit.band(c:GetType(),0x81)==0x81 and c:IsAbleToGrave()
end
function c99950250.stztg(e,tp,eg,ep,ev,re,r,rp,chk)
  if e:GetHandler():IsLocation(LOCATION_HAND) then v=1 else v=0 end
  if chk==0 then return Duel.IsExistingMatchingCard(c99950250.stzfilter,tp,LOCATION_GRAVE,0,1,nil)
  and Duel.IsExistingMatchingCard(c99950250.tgfilter,tp,LOCATION_DECK,0,1,nil)
  and Duel.GetLocationCount(tp,LOCATION_SZONE)>v end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c99950250.stzop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  local g1=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c99950250.stzfilter),tp,LOCATION_GRAVE,0,1,1,nil)
  local tc=g1:GetFirst()
  if tc and  Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)~=0 then
    --Continuous Spell
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetCode(EFFECT_CHANGE_TYPE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetReset(RESET_EVENT+0x1fc0000)
    e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
    tc:RegisterEffect(e1)
    Duel.RaiseEvent(tc,EVENT_CUSTOM+99950150,e,0,tp,0,0)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g2=Duel.SelectMatchingCard(tp,c99950250.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g2:GetCount()>0 then
      Duel.SendtoGrave(g2,REASON_EFFECT)
    end
  end
end
--(2) Special Summon
function c99950250.spfilter(c,e,tp)
  return c:IsFaceup() and c:IsSetCard(0x995) and bit.band(c:GetOriginalType(),0x81)==0x81
  and c:IsCanBeSpecialSummoned(e,0,tp,true,true) 
end
function c99950250.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingTarget(c99950250.spfilter,tp,LOCATION_SZONE,0,1,nil,e,tp)
  and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectTarget(tp,c99950250.spfilter,tp,LOCATION_SZONE,0,1,1,nil,e,tp)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c99950250.spop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) then
    Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
  end
end