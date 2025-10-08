local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetOperation(s.damop)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e3:SetOperation(s.regop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e4:SetOperation(s.drawop)
	c:RegisterEffect(e4)
end
s.listed_names={76103675}
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local token=Duel.CreateToken(tp,76103675)
	Duel.SendtoHand(token,nil,REASON_EFFECT)
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsCode(76103675) then
		e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1)
	end
end
function s.drawop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(id)~=0 and re:GetHandler():IsCode(76103675) and re:GetHandlerPlayer()==e:GetHandlerPlayer() then
		Duel.Recover(tp,800,REASON_EFFECT)
	end
end