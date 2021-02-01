--Overlord Magic Tier Encyclopedia
--Scripted by Raivost
function c99920150.initial_effect(c)
  --(1) Search
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99920150,0))
  e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,99920150+EFFECT_COUNT_CODE_OATH)
  e1:SetTarget(c99920150.thtg)
  e1:SetOperation(c99920150.thop)
  c:RegisterEffect(e1)
end
--(1) Search
function c99920150.thfilter(c)
  return c:IsSetCard(0x992) and not c:IsCode(99920150) and c:IsAbleToHand()
end
function c99920150.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99920150.thfilter,tp,LOCATION_DECK,0,1,nil)
  and Duel.IsPlayerCanDiscardDeck(tp,5) and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=6 end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99920150.thop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,c99920150.thfilter,tp,LOCATION_DECK,0,1,1,nil)
  if g:GetCount()>0 then
    Duel.SendtoHand(g,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,g)
    Duel.ShuffleDeck(tp)
    if not Duel.IsPlayerCanDiscardDeck(tp,5) then return end
    Duel.BreakEffect()
    Duel.ConfirmDecktop(tp,5)
    local sg=Duel.GetDecktopGroup(tp,5)
    local ct=sg:FilterCount(Card.IsType,nil,g:GetFirst():GetType())
    Duel.DisableShuffleCheck()
    if ct>0 then
      Duel.Recover(tp,ct*1000,REASON_EFFECT)
    end
    Duel.SendtoDeck(sg,nil,0,REASON_EFFECT)
    Duel.SortDecktop(tp,tp,5)
    for i=1,5 do
      local mg=Duel.GetDecktopGroup(tp,1)
      Duel.MoveSequence(mg:GetFirst(),1)
    end
  end
end