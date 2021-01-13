--scripted and created by rising phoenix
function c100001168.initial_effect(c)	
c:EnableReviveLimit()
--spson
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e8:SetCode(EFFECT_SPSUMMON_CONDITION)
	e8:SetValue(aux.FALSE)
	c:RegisterEffect(e8)
	--special summon
	local e30=Effect.CreateEffect(c)
	e30:SetType(EFFECT_TYPE_FIELD)
	e30:SetCode(EFFECT_SPSUMMON_PROC)
	e30:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e30:SetRange(LOCATION_HAND)
	e30:SetCondition(c100001168.spcon)
	c:RegisterEffect(e30)
		--cannot attack
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e11:SetCode(EVENT_SUMMON_SUCCESS)
	e11:SetOperation(c100001168.atklimit)
	c:RegisterEffect(e11)
	local e12=e11:Clone()
	e12:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e12)
	local e13=e11:Clone()
	e13:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e13)
		--Atk update
	local e14=Effect.CreateEffect(c)
	e14:SetType(EFFECT_TYPE_SINGLE)
	e14:SetCode(EFFECT_UPDATE_ATTACK)
	e14:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e14:SetRange(LOCATION_MZONE)
	e14:SetValue(c100001168.atkval)
	c:RegisterEffect(e14)
		local e15=e14:Clone()
	e15:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e15)
	--half damage
	local e24=Effect.CreateEffect(c)
	e24:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e24:SetRange(LOCATION_MZONE)
	e24:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e24:SetCondition(c100001168.dxcon)
	e24:SetOperation(c100001168.dxop)
	c:RegisterEffect(e24)
end
function c100001168.dxcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep~=tp and (c==Duel.GetAttacker() or c==Duel.GetAttackTarget())
end
function c100001168.dxop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev/2)
end
function c100001168.atkval(e,c)
	local  c=e:GetHandler()
	return math.abs(Duel.GetLP(0)-Duel.GetLP(1))
end
function c100001168.atklimit(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function c100001168.cfilter(c)
	return c:IsFaceup() and c:IsCode(100001155)
end
function c100001168.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c100001168.cpfilter,c:GetControler(),LOCATION_SZONE,0,1,nil)
end