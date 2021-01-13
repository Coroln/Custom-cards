--Created and scripted by Rising Phoenix
function c100000781.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
		--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100000781,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,100000781)
	e2:SetCost(c100000781.thcost)
	e2:SetTarget(c100000781.thtg)
	e2:SetOperation(c100000781.thop)
	c:RegisterEffect(e2)
end
function c100000781.filter(c)
	return c:IsSetCard(0x75F) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand() and not c:IsCode(100000781)
end
function c100000781.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c100000781.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100000781.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c100000781.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100000781.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end