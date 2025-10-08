local s,id=GetID()
function s.initial_effect(c)
	--Change all of opponent's monsters to attack position, must attack if able to
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_STANDBY_PHASE)
	e1:SetCondition(s.condition)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and Duel.GetCurrentPhase()==PHASE_STANDBY
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
			--Must attack, if able to
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_MUST_ATTACK)
			e1:SetTargetRange(0,LOCATION_MZONE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
			--Cannot change their battle positions
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetCode(EFFECT_SET_POSITION)
			e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e2:SetTargetRange(0,LOCATION_MZONE)
			e2:SetValue(POS_FACEUP_ATTACK+NO_FLIP_EFFECT)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e2,tp)
			local e3=e2:Clone()
			e3:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
			Duel.RegisterEffect(e3,tp)
end