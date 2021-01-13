 --Created and coded by Rising Phoenix
function c100000992.initial_effect(c)
		local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100000992,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c100000992.recop)
	c:RegisterEffect(e1)
			--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c100000992.cost)
	e2:SetTarget(c100000992.targetb)
	e2:SetOperation(c100000992.op)
	c:RegisterEffect(e2)
end
function c100000992.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c100000992.filter(c,e,sp)
	return (c:IsCode(64631466) or c:IsCode(78063197) or c:IsCode(41426869) or c:IsCode(100000990) or c:IsCode(100000991) or c:IsCode(100000993) or c:IsCode(15173384) or c:IsCode(89785779) or c:IsCode(63519819) or c:IsCode(41578483)) and (c:IsAbleToDeck()  or c:IsAbleToExtra()) and c:IsFaceup()
end
function c100000992.targetb(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100000992.filter,tp,LOCATION_REMOVED,0,1,nil) end
	local g=Duel.GetMatchingGroup(c100000992.filter,tp,LOCATION_REMOVED,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c100000992.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c100000992.filter,tp,LOCATION_REMOVED,0,nil)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		end
function c100000992.filter1(c)
	return (c:IsCode(100000990) or c:IsCode(100000991) or c:IsCode(100000993) or c:IsCode(15173384) or c:IsCode(89785779) or c:IsCode(63519819) or c:IsCode(41578483)) and c:IsAbleToHand()
end
function c100000992.recop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100000992.filter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end