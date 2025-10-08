local s,id=GetID()
function s.initial_effect(c)
	--Activate 1 of these effects
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return ep==1-tp end)
	e1:SetTarget(s.efftg)
	e1:SetOperation(s.effop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetTarget(s.aclimit)
	c:RegisterEffect(e2)
	--ATKup Scorpion
	local e3 = Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x1a))
	e3:SetValue(300)
	c:RegisterEffect(e3)
	--ATKup Don Zaloog
	local e4 = e3:Clone()
	e4:SetTarget(aux.TargetBoolFunction(Card.IsCode,76922029))
	c:RegisterEffect(e4)
end
function s.efftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsAbleToDeck() end
	local b1=Duel.IsExistingTarget(Card.IsAbleToDeck,tp,0,LOCATION_MZONE,1,nil)
	local b2=Duel.IsPlayerCanDiscardDeck(1-tp,1)
	if chk==0 then return b1 or b2 end
	local op=Duel.SelectEffect(tp,
		{b1,aux.Stringid(id,1)},
		{b2,aux.Stringid(id,2)})
	e:SetLabel(op)
	if op==1 then
		e:SetCategory(CATEGORY_TODECK)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,0,LOCATION_MZONE,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,tp,0)
	else
		e:SetCategory(CATEGORY_DECKDES)
		e:SetProperty(0)
		Duel.SetOperationInfo(0,CATEGORY_DECKDES,0,0,1-tp,1)
	end
end
function s.effop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==1 then
		--Return 1 monster your opponent controls to the top of the Deck
		local tc=Duel.GetFirstTarget()
		if not (tc:IsRelateToEffect(e) and tc:IsControler(1-tp)) then return end
		Duel.SendtoDeck(tc,nil,SEQ_DECKTOP,REASON_EFFECT)
	else
		--Send the top card of your opponent's Deck to the GY
		Duel.DiscardDeck(1-tp,1,REASON_EFFECT)
	end
end
function filter(c,tp)
	return c:IsControler(tp) and c:IsFaceup() and c:IsMonster() and (c:IsSetCard(SET_DARK_SCORPION) or c:IsCode(76922029))
end
function s.aclimit(e,c)
	local tp=e:GetHandlerPlayer()
	return c:GetColumnGroup():IsExists(filter,1,c,tp)
end
