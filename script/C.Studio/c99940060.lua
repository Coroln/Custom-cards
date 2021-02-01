--NGNL Elkia Kingdom
--Scripted by Raivost
function c99940060.initial_effect(c)
  --Activate
  local e0=Effect.CreateEffect(c)
  e0:SetType(EFFECT_TYPE_ACTIVATE)  
  e0:SetCode(EVENT_FREE_CHAIN)
  c:RegisterEffect(e0)
  --(1) Cannot be targeted/destroyed
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
  e1:SetRange(LOCATION_FZONE)
  e1:SetCondition(c99940060.condition)
  e1:SetValue(1)
  c:RegisterEffect(e1)
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE)
  e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e2:SetRange(LOCATION_FZONE)
  e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
  e2:SetCondition(c99940060.condition)
  e2:SetValue(1)
  c:RegisterEffect(e2)
  --(2) Avoid damage
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_FIELD)
  e3:SetCode(EFFECT_CHANGE_DAMAGE)
  e3:SetRange(LOCATION_FZONE)
  e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_AVAILABLE_BD)
  e3:SetTargetRange(1,0)
  e3:SetLabel(0)
  e3:SetCondition(c99940060.condition)
  e3:SetValue(c99940060.damval)
  c:RegisterEffect(e3)
  --(3) Draw 1
  local e4=Effect.CreateEffect(c)
  e4:SetDescription(aux.Stringid(99940060,0))
  e4:SetCategory(CATEGORY_DRAW)
  e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
  e4:SetRange(LOCATION_FZONE)
  e4:SetCode(EVENT_SPSUMMON_SUCCESS)
  e4:SetCondition(c99940060.drcon1)
  e4:SetOperation(c99940060.drop1)
  c:RegisterEffect(e4)
  --(4) Return to hand
  local e5=Effect.CreateEffect(c)
  e5:SetDescription(aux.Stringid(99940060,1))
  e5:SetCategory(CATEGORY_TOHAND)
  e5:SetType(EFFECT_TYPE_IGNITION)
  e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e5:SetRange(LOCATION_FZONE)
  e5:SetCountLimit(1)
  e5:SetTarget(c99940060.rthtg)
  e5:SetOperation(c99940060.rthop)
  c:RegisterEffect(e5)
  --(5) Send to GY
  local e6=Effect.CreateEffect(c)
  e6:SetDescription(aux.Stringid(99940060,2))
  e6:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DESTROY)
  e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e6:SetCode(EVENT_TOSS_COIN)
  e6:SetProperty(EFFECT_FLAG_DELAY)
  e6:SetRange(LOCATION_FZONE)
  e6:SetCode(EVENT_TOSS_COIN)
  e6:SetCondition(c99940060.tgcon)
  e6:SetTarget(c99940060.tgtg)
  e6:SetOperation(c99940060.tgop)
  c:RegisterEffect(e6)
  local e7=e6:Clone()
  e7:SetCode(EVENT_TOSS_DICE)
  c:RegisterEffect(e7)
  --(6) Draw 2
  local e8=Effect.CreateEffect(c)
  e8:SetDescription(aux.Stringid(99940060,0))
  e8:SetCategory(CATEGORY_DRAW)
  e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
  e8:SetCode(EVENT_PHASE+PHASE_END)
  e8:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e8:SetRange(LOCATION_FZONE)
  e8:SetCountLimit(1)
  e8:SetTarget(c99940060.drtg2)
  e8:SetOperation(c99940060.drop2)
  c:RegisterEffect(e8)
  if not c99940060.global_check then
    c99940060.global_check=true
    c99940060[0]=0
    c99940060[1]=0
    local e9=Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e9:SetCode(EVENT_CUSTOM+99940060)
    e9:SetOperation(c99940060.addcount)
    Duel.RegisterEffect(e9,0)
    local ge10=Effect.CreateEffect(c)
    ge10:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    ge10:SetCode(EVENT_PHASE_START+PHASE_DRAW)
    ge10:SetOperation(c99940060.clearop)
    Duel.RegisterEffect(ge10,0)
  end
