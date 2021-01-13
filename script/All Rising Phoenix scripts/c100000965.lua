 --Created and coded by Rising Phoenix
function c100000965.initial_effect(c)
c:EnableCounterPermit(0x51)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c100000965.ctcon)
	e2:SetOperation(c100000965.ctop)
	c:RegisterEffect(e2)
		--destroy replace
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTarget(c100000965.destg)
	e4:SetValue(c100000965.value)
	e4:SetOperation(c100000965.desop)
	c:RegisterEffect(e4)
	end
function c100000965.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x768)
end
function c100000965.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c100000965.cfilter,1,nil)
end
function c100000965.ctop(e,tp,eg,ep,ev,re,r,rp)
		e:GetHandler():AddCounter(0x51,1)
end
function c100000965.dfilter(c,tp)
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE)
		and c:IsSetCard(0x768) and c:IsControler(tp) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
function c100000965.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local count=eg:FilterCount(c100000965.dfilter,nil,tp)
		e:SetLabel(count)
		return count>0 and Duel.IsCanRemoveCounter(tp,1,0,0x51,count*1,REASON_BATTLE+REASON_EFFECT)
	end
	return Duel.SelectYesNo(tp,aux.Stringid(100000965,1))
end
function c100000965.value(e,c)
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE)
		and c:IsSetCard(0x768) and c:IsControler(e:GetHandlerPlayer()) and c:IsReason(REASON_BATTLE+REASON_EFFECT) 
end
function c100000965.desop(e,tp,eg,ep,ev,re,r,rp)
	local count=e:GetLabel()
	Duel.RemoveCounter(tp,1,0,0x51,count*1,REASON_BATTLE+REASON_EFFECT)
end