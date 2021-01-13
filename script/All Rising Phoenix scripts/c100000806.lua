--魔轟神グリムロ
function c100000806.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,100000806)
	e1:SetCost(c100000806.cost)
	e1:SetTarget(c100000806.tg)
	e1:SetOperation(c100000806.op)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c100000806.spcon)
	c:RegisterEffect(e2)
	--synchro limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetValue(c100000806.synlimit)
	c:RegisterEffect(e3)
	--material
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(100000806,0))
	e4:SetCategory(CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BE_MATERIAL)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
	e4:SetCondition(c100000806.ddcon)
	e4:SetTarget(c100000806.ddtg)
	e4:SetOperation(c100000806.ddop)
	c:RegisterEffect(e4)
end
function c100000806.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c100000806.filter(c)
	return c:IsSetCard(0x767) and not (c:IsCode(100000808) or c:IsCode(100000809) or c:IsCode(100000806) or c:IsCode(100000804) or c:IsCode(100000801) or c:IsType(TYPE_SPELL+TYPE_TRAP)) and c:IsAbleToHand() and not c:IsHasEffect(EFFECT_NECRO_VALLEY) 
end
function c100000806.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100000806.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c100000806.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100000806.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then end
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
function c100000806.spfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x767) and not c:IsType(TYPE_TUNER)
end
function c100000806.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c100000806.spfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c100000806.synlimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x767)
end
function c100000806.ddcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_SYNCHRO
end
function c100000806.ddtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,1-tp,LOCATION_HAND)
end
function c100000806.ddop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetFieldGroup(p,0,LOCATION_HAND)
	if g:GetCount()>0 then
		Duel.ConfirmCards(p,g)
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
		local sg=g:Select(p,1,1,nil)
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
		Duel.ShuffleHand(1-p)
	end
end