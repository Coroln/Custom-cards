--Mechasect - Thunder Bee
--Script by Coroln
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(s.val)
	c:RegisterEffect(e2)
	--atk down (level)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetValue(s.val2)
	c:RegisterEffect(e3)
	--atk down (rank)
	local e3a=e3:Clone()
	e3a:SetValue(s.val3)
	c:RegisterEffect(e3a)
	--atk down (link)
	local e3b=e3:Clone()
	e3b:SetValue(s.val4)
	c:RegisterEffect(e3b)
	--def down (level)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
	--def down (rank)
	local e4a=e3:Clone()
	e4a:SetCode(EFFECT_UPDATE_DEFENSE)
	e4a:SetValue(s.val3)
	c:RegisterEffect(e4a)
end
s.listed_names={53790613}
--atkup
function s.valfilter(c)
	return (c:GetSummonType()&SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL
end
function s.val(e,c)
	return Duel.GetMatchingGroupCount(s.valfilter,c:GetControler(),0,LOCATION_MZONE,nil)*300
end
--atk/def down (level)
function s.val2(e,c)
	return c:GetLevel()*-100
end
--atk/def down (rank)
function s.val3(e,c)
	return c:GetRank()*-100
end
--atk down (link)
function s.val4(e,c)
	return c:GetLink()*-100
end
