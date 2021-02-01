--MSMM Divine Incertus
--Scripted by Raivost
function c99950230.initial_effect(c)
  --(1) Activate effect
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetTarget(c99950230.aetg)
  e1:SetOperation(c99950230.aeop)
  c:RegisterEffect(e1)
end
--(1) Activate effect
function c99950230.tdfilter(c)
  return c:IsSetCard(0x995) and c:GetLevel()==10 and bit.band(c:GetType(),0x81)==0x81 and c:IsAbleToDeck()
end
function c99950230.stzfilter(c)
  return c:IsSetCard(0x995) and c:GetLevel()==5 and bit.band(c:GetOriginalType(),0x81)==0x81 and not c:IsForbidden()
end
function c99950230.thfilter(c)
  return c:IsSetCard(0x995) and c:GetLevel()==5 and bit.band(c:GetOriginalType(),0x81)==0x81 and c:IsAbleToHand()
end
function c99950230.aetg(e,tp,eg,ep,ev,re,r,rp,chk)
  if e:GetHandler():IsLocation(LOCATION_HAND) then v=1 else v=0 end
  local b1=Duel.IsExistingTarget(c99950230.stzfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil)
  and Duel.GetLocationCount(tp,LOCATION_SZONE)>v and Duel.IsExistingMatchingCard(c99950230.tdfilter,tp,LOCATION_HAND,0,1,nil)
  local b2=Duel.IsExistingMatchingCard(c99950230.thfilter,tp,LOCATION_DECK,0,1,nil)
  and Duel.IsExistingMatchingCard(c99950230.tdfilter,tp,LOCATION_HAND,0,1,nil)
  if chk==0 then return b1 or b2 end
  local op=0
  if b1 and b2 then
    op=Duel.SelectOption(tp,aux.Stringid(99950230,0),aux.Stringid(99950230,1))
  elseif b1 then
    op=Duel.SelectOption(tp,aux.Stringid(99950230,0))
  else
    op=Duel.SelectOption(tp,aux.Stringid(99950230,1))+1
  end
  e:SetLabel(op)
  if op==0 then
  Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
  else
    e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
  end
  
end
function c99950230.aeop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
  local g=Duel.SelectMatchingCard(tp,c99950230.tdfilter,tp,LOCATION_HAND,0,1,1,nil)
  if g:GetCount()>0 and Duel.ConfirmCards(1-tp,g)~=0 
  and Duel.SendtoDeck(g,nil,2,REASON_EFFECT)~=0 and Duel.ShuffleDeck(tp)~=0 then
    local op=e:GetLabel()
    if op==0 then
      local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
      if ft<=0 then return end
      if ft>2 then ft=2 end
      Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
      local g=Duel.SelectMatchingCard(tp,c99950230.stzfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,ft,nil)
   	  for tc in aux.Next(g) do
        Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
        --Continuous Spell
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetCode(EFFECT_CHANGE_TYPE)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetReset(RESET_EVENT+0x1fc0000)
        e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
        tc:RegisterEffect(e1)
      end
      Duel.RaiseEvent(g,EVENT_CUSTOM+99950150,e,0,tp,0,0)
    else
      Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
      local g=Duel.SelectMatchingCard(tp,c99950230.thfilter,tp,LOCATION_DECK,0,1,2,nil)
      if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
      end
    end
  end
end