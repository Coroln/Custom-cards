--created and scripted by rising phoenix
function c100001191.initial_effect(c)
--fieldsp
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100001191,0))
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetOperation(c100001191.operation)
	e3:SetTarget(c100001191.target)
	e3:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e3)
		--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100001191,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c100001191.drcost)
	e2:SetTarget(c100001191.drtg)
	e2:SetOperation(c100001191.drop)
	c:RegisterEffect(e2)
end
function c100001191.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100001191.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c100001191.filter(c)
	return c:IsSetCard(0x767) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand() and not (c:IsCode(100000810) or c:IsCode(100001191))
end
function c100001191.drop(e,tp,eg,ep,ev,re,r,rp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100001191.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c100001191.cfilter(c)
	return c:IsCode(100000807) and c:IsAbleToRemoveAsCost()
end
function c100001191.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c100001191.cfilter,tp,LOCATION_GRAVE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c100001191.cfilter,tp,LOCATION_GRAVE,0,1,1,c)
	g:AddCard(c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c100001191.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100001191.filt,tp,LOCATION_MZONE,0,1,nil) end
end
function c100001191.filt(c)
	return c:IsFaceup() and c:IsSetCard(0x767) and c:IsType(TYPE_SYNCHRO)
end
function c100001191.efilter(e,re)
	return re:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c100001191.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c100001191.filt,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetOperation(c100001191.operation)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e3:SetValue(c100001191.efilter)
	tc:RegisterEffect(e3)
	tc=g:GetNext()
	end
end