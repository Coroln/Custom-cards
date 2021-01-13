--scripted and created by rising phoenix
function c100000722.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_SELF_TOGRAVE)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100000722,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetTarget(c100000722.target)
	e1:SetOperation(c100000722.operation)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
		e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCondition(c100000722.plcon)
	e1:SetCountLimit(1)
	c:RegisterEffect(e1)
		--act in hand
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e3:SetCondition(c100000722.handcon)
	c:RegisterEffect(e3)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e2)
	--destroy
		--tograve
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_SELF_TOGRAVE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c100000722.sdcon)
	c:RegisterEffect(e4)
end
function c100000722.plcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp 
end
function c100000722.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,1-tp,LOCATION_HAND)
end
function c100000722.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0,nil)
	if g:GetCount()>0 then end
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TODECK)
	local sg=g:Select(1-tp,1,1,nil)
		Duel.HintSelection(sg)
	Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
end
function c100000722.sdcon(e)
	return not Duel.IsExistingMatchingCard(c100000722.sdfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function c100000722.ccfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x764) and c:IsType(TYPE_MONSTER)
end
function c100000722.handcon(e)
	return Duel.IsExistingMatchingCard(c100000722.filter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function c100000722.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x764) and c:IsType(TYPE_MONSTER)
end
function c100000722.sdfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x764) and c:IsType(TYPE_MONSTER)
end