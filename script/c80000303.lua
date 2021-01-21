--Noble Hero Alter Artoria
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0xBDF),5,2,nil,nil,7)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetCondition(s.hspcon)
	e1:SetValue(s.atkval)
	c:RegisterEffect(e1)
	--extra att
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EXTRA_ATTACK)
	e2:SetCondition(s.damcon)
	e2:SetValue(1)
	c:RegisterEffect(e2)
end
function s.filter(c)
	return c:IsCode(80000315)
end
function s.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_ONFIELD,0,1,nil)
end
function s.atkval(e,c)
	return c:GetOverlayCount()*500
end	
function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	return c:GetOverlayGroup():IsExists(Card.IsCode,1,nil,80000304)
end
