--魔轟神ヴァルキュルス
local s,id=GetID()
function s.initial_effect(c)
	--synchro summon
	Synchro.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x767),1,1,Synchro.NonTunerEx(Card.IsSetCard,0x767),1,99)
	c:EnableReviveLimit()
	--cannot be target/battle indestructable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(s.target)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(s.val)
	c:RegisterEffect(e3)
	--defup
	local e9=e3:Clone()
	e9:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e9)
end
function s.filt(c)
	return c:IsSetCard(0x767) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function s.val(e,c)
	return Duel.GetMatchingGroupCount(s.filt,c:GetControler(),LOCATION_GRAVE,0,nil)*100
end
function s.target(e,c)
	return c~=e:GetHandler() and c:IsSetCard(0x767) and c:IsType(TYPE_MONSTER)
end