--SAO Kirito - GGO
--Scripted by Raivost
local s,id=GetID()
function s.initial_effect(c)
  --Xyz Summon
  aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x999),4,2)
  c:EnableReviveLimit()
  --(1) Destroy
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(id,0))
  e1:SetCategory(CATEGORY_DESTROY)
  e1:SetType(EFFECT_TYPE_QUICK_O)
  e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_CARD_TARGET)
  e1:SetCode(EVENT_CHAINING)
  e1:SetRange(LOCATION_MZONE)
  e1:SetCountLimit(1,id)
  e1:SetCost(s.descost)
  e1:SetCondition(s.descon)
  e1:SetTarget(s.destg)
  e1:SetOperation(s.desop)
  c:RegisterEffect(e1)
  --(2) Return to hand
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(id,1))
  e2:SetCategory(CATEGORY_TOHAND)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e2:SetCode(EVENT_BATTLE_START)
  e2:SetCountLimit(1)
  e2:SetCost(s.thcost)
  e2:SetCondition(s.tdcon)
  e2:SetTarget(s.tdtg)
  e2:SetOperation(s.tdop)
  c:RegisterEffect(e2,false,1)
end
s.listed_names={99990010}
--(1) Destroy
function s.descost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x1999,1,REASON_COST) end
  Duel.RemoveCounter(tp,1,0,0x1999,1,REASON_COST)
end
function s.desfilter(c,tp)
  return c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0x999) and c:IsType(TYPE_MONSTER) and c:IsControler(tp)
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
  if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
  if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
  local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
  return tg and tg:GetCount()==1 and tg:IsExists(s.desfilter,1,e:GetHandler(),tp)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,0))
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
  local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc and tc:IsRelateToEffect(e) then
    Duel.Destroy(tc,REASON_EFFECT)
  end
end
--(2) Return to hand
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
  e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.tdcon(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local d=Duel.GetAttackTarget()
  return c==Duel.GetAttacker() and d
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
  local d=Duel.GetAttackTarget()
  if chk==0 then return d:IsAbleToHand() end
  Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,1))
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,d,1,0,0)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
  local d=Duel.GetAttackTarget()
  if d:IsRelateToBattle() then
    Duel.SendtoHand(d,nil,REASON_EFFECT)
  end
end