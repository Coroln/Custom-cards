local s,id=GetID()
function s.initial_effect(c)
	--synchro summon
	Synchro.AddProcedure(c,nil,1,1,Synchro.NonTuner(nil),1,99)
	c:EnableReviveLimit()
	--immune
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCode(EFFECT_IMMUNE_EFFECT)
	e0:SetValue(s.efilter)
	c:RegisterEffect(e0)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(s.val)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetCode(EFFECT_PUBLIC)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(function(e) return Duel.HasFlagEffect(e:GetHandlerPlayer(),id) end)
	e2:SetTargetRange(0,LOCATION_ONFIELD)
	c:RegisterEffect(e2)
end
function s.val(e,c)
	return Duel.GetMatchingGroupCount(Card.IsAttribute,c:GetControler(),0,LOCATION_GRAVE,nil,ATTRIBUTE_LIGHT)*200
end
function s.efilter(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetHandler():IsAttribute(ATTRIBUTE_LIGHT)
end