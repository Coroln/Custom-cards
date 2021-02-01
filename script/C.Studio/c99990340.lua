--SAO Swordland
--Scripted by Raivost
local s,id=GetID()
function s.initial_effect(c)
  --(1) Activate + Place counter
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetTarget(s.pcttg)
  c:RegisterEffect(e1)
  --(2) Search
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(id,3))
  e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetRange(LOCATION_SZONE)
  e2:SetCountLimit(1,id)
  e2:SetCost(s.thcost)
  e2:SetTarget(s.thtg)
  e2:SetOperation(s.thop)
  c:RegisterEffect(e2)
  --(3) Draw
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(id,4))
  e3:SetCategory(CATEGORY_DRAW)
  e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e3:SetCode(EVENT_BATTLE_DESTROYING)
  e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e3:SetRange(LOCATION_SZONE)
  e3:SetCountLimit(1)
  e3:SetCondition(s.drcon)
  e3:SetTarget(s.drtg)
  e3:SetOperation(s.drop)
  c:RegisterEffect(e3)
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
--(2) Search
function s.thcostfilter(c)
  return c:IsSetCard(0x999) and c:IsType(TYPE_MONSTER) and c:IsDiscardable()
end
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
  local b1=Duel.IsCanRemoveCounter(tp,1,0,0x1999,2,REASON_COST)
  local b2=Duel.IsExistingMatchingCard(s.thcostfilter,tp,LOCATION_HAND,0,1,nil)
  if chk==0 then return b1 or b2 end
  if b1 and ((not b2) or Duel.SelectYesNo(tp,aux.Stringid(id,2))) then
    Duel.RemoveCounter(tp,1,0,0x1999,2,REASON_COST)
  else
    Duel.DiscardHand(tp,s.thcostfilter,1,1,REASON_COST,nil)
  end
end
function s.thfilter(c)
  return c:IsSetCard(0x999) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,3))
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
  if g:GetCount()>0 then
    Duel.SendtoHand(g,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,g)
  end
end
--(3) Draw
function s.drcon(e,tp,eg,ep,ev,re,r,rp)
  local ec=eg:GetFirst()
  local bc=ec:GetBattleTarget()
  return ec:IsControler(tp) and ec:IsSetCard(0x999) and bc 
  and bc:IsType(TYPE_MONSTER) and ec:IsStatus(STATUS_OPPO_BATTLE)
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
  Duel.SetTargetPlayer(tp)
  Duel.SetTargetParam(1)
  Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,4))
  Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
  Duel.Draw(p,d,REASON_EFFECT)
end