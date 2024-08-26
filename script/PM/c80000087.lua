--PM Mega Schlapor
function c80000087.initial_effect(c)
	c:EnableReviveLimit()
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(80000087,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCondition(c80000087.descon)
	e1:SetTarget(c80000087.destg)
	e1:SetOperation(c80000087.desop)
	c:RegisterEffect(e1)
	--actlimit
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(80000087,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetTarget(c80000087.target)
	e2:SetOperation(c80000087.operation)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,80000087)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c80000087.thtg)
	e3:SetOperation(c80000087.thop)
	c:RegisterEffect(e3)
end
function c80000087.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_RITUAL)
end
function c80000087.filter(c)
	return c:IsFaceup()
end
function c80000087.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c80000087.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c80000087.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c80000087.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c80000087.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_RITUAL)
end
function c80000087.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c80000087.cfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c80000087.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c80000087.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c80000087.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAINING)
		e1:SetCondition(c80000087.actcon)
		e1:SetOperation(c80000087.actop)
		e1:SetLabelObject(tc)
		Duel.RegisterEffect(e1,tp)
		tc:RegisterFlagEffect(c80000087,RESET_EVENT+RESETS_STANDARD+RESET_CONTROL,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(80000087,2))
	end
end
function c80000087.actcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(80000087)==0 then
		e:Reset()
		return false
	end
	return tc:GetFlagEffect(80000087)>0
end
function c80000087.actop(e,tp,eg,ep,ev,re,r,rp)
	if re:IsActiveType(TYPE_RITUAL) and re:IsActiveType(TYPE_MONSTER) and ep==tp then
		Duel.SetChainLimit(c80000087.chainlm)
	end
end
function c80000087.chainlm(e,rp,tp)
	return tp==rp
end
function c80000087.thfilter(c)
	return c:IsSetCard(0x7cc) and c:IsAbleToHand() and not c:IsCode(80000087)
end
function c80000087.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80000087.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c80000087.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c80000087.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
