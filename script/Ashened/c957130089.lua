local s,id=GetID()

function s.initial_effect(c)
	--Equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(s.eqtg)
	e1:SetOperation(s.eqop)
	c:RegisterEffect(e1)

	--Set itself if destroyed while a Field Spell is on the field
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCondition(s.setcon)
	e2:SetTarget(s.settg)
	e2:SetOperation(s.setop)
	c:RegisterEffect(e2)

	--Add 1 DARK Pyro monster if banished
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_REMOVE)
	e3:SetCountLimit(1,{id,1})
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)
end

--Equip only to a DARK Pyro monster
function s.eqfilter(c)
	return c:IsFaceup()
		and c:IsAttribute(ATTRIBUTE_DARK)
		and c:IsRace(RACE_PYRO)
end

function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(LOCATION_MZONE) and s.eqfilter(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(
			s.eqfilter,
			tp,
			LOCATION_MZONE,
			LOCATION_MZONE,
			1,
			nil
		)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(
		tp,
		s.eqfilter,
		tp,
		LOCATION_MZONE,
		LOCATION_MZONE,
		1,
		1,
		nil
	)
end

function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()

	if not tc or not tc:IsFaceup() or not tc:IsRelateToEffect(e) then
		return
	end

	if not Duel.Equip(tp,c,tc) then
		return
	end

	--Equip limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(s.eqlimit)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)

	--Equipped monster gains 450 ATK
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(450)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e2)
end

function s.eqlimit(e,c)
	return c:IsFaceup()
		and c:IsAttribute(ATTRIBUTE_DARK)
		and c:IsRace(RACE_PYRO)
end

--Set condition
function s.setcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()

	--It must have actually been destroyed from the field
	--and must still be in the GY when the effect resolves
	return c:IsPreviousLocation(LOCATION_ONFIELD)
		and c:IsLocation(LOCATION_GRAVE)
		and Duel.IsExistingMatchingCard(
			Card.IsType,
			tp,
			LOCATION_ONFIELD,
			LOCATION_ONFIELD,
			1,
			nil,
			TYPE_FIELD
		)
end

function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return e:GetHandler():IsLocation(LOCATION_GRAVE)
			and e:GetHandler():IsSSetable()
	end
	Duel.SetOperationInfo(
		0,
		CATEGORY_LEAVE_GRAVE,
		e:GetHandler(),
		1,
		0,
		0
	)
end

function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()

	--Must still be in the GY
	if c:IsLocation(LOCATION_GRAVE) and c:IsSSetable() then
		Duel.SSet(tp,c)

		--Banish it when it leaves the field
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(3300)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1)
	end
end

--If this card is banished: add 1 DARK Pyro monster from Deck
function s.thfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK)
		and c:IsRace(RACE_PYRO)
		and c:IsAbleToHand()
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(
			s.thfilter,
			tp,
			LOCATION_DECK,
			0,
			1,
			nil
		)
	end

	Duel.SetOperationInfo(
		0,
		CATEGORY_TOHAND,
		nil,
		1,
		tp,
		LOCATION_DECK
	)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)

	local g=Duel.SelectMatchingCard(
		tp,
		s.thfilter,
		tp,
		LOCATION_DECK,
		0,
		1,
		1,
		nil
	)

	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
