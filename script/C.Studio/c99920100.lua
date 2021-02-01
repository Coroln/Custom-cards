--Overlord Approaching Death's Premonition
--Scripted by Raivost
function c99920100.initial_effect(c)
  --(1) Send to GY
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99920100,0))
  e1:SetCategory(CATEGORY_DRAW)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,99920100+EFFECT_COUNT_CODE_OATH)
  e1:SetCost(c99920100.thcost)
  e1:SetTarget(c99920100.tgtg)
  e1:SetOperation(c99920100.tgop)
  c:RegisterEffect(e1)
end
--(1) Send to GY
function c99920100.tgfilter(c)
  return c:IsType(TYPE_MONSTER) and c:IsLevelAbove(5) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsAbleToGraveAsCost()
end
function c99920100.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
  if chk==0 then return Duel.IsExistingMatchingCard(c99920100.tgfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
  local g=Duel.SelectMatchingCard(tp,c99920100.tgfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
  Duel.SendtoGrave(g,REASON_COST)
end
function c99920100.drfilter(c)
  return c:IsSetCard(0x992) and c:IsType(TYPE_MONSTER) 
end
function c99920100.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
  local ct=Duel.GetMatchingGroupCount(c99920100.drfilter,tp,LOCATION_GRAVE,0,nil)
  if chk==0 then return Duel.IsPlayerCanDraw(tp,ct+1) end
  Duel.SetTargetPlayer(tp)
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct+1)
end
function c99920100.tgop(e,tp,eg,ep,ev,re,r,rp)
  local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
  local ct=Duel.GetMatchingGroupCount(c99920100.drfilter,tp,LOCATION_GRAVE,0,nil)
  Duel.Draw(p,ct+1,REASON_EFFECT)
  if not e:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetCode(EFFECT_CANNOT_TO_HAND)
  e1:SetTargetRange(LOCATION_DECK,0)
  e1:SetReset(RESET_PHASE+PHASE_END)
  Duel.RegisterEffect(e1,tp)
  local e2=Effect.CreateEffect(e:GetHandler())
  e2:SetType(EFFECT_TYPE_FIELD)
  e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e2:SetCode(EFFECT_CANNOT_DRAW)
  e2:SetReset(RESET_PHASE+PHASE_END)
  e2:SetTargetRange(1,0)
  Duel.RegisterEffect(e2,tp)
end