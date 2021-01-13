--Created and scripted by Rising Phoenix
function c100000775.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,100000775)
	e1:SetDescription(aux.Stringid(100000775,4))
	e1:SetTarget(c100000775.target)
	e1:SetOperation(c100000775.activate)
	e1:SetCondition(c100000775.descon)
	c:RegisterEffect(e1)
		--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_SPSUMMON)
	e2:SetCountLimit(1,100000775)
	e2:SetDescription(aux.Stringid(100000775,3))
	e2:SetTarget(c100000775.target2)
	e2:SetOperation(c100000775.activate2)
	e2:SetCondition(c100000775.descon2)
	c:RegisterEffect(e2)
		--Activate
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCountLimit(1,100000775)
	e3:SetCode(EVENT_SUMMON)
	e3:SetDescription(aux.Stringid(100000775,2))
	e3:SetTarget(c100000775.target3)
	e3:SetOperation(c100000775.activate3)
	e3:SetCondition(c100000775.descon3)
	c:RegisterEffect(e3)
		local e4=e3:Clone()
	e4:SetCode(EVENT_FLIP_SUMMON)
	c:RegisterEffect(e4)
end
function c100000775.coffilter(c)
	return c:IsFaceup() and c:IsSetCard(0x75F) and c:IsType(TYPE_MONSTER) 
end
function c100000775.descon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c100000775.coffilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) and Duel.GetLP(tp)<=5000 and Duel.GetCurrentChain()==0
end
function c100000775.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function c100000775.activate2(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
	end
function c100000775.descon3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c100000775.coffilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) and Duel.GetLP(tp)<=7000 and Duel.GetCurrentChain()==0
end
function c100000775.target3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function c100000775.activate3(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
	end
function c100000775.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c100000775.coffilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) and Duel.GetLP(tp)<=2000 and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c100000775.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then end
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
end
function c100000775.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then end
		Duel.Destroy(eg,REASON_EFFECT)
	end