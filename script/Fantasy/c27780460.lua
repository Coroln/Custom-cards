--Fantasy Magic: Annihilation Sphere
--Coroln
local s,id=GetID()
local COUNTER_MANA=0xFF
function s.initial_effect(c)
	-- Activate: choose effect
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)

	-- Negate activation (Quick effect)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(s.negcon)
	e2:SetCost(s.negcost)
	e2:SetTarget(s.negtg)
	e2:SetOperation(s.negop)
	c:RegisterEffect(e2)
end
s.counter_list={0xFF}
-----------------------------------
-- Helper: can remove counters
-----------------------------------
function s.canrem(tp,ct)
	return Duel.IsCanRemoveCounter(tp,LOCATION_ONFIELD,0,COUNTER_MANA,ct,REASON_COST)
end

-----------------------------------
-- Option selection (effect 1)
-----------------------------------
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return s.canrem(tp,5)
	end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,0,1-tp,LOCATION_SZONE)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.RemoveCounter(tp,LOCATION_ONFIELD,0,COUNTER_MANA,5,REASON_COST)

	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_SZONE,nil)
	if #g>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end

-----------------------------------
-- Negation effect
-----------------------------------
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and Duel.IsChainNegatable(ev)
end

function s.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return s.canrem(tp,3)
	end
	Duel.RemoveCounter(tp,LOCATION_ONFIELD,0,COUNTER_MANA,3,REASON_COST)
end

function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end

function s.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
