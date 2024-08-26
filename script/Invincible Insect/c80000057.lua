--Unschlagbares Insekt Moskitodrache
function c80000057.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	Link.AddProcedure(c,aux.FilterBoolFunction(Card.IsLevelAbove,5,Card.IsRace,RACE_INSECT),3,3)
	--(1) Special summon 1
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(80000057,0))
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e1:SetCode(EVENT_SPSUMMON_SUCCESS)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetCondition(c80000057.spcon1)
  e1:SetTarget(c80000057.sptg1)
  e1:SetOperation(c80000057.spop1)
  c:RegisterEffect(e1)
  --(2) Inflict damage
  local e2=Effect.CreateEffect(c)
  e2:SetCategory(CATEGORY_DAMAGE)
  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e2:SetProperty(EFFECT_FLAG_DELAY)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCode(EVENT_SPSUMMON_SUCCESS)
  e2:SetCondition(c80000057.damcon)
  e2:SetOperation(c80000057.damop)
  c:RegisterEffect(e2)
  --(3) Negate
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(80000057,1))
  e3:SetCategory(CATEGORY_TOHAND)
  e3:SetType(EFFECT_TYPE_QUICK_O)
  e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCountLimit(1)
  e3:SetCode(EVENT_FREE_CHAIN)
  e3:SetHintTiming(0,0x1c0+TIMING_MAIN_END)
  e3:SetCondition(c80000057.negcon)
  e3:SetTarget(c80000057.negtg)
  e3:SetOperation(c80000057.negop)
  c:RegisterEffect(e3)
  --(4) Special Summon 2
  local e4=Effect.CreateEffect(c)
  e4:SetDescription(aux.Stringid(80000057,0))
  e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
  e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e4:SetProperty(EFFECT_FLAG_DELAY)
  e4:SetCode(EVENT_TO_GRAVE)
  e4:SetTarget(c80000057.sptg2)
  e4:SetOperation(c80000057.spop2)
  c:RegisterEffect(e4)
end
--(2) Special Summon
function c80000057.spcon1(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c80000057.spfilter1(c,e,tp,zone)
  return c:IsSetCard(0x2328) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone,true)
end
function c80000057.sptg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  local zone=e:GetHandler():GetLinkedZone(tp)
  if chk==0 then return zone~=0 and Duel.IsExistingTarget(c80000057.spfilter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp,zone) end
  Duel.Hint(HINT_OPSELECTED,tp,e:GetDescription())
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectTarget(tp,c80000057.spfilter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp,zone)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c80000057.spop1(e,tp,eg,ep,ev,re,r,rp)
  local zone=e:GetHandler():GetLinkedZone(tp)
  local tc=Duel.GetFirstTarget()
  if tc and tc:IsRelateToEffect(e) and zone~=0 then
    Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP,zone)
  end
end
--(2) Inflict damage
function c80000057.damconfilter(c,g)
  return c:IsRace(RACE_INSECT) and g:IsContains(c)
end
function c80000057.damfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x2328)
end
function c80000057.damcon(e,tp,eg,ep,ev,re,r,rp)
  local lg=e:GetHandler():GetLinkedGroup()
  return lg and eg:IsExists(c80000057.damconfilter,1,nil,lg)
end
function c80000057.damop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_CARD,0,80000057)
  local ct=Duel.GetMatchingGroupCount(c80000057.damfilter,tp,LOCATION_MZONE,0,e:GetHandler())
  local dam=Duel.Damage(1-tp,ct*200,REASON_EFFECT)
  if dam>0 then
  	Duel.Recover(tp,dam,REASON_EFFECT)
  end
end
--(3) Negate
function c80000057.negcon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetCurrentPhase()==PHASE_MAIN1
end
function c80000057.negfilter(c,lg)
  return c:IsFaceup() and lg and lg:IsContains(c) and not c:IsDisabled()
end
function c80000057.negtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  local lg=e:GetHandler():GetLinkedGroup()
  if chk==0 then return Duel.IsExistingTarget(c80000057.negfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,lg) end
  Duel.Hint(HINT_OPSELECTED,tp,e:GetDescription())
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
  local g=Duel.SelectTarget(tp,c80000057.negfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,lg)
  Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c80000057.thfilter(c,val)
  local atk=c:GetAttack()
  return atk>=0 and atk<val and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c80000057.negop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local tc=Duel.GetFirstTarget()
  if tc and ((tc:IsFaceup() and not tc:IsDisabled()) or tc:IsType(TYPE_TRAPMONSTER)) and tc:IsRelateToEffect(e) then
    local pl = tc:GetOwner()
    local atk = tc:GetAttack()
    Duel.NegateRelatedChain(tc,RESET_TURN_SET)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetCode(EFFECT_DISABLE)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
    tc:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e2:SetCode(EFFECT_DISABLE_EFFECT)
    e2:SetValue(RESET_TURN_SET)
    e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
    tc:RegisterEffect(e2)
    if tc:IsType(TYPE_TRAPMONSTER) then
      local e3=Effect.CreateEffect(c)
      e3:SetType(EFFECT_TYPE_SINGLE)
      e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
      e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
      e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
      tc:RegisterEffect(e3)
    end
    if Duel.IsExistingMatchingCard(c80000057.thfilter,pl,LOCATION_DECK,0,1,nil,atk) and Duel.SelectYesNo(pl,aux.Stringid(80000057,2)) then
      Duel.Hint(HINT_OPSELECTED,tp,aux.Stringid(80000057,3))
      Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(80000057,3))
      Duel.Hint(HINT_SELECTMSG,pl,HINTMSG_ATOHAND)
      local g=Duel.SelectMatchingCard(pl,c80000057.thfilter,pl,LOCATION_DECK,0,1,1,nil,atk)
      if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        if pl==tp then
          Duel.ConfirmCards(1-tp,g)
        else
          Duel.ConfirmCards(tp,g)
        end
      end
    end
  end
end
--(4)
function c80000057.spfilter2(c,e,tp)
  return c:IsCode(80000052) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c80000057.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return  Duel.IsExistingTarget(c80000057.spfilter2,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
  Duel.Hint(HINT_OPSELECTED,tp,e:GetDescription())
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectTarget(tp,c80000057.spfilter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c80000057.tdfilter(c)
  return c:IsSetCard(0x2328) and c:IsType(TYPE_XYZ) and c:IsAbleToDeck()
end
function c80000057.spop2(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0
  and Duel.IsExistingMatchingCard(c80000057.tdfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(80000057,4)) then
    Duel.Hint(HINT_OPSELECTED,tp,aux.Stringid(80000057,5))
    Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(80000057,5))
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c80000057.tdfilter),tp,LOCATION_GRAVE,0,1,1,nil)
    if g:GetCount()>0 then
      Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
    end
  end
end