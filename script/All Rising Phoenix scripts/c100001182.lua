 --Created and coded by Rising Phoenix
function c100001182.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetCategory(CATEGORY_DAMAGE+CATEGORY_RECOVER)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c100001182.ctcon)
	e2:SetOperation(c100001182.rmop)
	e2:SetTarget(c100001182.rmtg)
	c:RegisterEffect(e2)
		--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c100001182.destg)
	e3:SetValue(1)
		e3:SetOperation(c100001182.repop)
e3:SetValue(c100001182.repval)
	c:RegisterEffect(e3)
	end
	function c100001182.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGrave() and eg:IsExists(c100001182.repfilter,1,nil,tp) end
	return Duel.SelectYesNo(tp,aux.Stringid(100001182,0)) 
end
function c100001182.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
end
function c100001182.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
		and c:IsSetCard(0x764) and c:IsReason(REASON_EFFECT+REASON_BATTLE)
end
function c100001182.filter22(c,tp)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP)
		and c:IsControler(tp) and c:IsSetCard(0x764) and c:IsType(TYPE_TRAP+TYPE_CONTINUOUS)
end
function c100001182.repval(e,c)
	return c100001182.repfilter(c,e:GetHandlerPlayer())
end
function c100001182.ctcon(e,tp,eg,ep,ev,re,r,rp)
return eg:IsExists(c100001182.filter22,1,nil,tp)
end
function c100001182.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,300)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,300)
end
function c100001182.rmop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Damage(1-tp,300,REASON_EFFECT,true)
	Duel.Recover(tp,300,REASON_EFFECT,true)
	Duel.RDComplete()
end