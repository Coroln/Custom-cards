--NGNL Stephanie Dola
--Scripted by Raivost
function c99940030.initial_effect(c)
  Pendulum.AddProcedure(c)
  --Pendulum Effects
  --(1) Scale Change
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_DICE)
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
  e1:SetRange(LOCATION_PZONE)
  e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
  e1:SetCountLimit(1)
  e1:SetCondition(c99940030.sccon)
  e1:SetTarget(c99940030.sctg)
  e1:SetOperation(c99940030.scop)
  c:RegisterEffect(e1)
  --(2) Shuffle
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99940030,2))
  e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetRange(LOCATION_PZONE)
  e2:SetCountLimit(1,99940030)
  e2:SetTarget(c99940030.tdtg)
  e2:SetOperation(c99940030.tdop)
  c:RegisterEffect(e2)
  --(3) Send to GY
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99940030,3))
  e3:SetCategory(CATEGORY_DECKDES)
  e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
  e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e3:SetCode(EVENT_DRAW)
  e3:SetRange(LOCATION_PZONE)
  e3:SetCondition(c99940030.tgcon)
  e3:SetTarget(c99940030.tgtg)
  e3:SetOperation(c99940030.tgop)
  c:RegisterEffect(e3)
  --Monster Effects
  --(1) Special Summon from hand
  local e4=Effect.CreateEffect(c)
  e4:SetType(EFFECT_TYPE_FIELD)
  e4:SetCode(EFFECT_SPSUMMON_PROC)
  e4:SetProperty(EFFECT_FLAG_UNCOPYABLE)
  e4:SetRange(LOCATION_HAND)
  e4:SetCondition(c99940030.hspcon)
  c:RegisterEffect(e4)
  --(2) Negate effect
  local e5=Effect.CreateEffect(c)
  e5:SetDescription(aux.Stringid(99940030,4))
  e5:SetCategory(CATEGORY_NEGATE)
  e5:SetType(EFFECT_TYPE_QUICK_O)
  e5:SetCode(EVENT_CHAINING)
  e5:SetCountLimit(1,99940031)
  e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
  e5:SetRange(LOCATION_MZONE)
  e5:SetCondition(c99940030.negcon)
  e5:SetCost(c99940030.negcost)
  e5:SetTarget(c99940030.negtg)
  e5:SetOperation(c99940030.negop)
  c:RegisterEffect(e5)
  --(3) Avoid battle damage
  local e6=Effect.CreateEffect(c)
  e6:SetType(EFFECT_TYPE_SINGLE)
  e6:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
  e6:SetValue(1)
  c:RegisterEffect(e6)
end
--Pendulum Effects
--(1) Scale Change
function c99940030.sccon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetTurnPlayer()==tp
end
function c99940030.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  op=Duel.SelectOption(tp,aux.Stringid(99940030,0),aux.Stringid(99940030,1))
  e:SetLabel(op)
  if op==0 then
    Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
  else
    Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,2)
  end
end
function c99940030.scop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if not c:IsRelateToEffect(e) then return end
  if e:GetLabel()==0 then
    local dc=Duel.TossDice(tp,1)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_CHANGE_LSCALE)
    e1:SetValue(dc)
    e1:SetReset(RESET_EVENT+0x1ff0000)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_CHANGE_RSCALE)
    c:RegisterEffect(e2)
  else
    local d1,d2=Duel.TossDice(tp,2)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_CHANGE_LSCALE)
    e1:SetValue(d1+d2)
    e1:SetReset(RESET_EVENT+0x1ff0000)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_CHANGE_RSCALE)
    c:RegisterEffect(e2)
  end
end
--(2) Shuffle
function c99940030.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():IsAbleToDeck() and Duel.IsPlayerCanDraw(tp,2) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
  Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c99940030.tdop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if not c:IsRelateToEffect(e) then return end
  if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,2,REASON_EFFECT)~=0 then
    Duel.ShuffleDeck(tp)
    if Duel.Draw(tp,2,REASON_EFFECT)==2 then
      Duel.ShuffleHand(tp)
      Duel.BreakEffect()
      Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
      local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
      if g:GetCount()>0 then
        Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
      end
    end
  end
end
--(3) Send to GY
function c99940030.tgcon(e,tp,eg,ep,ev,re,r,rp)
  return ep~=tp and Duel.GetCurrentPhase()~=PHASE_DRAW
end
function c99940030.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.SetTargetPlayer(1-tp)
  Duel.SetTargetParam(1)
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,1-tp,1)
end
function c99940030.tgop(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
  Duel.DiscardDeck(p,d,REASON_EFFECT)
end
--Monster Effects
--(1) Special Summon from hand
function c99940030.hspconfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x994) and c:GetCode()~=99940030
end
function c99940030.hspcon(e,c)
  if c==nil then return true end
  return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
    Duel.IsExistingMatchingCard(c99940030.hspconfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
--(2) Negate effect
function c99940030.negcon(e,tp,eg,ep,ev,re,r,rp)
  return rp~=tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c99940030.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
  Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c99940030.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c99940030.negop(e,tp,eg,ep,ev,re,r,rp)
  Duel.NegateActivation(ev)
end
