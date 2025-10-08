local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetRange(LOCATION_MZONE)
	e0:SetTargetRange(LOCATION_MZONE,0)
	e0:SetCode(EFFECT_UPDATE_ATTACK)
	e0:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_DINOSAUR))
	e0:SetValue(200)
	c:RegisterEffect(e0)
	--summon success
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(s.con)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.con(e)
	return Duel.GetTurnCount()==1
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_BP_FIRST_TURN)
		e1:SetTargetRange(1,1)
		Duel.RegisterEffect(e1,tp)
end