--BRS Inner Flame Heat
--Scripted by Raivost
function c99960370.initial_effect(c)
  --(1) Activate
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_DRAW)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,99960370+EFFECT_COUNT_CODE_OATH)
  e1:SetHintTiming(TIMING_END_PHASE)
  e1:SetOperation(c99960370.activate)
  c:RegisterEffect(e1)
  --(2) Draw
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99960370,0))
  e2:SetCategory(CATEGORY_DRAW)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e2:SetCode(EVENT_TO_GRAVE)
  e2:SetCondition(c99960370.drcon)
  e2:SetCost(c99960370.drcost)
  e2:SetTarget(c99960370.drtg)
  e2:SetOperation(c99960370.drop)
  c:RegisterEffect(e2)
  if c99960370.counter==nil then
    c99960370.counter=true
    c99960370[0]=0
    c99960370[1]=0
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
    e2:SetOperation(c99960370.resetcount)
    Duel.RegisterEffect(e2,0)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e3:SetCode(EVENT_PAY_LPCOST)
    e3:SetOperation(c99960370.addcount)
    Duel.RegisterEffect(e3,0)
  end
end
function c99960370.resetcount(e,tp,eg,ep,ev,re,r,rp)
  c99960370[0]=0
  c99960370[1]=0
end
function c99960370.addcount(e,tp,eg,ep,ev,re,r,rp)
  local p=Duel.GetTurnPlayer()
  if ep==p and re and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and re:GetHandler():IsSetCard(0x996) then
    local val=math.ceil(ev/2)
    c99960370[p]=c99960370[p]+val
  end
end
--(1) Activate
function c99960370.activate(e,tp,eg,ep,ev,re,r,rp)
  --(1.1) Inflict damage
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e1:SetCode(EVENT_PHASE+PHASE_END)
  e1:SetReset(RESET_PHASE+PHASE_END)
  e1:SetCountLimit(1)
  e1:SetOperation(c99960370.recop)
  Duel.RegisterEffect(e1,tp)
end
--(1.1) Inflict damage
function c99960370.recop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_CARD,0,99960370)
  Duel.Damage(1-tp,c99960370[tp],REASON_EFFECT)
end
--(2) Draw
function c99960370.drcon(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  return c:IsReason(REASON_COST) and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_MONSTER)
  and c:IsPreviousLocation(LOCATION_OVERLAY) and re:GetHandler():IsSetCard(0x996) 
end
function c99960370.drcostfilter(c)
  return c:IsSetCard(0x996) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeckOrExtraAsCost()
end
function c99960370.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99960370.drcostfilter,tp,LOCATION_MZONE,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
  local g=Duel.SelectMatchingCard(tp,c99960370.drcostfilter,tp,LOCATION_MZONE,0,1,1,nil)
  Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c99960370.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
  Duel.SetTargetPlayer(tp)
  Duel.SetTargetParam(1)
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c99960370.drop(e,tp,eg,ep,ev,re,r,rp,chk)
  local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
  Duel.Draw(p,d,REASON_EFFECT)
end