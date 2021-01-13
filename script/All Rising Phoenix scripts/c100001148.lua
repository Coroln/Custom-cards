--Jedes Böhnchen gibt ein Tönchen by Tobiz
function c100001148.initial_effect(c)
c:EnableCounterPermit(0x52)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c100001148.ctcon)
	e2:SetOperation(c100001148.ctop)
	c:RegisterEffect(e2)
		local e5=e2:Clone()
	e5:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e5)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
		--destroy replace
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTarget(c100001148.destg)
	e4:SetValue(c100001148.value)
	e4:SetOperation(c100001148.desop)
	c:RegisterEffect(e4)
	end
function c100001148.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x755)
end
function c100001148.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c100001148.cfilter,1,nil) 
end
function c100001148.ctop(e,tp,eg,ep,ev,re,r,rp)
		e:GetHandler():AddCounter(0x52,1)
end
function c100001148.dfilter(c,tp)
	return c:IsFaceup() and c:IsLocation(LOCATION_ONFIELD)
		and c:IsSetCard(0x755) and c:IsControler(tp) and c:IsReason(REASON_BATTLE) and c:IsType(TYPE_MONSTER)
end
function c100001148.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x52,1,REASON_COST) and eg:IsExists(c100001148.dfilter,1,nil,tp)
	end
	return Duel.SelectYesNo(tp,aux.Stringid(100001148,0))
end
function c100001148.value(e,c)
return c100001148.dfilter(c,e:GetHandlerPlayer())
end
function c100001148.desop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveCounter(tp,0x52,1,REASON_EFFECT,nil,nil)
end