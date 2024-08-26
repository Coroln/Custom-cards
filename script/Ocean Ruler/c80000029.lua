--Zerra, Ozeanherrscherin des Nordens
function c80000029.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c80000029.hspcon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--spsummon limit
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c80000029.limcon)
	e2:SetOperation(c80000029.limop)
	c:RegisterEffect(e2)
	--double tribute
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_DOUBLE_TRIBUTE)
	e3:SetValue(c80000029.condition)
	c:RegisterEffect(e3)
	--defense attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_DEFENSE_ATTACK)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--xyz limit
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e5:SetValue(c80000029.xyzlimit)
	c:RegisterEffect(e5)
end
function c80000029.filter(c)
	return c:IsCode(22702055)
end
function c80000029.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c80000029.filter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c80000029.limcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+1
end
function c80000029.limop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c80000029.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c80000029.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x1864)
end
function c80000029.condition(e,c)
	return c:IsRace(RACE_SEASERPENT)
end
function c80000029.xyzlimit(e,c)
	if not c then return false end
	return not c:IsAttribute(ATTRIBUTE_WATER) or not c:IsRace(RACE_SEASERPENT)
end
