--Fate Guardian of The Scales
--Scripted by Raivost
function c99890130.initial_effect(c)
  --(1) Special Summon
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99890130,0))
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetTarget(c99890130.sptg)
  e1:SetOperation(c99890130.spop)
  c:RegisterEffect(e1)
  --(2) Search
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99890130,1))
  e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e2:SetType(EFFECT_TYPE_QUICK_O)
  e2:SetRange(LOCATION_GRAVE)
  e2:SetCode(EVENT_FREE_CHAIN)
  e2:SetCost(aux.bfgcost)
  e2:SetTarget(c99890130.thtg)
  e2:SetOperation(c99890130.thop)
  c:RegisterEffect(e2)
end
--(1) Special Summon
function c99890130.spfilter(c,e,tp,m,ft)
  if not c:IsSetCard(0x989) or bit.band(c:GetType(),0x81)~=0x81 or not c:IsAbleToRemove()
  or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
  local mg=m:Filter(Card.IsCanBeRitualMaterial,c,c)
  if ft>0 then
    return mg:CheckWithSumGreater(Card.GetRitualLevel,c:GetLevel(),c)
  else
    return mg:IsExists(c99890130.spfilterF,1,nil,tp,mg,c)
  end
end
function c99890130.spfilterF(c,tp,mg,rc)
  if c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5 then
    Duel.SetSelectedCard(c)
    return mg:CheckWithSumGreater(Card.GetRitualLevel,rc:GetLevel(),rc)
  else return false end
end
function c99890130.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then
    local mg=Duel.GetRitualMaterial(tp)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    return ft>-1 and Duel.IsExistingMatchingCard(c99890130.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp,mg,ft)
  end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function c99890130.spop(e,tp,eg,ep,ev,re,r,rp)
  local mg=Duel.GetRitualMaterial(tp)
  local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
  local tg=Duel.SelectMatchingCard(tp,c99890130.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp,mg,ft)
  local tc=tg:GetFirst()
  if tc and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 then
    mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
    local mat=nil
    if ft>0 then
      Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
      mat=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,tc:GetLevel(),tc)
    else
      Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
      mat=mg:FilterSelect(tp,c99890130.spfilterF,1,1,nil,tp,mg,tc)
      Duel.SetSelectedCard(mat)
      Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
      local mat2=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,tc:GetLevel(),tc)
      mat:Merge(mat2)
    end
    tc:SetMaterial(mat)
    Duel.ReleaseRitualMaterial(mat)
    Duel.BreakEffect()
    Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e1:SetValue(1)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
    tc:RegisterEffect(e1)
    tc:CompleteProcedure()
  end
end
--(2) Search
function c99890130.thfilter(c)
  return c:IsSetCard(0x989) and not c:IsCode(99890130) and c:IsAbleToHand()
end
function c99890130.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99890130.thfilter,tp,LOCATION_DECK,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99890130.thop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,c99890130.thfilter,tp,LOCATION_DECK,0,1,1,nil)
  if g:GetCount()>0 then
    Duel.SendtoHand(g,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,g)
  end
end