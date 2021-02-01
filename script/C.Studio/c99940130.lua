--NGNL Seize The Moment
--Scripted by Raivost
function c99940130.initial_effect(c)
  --(1) Rock-paper-scissors
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99940130,0))
  e1:SetCategory(CATEGORY_DECKDES+CATEGORY_TOHAND+CATEGORY_SEARCH)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,99940130+EFFECT_COUNT_CODE_OATH)
  e1:SetCondition(c99940130.rpscon)
  e1:SetTarget(c99940130.rpstg)
  e1:SetOperation(c99940130.rpsop)
  c:RegisterEffect(e1)
  --(2) Return to hand
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99940130,3))
  e2:SetCategory(CATEGORY_TOHAND)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e2:SetProperty(EFFECT_FLAG_DELAY)
  e2:SetCode(EVENT_TO_GRAVE)
  e2:SetCondition(c99940130.rthcon)
  e2:SetTarget(c99940130.rthtg)
  e2:SetOperation(c99940130.rthop)
  c:RegisterEffect(e2)
end
--(1) Rock-paper-scissors
function c99940130.rpscon(e)
  return Duel.IsExistingMatchingCard(Card.IsSetCard,e:GetHandlerPlayer(),LOCATION_PZONE,0,2,nil,0x994)
end
function c99940130.rpstg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsPlayerCanDiscardDeckAsCost(tp,3) and Duel.IsPlayerCanDiscardDeckAsCost(1-tp,3) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,3)
  Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,1-tp,3)
end
function c99940130.thfilter(c)
  return c:IsType(TYPE_MONSTER) and (c:IsLocation(LOCATION_DECK) or (c:IsFaceup() and c:IsType(TYPE_PENDULUM))) and c:IsAbleToHand()
end
function c99940130.rpsop(e,tp,eg,ep,ev,re,r,rp)
  local res=Duel.RockPaperScissors()
  if res==tp then
  	Duel.DiscardDeck(1-tp,3,REASON_EFFECT)
  	if Duel.IsExistingMatchingCard(c99940130.thfilter,tp,LOCATION_EXTRA+LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(99940130,1)) then
	  Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(99940130,2))
  	  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	  local g=Duel.SelectMatchingCard(tp,c99940130.thfilter,tp,LOCATION_EXTRA+LOCATION_DECK,0,1,1,nil)
	  if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	  end
  	end
  else
  	Duel.DiscardDeck(tp,3,REASON_EFFECT)
  	if Duel.IsExistingMatchingCard(c99940130.thfilter,1-tp,LOCATION_EXTRA+LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(1-tp,aux.Stringid(99940130,1)) then
	  Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(99940130,2))
      Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
	  local g=Duel.SelectMatchingCard(1-tp,c99940130.thfilter,1-tp,LOCATION_EXTRA+LOCATION_DECK,0,1,1,nil)
	  if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(tp,g)
	  end
  	end
  end
end
--(2) Return to hand
function c99940130.rthcon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsReason(REASON_EFFECT) 
  and (e:GetHandler():GetPreviousLocation()==LOCATION_DECK or e:GetHandler():GetPreviousLocation()==LOCATION_HAND)
end
function c99940130.rthtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():IsAbleToHand() end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,tp,LOCATION_GRAVE)
end
function c99940130.rthop(e,tp,eg,ep,ev,re,r,rp)
  if e:GetHandler():IsRelateToEffect(e) and Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)~=0 
  and Duel.ConfirmCards(1-tp,e:GetHandler())~=0 then
    Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+99940060,e,0,tp,0,0)
  end
end