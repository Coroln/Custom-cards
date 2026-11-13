--Fallen God, Mokey Mokey
local s,id=GetID()
function s.initial_effect(c)
	--Normal Summon with 3 Tributes
	aux.AddNormalSummonProcedure(c,true,false,3,3)
	aux.AddNormalSetProcedure(c)
	--Cannot be Special Summoned
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	--This card's Normal Summon cannot be negated
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
	c:RegisterEffect(e1)
	--Other cards and effects cannot be activated when Normal Summoned
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetOperation(function(e) Duel.SetChainLimitTillChainEnd(s.genchainlm(e:GetHandler())) end)
	c:RegisterEffect(e2)
	--change name
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
--	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_CHANGE_CODE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetValue(27288416)
	c:RegisterEffect(e3)
	--Immune
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(aux.tgoval)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e5:SetValue(s.tgvalue)
	c:RegisterEffect(e5)
	--Register if a monster leaves the field
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_LEAVE_FIELD)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(s.regcon)
	e6:SetOperation(function(e) return e:GetHandler():RegisterFlagEffect(id,RESETS_STANDARD_PHASE_END,0,1) end)
	c:RegisterEffect(e6)
	--The ATK of each "Mokey Mokey" you control will become 3000
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_SET_ATTACK)
	e7:SetRange(LOCATION_MZONE)
	e7:SetTargetRange(LOCATION_MZONE,0)
	e7:SetCondition(function(e) return e:GetHandler():HasFlagEffect(id) end)
	e7:SetTarget(function(e,c) return c:IsCode(27288416) and c:IsFaceup() end)
	e7:SetValue(3000)
	c:RegisterEffect(e7)
end
s.listed_names={27288416,id}
s.listed_series={SET_MOKEY_MOKEY}
function s.genchainlm(c)
	return	function(e,rp,tp)
			return e:GetHandler()==c
		end
end
function s.tgvalue(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
function s.regconfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE)-- and c:IsPreviousPosition(POS_FACEUP)
		and c:IsPreviousControler(tp) and c:GetReasonPlayer()==1-tp
end
function s.regcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():HasFlagEffect(id) and eg:IsExists(s.regconfilter,1,nil,tp)
		and Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,27288416),tp,LOCATION_MZONE,0,1,nil)
end

