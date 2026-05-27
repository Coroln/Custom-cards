--PM Stealth Rock
--Coroln
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCondition(s.activate)
	c:RegisterEffect(e0)
	--destroy (self)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(s.descon)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
	--decrase atk then destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(s.damcon)
	e2:SetTarget(s.atktg)
	e2:SetOperation(s.atkop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
s.listed_names={19962003}
s.listed_series={0x7CC}
--Activate
function s.ffilter(c)
    return c:IsFaceup() and (c:IsCode(19962003) or (c:IsSetCard(0x7CC) and (c:IsRace(RACE_ROCK) or c:IsAttribute(ATTRIBUTE_EARTH))))
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.ffilter,tp,LOCATION_ONFIELD,0,1,nil)
end
--destroy (self)
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsTurnPlayer(1-tp)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	ct=ct+1
	c:SetTurnCounter(ct)
	if ct==3 then
		Duel.Destroy(c,REASON_EFFECT)
	end
end
--decrase atk then destroy
function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSummonPlayer,1,nil,1-tp) and eg:IsExists(Card.IsAttackAbove,1,nil,1000)
end
function s.atkfilter(c,tp)
	return c:IsPosition(POS_FACEUP)
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) end
	local g=Duel.GetMatchingGroup(s.atkfilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetTargetCard(g)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetCards(e):Match(Card.IsFaceup,nil)
	if #g==0 then return end
	local dg=Group.CreateGroup()
	local c=e:GetHandler()
	for tc in g:Iter() do
		local preatk=tc:GetAttack()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-1000)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD)
		tc:RegisterEffect(e1)
		if preatk~=0 and tc:GetAttack()==0 then dg:AddCard(tc) end
	end
	if #dg==0 then return end
	Duel.BreakEffect()
	Duel.Destroy(dg,REASON_EFFECT)
end