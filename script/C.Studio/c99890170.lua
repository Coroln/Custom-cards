--Fate Lancer, Cu Chulainn
--Scripted by Raivost
function c99890170.initial_effect(c)
  c:EnableReviveLimit()
  --(1) Search
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99890170,0))
  e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e1:SetType(EFFECT_TYPE_IGNITION)
  e1:SetRange(LOCATION_HAND)
  e1:SetCountLimit(1,99890170)
  e1:SetCost(c99890170.thcost)
  e1:SetTarget(c99890170.thtg)
  e1:SetOperation(c99890170.thop)
  c:RegisterEffect(e1)
  --(2) Special Summon
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
  e2:SetCode(EVENT_SPSUMMON_SUCCESS)
  e2:SetOperation(c99890170.spreg)
  c:RegisterEffect(e2)
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99890170,1))
  e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
  e3:SetCondition(c99890170.spcon)
  e3:SetCost(c99890170.spcost)
  e3:SetTarget(c99890170.sptg)
  e3:SetOperation(c99890170.spop)
  e3:SetLabelObject(e2)
  c:RegisterEffect(e3)
  --(3) Destroy
  local e4=Effect.CreateEffect(c)
  e4:SetDescription(aux.Stringid(99890170,2))
  e4:SetCategory(CATEGORY_DESTROY)
  e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e4:SetCode(EVENT_BATTLE_START)
  e4:SetTarget(c99890170.destg)
  e4:SetOperation(c99890170.desop)
  c:RegisterEffect(e4)
  --(4) Discard
  local e5=Effect.CreateEffect(c)
  e5:SetDescription(aux.Stringid(99890170,3))
  e5:SetCategory(CATEGORY_HANDES)
  e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e5:SetCode(EVENT_ATTACK_ANNOUNCE)
  e5:SetTarget(c99890170.distg)
  e5:SetOperation(c99890170.disop)
  c:RegisterEffect(e5)
end
c99890170.listed_names={99890180}
--(1) Search
function c99890170.thcostfiler(c)
  return c:IsSetCard(0x989) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c99890170.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
  if chk==0 then return not c:IsPublic() and Duel.IsExistingMatchingCard(c99890170.thcostfilter,tp,LOCATION_HAND,0,1,e:GetHandler())
  and Duel.IsExistingMatchingCard(c99890170.thcostfiler,tp,LOCATION_DECK,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
  local g=Duel.SelectMatchingCard(tp,c99890170.thcostfiler,tp,LOCATION_DECK,0,1,1,nil)
  Duel.SendtoGrave(g,REASON_COST)
  Duel.ShuffleHand(tp)
end
function c99890170.thfilter(c)
  return c:IsCode(99890010) and c:IsAbleToHand()
end
function c99890170.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99890170.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c99890170.thop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c99890170.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
  if g:GetCount()>0 then
    Duel.SendtoHand(g,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,g)
  end
end
--(2) Special Summon
function c99890170.spreg(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_STANDBY then
    e:SetLabel(Duel.GetTurnCount())
    c:RegisterFlagEffect(99890171,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,0,2)
  else
    e:SetLabel(0)
    c:RegisterFlagEffect(99890171,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,0,1)
  end
end
function c99890170.spcon(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  return e:GetLabelObject():GetLabel()~=Duel.GetTurnCount() and tp==Duel.GetTurnPlayer() and c:GetFlagEffect(99890171)>0
end
function c99890170.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
  Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c99890170.spfilter(c,e,tp)
  return c:IsCode(99890180) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c99890170.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
  and Duel.IsExistingMatchingCard(c99890170.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c99890170.spop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c99890170.spfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
  if g:GetCount()>0 then
    Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
  end
end
--(3) Destroy
function c99890170.destg(e,tp,eg,ep,ev,re,r,rp,chk)
  local d=Duel.GetAttackTarget()
  if chk ==0 then return Duel.GetAttacker()==e:GetHandler() and d and d:IsDefensePos() end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,d,1,0,0)
end
function c99890170.desop(e,tp,eg,ep,ev,re,r,rp)
  local d=Duel.GetAttackTarget()
  if d~=nil and d:IsRelateToBattle() and d:IsDefensePos() then
    Duel.Destroy(d,REASON_EFFECT)
  end
end
--(4) Discard
function c99890170.distg(e,tp,eg,ep,ev,re,r,rp,chk)
  local h1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
  local h2=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
  if chk==0 then return h1>0 and h2>0 end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,PLAYER_ALL,1)
end
function c99890170.disop(e,tp,eg,ep,ev,re,r,rp)
  local h1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
  local h2=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
  if h1>0 and h2>0 then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
    local g1=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND,0,1,1,nil)
    Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_DISCARD)
    local g2=Duel.SelectMatchingCard(1-tp,aux.TRUE,1-tp,LOCATION_HAND,0,1,1,nil)
    g1:Merge(g2)
    Duel.SendtoGrave(g1,REASON_EFFECT+REASON_DISCARD)
  end
end