--Inuyashas Red Tessaiga
function c53790710.initial_effect(c)
	--synchro summon
    Synchro.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x5EB),1,1,Synchro.NonTunerEx(Card.IsSetCard,0x5EB),1,99)
	c:EnableReviveLimit()
	--change name
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetValue(53790700)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c53790710.destg)
	e2:SetOperation(c53790710.desop)
	c:RegisterEffect(e2)
	--(3) Gain ATK/DEF
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(53790710,1))
    e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_BATTLE_DESTROYED)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCondition(c53790710.atkcon)
    e3:SetTarget(c53790710.atktg)
    e3:SetOperation(c53790710.atkop)
    c:RegisterEffect(e3)
end
function c53790710.filter(c,atk)
	return c:IsFaceup() and c:IsAttackBelow(atk) and bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL
		and c:IsType(TYPE_EFFECT)
end
function c53790710.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c53790710.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c,c:GetAttack()) end
	local g=Duel.GetMatchingGroup(c53790710.filter,tp,LOCATION_MZONE,LOCATION_MZONE,c,c:GetAttack())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetCount()*800)
end
function c53790710.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local g=Duel.GetMatchingGroup(c53790710.filter,tp,LOCATION_MZONE,LOCATION_MZONE,c,c:GetAttack())
	local ct=Duel.Destroy(g,REASON_EFFECT)
	if ct>0 then
		Duel.BreakEffect()
		Duel.Damage(1-tp,ct*800,REASON_EFFECT)
	end
end
--(3) Gain ATK/DEF
function c53790710.atkcon(e,tp,eg,ep,ev,re,r,rp)
  local des=eg:GetFirst()
  local rc=des:GetReasonCard()
  if des:IsType(TYPE_XYZ) then
    e:SetLabel(des:GetRank()) 
  elseif des:IsType(TYPE_LINK) then
    e:SetLabel(des:GetLink())
  else
    e:SetLabel(des:GetLevel())
  end
  return rc and rc:IsSetCard(0x5EB) and rc:IsControler(tp) and rc:IsRelateToBattle() and des:IsReason(REASON_BATTLE) 
end
function c53790710.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.Hint(HINT_OPSELECTED,tp,e:GetDescription())
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c53790710.atkop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetValue(e:GetLabel()*200)
  e1:SetReset(RESET_EVENT+0x1ff0000)
  c:RegisterEffect(e1)
  local e2=e1:Clone()
  e2:SetCode(EFFECT_UPDATE_DEFENSE)
  c:RegisterEffect(e2)
end