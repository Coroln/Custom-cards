local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(s.cost)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local token=Duel.CreateToken(tp,76103675)
	Duel.SendtoHand(token,nil,REASON_EFFECT)
	local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e1:SetCode(EVENT_CHAINING)
		e1:SetProperty(EFFECT_FLAG_DELAY)
		e1:SetCondition(s.drawcon)
		e1:SetOperation(s.drawop)
		Duel.RegisterEffect(e1,tp)
end
function s.drawcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and (re:GetHandler():IsCode(76103675) or re:GetHandler():IsCode(46130346) or re:GetHandler():IsCode(19523799))
end
function s.drawop(e,tp,eg,ep,ev,re,r,rp)
	--if e:GetHandler():GetFlagEffect(id)~=0 then
	Duel.Draw(tp,1,REASON_EFFECT)
	local gc=Duel.GetMatchingGroupCount(Card.IsCode,tp,LOCATION_GRAVE,0,nil,76103675)
	if gc>0 then
		Duel.Damage(1-tp,300*gc,REASON_EFFECT)
	end
	--end
end