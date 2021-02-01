--HN Compa
--Scripted by Raivost
function c99980200.initial_effect(c)
  --(1) Normal Summon
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99980200,0))
  e1:SetCategory(CATEGORY_TOHAND)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e1:SetProperty(EFFECT_FLAG_DELAY)
  e1:SetCode(EVENT_SUMMON_SUCCESS)
  e1:SetCountLimit(1,99980200)
  e1:SetTarget(c99980200.thtg)
  e1:SetOperation(c99980200.thop)
  c:RegisterEffect(e1)
end
--(1) Normal Summon
function c99980200.thfilter(c)
  return c:IsSetCard(0x998) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c99980200.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99980200.thfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsPlayerCanDraw(tp,1) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
  Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c99980200.thop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local hg=Duel.SelectMatchingCard(tp,c99980200.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
  if hg:GetCount()>0 and Duel.SendtoHand(hg,tp,REASON_EFFECT)>0 then
  	if hg:GetFirst():IsLocation(LOCATION_HAND) then
      Duel.ConfirmCards(1-tp,hg)
    end
    Duel.Draw(tp,1,REASON_EFFECT)
  end
end