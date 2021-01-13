--scripted and created by rising phoenix
function c100000718.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_SELF_TOGRAVE)
		--act in hand
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e7:SetCondition(c100000718.handcon)
	c:RegisterEffect(e7)
	--cannot attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCondition(c100000718.atkcon)
	e2:SetTarget(c100000718.atktg)
	c:RegisterEffect(e2)
	--check
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetOperation(c100000718.checkop)
	e3:SetLabelObject(e2)
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
	e12:SetCondition(c100000718.descon)
	c:RegisterEffect(e12)
end
function c100000718.descon(e)
	return not Duel.IsExistingMatchingCard(c100000718.filterd,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function c100000718.ccondition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c100000718.ccfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c100000718.ccfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x764) and c:IsType(TYPE_MONSTER)
end
function c100000718.atkcon(e)
	return e:GetHandler():GetFlagEffect(100000718)~=0
end
function c100000718.atktg(e,c)
	return c:GetFieldID()~=e:GetLabel()
end
function c100000718.checkop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(100000718)~=0 then return end
	local fid=eg:GetFirst():GetFieldID()
	e:GetHandler():RegisterFlagEffect(100000718,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	e:GetLabelObject():SetLabel(fid)
end


function c100000718.handcon(e)
	return Duel.IsExistingMatchingCard(c100000719.filter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function c100000718.filterd(c)
	return c:IsFaceup() and c:IsSetCard(0x764) and c:IsType(TYPE_MONSTER)
end
function c100000718.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x764) and c:IsType(TYPE_MONSTER)
end