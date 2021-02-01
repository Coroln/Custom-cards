--HN Game Reload
--Scripted by Raivost
function c99980480.initial_effect(c)
  --Activate
  local e0=Effect.CreateEffect(c)
  e0:SetType(EFFECT_TYPE_ACTIVATE)
  e0:SetCode(EVENT_FREE_CHAIN)
  c:RegisterEffect(e0)
  --(1) Return to hand
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99980480,0))
  e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SUMMON)
  e1:SetType(EFFECT_TYPE_IGNITION)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetRange(LOCATION_SZONE)
  e1:SetCountLimit(1,99980480)
  e1:SetTarget(c99980480.rthtg)
  e1:SetOperation(c99980480.rthop)
  c:RegisterEffect(e1)
  --(2) Reveal
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99980480,3))
  e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetRange(LOCATION_SZONE)
  e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e2:SetCountLimit(1,99980481)
  e2:SetTarget(c99980480.revtg)
  e2:SetOperation(c99980480.revop)
  c:RegisterEffect(e2)
end
--(1) Return to hand
function c99980480.rthfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x998) and c:IsLevelAbove(3) and c:IsAbleToHand()
end
function c99980480.nsfilter(c)
  return c:IsSetCard(0x998)  and c:IsSummonable(true,nil)
end
function c99980480.rthtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingTarget(c99980480.rthfilter,tp,LOCATION_MZONE,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
  local g=Duel.SelectTarget(tp,c99980480.rthfilter,tp,LOCATION_MZONE,0,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
  Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c99980480.rthop(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  local tc=Duel.GetFirstTarget()
  if tc and tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 then
    local g=Duel.GetMatchingGroup(c99980480.nsfilter,tp,LOCATION_HAND,0,nil)
    if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(99980480,1)) then
      Duel.BreakEffect()
      Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(99980480,2))
      Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
      local sg=g:Select(tp,1,1,nil):GetFirst()
      Duel.Summon(tp,sg,true,nil)
    end
  end
end
--(2) Reveal
function c99980480.revfilter(c)
  return c:IsSetCard(0x998) and c:IsAbleToDeck()
end
function c99980480.revtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsPlayerCanDraw(tp)
  and Duel.IsExistingMatchingCard(c99980480.revfilter,tp,LOCATION_HAND,0,1,nil) end
  Duel.SetTargetPlayer(tp)
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
end
function c99980480.revop(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
  Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
  local g=Duel.SelectMatchingCard(p,c99980480.revfilter,p,LOCATION_HAND,0,1,63,nil)
  if g:GetCount()>0 then
    Duel.ConfirmCards(1-p,g)
    local ct=Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
    Duel.ShuffleDeck(p)
    Duel.BreakEffect()
    Duel.Draw(p,ct,REASON_EFFECT)
  end
end