--Noble Hero Herakles
local s,id=GetID()
function s.initial_effect(c)
--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCountLimit(1,id)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.spcon)
	c:RegisterEffect(e1)
	--battle indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e2:SetCondition(s.dircon)
	e2:SetCountLimit(1)
	e2:SetValue(s.valcon)
	c:RegisterEffect(e2)
end
function s.spfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xBDF)
end
function s.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and	Duel.IsExistingMatchingCard(s.spfilter,c:GetControler(),LOCATION_MZONE,0,2,nil)
end
function s.dircon(e)
	return Duel.IsEnvironment(80000315)
end

function s.valcon(e,re,r,rp)
	return (r&REASON_BATTLE)~=0
end
