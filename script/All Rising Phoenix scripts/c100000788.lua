function c100000788.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x754))
	e3:SetValue(c100000788.val)
	c:RegisterEffect(e3)
		local e9=e3:Clone()
	e9:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e9)
		local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(100000788,1))
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetCountLimit(1)
	e5:SetRange(LOCATION_FZONE)
	e5:SetTarget(c100000788.rmtgr)
	e5:SetOperation(c100000788.rmopr)
	c:RegisterEffect(e5)
end
function c100000788.filt(c)
	return c:IsSetCard(0x754) and c:IsType(TYPE_EQUIP) and c:IsFaceup()
end
function c100000788.val(e,c)
	return Duel.GetMatchingGroupCount(c100000788.filt,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,nil)*500
end
function c100000788.filterrgr(c)
	return  c:IsSetCard(0x754) and c:IsType(TYPE_EQUIP) and c:IsAbleToHand()
end
function c100000788.rmtgr(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100000788.filterrgr,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c100000788.rmopr(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOHAND)
	local g=Duel.SelectMatchingCard(tp,c100000788.filterrgr,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then  end
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
end