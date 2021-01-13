 --Created and coded by Rising Phoenix
function c100000717.initial_effect(c)
c:EnableCounterPermit(0x53)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100000717,1))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_IGNITION)
		e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_FZONE)
e3:SetTarget(c100000717.target)
	e3:SetOperation(c100000717.operation)
	c:RegisterEffect(e3)
		--Add counter
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EVENT_CHAINING)
	e0:SetRange(LOCATION_SZONE)
	e0:SetOperation(aux.chainreg)
	c:RegisterEffect(e0)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c100000717.ctcon)
	e2:SetOperation(c100000717.ctop)
	c:RegisterEffect(e2)
	--atkup
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x764))
	e4:SetValue(c100000717.atkval)
	c:RegisterEffect(e4)
			--defup
	local e9=e4:Clone()
	e9:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e9)
	end
	function c100000717.filter22(c,tp)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP)
		and c:IsControler(tp) and c:IsSetCard(0x764) and c:IsType(TYPE_TRAP+TYPE_CONTINUOUS)
end
	function c100000717.ctcon(e,tp,eg,ep,ev,re,r,rp)
return	eg:IsExists(c100000717.filter22,1,nil,tp)
end
function c100000717.ctop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x53,1)
end
function c100000717.atkval(e,c)
	return e:GetHandler():GetCounter(0x53)*100
end
function c100000717.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c100000717.cfilter(chkc) end
	if chk==0 then return  Duel.IsPlayerCanDraw(tp,1)
	and Duel.IsExistingTarget(c100000717.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
		Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectTarget(tp,c100000717.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c100000717.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		if Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_DECK+LOCATION_EXTRA) then
			if tc:IsLocation(LOCATION_DECK) then Duel.ShuffleDeck(tp) end
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end

function c100000717.cfilter(c)
	return c:IsFaceup() and c:IsAbleToDeck() and c:IsSetCard(0x764)
end