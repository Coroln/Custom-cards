--MSMM Night's Magic Dinner
--Scripted by Raivost
function c99950300.initial_effect(c)
  --(1) Search
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99950300,0))
  e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DECKDES)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,99950300+EFFECT_COUNT_CODE_OATH)
  e1:SetCost(c99950300.thcost)
  e1:SetTarget(c99950300.thtg)
  e1:SetOperation(c99950300.thop)
  c:RegisterEffect(e1)
end
--(1) Search
function c99950300.thcostfilter(c)
  return c:IsSetCard(0x995) and c:IsAbleToGraveAsCost()
end
function c99950300.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99950300.thcostfilter,tp,LOCATION_DECK,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
  local g=Duel.SelectMatchingCard(tp,c99950300.thcostfilter,tp,LOCATION_DECK,0,1,1,nil)
  Duel.SendtoGrave(g,REASON_COST)
end
function c99950300.thfilter(c,tp)
  return c:IsType(TYPE_MONSTER) and c:IsLevelBelow(5) and c:IsAbleToHand() and Duel.IsPlayerCanDiscardDeckAsCost(tp,c:GetLevel()+1)
end
function c99950300.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99950300.thfilter,tp,LOCATION_DECK,0,1,nil,tp) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
  Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,1)
end
function c99950300.thop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,c99950300.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
  if g:GetCount()>0 and Duel.SendtoHand(g,tp,REASON_EFFECT)~=0
  and g:GetFirst():IsLocation(LOCATION_HAND) then
  	ct=g:GetFirst():GetLevel()
    Duel.ConfirmCards(1-tp,g)
    if ct>0 then
    	Duel.DiscardDeck(tp,ct,REASON_EFFECT)
    end
  end
end