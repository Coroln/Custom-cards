--MSMM Sinful Wishes
--Scripted by Raivost
function c99950260.initial_effect(c)
  --(1) Draw
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99950260,0))
  e1:SetCategory(CATEGORY_DRAW)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,99950260+EFFECT_COUNT_CODE_OATH)
  e1:SetCost(c99950260.drcost)
  e1:SetTarget(c99950260.drtg)
  e1:SetOperation(c99950260.drop)
  c:RegisterEffect(e1)
end
--(1) Draw
function c99950260.drcostfilter(c,tp)
  return c:IsSetCard(0x995) and c:IsType(TYPE_RITUAL) and c:IsAbleToRemoveAsCost()
end
function c99950260.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99950260.drcostfilter,tp,LOCATION_GRAVE,0,1,nil,tp) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
  local g=Duel.SelectMatchingCard(tp,c99950260.drcostfilter,tp,LOCATION_GRAVE,0,1,1,nil,tp)
  Duel.Remove(g,POS_FACEUP,REASON_COST)
  local tg=g:GetFirst()
  --(1.1) Shuffle
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e1:SetRange(LOCATION_REMOVED)
  e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
  e1:SetCountLimit(1)
  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
  e1:SetCondition(c99950260.tdcon)
  e1:SetOperation(c99950260.tdop)
  e1:SetLabel(0)
  tg:RegisterEffect(e1)
end
function c99950260.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
  Duel.SetTargetPlayer(tp)
  Duel.SetTargetParam(2)
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c99950260.drop(e,tp,eg,ep,ev,re,r,rp)
  local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
  Duel.Draw(p,d,REASON_EFFECT)
end
--(1.1) Shuffle
function c99950260.tdcon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetTurnPlayer()==tp
end
function c99950260.tdop(e,tp,eg,ep,ev,re,r,rp)
  local ct=e:GetLabel()
  e:GetHandler():SetTurnCounter(ct+1)
  if ct==1 then
    Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
  else e:SetLabel(1) end
end
