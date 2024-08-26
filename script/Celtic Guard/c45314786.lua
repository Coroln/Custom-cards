--炎舞－「天璣」
function c45314786.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,45314786+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c45314786.activate)
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
function c45314786.filter(c)
	return c:IsLevelBelow(4) and c:IsRace(RACE_BEAST) or c:IsRace(RACE_WARRIOR) and c:IsAbleToHand()
end
function c45314786.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c45314786.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(45314786,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
