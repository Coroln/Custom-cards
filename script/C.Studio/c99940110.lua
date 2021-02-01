--NGNL Fake End
--Scripted by Raivost
function c99940110.initial_effect(c)
  --(1) To deck
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99940110,0))
  e1:SetCategory(CATEGORY_COIN+CATEGORY_TODECK+CATEGORY_DRAW)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,99940110+EFFECT_COUNT_CODE_OATH)
  e1:SetTarget(c99940110.tdtg)
  e1:SetOperation(c99940110.tdop)
  c:RegisterEffect(e1)
  --(2) Return to hand
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99940110,1))
  e2:SetCategory(CATEGORY_TOHAND)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e2:SetProperty(EFFECT_FLAG_DELAY)
  e2:SetCode(EVENT_TO_GRAVE)
  e2:SetCondition(c99940110.rthcon)
  e2:SetTarget(c99940110.rthtg)
  e2:SetOperation(c99940110.rthop)
  c:RegisterEffect(e2)
end
function c99940110.tdfilter(c)
  return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsAbleToDeck()
end
function c99940110.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingMatchingCard(c99940110.tdfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
  Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c99940110.tdop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c99940110.tdfilter),tp,LOCATION_EXTRA+LOCATION_GRAVE,0,nil)
  if g:GetCount()<1 then return end
  local dc=Duel.TossDice(tp,1)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
  local sg=g:Select(tp,1,dc,nil)
  Duel.SendtoDeck(sg,nil,0,REASON_EFFECT)
  local og=Duel.GetOperatedGroup()
  if og:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
  Duel.BreakEffect()
  Duel.Draw(tp,1,REASON_EFFECT)
  if dc==6 and c:IsRelateToEffect(e) and e:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.SelectYesNo(tp,aux.Stringid(99940110,2)) then
  	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    c:CancelToGrave()
    Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
  end
end
--(2) Return to hand
function c99940110.rthcon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsReason(REASON_EFFECT) 
  and (e:GetHandler():GetPreviousLocation()==LOCATION_DECK or e:GetHandler():GetPreviousLocation()==LOCATION_HAND)
end
function c99940110.rthtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():IsAbleToHand() end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,tp,LOCATION_GRAVE)
end
function c99940110.rthop(e,tp,eg,ep,ev,re,r,rp)
  if e:GetHandler():IsRelateToEffect(e) and Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)~=0 
  and Duel.ConfirmCards(1-tp,e:GetHandler())~=0 then
    Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+99940060,e,0,tp,0,0)
  end
end