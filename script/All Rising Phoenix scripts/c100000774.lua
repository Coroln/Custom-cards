--Created and scripted by Rising Phoenix
local s,id=GetID()
function s.initial_effect(c)
	Xyz.AddProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x75F),3,2)
	c:EnableReviveLimit()
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetCountLimit(1,id)
	e4:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCost(s.cost)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(s.descon)
	e4:SetTarget(s.destg)
	e4:SetOperation(s.desop)
	c:RegisterEffect(e4)	
	--destroy
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,3))
	e5:SetCountLimit(1,id)
	e5:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetCost(s.cost)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(s.descon2)
	e5:SetTarget(s.destg2)
	e5:SetOperation(s.desop2)
	c:RegisterEffect(e5)
	--destroy
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,4))
	e6:SetCountLimit(1,id)
	e6:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetCost(s.cost)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(s.descon3)
	e6:SetTarget(s.destg3)
	e6:SetOperation(s.desop3)
	c:RegisterEffect(e6)		
	--recover
	local e1=Effect.CreateEffect(c)
	e1:SetCost(s.cost2)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	--recover
	local e1=Effect.CreateEffect(c)
	e1:SetCost(s.cost2)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetTarget(s.target2)
	e1:SetOperation(s.operation2)
	c:RegisterEffect(e1)
end
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_GRAVE,0,1,nil,0x75F) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,0)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local d=Duel.GetMatchingGroupCount(Card.IsSetCard,tp,LOCATION_GRAVE,0,nil,0x75F)*100
	Duel.Damage(p,d,REASON_EFFECT)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_GRAVE,0,1,nil,0x75F) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local d=Duel.GetMatchingGroupCount(Card.IsSetCard,tp,LOCATION_GRAVE,0,nil,0x75F)*100
	Duel.Recover(p,d,REASON_EFFECT)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function s.cfilter(c)
	return c:IsSetCard(0x75F)
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)<=7000
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,nil) end
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
		local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(250)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
end
end
function s.descon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)<=5000
end
function s.destg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,nil) end
end
function s.desop2(e,tp,eg,ep,ev,re,r,rp)
		local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do 
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
end
end
function s.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x75F) and c:IsType(TYPE_MONSTER)
end
function s.descon3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)<=2000
end
function s.destg3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,nil) end
end
function s.desop3(e,tp,eg,ep,ev,re,r,rp)
		local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do 
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(750)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
end
end