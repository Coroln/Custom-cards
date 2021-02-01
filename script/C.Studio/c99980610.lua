--HN Divine Pudding
--Scripted by Raivost
function c99980610.initial_effect(c)
  --(1) Excavate
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99980610,0))
  e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,99980610+EFFECT_COUNT_CODE_OATH)
  e1:SetTarget(c99980610.excatg)
  e1:SetOperation(c99980610.excaop)
  c:RegisterEffect(e1)
end
function c99980610.excafilter(c)
  return c:IsFaceup() and c:IsSetCard(0x998) and c:GetLink()>0
end
function c99980610.excatg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then
    local lg=Duel.GetMatchingGroup(c99980610.excafilter,tp,LOCATION_MZONE,0,c)
    local ct=lg:GetSum(Card.GetLink)
    if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<ct or ct<1 then return false end
    local g=Duel.GetDecktopGroup(tp,ct)
    return g:FilterCount(Card.IsAbleToHand,nil)>0
  end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c99980610.thfilter(c)
  return c:IsSetCard(0x998) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c99980610.excaop(e,tp,eg,ep,ev,re,r,rp)
  local lg=Duel.GetMatchingGroup(c99980610.excafilter,tp,LOCATION_MZONE,0,c)
  local ct=lg:GetSum(Card.GetLink)
  Duel.ConfirmDecktop(tp,ct)
  local g=Duel.GetDecktopGroup(tp,ct)
  if g:GetCount()>0 then
    local tg=g:Filter(Card.IsAbleToHand,nil)
    if tg:GetCount()>0 then
      Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
      local sg=tg:Select(tp,1,1,nil)
      Duel.SendtoHand(sg,nil,REASON_EFFECT)
      Duel.ConfirmCards(1-tp,sg)
    end
    Duel.ShuffleDeck(tp)
    if Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c99980610.thfilter),tp,LOCATION_GRAVE,0,1,nil) 
    and g:IsExists(Card.IsCode,1,nil,99980290,99980610) and Duel.SelectYesNo(tp,aux.Stringid(99980610,1)) then
      Duel.BreakEffect()
      Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(99980610,2))
      Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
      local hg=Duel.SelectMatchingCard(tp,c99980610.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
      if hg:GetCount()>0 then
        Duel.SendtoHand(hg,tp,REASON_EFFECT)
        if hg:GetFirst():IsLocation(LOCATION_HAND) then
          Duel.ConfirmCards(1-tp,hg)
        end
      end
    end
  end
end