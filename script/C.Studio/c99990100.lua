--SAO Silica - SAO
--Scripted by Raivost
local s,id=GetID()
function s.initial_effect(c)
  --(1) Equip
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(id,0))
  e1:SetCategory(CATEGORY_EQUIP)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e1:SetProperty(EFFECT_FLAG_DELAY)
  e1:SetCode(EVENT_SUMMON_SUCCESS)
  e1:SetCountLimit(1,id)
  e1:SetTarget(s.eqtg)
  e1:SetOperation(s.eqop)
  c:RegisterEffect(e1)
  aux.AddEREquipLimit(c,nil,s.eqval,s.equipop,e1)
  local e2=e1:Clone()
  e2:SetCode(EVENT_SPSUMMON_SUCCESS)
  c:RegisterEffect(e2)
  aux.AddEREquipLimit(c,nil,s.eqval,s.equipop,e2)
  --(2) Return to hand
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(id,1))
  e3:SetCategory(CATEGORY_TOHAND)
  e3:SetType(EFFECT_TYPE_IGNITION)
  e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCountLimit(1)
  e3:SetCost(s.rthcost)
  e3:SetTarget(s.rthtg)
  e3:SetOperation(s.rthop)
  c:RegisterEffect(e3)
end
--(1) Equip
function s.eqval(ec,c,tp)
  return ec:IsControler(tp) and c:IsCode(99990110)
end
function s.eqfilter(c)
  return c:IsCode(99990110) and not c:IsForbidden()
end
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
  and Duel.IsExistingMatchingCard(s.eqfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e:GetHandler()) end
  Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,0))
  Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function s.equipop(c,e,tp,tc)
  aux.EquipByEffectAndLimitRegister(c,e,tp,tc,nil,true)
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or c:IsFacedown() or not c:IsRelateToEffect(e) then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
  local g=Duel.SelectMatchingCard(tp,s.eqfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,c)
  local tc=g:GetFirst()
  if c:IsFaceup() and c:IsRelateToEffect(e) then
    s.equipop(c,e,tp,tc)
  else 
  	Duel.SendtoGrave(tc,REASON_EFFECT) 
  end
end
--(2) Return to hand
function s.rthcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x1999,1,REASON_COST) end
  Duel.RemoveCounter(tp,1,0,0x1999,1,REASON_COST)
end
function s.thfilter(c)
  return c:IsFacedown() and c:IsAbleToHand()
end
function s.rthtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingTarget(s.thfilter,tp,0,LOCATION_ONFIELD,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,1))
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
  local g=Duel.SelectTarget(tp,s.thfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
  Duel.SetChainLimit(s.limit(g:GetFirst()))
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function s.limit(c)
  return function (e,lp,tp)
  return e:GetHandler()~=c
  end
end
function s.rthop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) then
    Duel.SendtoHand(tc,nil,REASON_EFFECT)
  end
end