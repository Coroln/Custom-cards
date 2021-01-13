--scripted and created by rising phoenix
function c100000721.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_SELF_TOGRAVE)
		--act in hand
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e7:SetCondition(c100000721.handcon)
	c:RegisterEffect(e7)
		local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(c100000721.aclimit1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAIN_NEGATED)
	e3:SetRange(LOCATION_SZONE)
	e3:SetOperation(c100000721.aclimit2)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(0,1)
	e4:SetCondition(c100000721.econ)
	e4:SetValue(c100000721.elimit)
	c:RegisterEffect(e4)
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
	e12:SetCondition(c100000721.descon)
	c:RegisterEffect(e12)
	--prevent set
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_FIELD)
	e13:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e13:SetCode(EFFECT_CANNOT_SSET)
	e13:SetRange(LOCATION_SZONE)
	e13:SetCondition(c100000721.setcon1)
	e13:SetTarget(c100000721.settg)
	e13:SetTargetRange(0,1)
	c:RegisterEffect(e13)
		--Check for single Set
	if not c100000721.global_check then
		c100000721.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SSET)
		ge1:SetOperation(c100000721.checkop)
		Duel.RegisterEffect(ge1,0)
end
end
function c100000721.checkop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(Card.IsPreviousLocation,1,nil,LOCATION_HAND) then
		Duel.RegisterFlagEffect(rp,100000721,RESET_PHASE+PHASE_END,0,1)
	end
end
function c100000721.settg(e,c)
	return c:IsLocation(LOCATION_HAND)
end
function c100000721.setcon1(e)
	return Duel.GetFlagEffect(1-e:GetHandlerPlayer(),100000721)>0
end
function c100000721.descon(e)
	return not Duel.IsExistingMatchingCard(c100000721.filterd,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function c100000721.ccfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x764) and c:IsType(TYPE_MONSTER)
end
function c100000721.handcon(e)
	return Duel.IsExistingMatchingCard(c100000721.filter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function c100000721.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x764) and c:IsType(TYPE_MONSTER)
end
function c100000721.filterd(c)
	return c:IsFaceup() and c:IsSetCard(0x764) and c:IsType(TYPE_MONSTER)
end
function c100000721.aclimit1(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	e:GetHandler():RegisterFlagEffect(100000721,RESET_EVENT+0x3ff0000+RESET_PHASE+PHASE_END,0,1)
end
function c100000721.aclimit2(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	e:GetHandler():ResetFlagEffect(100000721)
end
function c100000721.econ(e)
	return e:GetHandler():GetFlagEffect(100000721)~=0
end
function c100000721.elimit(e,te,tp)
	return te:IsHasType(EFFECT_TYPE_ACTIVATE)
end
