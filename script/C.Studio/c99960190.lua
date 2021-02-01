--BRS Suffering Feast
--Scripted by Raivost
function c99960190.initial_effect(c)
  --(1) Search
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99960190,0))
  e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,99960190+EFFECT_COUNT_CODE_OATH)
  e1:SetCost(c99960190.thcost)
  e1:SetTarget(c99960190.thtg)
  e1:SetOperation(c99960190.thop)
  c:RegisterEffect(e1)
  --(2) Gain ATK
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99960190,1))
  e2:SetCategory(CATEGORY_ATKCHANGE)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e2:SetCode(EVENT_TO_GRAVE)
  e2:SetCondition(c99960190.atkcon)
  e2:SetTarget(c99960190.atktg)
  e2:SetOperation(c99960190.atkop)
  c:RegisterEffect(e2)
end
--(1) Search
function c99960190.thcostfilter(c)
  return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() and aux.SpElimFilter(c,true)
end
function c99960190.npayfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x996) and c:GetRank()==5
end
function c99960190.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
  local b1=Duel.CheckLPCost(tp,700) and not Duel.IsExistingMatchingCard(c99960190.npayfilter,tp,LOCATION_MZONE,0,1,nil)
  local b2=Duel.IsExistingMatchingCard(c99960190.npayfilter,tp,LOCATION_MZONE,0,1,nil)
  if chk==0 then return (b1 or b2) and Duel.IsExistingMatchingCard(c99960190.thcostfilter,tp,LOCATION_GRAVE,0,1,nil) end
  if b1 then 
    Duel.PayLPCost(tp,700)
  end
  local ct=Duel.GetMatchingGroupCount(c99960190.thfilter,tp,LOCATION_DECK,0,nil)
  if ct>3 then ct=3 end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
  local rg=Duel.SelectMatchingCard(tp,c99960190.thcostfilter,tp,LOCATION_GRAVE,0,1,ct,nil)
  Duel.Remove(rg,POS_FACEUP,REASON_COST)
  e:SetLabel(rg:GetCount())
end
function c99960190.thfilter(c)
  return c:IsSetCard(0x996) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c99960190.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99960190.thfilter,tp,LOCATION_DECK,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99960190.thop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,c99960190.thfilter,tp,LOCATION_DECK,0,1,e:GetLabel(),nil)
  if g:GetCount()>0 then
    Duel.SendtoHand(g,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,g)
  end
end
--(2) Gain ATK
function c99960190.atkcon(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  return c:IsReason(REASON_COST) and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_MONSTER)
  and c:IsPreviousLocation(LOCATION_OVERLAY) and re:GetHandler():IsSetCard(0x996)
end
function c99960190.atkfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x996) and c:IsType(TYPE_MONSTER)
end
function c99960190.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
  if chk==0 then return Duel.IsExistingTarget(c99960190.atkfilter,tp,LOCATION_MZONE,0,1,nil) and g:GetCount()>1 end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  Duel.SelectTarget(tp,c99960190.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c99960190.atkop(e,tp,eg,ep,ev,re,r,rp)
  local tc1=Duel.GetFirstTarget()
  local atk=0
  local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,tc1)
  if g:GetCount()>0 then
    for tc2 in aux.Next(g) do
      atk=atk+tc2:GetAttack()/2
      local e1=Effect.CreateEffect(e:GetHandler())
      e1:SetType(EFFECT_TYPE_SINGLE)
      e1:SetCode(EFFECT_SET_ATTACK_FINAL)
      e1:SetValue(tc2:GetAttack()/2)
      e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
      tc2:RegisterEffect(e1)
    end
    if tc1:IsFaceup() and tc1:IsRelateToEffect(e) then
      local e1=Effect.CreateEffect(e:GetHandler())
      e1:SetType(EFFECT_TYPE_SINGLE)
      e1:SetCode(EFFECT_UPDATE_ATTACK)
      e1:SetValue(atk/2)
      e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
      tc1:RegisterEffect(e1)
    end
  end
end