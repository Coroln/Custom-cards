--YuYuYu Jukai
--Scripted by Raivost
function c99910070.initial_effect(c)
  --Activate
  local e0=Effect.CreateEffect(c)
  e0:SetType(EFFECT_TYPE_ACTIVATE)
  e0:SetCode(EVENT_FREE_CHAIN)
  c:RegisterEffect(e0)
  --(1) Search
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99910070,0))
  e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e1:SetType(EFFECT_TYPE_IGNITION)
  e1:SetRange(LOCATION_FZONE)
  e1:SetCountLimit(1,99990100)
  e1:SetCost(c99910070.thcost)
  e1:SetTarget(c99910070.thtg)
  e1:SetOperation(c99910070.thop)
  c:RegisterEffect(e1)
  --(3) Gain LP
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99910070,2))
  e3:SetCategory(CATEGORY_RECOVER)
  e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
  e3:SetCode(EVENT_PHASE+PHASE_END)
  e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e3:SetRange(LOCATION_FZONE)
  e3:SetCountLimit(1)
  e3:SetTarget(c99910070.rectg)
  e3:SetOperation(c99910070.recop)
  c:RegisterEffect(e3)
  --Counter
  if not c99910070.global_check then
    c99910070.global_check=true
    c99910070[0]=0
    c99910070[1]=0
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e4:SetCode(EVENT_DESTROYED)
    e4:SetOperation(c99910070.addcount)
    Duel.RegisterEffect(e4,0)
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e5:SetCode(EVENT_PHASE_START+PHASE_DRAW)
    e5:SetOperation(c99910070.clearop)
    Duel.RegisterEffect(e5,0)
  end
end
--(1) Search
function c99910070.thcostfilter(c)
  return c:IsSetCard(0x991) and c:IsRace(RACE_FAIRY) and c:IsAbleToGraveAsCost()
end
function c99910070.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99910070.thcostfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
  local g=Duel.SelectMatchingCard(tp,c99910070.thcostfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
  Duel.SendtoGrave(g,REASON_COST)
end
function c99910070.thfilter(c)
  return c:IsSetCard(0x991) and not c:IsCode(99910070) and c:IsAbleToHand()
end
function c99910070.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99910070.thfilter,tp,LOCATION_DECK,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99910070.thop(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,c99910070.thfilter,tp,LOCATION_DECK,0,1,1,nil)
  if g:GetCount()>0 then
    Duel.SendtoHand(g,nil,REASON_EFFECT)
  Duel.ConfirmCards(1-tp,g)
  end
end
--(3) Gain LP
function c99910070.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.SetTargetPlayer(tp)
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,500*c99910070[tp])
end
function c99910070.recop(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
  Duel.Recover(p,500*c99910070[tp],REASON_EFFECT)
end
--Counter
function c99910070.counterfilter(c,tp)
  return c:IsType(TYPE_MONSTER) and c:IsReason(REASON_EFFECT)
end
function c99910070.addcount(e,tp,eg,ep,ev,re,r,rp)
  local tc=eg:GetFirst()
  while tc do
    if tc:IsReason(REASON_BATTLE) then
      local rc=tc:GetReasonCard()
      if rc and rc:IsSetCard(0x991) and bit.band(rc:GetType(),0x81)==0x81 and rc:IsRelateToBattle() then
        local p=rc:GetReasonPlayer()
        c99910070[p]=c99910070[p]+1
      end
    elseif re then
      local rc=re:GetHandler()
      if eg:IsExists(c99910070.counterfilter,1,nil,tp) and rc and rc:IsSetCard(0x991) 
      and bit.band(rc:GetType(),0x81)==0x81 and re:IsActiveType(TYPE_MONSTER) then
        local p=rc:GetReasonPlayer()
        c99910070[p]=c99910070[p]+1
      end
    end
    tc=eg:GetNext()
  end
end
function c99910070.clearop(e,tp,eg,ep,ev,re,r,rp)
  c99910070[0]=0
  c99910070[1]=0
end