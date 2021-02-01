--RE:C CM: Existance Change
--Script by Raivost
function c99900110.initial_effect(c)
  --(1) Equip
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99900110,0))
  e1:SetCategory(CATEGORY_EQUIP)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,99900110+EFFECT_COUNT_CODE_OATH)
  e1:SetTarget(c99900110.eqtg)
  e1:SetOperation(c99900110.eqop)
  c:RegisterEffect(e1)
end
function c99900110.eqfilter1(c,tp)
  return c:IsFaceup() and c:IsType(TYPE_EFFECT) and c:IsAbleToChangeControler() 
    and Duel.IsExistingMatchingCard(c99900110.eqfilter2,tp,LOCATION_MZONE,0,1,nil)
end
function c99900110.eqfilter2(c)
  return c:IsFaceup() and c:IsCode(99900010)
end
function c99900110.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if e:GetHandler():IsLocation(LOCATION_HAND) then v=1 else v=0 end
  if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler())
  and Duel.GetLocationCount(tp,LOCATION_SZONE)>v and Duel.IsExistingTarget(c99900110.eqfilter1,tp,0,LOCATION_MZONE,1,nil,tp) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
  local g=Duel.SelectTarget(tp,c99900110.eqfilter1,tp,0,LOCATION_MZONE,1,1,nil,tp)
  Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c99900110.eqop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)~=0 then
    local tc1=Duel.GetFirstTarget()
    if not tc1 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    local g=Duel.SelectMatchingCard(tp,c99900110.eqfilter2,tp,LOCATION_MZONE,0,1,1,nil)
    local tc2=g:GetFirst()
    if not tc2 then return end
    if tc1:IsRelateToEffect(e) and tc2 and tc2:IsLocation(LOCATION_MZONE) and tc2:IsFaceup() then
      Duel.Equip(tp,tc1,tc2)
      local e1=Effect.CreateEffect(e:GetHandler())
      e1:SetType(EFFECT_TYPE_FIELD)
      e1:SetCode(EFFECT_CANNOT_SUMMON)
      e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
      e1:SetTargetRange(0,0x7f)
      e1:SetRange(LOCATION_SZONE)
      e1:SetTarget(c99900110.sumlimit)
      e1:SetLabel(tc1:GetCode())
      e1:SetReset(RESET_EVENT+0x1fe0000)
      tc1:RegisterEffect(e1)
      local e2=e1:Clone()
      e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
      tc1:RegisterEffect(e2)
      local e3=e1:Clone()
      e3:SetCode(EFFECT_CANNOT_MSET)
      tc1:RegisterEffect(e3)
      local e4=e1:Clone()
      e4:SetCode(EFFECT_CANNOT_ACTIVATE)
      e4:SetValue(c99900110.aclimit)
      tc1:RegisterEffect(e4)
      --Equip limit
      local e5=Effect.CreateEffect(e:GetHandler())
      e5:SetType(EFFECT_TYPE_SINGLE)
      e5:SetCode(EFFECT_EQUIP_LIMIT)
      e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
      e5:SetValue(c99900110.eqlimit2)
      e5:SetReset(RESET_EVENT+0x1fe0000)
      e5:SetLabelObject(tc2)
      tc1:RegisterEffect(e5)
    else 
      Duel.SendtoGrave(tc1,REASON_RULE)
    end
  end
end
function c99900110.sumlimit(e,c)
  return c:IsCode(e:GetLabel())
end
function c99900110.aclimit(e,re,tp)
  return re:GetHandler():IsCode(e:GetLabel()) and re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsImmuneToEffect(e)
end
function c99900110.eqlimit2(e,c)
  return c==e:GetLabelObject()
end