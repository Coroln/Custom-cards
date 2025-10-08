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
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x1a))
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3 = e2:Clone()
	e3:SetTarget(aux.TargetBoolFunction(Card.IsCode,76922029))
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x1a))
	e4:SetValue(s.aclimit)
	c:RegisterEffect(e4)
	local e5 = e4:Clone()
	e5:SetTarget(aux.TargetBoolFunction(Card.IsCode,76922029))
	c:RegisterEffect(e5)
end
function s.efftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToHand() end
	local b1=Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
	local b2=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0
	if chk==0 then return b1 or b2 end
	local op=Duel.SelectEffect(tp,
		{b1,aux.Stringid(id,1)},
		{b2,aux.Stringid(id,2)})
	e:SetLabel(op)
	if op==1 then
		e:SetCategory(CATEGORY_TOHAND)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	else
		e:SetCategory(0)
		e:SetProperty(0)
	end
end
function s.effop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==1 then
		--Return 1 card on the field to the hand
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
	else
		--Look at the top card of the opponent's Deck
		local g=Duel.GetDecktopGroup(1-tp,1)
		if #g>0 then
			Duel.ConfirmCards(tp,g)
			Duel.Hint(HINT_SELECTMSG,tp,0)
			local ac=Duel.SelectOption(tp,aux.Stringid(id,3),aux.Stringid(id,4))
			if ac==1 then Duel.MoveSequence(g:GetFirst(),1) end
		end
	end
end
function s.filter(c,tp)
	return c:IsControler(tp) and c:IsFaceup() and c:IsMonster() and (c:IsSetCard(SET_DARK_SCORPION) or c:IsCode(76922029))
end
function s.aclimit(e,rc)
	return rc:GetColumnGroup():IsExists(s.filter,1,c,e:GetHandler():GetOwner())
end