--gate
function c100000755.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c100000755.actcon)
	c:RegisterEffect(e1)
	--no damage
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_CHANGE_DAMAGE)
	e7:SetRange(LOCATION_SZONE)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e7:SetTargetRange(1,0)
	e7:SetValue(c100000755.damval)
	c:RegisterEffect(e7)
		local e3=e7:Clone()
	e3:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	c:RegisterEffect(e3)
	--negate attack
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(100000755,0))
	e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e11:SetCode(EVENT_BE_BATTLE_TARGET)
	e11:SetRange(LOCATION_SZONE)
	e11:SetCountLimit(1)
	e11:SetCondition(c100000755.condition)
	e11:SetOperation(c100000755.operation)
	c:RegisterEffect(e11)
end
function c100000755.condition(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetAttackTarget()
	return d and d:IsControler(tp) and d:IsFaceup() and d:IsSetCard(0x753)
end
function c100000755.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
end

function c100000755.filter(c)
	return c:IsFaceup() and c:IsCode(100000875)
end
function c100000755.check()
	return Duel.IsExistingMatchingCard(c100000755.filter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		or Duel.IsEnvironment(100000875)
end
function c100000755.actcon(e,tp,eg,ep,ev,re,r,rp)
	return c100000755.check()
end
function c100000755.damval(e,re,val,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 then return 0 end
	return val
end
