--Created and scripted by Rising Phoenix
function c100000782.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c100000782.spcon)
	e1:SetOperation(c100000782.spop)
	c:RegisterEffect(e1)
		--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(100000782,2))
	e4:SetCountLimit(1,100000782)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetOperation(c100000782.desop)
	c:RegisterEffect(e4)	
			--destroy
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(100000782,3))
	e5:SetCountLimit(1,100000782)
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetOperation(c100000782.desop2)
	c:RegisterEffect(e5)
		--destroy
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(100000782,4))
	e6:SetCountLimit(1,100000782)
	e6:SetCategory(CATEGORY_DESTROY)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetRange(LOCATION_MZONE)
	e6:SetOperation(c100000782.desop3)
	c:RegisterEffect(e6)		
	--dam
		local e21=Effect.CreateEffect(c)
	e21:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e21:SetCategory(CATEGORY_DAMAGE)
	e21:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e21:SetRange(LOCATION_GRAVE)
	e21:SetCountLimit(1)
	e21:SetCondition(c100000782.damcon7)
	e21:SetTarget(c100000782.damtg7)
	e21:SetOperation(c100000782.damop7)
	c:RegisterEffect(e21)
end
function c100000782.spfilter(c)
	return c:IsSetCard(0x75F) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() and not c:IsCode(100000782)
end
function c100000782.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return  Duel.GetLocationCount(tp,LOCATION_MZONE)>-3
		and Duel.IsExistingMatchingCard(c100000782.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND+LOCATION_ONFIELD,0,3,nil)
end
function c100000782.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c100000782.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND+LOCATION_ONFIELD,0,3,3,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c100000782.damcon7(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c100000782.damtg7(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	local op=Duel.SelectOption(tp,aux.Stringid(100000782,0),aux.Stringid(100000782,1))
	e:SetLabel(op)
	if op==0 then
		e:SetCategory(CATEGORY_RECOVER)
		Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(300)
		Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,300)
	else
		e:SetCategory(CATEGORY_DAMAGE)
		Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(300)
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,300)
	end
end
function c100000782.damop7(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if e:GetLabel()==0 then
		Duel.Recover(p,d,REASON_EFFECT)
	else Duel.Damage(p,d,REASON_EFFECT) end
end
function c100000782.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(tp,2000)
end

function c100000782.desop2(e,tp,eg,ep,ev,re,r,rp)
		Duel.SetLP(tp,5000)
end
function c100000782.desop3(e,tp,eg,ep,ev,re,r,rp)
		Duel.SetLP(tp,7000)
end
