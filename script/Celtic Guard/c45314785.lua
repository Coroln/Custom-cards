--炎舞－「揺光」
function c45314785.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c45314785.target)
	e1:SetOperation(c45314785.activate)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_BEAST))
	e2:SetValue(200)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_WARRIOR))
	c:RegisterEffect(e3)
end
function c45314785.filter(c)
	return c:IsFaceup()
end
function c45314785.filter2(c)
	return c:IsRace(RACE_BEAST) or c:IsRace(RACE_WARRIOR) and c:IsDiscardable()
end
function c45314785.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() and c45314785.filter(chkc) end
	if chk==0 then return true end
	if Duel.IsExistingTarget(c45314785.filter,tp,0,LOCATION_ONFIELD,1,nil)
		and Duel.IsExistingMatchingCard(c45314785.filter2,tp,LOCATION_HAND,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(45314785,0)) then
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectTarget(tp,c45314785.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	else
		e:SetProperty(0)
	end
end
function c45314785.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if not tc then return end
	if Duel.DiscardHand(tp,c45314785.filter2,1,1,REASON_EFFECT+REASON_DISCARD)>0 and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
