--s4
function c100000839.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--avoid battle damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c100000839.con)
	e2:SetTarget(c100000839.infilter)
	e2:SetTargetRange(LOCATION_SZONE,0)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--todeck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100000839,0))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCondition(c100000839.retcon)
	e3:SetTarget(c100000839.rettg)
	e3:SetOperation(c100000839.retop)
	c:RegisterEffect(e3)
end
function c100000839.con(e)
	return Duel.IsExistingMatchingCard(c100000839.filter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c100000839.filter(c)
	return c:IsFaceup() and (c:IsSetCard(0x751) or c:IsSetCard(0x752))
end
function c100000839.infilter(e,c)
	return c:IsFaceup() and (c:IsCode(100000839) or c:IsCode(100000838) or c:IsCode(100000837) or c:IsCode(100000836))
end
function c100000839.retcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_DESTROY)
end
function c100000839.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() end
	e:GetHandler():CreateEffectRelation(e)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c100000839.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoDeck(c,nil,REASON_EFFECT,nil)
		Duel.ConfirmCards(1-tp,c)
	end
end