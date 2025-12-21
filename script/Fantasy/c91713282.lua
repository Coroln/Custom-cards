--Fantasy Magic: Summoning
--Coroln
local s,id=GetID()
local COUNTER_MANA=0xFF

function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)

	--Set from GY if monster destroyed by battle
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DESTROYED)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(s.setcon)
	e2:SetTarget(s.settg)
	e2:SetOperation(s.setop)
	c:RegisterEffect(e2)
end
s.counter_list={0xFF}
--------------------------------------------------
-- COST: Remove 2–6 Mana Counters from your field
--------------------------------------------------
function s.canpay(tp,ct)
	return Duel.IsCanRemoveCounter(tp,LOCATION_ONFIELD,0,COUNTER_MANA,ct,REASON_COST)
end

function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return s.canpay(tp,2)
	end

	local opts={}
	local vals={}

	if s.canpay(tp,2) then
		table.insert(opts,aux.Stringid(id,1)) -- Remove 2
		table.insert(vals,2)
	end
	if s.canpay(tp,4) then
		table.insert(opts,aux.Stringid(id,2)) -- Remove 4
		table.insert(vals,4)
	end
	if s.canpay(tp,6) then
		table.insert(opts,aux.Stringid(id,3)) -- Remove 6
		table.insert(vals,6)
	end

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COST)
	local sel=Duel.SelectOption(tp,table.unpack(opts))
	local ct=vals[sel+1]

	Duel.RemoveCounter(tp,LOCATION_ONFIELD,0,COUNTER_MANA,ct,REASON_COST)
	e:SetLabel(ct)
end

--------------------------------------------------
-- TARGET
--------------------------------------------------
function s.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and c:IsCanAddCounter(COUNTER_MANA,1)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=math.floor(e:GetLabel()/2)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>=ct
			and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND,0,ct,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,ct,tp,LOCATION_HAND)
end

--------------------------------------------------
-- OPERATION
--------------------------------------------------
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct=math.floor(e:GetLabel()/2)
	if ct<=0 then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<ct then return end

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND,0,ct,ct,nil,e,tp)
	for tc in aux.Next(g) do
		if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
			tc:AddCounter(COUNTER_MANA,1)
		end
	end
	Duel.SpecialSummonComplete()
end

--------------------------------------------------
-- GY SET EFFECT
--------------------------------------------------
function s.setcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(function(c)
		return c:IsPreviousControler(tp) and c:IsReason(REASON_BATTLE)
	end,1,nil)
end

function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
end

function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SSet(tp,c)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1)
	end
end
