function c100000942.initial_effect(c)
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
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x766))
	e3:SetValue(c100000942.val)
	c:RegisterEffect(e3)
			--defup
	local e9=e3:Clone()
	e9:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e9)
		--search
	local e2=Effect.CreateEffect(c)
	e2:SetCondition(c100000942.hspcon)
	e2:SetDescription(aux.Stringid(100000942,0))
	e2:SetCategory(CATEGORY_CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1)
	e2:SetTarget(c100000942.target1)
	e2:SetOperation(c100000942.activate1)
	c:RegisterEffect(e2)
		--search
	local e4=Effect.CreateEffect(c)
	e4:SetCondition(c100000942.hspcon)
	e4:SetDescription(aux.Stringid(100000942,1))
	e4:SetCategory(CATEGORY_CATEGORY_POSITION)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1)
	e4:SetTarget(c100000942.target2)
	e4:SetOperation(c100000942.activate2)
	c:RegisterEffect(e4)
end
function c100000942.hspcon(e,tp,eg,ep,ev,re,r,rp)
		return Duel.IsExistingMatchingCard(c100000942.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c100000942.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x766)
end
function c100000942.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and c100000942.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100000942.filter,tp,0,LOCATION_SZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c100000942.filter,tp,0,LOCATION_SZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end 
function c100000942.filter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c100000942.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c100000942.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100000942.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c100000942.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c100000942.activate2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.ChangePosition(tc,POS_FACEDOWN)
	end
end
function c100000942.activate1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.ChangePosition(tc,POS_FACEDOWN_ATTACK,0,POS_FACEDOWN_DEFENSE,0)
	end
end
function c100000942.filt(c)
	return  c:IsFacedown()
end
function c100000942.val(e,c)
	return Duel.GetMatchingGroupCount(c100000942.filt,e:GetHandlerPlayer(),0,LOCATION_ONFIELD,nil)*100
end