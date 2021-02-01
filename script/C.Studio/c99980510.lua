--HN CyberConnect2
--Scripted by Raivost
function c99980510.initial_effect(c)
  aux.EnablePendulumAttribute(c)
  --Pendulum Effects
  --(1) Draw
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99980510,0))
  e1:SetCategory(CATEGORY_DRAW)
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e1:SetCode(EVENT_SPSUMMON_SUCCESS)
  e1:SetRange(LOCATION_PZONE)
  e1:SetCountLimit(1)
  e1:SetCondition(c99980510.drcon)
  e1:SetTarget(c99980510.drtg)
  e1:SetOperation(c99980510.drop)
  c:RegisterEffect(e1)
  --Monster Effects
  --(1) Discard
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99980510,1))
  e2:SetCategory(CATEGORY_HANDES)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e2:SetCode(EVENT_DESTROYED)
  e2:SetProperty(EFFECT_FLAG_DELAY)
  e2:SetCondition(c99980510.discon)
  e2:SetTarget(c99980510.distg)
  e2:SetOperation(c99980510.disop)
  c:RegisterEffect(e2)
  --(2) Return to hand 
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99980510,2))
  e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
  e3:SetType(EFFECT_TYPE_IGNITION)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCountLimit(1)
  e3:SetTarget(c99980510.rthtg)
  e3:SetOperation(c99980510.rthop)
  c:RegisterEffect(e3)
end
--Pendulum Effects
--(1) Draw
function c99980510.drconfilter(c,tp)
  return c:IsFaceup() and c:IsSetCard(0x998) and c:GetSummonPlayer()==tp and c:GetSummonType()==SUMMON_TYPE_XYZ
end
function c99980510.drcon(e,tp,eg,ep,ev,re,r,rp)
  return eg:IsExists(c99980510.drconfilter,1,nil,tp)
end
function c99980510.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
  Duel.SetTargetPlayer(tp)
  Duel.SetTargetParam(1)
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c99980510.drop(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
  Duel.Draw(p,d,REASON_EFFECT)
end
--Monster Effects
--(1) Discard
function c99980510.discon(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  return c:IsPreviousLocation(LOCATION_PZONE)
end
function c99980510.distg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
end
function c99980510.disop(e,tp,eg,ep,ev,re,r,rp)
  local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
  if g:GetCount()>0 then
    local sg=g:RandomSelect(1-tp,1)
    Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
  end
end
--(3) Return to hand
function c99980510.rthfilter(c,e,tp)
  return c:IsSetCard(0x998) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99980510.rthtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():IsAbleToHand() and Duel.IsExistingTarget(c99980510.rthfilter,tp,LOCATION_HAND,0,1,e:GetHandler(),e,tp) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c99980510.rthop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_HAND) then
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c99980510.rthfilter,tp,LOCATION_HAND,0,1,1,c,e,tp)
    if g:GetCount()>0 then
      Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
  end
end