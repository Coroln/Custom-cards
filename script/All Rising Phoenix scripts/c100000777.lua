--Created and scripted by Rising Phoenix
function c100000777.initial_effect(c)
		--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(100000777,2))
	e4:SetCountLimit(1,100000777)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c100000777.descon)
	e4:SetTarget(c100000777.destg)
	e4:SetCost(c100000777.spcost)
	e4:SetOperation(c100000777.desop)
	c:RegisterEffect(e4)	
			--destroy
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(100000777,3))
	e5:SetCountLimit(1,100000777)
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c100000777.descon2)
	e5:SetTarget(c100000777.destg2)
	e5:SetCost(c100000777.spcost)
	e5:SetOperation(c100000777.desop2)
	c:RegisterEffect(e5)
		--destroy
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(100000777,4))
	e6:SetCountLimit(1,100000777)
	e6:SetCategory(CATEGORY_DESTROY)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(c100000777.descon3)
	e6:SetTarget(c100000777.destg3)
	e6:SetCost(c100000777.spcost)
	e6:SetOperation(c100000777.desop3)
	c:RegisterEffect(e6)		
	--dam
		local e21=Effect.CreateEffect(c)
	e21:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e21:SetCategory(CATEGORY_DAMAGE)
	e21:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e21:SetRange(LOCATION_GRAVE)
	e21:SetCountLimit(1)
	e21:SetCondition(c100000777.damcon7)
	e21:SetTarget(c100000777.damtg7)
	e21:SetOperation(c100000777.damop7)
	c:RegisterEffect(e21)
end
function c100000777.cfilter(c)
	return c:IsSetCard(0x75F) and not c:IsPublic()
end
function c100000777.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100000777.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c100000777.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c100000777.damcon7(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c100000777.damtg7(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	local op=Duel.SelectOption(tp,aux.Stringid(100000777,0),aux.Stringid(100000777,1))
	e:SetLabel(op)
	if op==0 then
		e:SetCategory(CATEGORY_RECOVER)
		Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(300)
		Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,300)
	else
		e:SetCategory(CATEGORY_DAMAGE)
		Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(300)
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,300)
	end
end
function c100000777.damop7(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if e:GetLabel()==0 then
		Duel.Recover(p,d,REASON_EFFECT)
	else Duel.Damage(p,d,REASON_EFFECT) end
end
function c100000777.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)<=7000
end
function c100000777.filtertogr(c)
	return c:IsSetCard(0x75F) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c100000777.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		if chk==0 then return Duel.IsExistingMatchingCard(c100000777.filtertogr,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c100000777.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c100000777.filtertogr,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
		end
end
function c100000777.descon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)<=5000
end
function c100000777.filtertogr2(c)
	return c:IsSetCard(0x75F) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not c:IsCode(100000777)
end
function c100000777.destg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100000777.filtertogr2,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c100000777.desop2(e,tp,eg,ep,ev,re,r,rp)
		if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c100000777.filtertogr2,tp,LOCATION_GRAVE,0,nil)
	if g:GetCount()>0 then end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
end
function c100000777.descon3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)<=2000
end
function c100000777.filtertogr3(c)
	return c:IsSetCard(0x75F) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() 
end
function c100000777.destg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100000777.filtertogr3,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c100000777.desop3(e,tp,eg,ep,ev,re,r,rp)
			if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c100000777.filtertogr3,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 then end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
end