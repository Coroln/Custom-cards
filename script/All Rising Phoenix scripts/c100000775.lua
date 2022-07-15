--Created and scripted by Rising Phoenix
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,id)
	e1:SetDescription(aux.Stringid(id,4))
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	e1:SetCondition(s.descon)
	c:RegisterEffect(e1)
		--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_SPSUMMON)
	e2:SetCountLimit(1,id)
	e2:SetDescription(aux.Stringid(id,3))
	e2:SetCondition(s.descon2)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.activate2)
	c:RegisterEffect(e2)
		--Activate
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCountLimit(1,id)
	e3:SetCode(EVENT_SUMMON)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetTarget(s.target3)
	e3:SetOperation(s.activate3)
	e3:SetCondition(s.descon3)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_FLIP_SUMMON)
	c:RegisterEffect(e4)
end
function s.coffilter(c)
	return c:IsFaceup() and c:IsSetCard(0x75F) and c:IsType(TYPE_MONSTER) 
end
function s.descon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain(true)==0 and Duel.GetLP(tp)<=5000 and Duel.IsExistingMatchingCard(s.coffilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) 
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,#eg,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,#eg,0,0)
end
function s.activate2(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
	end
function s.descon3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.coffilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) and Duel.GetLP(tp)<=7000 and Duel.GetCurrentChain()==0
end
function s.target3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function s.activate3(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
	end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.coffilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) and Duel.GetLP(tp)<=2000 and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then end
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then end
		Duel.Destroy(eg,REASON_EFFECT)
	end