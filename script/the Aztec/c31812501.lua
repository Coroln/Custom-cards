--Stone Temple of the Aztecs
--Script by Coroln
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
    --immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(s.itg)
	e1:SetValue(s.ifilter)
	c:RegisterEffect(e1)
    --Opponent's monsters must attack a "the Aztec" monster
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_MUST_ATTACK)
    e2:SetRange(LOCATION_FZONE)
    e2:SetTargetRange(0,LOCATION_MZONE)
    e2:SetCondition(function(e) return Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsAztec),e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil) end)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EFFECT_MUST_ATTACK_MONSTER)
    e3:SetValue(aux.TargetBoolFunction(Card.IsAztec))
    c:RegisterEffect(e3)
    --Pos Change
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_SET_POSITION)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTarget(s.target)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetValue(POS_FACEUP_ATTACK)
	c:RegisterEffect(e4)
end
s.listed_series={0x39F}
s.listed_names={id}
s.listed_names={31812496}
--immune
function s.itg(e,c)
	return (c:IsSetCard(0x39F) or c:IsCode(31812496))
end
function s.ifilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end
--Opponent's monsters must attack a "the Aztec" monster
--Anders wollte es nicht gehen :(
    function Card.IsAztec(c)
        return (c:IsCode(31812496) or c:IsSetCard(0x39F))
    end
--pos change
function s.target(e,c)
	return c:IsFaceup()
end
