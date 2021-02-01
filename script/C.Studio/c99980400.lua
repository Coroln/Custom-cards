--HN Fragment Reaction
--Scripted by Raivost
function c99980400.initial_effect(c)
  --(1) Send to GY
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99980400,0))
  e1:SetCategory(CATEGORY_DECKDES+CATEGORY_RECOVER+CATEGORY_DRAW+CATEGORY_TOHAND+CATEGORY_SEARCH)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,99980400+EFFECT_COUNT_CODE_OATH)
  e1:SetTarget(c99980400.tgtg)
  e1:SetOperation(c99980400.tgop)
  c:RegisterEffect(e1)
end
--(1) Send to GY
function c99980400.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
  local ct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
  if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,3) and ct>=4 and Duel.IsPlayerCanDraw(tp,1) end
  Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,3)
  Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
  Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99980400.effilter(c)
  return c:IsLocation(LOCATION_GRAVE) and c:IsSetCard(0x998) and c:IsType(TYPE_MONSTER)
end
function c99980400.thfilter(c)
  return c:IsSetCard(0x998) and c:IsAbleToHand()
end
function c99980400.tgop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.DiscardDeck(tp,3,REASON_EFFECT)~=0 then
    local g=Duel.GetOperatedGroup()
    local ct=g:FilterCount(c99980400.effilter,nil)
    Duel.Draw(tp,1,REASON_EFFECT)
    if ct==0 then return end
    local hg=Duel.GetMatchingGroup(c99980400.thfilter,tp,LOCATION_DECK,0,nil)
    if ct==1 then
      Duel.BreakEffect()
      Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(99980400,1))
      Duel.Recover(tp,1000,REASON_EFFECT)
    elseif ct==2 then
      Duel.BreakEffect()
      Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(99980400,2))
      Duel.Draw(tp,1,REASON_EFFECT)
    elseif ct==3 and hg:GetCount()>0 then
      Duel.BreakEffect()
      Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(99980400,3))
      Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
      local shg=hg:Select(tp,1,1,nil)
      Duel.SendtoHand(shg,nil,REASON_EFFECT)
      Duel.ConfirmCards(1-tp,shg)
    end
  end
end