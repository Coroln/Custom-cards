--BRS Nana Gray
--Scripted by Raivost
function c99960400.initial_effect(c)
  --(1) Special Summon
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99960400,0))
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetType(EFFECT_TYPE_IGNITION)
  e1:SetRange(LOCATION_HAND)
  e1:SetCountLimit(1,99960400)
  e1:SetTarget(c99960400.hsptg)
  e1:SetOperation(c99960400.hspop)
  c:RegisterEffect(e1)
  --(2) Search
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99960400,1))
  e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e2:SetCode(EVENT_SUMMON_SUCCESS)
  e2:SetProperty(EFFECT_FLAG_DELAY)
  e2:SetCountLimit(1,99960401)
  e2:SetTarget(c99960400.thtg)
  e2:SetOperation(c99960400.thop)
  c:RegisterEffect(e2)
  local e3=e2:Clone()
  e3:SetCode(EVENT_SPSUMMON_SUCCESS)
  c:RegisterEffect(e3)
  --(3) Draw
  local e4=Effect.CreateEffect(c)
  e4:SetDescription(aux.Stringid(99960400,2))
  e4:SetCategory(CATEGORY_DRAW)
  e4:SetType(EFFECT_TYPE_IGNITION)
  e4:SetRange(LOCATION_GRAVE)
  e4:SetCountLimit(1,99960402)
  e4:SetCondition(c99960400.drcon)
  e4:SetCost(c99960400.drcost)
  e4:SetTarget(c99960400.drtg)
  e4:SetOperation(c99960400.drop)
  c:RegisterEffect(e4)
  Duel.AddCustomActivityCounter(99960400,ACTIVITY_SPSUMMON,c99960400.counterfilter)
end
function c99960400.counterfilter(c)
  return c:GetSummonLocation()~=LOCATION_EXTRA or c:IsSetCard(0x996)
end
--(1) Special Summon
function c99960400.hspfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x996) and c:IsType(TYPE_XYZ)
end
function c99960400.hsptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then
    local g=Group.CreateGroup()
    local mg=Duel.GetMatchingGroup(c99960400.hspfilter,tp,LOCATION_MZONE,0,nil)
    for tc in aux.Next(mg) do
      g:Merge(tc:GetOverlayGroup())
    end
    if g:GetCount()==0 then return false end
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
    and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
  end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c99960400.hspop(e,tp,eg,ep,ev,re,r,rp)
  local g=Group.CreateGroup()
  local mg=Duel.GetMatchingGroup(c99960400.hspfilter,tp,LOCATION_MZONE,0,nil)
  for tc in aux.Next(mg) do
    g:Merge(tc:GetOverlayGroup())
  end
  if g:GetCount()==0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local sg=g:Select(tp,1,1,nil)
  Duel.SendtoHand(sg,nil,REASON_EFFECT)
  local c=e:GetHandler()
  if not c:IsRelateToEffect(e) then return end
  Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
--(2) Search
function c99960400.thfilter(c)
  return c:IsSetCard(0x996) and c:IsAbleToHand() and not c:IsCode(99960400)
end
function c99960400.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99960400.thfilter,tp,LOCATION_DECK,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99960400.thop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,c99960400.thfilter,tp,LOCATION_DECK,0,1,1,nil)
  if g:GetCount()>0 then
    Duel.SendtoHand(g,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,g)
  end
end
--(3) Draw
function c99960400.drcon(e)
  return not Duel.IsExistingMatchingCard(c99960400.hspfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c99960400.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
  if chk==0 then return aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,0) and Duel.GetCustomActivityCount(99960400,tp,ACTIVITY_SPSUMMON)==0 end
  Duel.Remove(c,POS_FACEUP,REASON_COST)
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
  e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
  e1:SetTargetRange(1,0)
  e1:SetTarget(c99960400.splimit)
  e1:SetReset(RESET_PHASE+PHASE_END)
  Duel.RegisterEffect(e1,tp)
end
function c99960400.splimit(e,c,sump,sumtype,sumpos,targetp,se)
  return not c:IsSetCard(0x996) and c:IsLocation(LOCATION_EXTRA)
end
function c99960400.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
  Duel.SetTargetPlayer(tp)
  Duel.SetTargetParam(2)
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c99960400.drop(e,tp,eg,ep,ev,re,r,rp)
  local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
  Duel.Draw(p,d,REASON_EFFECT)
end