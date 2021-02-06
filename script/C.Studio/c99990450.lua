--SAO Pitohui - GGO
--Scripted by Raivost
local s,id=GetID()
function s.initial_effect(c)
  --Xyz Summon
   Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x999),4,2)
  c:EnableReviveLimit()
  --(1) Banish
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(id,0))
  e1:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND+CATEGORY_SEARCH)
  e1:SetType(EFFECT_TYPE_QUICK_O)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetRange(LOCATION_MZONE)
  e1:SetCountLimit(1,id)
  e1:SetHintTiming(0,0x1e0)
  e1:SetCost(s.bancost)
  e1:SetTarget(s.bantg)
  e1:SetOperation(s.banop)
  c:RegisterEffect(e1,false,1)
  --(2) Add to hand
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(id,1))
  e2:SetCategory(CATEGORY_TOHAND+CATEGORY_EQUIP)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCountLimit(1,id+1)
  e2:SetCost(s.thcost)
  e2:SetTarget(s.thtg)
  e2:SetOperation(s.thop)
  c:RegisterEffect(e2)
end
--(1) Destroy
function s.bancost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
  e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.banfilter(c,tp)
  return c:IsSetCard(0x999) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemove()
  and Duel.IsExistingMatchingCard(s.thfilter1,tp,LOCATION_DECK,0,1,c,c:GetCode())
end
function s.thfilter1(c,code)
  return c:IsCode(code) and c:IsAbleToHand()
end
function s.bantg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingTarget(s.banfilter,tp,LOCATION_GRAVE,0,1,nil,tp) end
  Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,0))
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
  local g=Duel.SelectTarget(tp,s.banfilter,tp,LOCATION_GRAVE,0,1,1,nil,tp)
  Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.banop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local sg=Duel.SelectMatchingCard(tp,s.thfilter1,tp,LOCATION_DECK,0,1,1,nil,tc:GetCode())
    if sg:GetCount()>0 then
      Duel.SendtoHand(sg,nil,REASON_EFFECT)
      Duel.ConfirmCards(1-tp,sg)
    end
  end
end
--(2) Add to hand
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x1999,2,REASON_COST) end
  Duel.RemoveCounter(tp,1,0,0x1999,2,REASON_COST)
end
function s.thfilter2(c)
  return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x999) and c:GetOverlayCount()>0
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingTarget(s.thfilter2,tp,LOCATION_MZONE,0,1,e:GetHandler()) 
  and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
  Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,0))
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  Duel.SelectTarget(tp,s.thfilter2,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local tc=Duel.GetFirstTarget()
  if tc:GetOverlayCount()==0 then return end
  if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
  local ct=tc:GetOverlayGroup()
    if tc:IsRelateToEffect(e) and tc:IsFaceup() and #ct>0 and Duel.SendtoHand(ct,nil,REASON_EFFECT)~=0 then
      if tc and c:IsFaceup() and c:IsRelateToEffect(e) then
      if not Duel.Equip(tp,tc,c,true) then return end
      local e1=Effect.CreateEffect(c)
      e1:SetType(EFFECT_TYPE_SINGLE)
      e1:SetCode(EFFECT_EQUIP_LIMIT)
      e1:SetReset(RESET_EVENT+0x1fe0000)
      e1:SetValue(s.eqlimit)
      e1:SetLabelObject(c)
      tc:RegisterEffect(e1)
      local atk=tc:GetTextAttack()/2
      if atk>0 then
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_EQUIP)
        e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_OWNER_RELATE)
        e2:SetCode(EFFECT_UPDATE_ATTACK)
        e2:SetReset(RESET_EVENT+0x1fe0000)
        e2:SetValue(atk)
        tc:RegisterEffect(e2)
      end
    end
  end
end
function s.eqlimit(e,c)
  return e:GetLabelObject()==c
end
