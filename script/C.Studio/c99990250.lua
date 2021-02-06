--SAO Sinon - GGO
--Scripted by Raivost
local s,id=GetID()
function s.initial_effect(c)
  --Xyz Summon
   Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x999),4,2)
  c:EnableReviveLimit()
  --(1) Gain effect this turn
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
  e1:SetCode(EVENT_SPSUMMON_SUCCESS)
  e1:SetCondition(s.gecon)
  e1:SetOperation(s.geop)
  c:RegisterEffect(e1)
  --(2) Banish
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(id,1))
  e2:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND)
  e2:SetType(EFFECT_TYPE_QUICK_O)
  e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e2:SetCode(EVENT_FREE_CHAIN)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCountLimit(1,id+1)
  e2:SetHintTiming(0,0x1e0)
  e2:SetCost(s.bancost)
  e2:SetTarget(s.bantg)
  e2:SetOperation(s.banop)
  c:RegisterEffect(e2)
end
--(1) Gain effect this turn
function s.gecon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function s.geop(e,tp,eg,ep,ev,re,r,rp)
  --(1.1) Destroy
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetDescription(aux.Stringid(id,0))
  e1:SetCategory(CATEGORY_DESTROY)
  e1:SetType(EFFECT_TYPE_IGNITION)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetRange(LOCATION_MZONE)
  e1:SetCountLimit(1,id)
  e1:SetCost(s.descost)
  e1:SetTarget(s.destg)
  e1:SetOperation(s.desop)
  e1:SetReset(RESET_EVENT+0x16c0000+RESET_PHASE+PHASE_END)
  e:GetHandler():RegisterEffect(e1)
end
--(1.1) Destroy
function s.descost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x1999,1,REASON_COST) end
  Duel.RemoveCounter(tp,1,0,0x1999,1,REASON_COST)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,0))
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
  local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
    local cd=tc:GetCode()
    local g=Duel.GetMatchingGroup(Card.IsCode,tp,0,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA,nil,cd)
    if g:GetCount()>0 then
      Duel.SendtoGrave(g,REASON_EFFECT)
    end
  end
end
--(2) Banish
function s.bancost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
  e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.banfilter(c,tp)
  local type=bit.band(c:GetType(),0x7)
  return c:IsAbleToRemove() and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_GRAVE,0,1,nil,type)
end
function s.thfilter(c,type)
  return c:IsSetCard(0x999) and c:IsType(type) and c:IsAbleToHand() 
end
function s.bantg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingTarget(s.banfilter,tp,0,LOCATION_GRAVE,1,nil,tp) end
  Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,1))
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
  local g=Duel.SelectTarget(tp,s.banfilter,tp,0,LOCATION_GRAVE,1,1,nil,tp)
  Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function s.banop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT) then
    local type=bit.band(tc:GetType(),0x7)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_GRAVE,0,1,1,nil,type)
    if g:GetCount()>0 then
      Duel.SendtoHand(g,nil,REASON_EFFECT)
      Duel.ConfirmCards(1-tp,g)
    end
  end
end
