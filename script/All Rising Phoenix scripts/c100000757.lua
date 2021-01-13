--Created and scripted by Rising Phoenix
function c100000757.initial_effect(c)
	--control
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_CHANGE_CONTROL)
	c:RegisterEffect(e1)
		--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c100000757.splimit)
	c:RegisterEffect(e2)
		--cannot release
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_FIELD)
	e12:SetRange(LOCATION_MZONE)
	e12:SetCode(EFFECT_CANNOT_RELEASE)
	e12:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e12:SetTargetRange(1,0)
	c:RegisterEffect(e12)
		--cannot special summon
	local e11=Effect.CreateEffect(c)
	e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_SPSUMMON_CONDITION)
	e11:SetValue(aux.FALSE)
	c:RegisterEffect(e11)
		local e9=Effect.CreateEffect(c)
e9:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e9:SetRange(LOCATION_DECK)
	e9:SetCode(EVENT_SPSUMMON_SUCCESS)
		e9:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
			e9:SetCondition(c100000757.condition2)
			e9:SetDescription(aux.Stringid(100000757,0))
	e9:SetTarget(c100000757.target)
		e9:SetCountLimit(1,100000757)
	e9:SetOperation(c100000757.operation)
	c:RegisterEffect(e9)
end
function c100000757.condition2(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(c100000757.filter,1,nil,tp)
end
function c100000757.splimit(e,c)
	return not (c:IsSetCard(0x75A) or c:IsCode(100001193))
end
function c100000757.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x75A) and c:IsType(TYPE_XYZ)
end
function c100000757.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c100000757.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100000757.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c100000757.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c100000757.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Overlay(tc,Group.FromCards(c))
	end
end
