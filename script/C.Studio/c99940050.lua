--NGNL Imanity Throne
--Scripted by Raivost
function c99940050.initial_effect(c)
  --(1) Send to GY
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99940050,0))
  e1:SetCategory(CATEGORY_COIN+CATEGORY_DECKDES)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,99940050+EFFECT_COUNT_CODE_OATH)
  e1:SetCondition(c99940050.tgcon)
  e1:SetTarget(c99940050.tgtg)
  e1:SetOperation(c99940050.tgop)
  c:RegisterEffect(e1)
  --(2) Return to hand
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99940050,1))
  e2:SetCategory(CATEGORY_TOHAND)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e2:SetProperty(EFFECT_FLAG_DELAY)
  e2:SetCode(EVENT_TO_GRAVE)
  e2:SetCondition(c99940050.rthcon)
  e2:SetTarget(c99940050.rthtg)
  e2:SetOperation(c99940050.rthop)
  c:RegisterEffect(e2)
end
--(1) Send to GY
function c99940050.tgcon(e,tp,eg,ep,ev,re,r,rp)
  local tc1=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
  local tc2=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
  return tc1 and tc1:IsSetCard(0x994) and tc2 and tc2:IsSetCard(0x994)
end
function c99940050.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
  local lsc=Duel.GetFieldCard(tp,LOCATION_PZONE,0):GetLeftScale()
  local rsc=Duel.GetFieldCard(tp,LOCATION_PZONE,1):GetRightScale()
  if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1) and Duel.IsPlayerCanDiscardDeck(1-tp,1) and (lsc>rsc or rsc>lsc) end
  if lsc>rsc then lsc,rsc=rsc,lsc end
  e:SetLabel(rsc-lsc)
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
  Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,rsc-lsc)
end
function c99940050.tgop(e,tp,eg,ep,ev,re,r,rp)
  local res=Duel.TossCoin(tp,1)
  if res==1 then 
    Duel.DiscardDeck(1-tp,e:GetLabel(),REASON_EFFECT)
  else  
    Duel.DiscardDeck(tp,e:GetLabel(),REASON_EFFECT)
  end
end
--(2) Return to hand
function c99940050.rthcon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsReason(REASON_EFFECT)
  and (e:GetHandler():GetPreviousLocation()==LOCATION_DECK or e:GetHandler():GetPreviousLocation()==LOCATION_HAND)
end
function c99940050.rthtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():IsAbleToHand() end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,tp,LOCATION_GRAVE)
end
function c99940050.rthop(e,tp,eg,ep,ev,re,r,rp)
  if e:GetHandler():IsRelateToEffect(e) and Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)~=0 
  and Duel.ConfirmCards(1-tp,e:GetHandler())~=0 then
    Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+99940060,e,0,tp,0,0)
  end
end