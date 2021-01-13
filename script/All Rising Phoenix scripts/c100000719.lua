--scripted and created by rising phoenix
function c100000719.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_SELF_TOGRAVE)
		--act in hand
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e7:SetCondition(c100000719.handcon)
	c:RegisterEffect(e7)
	--summon count limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	e2:SetTarget(c100000719.limittg)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	c:RegisterEffect(e4)
	local e5=e2:Clone()
	e5:SetCode(EFFECT_CANNOT_MSET)
	c:RegisterEffect(e5)
	--counter
	local et=Effect.CreateEffect(c)
	et:SetType(EFFECT_TYPE_FIELD)
	et:SetCode(EFFECT_LEFT_SPSUMMON_COUNT)
	et:SetRange(LOCATION_SZONE)
	et:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	et:SetTargetRange(0,1)
	et:SetValue(c100000719.countval)
	c:RegisterEffect(et)
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
	e12:SetCondition(c100000719.descon)
	c:RegisterEffect(e12)
end
function c100000719.descon(e)
	return not Duel.IsExistingMatchingCard(c100000719.filterd,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function c100000719.limittg(e,c,tp)
	local t1,t2,t3,t4=Duel.GetActivityCount(tp,ACTIVITY_SUMMON,ACTIVITY_FLIPSUMMON,ACTIVITY_SPSUMMON,ACTIVITY_MSET)
	return t1+t2+t3+t4>=1
end
function c100000719.countval(e,re,tp)
	local t1,t2,t3,t4=Duel.GetActivityCount(tp,ACTIVITY_SUMMON,ACTIVITY_FLIPSUMMON,ACTIVITY_SPSUMMON,ACTIVITY_MSET)
	if t1+t2+t3+t4>=1 then return 0 else return 1-t1-t2-t3-t4 end
end

function c100000719.handcon(e)
	return Duel.IsExistingMatchingCard(c100000719.filter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function c100000719.filterd(c)
	return c:IsFaceup() and c:IsSetCard(0x764) and c:IsType(TYPE_MONSTER)
end
function c100000719.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x764) and c:IsType(TYPE_MONSTER)
end