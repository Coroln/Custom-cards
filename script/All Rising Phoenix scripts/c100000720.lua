--scripted and created by rising phoenix
function c100000720.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_SELF_TOGRAVE)
		--act in hand
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e7:SetCondition(c100000720.handcon)
	c:RegisterEffect(e7)
		--activate limit
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e11:SetCode(EVENT_CHAINING)
	e11:SetRange(LOCATION_SZONE)
	e11:SetOperation(c100000720.aclimit1)
	c:RegisterEffect(e11)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_CHAIN_NEGATED)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(c100000720.aclimit2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(0,1)
	e3:SetCondition(c100000720.econ1)
	e3:SetValue(c100000720.elimit)
	c:RegisterEffect(e3)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--destroy
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_SINGLE)
	e12:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e12:SetRange(LOCATION_SZONE)
	e12:SetCode(EFFECT_SELF_TOGRAVE)
	e12:SetCondition(c100000720.descon)
	c:RegisterEffect(e12)
end
function c100000720.filterd(c)
	return c:IsFaceup() and c:IsSetCard(0x764) and c:IsType(TYPE_MONSTER)
end
function c100000720.descon(e)
	return not Duel.IsExistingMatchingCard(c100000720.filterd,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function c100000720.handcon(e)
	return Duel.IsExistingMatchingCard(c100000720.filter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function c100000720.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x764) and c:IsType(TYPE_MONSTER)
end
function c100000720.aclimit1(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or not re:IsActiveType(TYPE_MONSTER) then return end
	e:GetHandler():RegisterFlagEffect(100000720,RESET_EVENT+0x3ff0000+RESET_PHASE+PHASE_END,0,1)
end
function c100000720.aclimit2(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	e:GetHandler():ResetFlagEffect(100000720)
end
function c100000720.econ1(e)
	return e:GetHandler():GetFlagEffect(100000720)~=0
end
function c100000720.elimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsImmuneToEffect(e)
end