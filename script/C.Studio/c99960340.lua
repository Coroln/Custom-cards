--BRS Rank-Up-Magic - Obsidian Star
--Scripted by Raivost
function c99960340.initial_effect(c)
  --(1) Xyz Summon
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99960340,0))
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetTarget(c99960340.xyztg)
  e1:SetOperation(c99960340.xyzop)
  c:RegisterEffect(e1)
  --(2) Return to hand
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99960340,4))
  e2:SetCategory(CATEGORY_TOHAND)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e2:SetCode(EVENT_TO_GRAVE)
  e2:SetCondition(c99960340.rthcon)
  e2:SetCost(c99960340.rthcost)
  e2:SetTarget(c99960340.rthtg)
  e2:SetOperation(c99960340.rthop)
  c:RegisterEffect(e2)
end
function c99960340.xyzfilter1(c,e,tp)
  local loc=0
  if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_GRAVE end
  if Duel.GetLocationCountFromEx(tp,tp,c)>0 then loc=loc+LOCATION_EXTRA end
  return c:IsFaceup() and c:IsRank(4) and c:IsSetCard(0x996) and Duel.IsExistingMatchingCard(c99960340.xyzfilter2,tp,loc,0,1,nil,e,tp,c,c:GetRank()+1)
end
function c99960340.xyzfilter2(c,e,tp,mc,rk)
  if c.rum_limit and not c.rum_limit(mc,e) then return false end
  return mc:IsType(TYPE_XYZ,c,SUMMON_TYPE_XYZ,tp) and c:IsRank(rk) and c:IsSetCard(0x996) and mc:IsCanBeXyzMaterial(c,tp)
  and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,true,false)
end
function c99960340.xyztg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingTarget(c99960340.xyzfilter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  Duel.SelectTarget(tp,c99960340.xyzfilter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_GRAVE)
end
function c99960340.xyzop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local tc=Duel.GetFirstTarget()
  local loc=0
  if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_GRAVE end
  if Duel.GetLocationCountFromEx(tp,tp,tc)>0 then loc=loc+LOCATION_EXTRA end
  if loc==0 then return end
  if not tc or tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c99960340.xyzfilter2),tp,loc,0,1,1,nil,e,tp,tc,tc:GetRank()+1)
  local sc=g:GetFirst()
  if sc then
    local mg=tc:GetOverlayGroup()
    if mg:GetCount()~=0 then
      Duel.Overlay(sc,mg)
    end
    sc:SetMaterial(Group.FromCards(tc))
    Duel.Overlay(sc,Group.FromCards(tc))
    Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,true,false,POS_FACEUP)
  --(1.1) Untargetable
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(99960340,1))
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
    e1:SetRange(LOCATION_MZONE)
    e1:SetValue(1)
    e1:SetReset(RESET_EVENT+0x1fe0000)
    sc:RegisterEffect(e1,true)
    --(1.2) Indes by battle
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(99960340,2))
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
    e2:SetValue(1)
    e2:SetReset(RESET_EVENT+0x1fe0000)
    sc:RegisterEffect(e2,true)
    --(1.3) Inflict damage
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(99960340,3))
    e3:SetCategory(CATEGORY_DAMAGE+CATEGORY_ATKCHANGE)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_BATTLE_DESTROYING)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
    e3:SetCondition(c99960340.damcon1)
    e3:SetTarget(c99960340.damtg)
    e3:SetOperation(c99960340.damop)
    e3:SetReset(RESET_EVENT+0x1fe0000)
    sc:RegisterEffect(e3,true)
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_DAMAGE+CATEGORY_ATKCHANGE)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e4:SetCode(EVENT_DESTROYED)
    e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCondition(c99960340.damcon2)
    e4:SetTarget(c99960340.damtg)
    e4:SetOperation(c99960340.damop)
    e4:SetReset(RESET_EVENT+0x1fe0000)
    sc:RegisterEffect(e4,true)
    if not sc:IsType(TYPE_EFFECT) then
      local e5=Effect.CreateEffect(c)
      e5:SetType(EFFECT_TYPE_SINGLE)
      e5:SetCode(EFFECT_ADD_TYPE)
      e5:SetValue(TYPE_EFFECT)
      e5:SetReset(RESET_EVENT+0x1fe0000)
      sc:RegisterEffect(e5,true)
    end
    sc:CompleteProcedure()
  end
end
--(1.3) Inflict damage
function c99960340.damcon1(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsRelateToBattle()
end
function c99960340.damcon2(e,tp,eg,ep,ev,re,r,rp)
  return bit.band(r,REASON_EFFECT)~=0 and re:GetHandler()==e:GetHandler()
end
function c99960340.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.SetTargetPlayer(1-tp)
  Duel.SetTargetParam(500)
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
end
function c99960340.damop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
  if Duel.Damage(p,d,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) and c:IsFaceup() then
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(500)
    e1:SetReset(RESET_EVENT+0x1ff0000)
    c:RegisterEffect(e1)
    Duel.SetLP(tp,Duel.GetLP(tp)-500)
  end
end
--(2) Return to hand
function c99960340.rthcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.CheckLPCost(tp,700) end
  Duel.PayLPCost(tp,700)
end
function c99960340.rthcon(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  return c:IsReason(REASON_COST) and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_MONSTER)
  and c:IsPreviousLocation(LOCATION_OVERLAY) and re:GetHandler():IsSetCard(0x996) 
end
function c99960340.rthtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():IsAbleToHand() end  
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c99960340.rthop(e,tp,eg,ep,ev,re,r,rp)
  if e:GetHandler():IsRelateToEffect(e) then
    Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
  end
end