--SAO Halloween Dungeon Party
--Scripted by Raivost
local s,id=GetID()
function s.initial_effect(c)
  --(1) Reveal
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(id,0))
  e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,id)
  e1:SetTarget(s.revtg)
  e1:SetOperation(s.revop)
  c:RegisterEffect(e1)
  --(2) To hand
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(id,1))
  e2:SetCategory(CATEGORY_TOHAND)
  e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetRange(LOCATION_GRAVE)
  e2:SetCountLimit(1,id+1)
  e2:SetCost(s.thcost)
  e2:SetTarget(s.thtg)
  e2:SetOperation(s.thop)
  c:RegisterEffect(e2)
end
function s.revfilter(c)
  return c:IsSetCard(0x999) and c:IsType(TYPE_MONSTER)
end
function s.revtg(e,tp,eg,ep,ev,re,r,rp,chk)
  local g=Duel.GetMatchingGroup(s.revfilter,tp,LOCATION_DECK,0,nil)
  if chk==0 then return g:GetClassCount(Card.GetCode)>=3 end
  Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,0))
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function s.revop(e,tp,eg,ep,ev,re,r,rp)
  local g=Duel.GetMatchingGroup(s.revfilter,tp,LOCATION_DECK,0,nil)
  if g:GetClassCount(Card.GetCode)>=3 then
    local rg=Group.CreateGroup()
    for i=1,3 do
      Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
      local sg=g:Select(tp,1,1,nil)
      local tc=sg:GetFirst()
      rg:AddCard(tc)
      g:Remove(Card.IsCode,nil,tc:GetCode())
    end
    Duel.ConfirmCards(1-tp,rg)
    Duel.ShuffleDeck(tp)
    Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
    local tc=rg:Select(1-tp,1,1,nil):GetFirst()
    Duel.SendtoHand(tc,nil,REASON_EFFECT)
  end
end
--(2) To hand
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
  if chk==0 then return aux.exccon(e,tp,eg,ep,ev,re,r,rp,0) and Duel.IsCanRemoveCounter(tp,1,0,0x1999,1,REASON_COST)  end
  Duel.Remove(c,POS_FACEUP,REASON_COST)
  Duel.RemoveCounter(tp,1,0,0x1999,1,REASON_COST)
end
function s.thfilter(c)
  return c:IsSetCard(0x999) and not c:IsSetCard(0x1999) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingTarget(s.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,1))
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectTarget(tp,s.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) then
    Duel.SendtoHand(tc,nil,REASON_EFFECT)
  end
end