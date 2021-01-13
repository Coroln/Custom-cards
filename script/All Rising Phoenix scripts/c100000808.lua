function c100000808.initial_effect(c)
	--synchro limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(c100000808.synlimit)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100000808,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCost(c100000808.cost)
	e2:SetTarget(c100000808.targetf)
	e2:SetOperation(c100000808.operationf)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100000808,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,100000808)
	e3:SetTarget(c100000808.target)
	e3:SetOperation(c100000808.operation)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
end
function c100000808.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c100000808.synlimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x767)
end
function c100000808.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c100000808.filter(c)
	return c:GetCode()==100000810 and c:IsAbleToHand()
end
function c100000808.targetf(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c100000808.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c100000808.operationf(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.GetFirstMatchingCard(c100000808.filter,tp,LOCATION_GRAVE,0,nil)
	if tg then end
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
function c100000808.filterf(c)
	return c:IsSetCard(0x767) and c:IsType(TYPE_MONSTER) and not c:IsCode(100000808) and not c:IsCode(100000802) and not c:IsCode(100000809) and c:IsAbleToHand()
end
function c100000808.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100000808.filterf,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c100000808.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100000808.filterf,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then end
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
end