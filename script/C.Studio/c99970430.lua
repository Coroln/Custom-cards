--DAL Pendragon - Ellen
--Scripted by Raivost
function c99970430.initial_effect(c)
  --Xyz summon
  aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x997),3,3)
  c:EnableReviveLimit()
  --(1) Unaffected
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99970430,0))
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetType(EFFECT_TYPE_QUICK_O)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetRange(LOCATION_MZONE)
  e1:SetCountLimit(1)
  e1:SetCost(c99970430.unfcost)
  e1:SetTarget(c99970430.unftg)
  e1:SetOperation(c99970430.unfop)
  c:RegisterEffect(e1)
  --(2) Gain ATK
  local e3=Effect.CreateEffect(c)
  e3:SetCategory(CATEGORY_ATKCHANGE)
  e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e3:SetCode(EVENT_CHAIN_SOLVED)
  e3:SetRange(LOCATION_MZONE)
  e3:SetOperation(c99970430.atkop)
  c:RegisterEffect(e3)
end
--(1) Unaffected
function c99970430.unfcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
  e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c99970430.unffilter(c)
  return c:IsFaceup() and c:IsSetCard(0x997)
end
function c99970430.unftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingTarget(c99970430.unffilter,tp,LOCATION_MZONE,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  Duel.SelectTarget(tp,c99970430.unffilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c99970430.unfop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and tc:IsFaceup() then
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_IMMUNE_EFFECT)
    e1:SetValue(c99970430.unfilter)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
    tc:RegisterEffect(e1)
  end
end
function c99970430.unfilter(e,re)
  return e:GetHandler()~=re:GetOwner()
end
--(2) Gain ATK
function c99970430.atkop(e,tp,eg,ep,ev,re,r,rp)
  if re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0xA97) then
    Duel.Hint(HINT_CARD,0,99970430)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(300)
    e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
    e:GetHandler():RegisterEffect(e1)
  end
end