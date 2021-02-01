--NGNL The Lucky Draw
--Scripted by Raivost
function c99940090.initial_effect(c)
  --(1) Draw
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99940090,0))
  e1:SetCategory(CATEGORY_DRAW+CATEGORY_RECOVER)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN) 
  e1:SetCountLimit(1,99940090+EFFECT_COUNT_CODE_OATH)
  e1:SetCondition(c99940090.drcon)
  e1:SetTarget(c99940090.drtg)
  e1:SetOperation(c99940090.drop)
  c:RegisterEffect(e1)
  --(2) Return to hand
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99940090,1))
  e2:SetCategory(CATEGORY_TOHAND)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e2:SetProperty(EFFECT_FLAG_DELAY)
  e2:SetCode(EVENT_TO_GRAVE)
  e2:SetCondition(c99940090.rthcon)
  e2:SetTarget(c99940090.rthtg)
  e2:SetOperation(c99940090.rthop)
  c:RegisterEffect(e2)
end
--(1) Draw
function c99940090.drfilter(c)
  return c:IsSetCard(0x994)
end
function c99940090.drcon(e,tp,eg,ep,ev,re,r,rp)
  local tc1=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
  local tc2=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
  return (tc1 and c99940090.drfilter(tc1)) or (tc2 and c99940090.drfilter(tc2))
end
function c99940090.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsPlayerCanDraw(1-tp,1) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,1)
end
function c99940090.drop(e,tp,eg,ep,ev,re,r,rp)
  local d1=Duel.Draw(tp,1,REASON_EFFECT)
  local dc1=Duel.GetOperatedGroup():GetFirst()
  local d2=Duel.Draw(1-tp,1,REASON_EFFECT)
  local dc2=Duel.GetOperatedGroup():GetFirst()
  if d1>0 then
    Duel.ConfirmCards(1-tp,dc1)
    if dc1:IsType(TYPE_MONSTER) then
      Duel.Recover(tp,1000,REASON_EFFECT)
      Duel.ShuffleHand(tp)
    else
      Duel.SendtoGrave(dc1,REASON_EFFECT+REASON_DISCARD)
      Duel.ShuffleHand(tp)
    end
  end
  if d2>0 then
  Duel.ConfirmCards(tp,dc2)
  if dc2:IsType(TYPE_MONSTER) then
      Duel.Recover(1-tp,1000,REASON_EFFECT)
      Duel.ShuffleHand(1-tp)
    else
      Duel.SendtoGrave(dc2,REASON_EFFECT+REASON_DISCARD)
      Duel.ShuffleHand(1-tp)
    end
  end
end
--(2) Return to hand
function c99940090.rthcon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsReason(REASON_EFFECT) 
  and (e:GetHandler():GetPreviousLocation()==LOCATION_DECK or e:GetHandler():GetPreviousLocation()==LOCATION_HAND)
end
function c99940090.rthtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():IsAbleToHand() end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,tp,LOCATION_GRAVE)
end
function c99940090.rthop(e,tp,eg,ep,ev,re,r,rp)
  if e:GetHandler():IsRelateToEffect(e) and Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)~=0 
  and Duel.ConfirmCards(1-tp,e:GetHandler())~=0 then
    Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+99940060,e,0,tp,0,0)
  end
end