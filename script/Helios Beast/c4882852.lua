--Macro Cosmos, Folded
--Script by Coroln
local s,id=GetID()
function s.initial_effect(c)
    --Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
    --"Macro Cosmos" you control unaffected by card effects
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(0x5f)
	e1:SetTargetRange(LOCATION_SZONE,0)
	e1:SetTarget(function(e,c) return c:IsCode(30241314) and c:IsFaceup() end)
	e1:SetValue(s.efilter)
	c:RegisterEffect(e1)
    --opponent unaffected by "Macro Cosmos"
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(0xff)
	e2:SetTargetRange(0,LOCATION_ALL)
	e2:SetValue(s.efilter2)
	c:RegisterEffect(e2)
end
s.listed_names={30241314}
--Unaffected by opponent's card effects
function s.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function s.efilter2(e,te)
	return te:GetHandler():IsCode(30241314)
end