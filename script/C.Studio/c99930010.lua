--OTNN Tail Red
--Scripted by Raivost
function c99930010.initial_effect(c)
  c:EnableReviveLimit()
  --Xyz Summon
  Xyz.AddProcedure(c,c99930010.xyzfilter,nil,2,nil,nil,99,nil,false,c99930010.xyzcheck)
  --(1) Gain Rank
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99930010,0))
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
  e1:SetRange(LOCATION_MZONE)
  e1:SetCountLimit(1)
  e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
  e1:SetTarget(c99930010.rktg)
  e1:SetOperation(c99930010.rkop)
  c:RegisterEffect(e1)
  --(2) Gain ATK
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99930010,1))
  e2:SetCategory(CATEGORY_ATKCHANGE)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e2:SetCode(EVENT_ATTACK_ANNOUNCE)
  e2:SetTarget(c99930010.atktg)
  e2:SetOperation(c99930010.atkop)
  c:RegisterEffect(e2)
  --(3) Attach
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99930010,2))
  e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e3:SetCode(EVENT_BATTLE_DESTROYING)
  e3:SetCondition(aux.bdocon)
  e3:SetTarget(c99930010.attachtg)
  e3:SetOperation(c99930010.attachop)
  c:RegisterEffect(e3)
  --(4) Negate
  local e4=Effect.CreateEffect(c)
  e4:SetDescription(aux.Stringid(99930010,3))
  e4:SetCategory(CATEGORY_NEGATE+CATEGORY_ATKCHANGE)
  e4:SetType(EFFECT_TYPE_QUICK_O)
  e4:SetCode(EVENT_CHAINING)
  e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
  e4:SetRange(LOCATION_MZONE)
  e4:SetCountLimit(1)
  e4:SetCondition(c99930010.negcon)
  e4:SetCost(c99930010.negcost)
  e4:SetTarget(c99930010.negtg)
  e4:SetOperation(c99930010.negop)
  c:RegisterEffect(e4)
  --(5) Second attack
  local e5=Effect.CreateEffect(c)
  e5:SetDescription(aux.Stringid(99930010,4))
  e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e5:SetCode(EVENT_BATTLE_DESTROYING)
  e5:SetCondition(c99930010.sacon)
  e5:SetTarget(c99930010.satg)
  e5:SetOperation(c99930010.saop)
  c:RegisterEffect(e5)
end
--Xyz  Summon
function c99930010.xyzfilter(c,tp)
  return c:IsRace(RACE_WARRIOR) and c:IsLevelAbove(1)
end
function c99930010.xyzcheck(g,tp)
  local mg=g:Filter(function(c) return not c:IsHasEffect(511001175) end,nil)
  return mg:GetClassCount(Card.GetLevel)==1 
end
function c99930010.check(c,lvl)
  return c:Level()~=lvl and not c:IsHasEffect(511001175)
end
--(1) Gain Rank
function c99930010.rktg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99930010.rkop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_RANK)
  e1:SetValue(1)
  e1:SetReset(RESET_EVENT+0x1ff0000)
  c:RegisterEffect(e1)
end
--(2) Gain ATK
function c99930010.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99930010.atkop(e,tp,eg,ep,ev,re,r,rp)
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
--(3) Attach
function c99930010.attachtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99930010.attachop(e,tp,eg,ep,ev,re,r,rp)
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
--(4) Negate
function c99930010.negcon(e,tp,eg,ep,ev,re,r,rp)
  return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and rp~=tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function c99930010.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
  e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c99930010.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c99930010.negop(e,tp,eg,ep,ev,re,r,rp)
  local rc=re:GetHandler()
  if Duel.NegateActivation(ev) and rc:IsRelateToEffect(re) then
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
    e1:SetValue(rc:GetBaseAttack()/2)
    e:GetHandler():RegisterEffect(e1)
  end
end
--(5) Second attack
function c99930010.sacon(e,tp,eg,ep,ev,re,r,rp)
  return aux.bdocon(e,tp,eg,ep,ev,re,r,rp) and e:GetHandler():IsChainAttackable()
end
function c99930010.satg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99930010.saop(e,tp,eg,ep,ev,re,r,rp)
  Duel.ChainAttack()
end
