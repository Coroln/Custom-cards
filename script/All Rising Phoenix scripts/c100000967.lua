function c100000967.initial_effect(c)
	c:EnableCounterPermit(0x51)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
		e2:SetCondition(c100000967.ctcon)
	e2:SetRange(LOCATION_FZONE)
	e2:SetOperation(c100000967.ctop)
	c:RegisterEffect(e2)
		--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x768))
	e3:SetValue(c100000967.atkval)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
		--destroy
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetCountLimit(1)
	e5:SetDescription(aux.Stringid(100000967,1))
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_FZONE)
		e5:SetTarget(c100000967.destg)
	e5:SetCost(c100000967.cost2)
	e5:SetOperation(c100000967.op2)
	c:RegisterEffect(e5)	
	end
	function c100000967.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsDestructable() end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c100000967.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x51,1,REASON_COST) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	e:GetHandler():RemoveCounter(tp,0x51,1,REASON_COST)
end
function c100000967.op2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then end
		Duel.Destroy(tc,REASON_EFFECT)
	end
function c100000967.atkval(e,c)
	return Duel.GetCounter(0,1,1,0x51)*100
end
function c100000967.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x768)
end
function c100000967.ctop(e,tp,eg,ep,ev,re,r,rp)
		e:GetHandler():AddCounter(0x51,1)
end
function c100000967.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c100000967.cfilter,1,nil)
end