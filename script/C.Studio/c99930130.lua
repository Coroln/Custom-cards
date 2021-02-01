--OTNN Tail Red - Faller Chain
--Scripted by Raivost
function c99930130.initial_effect(c)
  c:EnableReviveLimit()
  --Xyz Summon
  aux.AddXyzProcedure(c,c99930130.xyzfilter,nil,99,c99930130.ovfilter,aux.Stringid(99930130,0))
  --Special Summon condition
  local e0=Effect.CreateEffect(c)
  e0:SetType(EFFECT_TYPE_SINGLE)
  e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
  e0:SetCode(EFFECT_SPSUMMON_CONDITION)
  c:RegisterEffect(e0)
  --(1) Gain rank 1
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99930130,0))
  e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e1:SetCode(EVENT_SPSUMMON_SUCCESS)
  e1:SetCondition(c99930130.rkcon1)
  e1:SetTarget(c99930130.rktg1)
  e1:SetOperation(c99930130.rkop1)
  c:RegisterEffect(e1)
  --(2) Indes by effects
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE)
  e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCondition(c99930130.indcon)
  e2:SetValue(1)
  c:RegisterEffect(e2)
  --(3) Gain Rank 2
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99930130,0))
  e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCountLimit(1)
  e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
  e3:SetTarget(c99930130.rktg1)
  e3:SetOperation(c99930130.rkop2)
  c:RegisterEffect(e3)
  --(4) Double damage
  local e4=Effect.CreateEffect(c)
  e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
  e4:SetCode(EVENT_PRE_BATTLE_DAMAGE)
  e4:SetOperation(c99930130.ddop)
  c:RegisterEffect(e4)
  --(5) Gain ATK 1
  local e5=Effect.CreateEffect(c)
  e5:SetDescription(aux.Stringid(99930130,1))
  e5:SetCategory(CATEGORY_ATKCHANGE)
  e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e5:SetCode(EVENT_ATTACK_ANNOUNCE)
  e5:SetTarget(c99930130.atktg1)
  e5:SetOperation(c99930130.atkop1)
  c:RegisterEffect(e5)
  --(6) Attach
  local e6=Effect.CreateEffect(c)
  e6:SetDescription(aux.Stringid(99930130,2))
  e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e6:SetCode(EVENT_BATTLE_DESTROYING)
  e6:SetCondition(aux.bdocon)
  e6:SetTarget(c99930130.attachtg)
  e6:SetOperation(c99930130.attachop)
  c:RegisterEffect(e6)
  --(7) Gain ATK 2
  local e7=Effect.CreateEffect(c)
  e7:SetDescription(aux.Stringid(99930130,1))
  e7:SetCategory(CATEGORY_ATKCHANGE)
  e7:SetType(EFFECT_TYPE_IGNITION)
  e7:SetRange(LOCATION_MZONE)
  e7:SetCountLimit(1)
  e7:SetCost(c99930130.atkcost2)
  e7:SetTarget(c99930130.atktg2)
  e7:SetOperation(c99930130.atkop2)
  c:RegisterEffect(e7)
  --(8) Negate
  local e8=Effect.CreateEffect(c)
  e8:SetDescription(aux.Stringid(99930130,3))
  e8:SetCategory(CATEGORY_DISABLE)
  e8:SetType(EFFECT_TYPE_QUICK_O)
  e8:SetCode(EVENT_CHAINING)
  e8:SetCountLimit(1)
  e8:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
  e8:SetRange(LOCATION_MZONE)
  e8:SetCondition(c99930130.negcon)
  e8:SetTarget(c99930130.negtg)
  e8:SetOperation(c99930130.negop)
  c:RegisterEffect(e8)
end
--Xyz Summon
function c99930130.xyzfilter(c,xyz,sumtype,tp)
  return c:IsType(TYPE_XYZ,xyz,sumtype,tp) and not c:IsSetCard(0x993)
end
function c99930130.ovfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x993) and c:IsType(TYPE_XYZ) and c:GetOverlayCount()>=5 and not c:IsCode(99930130)
end
--(1) Gain rank 1
function c99930130.rkcon1(e,tp,eg,ep,ev,re,r,rp)
  local ct=e:GetHandler():GetOverlayCount()
  return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ and ct>0
end
function c99930130.rktg1(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99930130.rkop1(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if not c:IsFaceup() or not c:IsRelateToEffect(e) then return end
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_RANK)
  e1:SetValue(c:GetOverlayCount())
  e1:SetReset(RESET_EVENT+0x1fe0000)
  c:RegisterEffect(e1)
end
--(2) Indes by effects
function c99930130.indfilter(c)
  return c:IsSetCard(0x993)
end
function c99930130.indcon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():GetOverlayGroup():Filter(c99930130.indfilter,nil)
end
--(3) Gain rank 2
function c99930130.rkop2(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_RANK)
  e1:SetValue(1)
  e1:SetReset(RESET_EVENT+0x1ff0000)
  c:RegisterEffect(e1)
end
--(4) Double damage
function c99930130.ddop(e,tp,eg,ep,ev,re,r,rp)
  Duel.ChangeBattleDamage(ep,ev*2)
end
--(5) Gain ATK
function c99930130.atktg1(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99930130.atkop1(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if c:IsRelateToEffect(e) and c:IsFaceup() then
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE)
    e1:SetValue(c:GetRank()*100)
    c:RegisterEffect(e1)
  end
end
--(6) Attach
function c99930130.attachtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99930130.attachop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local tc=c:GetBattleTarget()
  if c:IsRelateToEffect(e) and c:IsFaceup() and tc and tc:IsAbleToChangeControler() 
  and not tc:IsImmuneToEffect(e) and not tc:IsHasEffect(EFFECT_NECRO_VALLEY) then
    local og=tc:GetOverlayGroup()
    if og:GetCount()>0 then
      Duel.SendtoGrave(og,REASON_RULE)
    end
    Duel.Overlay(c,Group.FromCards(tc))
  end
end
--(7) Gain ATK 2
function c99930130.atkcost2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
  e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c99930130.atktg2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99930130.atkop2(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if c:IsRelateToEffect(e) then
  	local e1=Effect.CreateEffect(c)
  	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c:GetOverlayCount()*600)
  	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
  	c:RegisterEffect(e1)
  end
end
--(8) Negate
function c99930130.negcon(e,tp,eg,ep,ev,re,r,rp)
  local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
  local rc=re:GetHandler()
  return bit.band(loc,LOCATION_MZONE)~=0 and rp~=tp and re:IsActiveType(TYPE_MONSTER)
  and Duel.IsChainDisablable(ev) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function c99930130.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c99930130.negop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local rc=re:GetHandler()
  if Duel.NegateEffect(ev) and c:IsRelateToEffect(e) and rc:IsRelateToEffect(re) and c:IsType(TYPE_XYZ) then
  	local og=rc:GetOverlayGroup()
    if og:GetCount()>0 then
      Duel.SendtoGrave(og,REASON_RULE)
    end
  	rc:CancelToGrave()
  	Duel.Overlay(c,Group.FromCards(rc))
  end
end