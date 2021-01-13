 --Created and coded by Rising Phoenix
function c100000746.initial_effect(c)
	--Equip limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(c100000746.eqlimit)
	c:RegisterEffect(e1)
	--Atk,def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(c100000746.value)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	e3:SetValue(c100000746.value)
	c:RegisterEffect(e3)
		--Activate
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_EQUIP)
	e5:SetType(EFFECT_TYPE_ACTIVATE)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetTarget(c100000746.target)
	e5:SetOperation(c100000746.operation)
	c:RegisterEffect(e5)
end
function c100000746.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x754) and c:IsType(TYPE_MONSTER)
end
function c100000746.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and c100000746.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100000746.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c100000746.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c100000746.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end
function c100000746.eqlimit(e,c)
	return c:IsFaceup() and c:IsSetCard(0x754) and c:IsType(TYPE_MONSTER)
end
function c100000746.filt(c)
	return c:IsSetCard(0x754) and c:IsType(TYPE_EQUIP) and c:IsFaceup()
end
function c100000746.value(e,c)
	return Duel.GetMatchingGroupCount(c100000746.filt,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil)*500
end