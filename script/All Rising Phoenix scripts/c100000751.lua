local s,id=GetID()
function s.initial_effect(c)
	Synchro.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x765),1,1,Synchro.NonTunerEx(Card.IsSetCard,0x765),1,99)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	e1:SetCondition(s.dircon)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e2:SetCondition(s.rdcon)
	e2:SetOperation(s.rdop)
	c:RegisterEffect(e2)
	--to defense
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e11:SetCode(EVENT_DAMAGE_STEP_END)
	e11:SetCondition(s.poscon)
	e11:SetOperation(s.posop)
	c:RegisterEffect(e11)
	--draw
	local e21=Effect.CreateEffect(c)
	e21:SetDescription(aux.Stringid(id,0))
	e21:SetCategory(CATEGORY_DRAW)
	e21:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e21:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e21:SetCode(EVENT_BATTLE_DAMAGE)
	e21:SetCondition(s.condition)
	e21:SetTarget(s.target)
	e21:SetOperation(s.operation)
	c:RegisterEffect(e21)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function s.rdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep~=tp and Duel.GetAttackTarget()==nil
		and c:GetEffectCount(EFFECT_DIRECT_ATTACK)<2 and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
end
function s.rdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev/2)
end
function s.filter2(c)
	return c:IsFaceup() and c:IsCode(100000989)
end
function s.dircon(e)
local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(s.filter2,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		or Duel.IsEnvironment(100000989)
end
function s.atkval(e,c)
	return c:GetAttack()/2
end
function s.poscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler()==Duel.GetAttacker() and e:GetHandler():IsRelateToBattle()
end
function s.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsAttackPos() then
		Duel.ChangePosition(c,POS_FACEUP_DEFENSE)
	end
end
