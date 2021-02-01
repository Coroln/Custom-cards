--BRS Chains Of Agonizing Fate
--Scripted by Raivost
function c99960320.initial_effect(c)
  --(1) Excavate
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99960320,0))
  e1:SetCategory(CATEGORY_DECKDES+CATEGORY_DAMAGE+CATEGORY_ATKCHANGE)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,99960320+EFFECT_COUNT_CODE_OATH)
  e1:SetCost(c99960320.excacost)
  e1:SetCondition(c99960320.excacon)
  e1:SetTarget(c99960320.excatg)
  e1:SetOperation(c99960320.excaop)
  c:RegisterEffect(e1)
  --(2) Destroy
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99960320,1))
  e2:SetCategory(CATEGORY_DESTROY+CATEGORY_RECOVER)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e2:SetCode(EVENT_TO_GRAVE)
  e2:SetCondition(c99960320.descon)
  e2:SetTarget(c99960320.destg)
  e2:SetOperation(c99960320.desop)
  c:RegisterEffect(e2)
end
function c99960320.excacost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.CheckLPCost(tp,100) and Duel.IsPlayerCanDiscardDeck(1-tp,1) end
  local max=math.min(Duel.GetLP(tp),Duel.GetFieldGroupCount(tp,0,LOCATION_DECK))
  local ct=math.floor(math.min(max*100,1000)/100)
  local t={}
  for i=1,ct do
    t[i]=i*100
  end
  local cost=Duel.AnnounceNumber(tp,table.unpack(t))
  Duel.PayLPCost(tp,cost)
  e:SetLabel(cost/100)
end
function c99960320.excaconfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x996) and c:IsType(TYPE_XYZ)
end
function c99960320.excacon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.IsExistingMatchingCard(c99960320.excaconfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c99960320.excatg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsPlayerCanDiscardDeck(1-tp,1) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_DECKDES,0,0,1-tp,e:GetLabel())
end
function c99960320.tgtg(c,e,tp)
  return c:IsType(TYPE_MONSTER)
end
function c99960320.excaop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local ct=e:GetLabel()
  if not Duel.IsPlayerCanDiscardDeck(1-tp,ct) then return end
  Duel.ConfirmDecktop(1-tp,ct)
  local g1=Duel.GetDecktopGroup(1-tp,ct):Filter(c99960320.tgtg,nil,e,tp)
  if g1:GetCount()>0 then
    local dam=0
    for tc1 in aux.Next(g1) do
      if Duel.SendtoGrave(tc1,REASON_EFFECT)~=0 then
      dam=dam+1
      end
    end
    if dam>0 then
      local dam2=Duel.Damage(1-tp,dam*200,REASON_EFFECT)
    end
  end
end
--(2) Destroy 1
function c99960320.descon(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  return c:IsReason(REASON_COST) and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_MONSTER)
  and c:IsPreviousLocation(LOCATION_OVERLAY) and re:GetHandler():IsSetCard(0x996) 
end
function c99960320.desfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x996) and c:IsType(TYPE_XYZ)
end
function c99960320.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return true end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  Duel.SelectTarget(tp,c99960320.desfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c99960320.desop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
    --(2.1) Destroy 2
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_PHASE+PHASE_END)
    e1:SetReset(RESET_PHASE+PHASE_END)
    e1:SetCountLimit(1)
    e1:SetLabelObject(tc)
    e1:SetCondition(c99960320.descon2)
    e1:SetOperation(c99960320.desop2)
    Duel.RegisterEffect(e1,tp)
    tc:RegisterFlagEffect(99960320,RESET_EVENT+0x1fe0000,0,1)
  end
end
--(2.1) Destroy 2
function c99960320.descon2(e,tp,eg,ep,ev,re,r,rp)
  local tc=e:GetLabelObject()
  if tc:GetFlagEffect(99960320)==0 then
    e:Reset()
  return false
  end
  return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,tc)
end
function c99960320.desop2(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_CARD,0,99960320)
  local tc=e:GetLabelObject()
  local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,tc)
  local ct=Duel.Destroy(sg,REASON_EFFECT)
  if ct>0 then
    Duel.Recover(tp,ct*200,REASON_EFFECT)
  end
end