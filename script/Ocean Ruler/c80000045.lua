--Possaidon, Ozeanherrscher der Weltmeere
function c80000045.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsRace,RACE_SEASERPENT),8,2)
	c:EnableReviveLimit()
	--defense attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DEFENSE_ATTACK)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(80000045,0))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c80000045.discon)
	e2:SetTarget(c80000045.distg)
	e2:SetOperation(c80000045.disop)
	c:RegisterEffect(e2)
	--change battle target
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(80000045,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c80000045.cbcon)
	e3:SetCost(c80000045.cbcost)
	e3:SetOperation(c80000045.cbop)
	c:RegisterEffect(e3)
	--counter
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(80000045,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c80000045.condition)
	e1:SetCost(c80000045.cost)
	e1:SetTarget(c80000045.target)
	e1:SetOperation(c80000045.operation)
	c:RegisterEffect(e1)
	--win
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_DELAY)
	e2:SetOperation(c80000045.winop)
	c:RegisterEffect(e2)
end
function c80000045.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)==LOCATION_SZONE
		and re:IsActiveType(TYPE_SPELL) and Duel.IsChainDisablable(ev) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function c80000045.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c80000045.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if Duel.NegateEffect(ev) and c:IsRelateToEffect(e) and rc:IsRelateToEffect(re) and c:IsType(TYPE_XYZ) then
		rc:CancelToGrave()
		Duel.Overlay(c,Group.FromCards(rc))
	end
end
function c80000045.cbcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and Duel.GetAttackTarget()~=e:GetHandler()
end
function c80000045.cbcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c80000045.cbop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local at=Duel.GetAttacker()
		if at:IsAttackable() and not at:IsImmuneToEffect(e) then
			Duel.CalculateDamage(at,c)
		end
	end
end
function c80000045.filter(e,tp,eg,ep,ev,re,r,rp,c)
	return c:IsCode(22702055)
end
function c80000045.condition(e,tp,eg,ep,ev,re,r,rp,c)
if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingMatchingCard(c80000045.filter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c80000045.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCurrentPhase()==PHASE_MAIN1 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c80000045.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT)
		and e:GetHandler():IsCanAddCounter(0x44,1) end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x44)
end
function c80000045.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() and c:RemoveOverlayCard(tp,1,1,REASON_EFFECT) then
		c:AddCounter(0x44,1)
	end
end
function c80000045.winop(e,tp,eg,ep,ev,re,r,rp)
	local WIN_REASON_POSSAIDON_OZEANHERRSCHER_DER_WELTMEERE=0x1d
	local c=e:GetHandler()
	if c:GetCounter(0x44)==3 then
		Duel.Win(tp,WIN_REASON_POSSAIDON_OZEANHERRSCHER_DER_WELTMEERE)
	end
end
