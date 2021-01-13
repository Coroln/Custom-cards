--scripted and created by rising phoenix
function c100000711.initial_effect(c)	
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e2)
		--lv change
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100000711,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c100000711.target)
	e1:SetOperation(c100000711.operation)
	c:RegisterEffect(e1)
		--tohand
	local e7=Effect.CreateEffect(c)
		e7:SetHintTiming(TIMING_STANDBY_PHASE,0)
	e7:SetDescription(aux.Stringid(100000711,0))
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e7:SetRange(LOCATION_FZONE)
	e7:SetCountLimit(1)
		e7:SetCost(c100000711.cost)
	e7:SetOperation(c100000711.tdop)
		e7:SetCode(EVENT_PHASE+PHASE_STANDBY)
	c:RegisterEffect(e7)
		--todeck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100000711,0))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCondition(c100000711.retcon)
	e3:SetTarget(c100000711.rettg)
	e3:SetOperation(c100000711.retop)
	c:RegisterEffect(e3)
end
function c100000711.retcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_DESTROY)
end
function c100000711.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() end
	e:GetHandler():CreateEffectRelation(e)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c100000711.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoDeck(c,nil,REASON_EFFECT,nil)
		Duel.ConfirmCards(1-tp,c)
	end
end
function c100000711.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100000711.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c100000711.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c100000711.cfilter(c)
	return (c:IsSetCard(0x751) or c:IsSetCard(0x752)) and (c:IsAbleToDeckAsCost() or c:IsAbleToExtraAsCost()) 
end
function c100000711.tdop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
		local g2=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_SZONE,1,1,nil)
		if g2:GetCount()>0 then Duel.SendtoDeck(g2,nil,2,REASON_EFFECT) end
end
function c100000711.filter(c)
	return c:IsFaceup() and (c:IsSetCard(0x751) or c:IsSetCard(0x752)) and c:IsLevelAbove(1)
end
function c100000711.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c100000711.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100000711.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c100000711.filter,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	local op=0
	if tc:GetLevel()==1 then op=Duel.SelectOption(tp,aux.Stringid(100000711,1))
	else op=Duel.SelectOption(tp,aux.Stringid(100000711,1),aux.Stringid(100000711,2)) end
	e:SetLabel(op)
end
function c100000711.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		if e:GetLabel()==0 then
			e1:SetValue(1)
		else e1:SetValue(-1) end
		tc:RegisterEffect(e1)
	end
end