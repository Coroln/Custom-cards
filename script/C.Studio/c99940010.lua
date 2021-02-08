--NGNL Sora
--Scripted by Raivost
function c99940010.initial_effect(c)
  Pendulum.AddProcedure(c)
  --Pendulum Effects
  --(1) Scale change
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_DICE)
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
  e1:SetRange(LOCATION_PZONE)
  e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
  e1:SetCountLimit(1)
  e1:SetCondition(c99940010.sccon)
  e1:SetTarget(c99940010.sctg)
  e1:SetOperation(c99940010.scop)
  c:RegisterEffect(e1)
  --(2) To hand
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99940010,2))
  e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetRange(LOCATION_PZONE)
  e2:SetCountLimit(1)
  e2:SetTarget(c99940010.thtg)
  e2:SetOperation(c99940010.thop)
  c:RegisterEffect(e2)
  --(3) Draw
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99940010,3))
  e3:SetCategory(CATEGORY_DRAW)
  e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e3:SetCode(EVENT_DRAW)
  e3:SetRange(LOCATION_PZONE)
  e3:SetCondition(c99940010.drcon)
  e3:SetTarget(c99940010.drtg)
  e3:SetOperation(c99940010.drop)
  c:RegisterEffect(e3)
  --Monster Effects
  --(1) Disable Summon
  local e4=Effect.CreateEffect(c)
  e4:SetDescription(aux.Stringid(99940010,4))
  e4:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
  e4:SetType(EFFECT_TYPE_QUICK_O)
  e4:SetCode(EVENT_SPSUMMON)
  e4:SetRange(LOCATION_MZONE)
  e4:SetCondition(c99940010.dscon)
  e4:SetTarget(c99940010.dstg)
  e4:SetOperation(c99940010.dsop)
  c:RegisterEffect(e4)
  --(2) Discard
  local e5=Effect.CreateEffect(c)
  e5:SetDescription(aux.Stringid(99940010,5))
  e5:SetCategory(CATEGORY_HANDES+CATEGORY_DRAW)
  e5:SetType(EFFECT_TYPE_IGNITION)
  e5:SetCountLimit(1,99940010)
  e5:SetRange(LOCATION_MZONE)
  e5:SetTarget(c99940010.distg)
  e5:SetOperation(c99940010.disop)
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
function c99940010.sccon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetTurnPlayer()==tp
end
function c99940010.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  op=Duel.SelectOption(tp,aux.Stringid(99940010,0),aux.Stringid(99940010,1))
  e:SetLabel(op)
  if op==0 then
    Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
  else
    Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,2)
  end
end
function c99940010.scop(e,tp,eg,ep,ev,re,r,rp)
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
--(2) To hand
function c99940010.thfilter(c)
  return c:IsSetCard(0x994) and c:IsAbleToHand() and not c:IsCode(99940010)
end
function c99940010.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99940010.thfilter,tp,LOCATION_DECK,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99940010.thop(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,c99940010.thfilter,tp,LOCATION_DECK,0,1,1,nil)
  if g:GetCount()>0 then
    Duel.SendtoHand(g,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,g)
  end
end
--(3) Draw
function c99940010.drcon(e,tp,eg,ep,ev,re,r,rp)
  return ep~=tp and Duel.GetCurrentPhase()~=PHASE_DRAW
end
function c99940010.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
  Duel.SetTargetPlayer(tp)
  Duel.SetTargetParam(1)
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c99940010.drop(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
  Duel.Draw(p,d,REASON_EFFECT)
end
--Monster Effects
--(1) Disable Summon
function c99940010.dscon(e,tp,eg,ep,ev,re,r,rp)
  return tp~=ep and eg:GetCount()==1 and Duel.GetCurrentChain()==0
end
function c99940010.dstg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
  Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,eg,eg:GetCount(),0,0)
end
function c99940010.dsfilter(c)
  return c:IsFaceup() and c:IsAbleToHand()
end
function c99940010.dsop(e,tp,eg,ep,ev,re,r,rp)
  local coin=Duel.SelectOption(tp,aux.Stringid(99940010,6),aux.Stringid(99940010,7))
  local res=Duel.TossCoin(tp,1)
  if coin~=res then
    Duel.NegateSummon(eg)
    Duel.SendtoHand(eg,nil,REASON_EFFECT)
  else
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
    local g=Duel.SelectTarget(tp,c99940010.dsfilter,tp,LOCATION_MZONE,0,1,1,nil)
    local tc=g:GetFirst()
    if tc:IsRelateToEffect(e) then
      Duel.SendtoHand(tc,nil,REASON_EFFECT)
      Duel.ConfirmCards(1-tp,tc)
    end
  end
end
--(2) Discard
function c99940010.disfilter(c)
  return c:IsDiscardable(REASON_EFFECT)
end
function c99940010.distg(e,tp,eg,ep,ev,re,r,rp,chk)
  local tp=e:GetHandlerPlayer()
  local tc1=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
  local tc2=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
  if tc1 and tc1:IsSetCard(0x994) and tc2 and tc2:IsSetCard(0x994) then
    e:SetLabel(2)
  else 
    e:SetLabel(1)
  end
  if chk==0 then return Duel.IsPlayerCanDraw(tp,e:GetLabel())
  and Duel.IsExistingMatchingCard(c99940010.disfilter,tp,LOCATION_HAND,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
  Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,e:GetLabel())
end
function c99940010.disop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.DiscardHand(tp,c99940010.disfilter,1,1,REASON_EFFECT+REASON_DISCARD,nil)~=0 then
    Duel.Draw(tp,e:GetLabel(),REASON_EFFECT)
  end
end
