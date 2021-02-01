--MSMM Magia, Supreme Wish 
--Scripted by Raivost
function c99950280.initial_effect(c)
  --(1) Special Summon
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99950280,0))
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,99950280+EFFECT_COUNT_CODE_DUEL)
  e1:SetCondition(c99950280.spcon)
  e1:SetTarget(c99950280.sptg)
  e1:SetOperation(c99950280.spop)
  c:RegisterEffect(e1)
  --(2) Shuffle
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99950280,1))
  e2:SetCategory(CATEGORY_TODECK)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetRange(LOCATION_GRAVE)
  e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e2:SetCondition(aux.exccon)
  e2:SetCost(aux.bfgcost)
  e2:SetTarget(c99950280.tdtg)
  e2:SetOperation(c99950280.tdop)
  c:RegisterEffect(e2)
  --(3) Ritual Summon count
  if not c99950280.global_check then
    c99950280.global_check=true
    c99950280[0]=0
    c99950280[1]=0
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetOperation(c99950280.checkop)
    Duel.RegisterEffect(e3,0)
  end
end
--(1) Special summon
function c99950280.spcon(e,tp,eg,ep,ev,re,r,rp)
    return c99950280[tp]>4
end
function c99950280.spmfilterf(c,tp,mg,rc)
  if c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) then
    Duel.SetSelectedCard(c)
    return mg:CheckWithSumGreater(Card.GetRitualLevel,rc:GetLevel(),rc)
  else return false end
end
function c99950280.spfilter(c,e,tp,m1,m2,ft)
  if not c:IsSetCard(0x995) or bit.band(c:GetType(),0x81)~=0x81 or c:GetLevel()~=10
  or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,false) then return false end
  local mg=m1:Filter(Card.IsCanBeRitualMaterial,c,c)
  mg:Merge(m2)
  if (c:IsCode(99950070) or c:IsCode(99950190)) then return c:ritual_custom_condition(mg,ft) end
  if c.mat_filter then
    mg=mg:Filter(c.mat_filter,nil)
  end
  return mg:CheckWithSumGreater(Card.GetRitualLevel,c:GetLevel(),c)
end
function c99950280.spmfilter(c)
   return c:GetLevel()==5 and c:IsSetCard(0x995) and bit.band(c:GetOriginalType(),0x81)==0x81 and c:IsAbleToRemove()
end
function c99950280.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then
    local mg1=Duel.GetRitualMaterial(tp)
    mg1:Remove(Card.IsLocation,nil,LOCATION_HAND+LOCATION_MZONE)
    local mg2=Duel.GetMatchingGroup(c99950280.spmfilter,tp,LOCATION_GRAVE+LOCATION_SZONE,0,nil)
    return Duel.IsExistingMatchingCard(c99950280.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp,mg1,mg2)
  end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
  if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
    Duel.SetChainLimit(c99950280.chlimit)
  end
end
function c99950280.chlimit(e,ep,tp)
  return tp==ep
end
function c99950280.spop(e,tp,eg,ep,ev,re,r,rp)
  local mg1=Duel.GetRitualMaterial(tp)
  mg1:Remove(Card.IsLocation,nil,LOCATION_HAND+LOCATION_MZONE)
  local mg2=Duel.GetMatchingGroup(c99950280.spmfilter,tp,LOCATION_GRAVE+LOCATION_SZONE,0,nil)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,c99950280.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp,mg1,mg2)
  local tc=g:GetFirst()
  if tc then
    local mg=mg1:Filter(Card.IsCanBeRitualMaterial,tc,tc)
    mg:Merge(mg2)
    if (tc:IsCode(99950070) or tc:IsCode(99950190)) then
      tc:ritual_custom_operation(mg)
      local mat=tc:GetMaterial()
      Duel.Remove(mat,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
    else
      if tc.mat_filter then
        mg=mg:Filter(tc.mat_filter,nil)
      end
      local mat=nil
      Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
      mat=mg:FilterSelect(tp,c99950280.spmfilterf,1,1,nil,tp,mg,tc)
      Duel.SetSelectedCard(mat)
      Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
      local mat2=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,tc:GetLevel(),tc)
      mat:Merge(mat2)
      tc:SetMaterial(mat)
      local mat2=mat:Filter(Card.IsLocation,nil,LOCATION_GRAVE+LOCATION_SZONE)
      mat:Sub(mat2)
      Duel.Remove(mat2,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
    end
    Duel.BreakEffect()
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(tc:GetMaterialCount()*300)
    e1:SetReset(RESET_EVENT+0xfe0000)
    tc:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_UPDATE_DEFENSE)
    tc:RegisterEffect(e2)
    Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,true,false,POS_FACEUP)
    tc:CompleteProcedure()
  end
end
--(2) Shuffle
function c99950280.tdfilter(c)
  return c:IsSetCard(0x995) and bit.band(c:GetOriginalType(),0x81)==0x81 and c:IsAbleToDeck()
end
function c99950280.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99950280.tdfilter,tp,LOCATION_REMOVED,0,1,nil) 
  and Duel.IsPlayerCanDraw(tp,1) end
  local g=Duel.GetMatchingGroup(c99950280.tdfilter,tp,LOCATION_REMOVED,0,nil)
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c99950280.tdop(e,tp,eg,ep,ev,re,r,rp)
  local g=Duel.GetMatchingGroup(c99950280.tdfilter,tp,LOCATION_REMOVED,0,nil)
  if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)~=0 then
  Duel.ShuffleDeck(tp)
    Duel.Draw(tp,1,REASON_EFFECT)
  end
end
--(3) Ritual Summon count
function c99950280.checkop(e,tp,eg,ep,ev,re,r,rp)
  local tc=eg:GetFirst()
  while tc do
    if tc:IsSetCard(0x995) and tc:GetLevel()==5 and bit.band(tc:GetType(),0x81)==0x81
    and bit.band(tc:GetSummonType(),SUMMON_TYPE_RITUAL)==SUMMON_TYPE_RITUAL then
      local p=tc:GetSummonPlayer()
      c99950280[p]=c99950280[p]+1
    end
    tc=eg:GetNext()
  end
end