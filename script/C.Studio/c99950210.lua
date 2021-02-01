--MSMM Return Of Miracles
--Scripted by Raivost
function c99950210.initial_effect(c)
  --(1) Shuffle 1
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99950210,0))
  e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW+CATEGORY_DECKDES)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,99950210+EFFECT_COUNT_CODE_OATH)
  e1:SetTarget(c99950210.tdtg)
  e1:SetOperation(c99950210.tdop)
  c:RegisterEffect(e1)
end
--(1) Shuffle 
function c99950210.tdfilter(c)
  return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsSetCard(0x995) and c:IsAbleToDeck()
end
function c99950210.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingTarget(c99950210.tdfilter,tp,LOCATION_GRAVE+LOCATION_SZONE,0,2,e:GetHandler()) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
  local g=Duel.SelectTarget(tp,aux.NecroValleyFilter(c99950210.tdfilter),tp,LOCATION_GRAVE+LOCATION_SZONE,0,2,5,e:GetHandler())
  Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
  Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c99950210.tdop(e,tp,eg,ep,ev,re,r,rp)
  local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
  if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)<2 then return end
  Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
  local g=Duel.GetOperatedGroup()
  if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
  local ct1=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
  if ct1>1 then
    local ct2=Duel.Draw(tp,2,REASON_EFFECT)
    local ct3=ct1-ct2
    if ct3>0 and Duel.IsPlayerCanDiscardDeck(tp,ct3) then
  	  Duel.BreakEffect()
      Duel.DiscardDeck(tp,ct3,REASON_EFFECT)
    end
  end
end