end
--(1) Cannot be targeted/destroyed
function c99940060.confilter(c)
  return c:IsFaceup() and c:IsSetCard(0x994)
end
function c99940060.condition(e)
  return Duel.IsExistingMatchingCard(c99940060.confilter,e:GetHandlerPlayer(),LOCATION_PZONE,0,2,nil)
end
--(2) Avoid damage
function c99940060.damval(e,re,val,r,rp,rc)
  local tp=e:GetHandlerPlayer()
  if val~=0 then
    e:SetLabel(val)
    return 0
  else return val end
end
--(3) Draw 1
function c99940060.drfilter1(c,tp)
  return c:IsFaceup() and c:IsControler(tp) and c:IsSetCard(0x994) and c:GetSummonPlayer()==tp
end
function c99940060.drcon1(e,tp,eg,ep,ev,re,r,rp)
  return eg:IsExists(c99940060.drfilter1,1,nil,tp)
end
function c99940060.drop1(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_CARD,0,99940060)
  local d1=Duel.Draw(tp,1,REASON_EFFECT)
  local d2=Duel.Draw(1-tp,1,REASON_EFFECT)
end
--(4) Return to hand
function c99940060.rthfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x994) and c:IsAbleToHand()
end
function c99940060.penfilter(c)
  return (c:IsLocation(LOCATION_HAND) or (c:IsFaceup() and c:IsType(TYPE_PENDULUM))) and c:IsSetCard(0x994) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c99940060.rthtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingTarget(c99940060.rthfilter,tp,LOCATION_PZONE,0,1,nil) 
  and Duel.IsExistingMatchingCard(c99940060.penfilter,tp,LOCATION_EXTRA+LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
  local g=Duel.SelectTarget(tp,c99940060.rthfilter,tp,LOCATION_PZONE,0,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c99940060.rthop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if not c:IsRelateToEffect(e) then return end
  local tc1=Duel.GetFirstTarget()
  if tc1:IsRelateToEffect(e) and tc1:IsControler(tp) and Duel.SendtoHand(tc1,nil,REASON_EFFECT)>0 and tc1:IsLocation(LOCATION_HAND) then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    local g=Duel.SelectMatchingCard(tp,c99940060.penfilter,tp,LOCATION_EXTRA+LOCATION_HAND+LOCATION_MZONE,0,1,1,tc1)
    local tc2=g:GetFirst()
    if tc2 then
      Duel.MoveToField(tc2,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
    end
  end
end
--(5) Send to GY
function c99940060.tgcon(e,tp,eg,ep,ev,re,r,rp)
  return rp==tp
end
function c99940060.tgfilter(c)
  return c:IsSetCard(0x994) and c:IsAbleToGrave()
end
function c99940060.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil)
  and Duel.IsExistingMatchingCard(c99940060.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) end
  local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c99940060.tgop(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
  local g1=Duel.SelectMatchingCard(tp,c99940060.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,tp)
  local tc=g1:GetFirst()
  if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE) then
    local g2=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
    if g2:GetCount()>0 then
      Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
      local sg=g2:Select(tp,1,1,nil)
      Duel.HintSelection(sg)
      Duel.Destroy(sg,REASON_EFFECT)
    end
  end
end
--(6) Draw 2
function c99940060.addcount(e,tp,eg,ep,ev,re,r,rp)
  local tc=eg:GetFirst()
  while tc do
      local p=tc:GetReasonPlayer()
    c99940060[p]=c99940060[p]+1
    tc=eg:GetNext()
  end
end
function c99940060.clearop(e,tp,eg,ep,ev,re,r,rp)
  c99940060[0]=0
  c99940060[1]=0
end
function c99940060.drtg2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  local dr=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)
  if dr<c99940060[tp] then
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,dr)
  else
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,c99940060[tp])
  end
end
function c99940060.drop2(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  local dr=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)
  if dr<c99940060[tp] then
    Duel.Draw(1-tp,dr,REASON_EFFECT)
  else
    Duel.Draw(1-tp,c99940060[tp],REASON_EFFECT)
  end
end