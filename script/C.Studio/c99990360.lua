--SAO Edge of The World
--Scripted by Raivost
local s,id=GetID()
function s.initial_effect(c)
  --(1) Activate + Place counter
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetTarget(s.pcttg)
  c:RegisterEffect(e1)
  --(2) Excavate
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(id,4))
  e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetRange(LOCATION_SZONE)
  e2:SetCountLimit(1,id)
  e2:SetCost(s.excacost)
  e2:SetTarget(s.excatg)
  e2:SetOperation(s.excaop)
  c:RegisterEffect(e2)
 end
 --(1) Activate + Place counter
function s.pcttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return true end
  local tc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
  if tc and tc:IsFaceup() and tc:IsSetCard(0x999) 
  and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
    Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,1))
    e:SetCategory(CATEGORY_COUNTER)
    e:SetOperation(s.pctop)
  else
    e:SetCategory(0)
    e:SetProperty(0)
    e:SetOperation(nil)
  end
end
function s.pctop(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  local tc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
  if tc and tc:IsFaceup() and tc:IsSetCard(0x999) then
    tc:AddCounter(0x1999,1)
  end
end
--(2) Excavate
function s.excacost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x1999,1,REASON_COST) end
  Duel.RemoveCounter(tp,1,0,0x1999,1,REASON_COST)
end
function s.excatg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>2 end
  Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,2))
end
function s.excafilter(c)
  return c:IsSetCard(0x999) and c:IsAbleToHand()
end
function s.excaop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<3 then return end
  Duel.ConfirmDecktop(tp,3)
  local g=Duel.GetDecktopGroup(tp,3)
  if g:IsExists(s.excafilter,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
    Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,4))
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local sg=g:FilterSelect(tp,s.excafilter,1,1,nil)
    Duel.SendtoHand(sg,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,sg)
    Duel.ShuffleHand(tp)
  end
  Duel.ShuffleDeck(tp)
end