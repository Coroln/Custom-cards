--Buzzing Nikovi
--Coroln
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--Synchro Summon procedure
	Synchro.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsRace,RACE_INSECT),1,99,nil,1,99)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.cost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--Negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1,{id,1})
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(s.ncost)
	e2:SetCondition(s.discon)
	e2:SetTarget(s.distg)
	e2:SetOperation(s.disop)
	c:RegisterEffect(e2)
end
s.listed_series={0xBEE}
s.listed_names={61517904,id}
s.counter_list={0x1BEE}
--special summon
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,0)
	local b=Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,nil,e,tp,1)
	local g=Duel.GetMatchingGroup(s.costfilter,tp,LOCATION_ONFIELD,0,nil,tp)
	if chk==0 then return a or b end
	if #g==0 then
		e:SetLabel(0)
	else
		if b and g:GetFirst():IsCanRemoveCounter(tp,0x1BEE,10,REASON_COST) and Duel.GetMatchingGroupCount(Card.IsFaceup,tp,0,LOCATION_ONFIELD,nil,tp)>0 then
			if Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
				if #g==1 then
					g:GetFirst():RemoveCounter(tp,0x1BEE,10,REASON_COST)
					e:SetLabel(1)
				else
					local ct=0
					while ct<10 do
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
						local tc=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_ONFIELD,0,1,1,nil,tp):GetFirst()
						tc:RemoveCounter(tp,0x1BEE,1,REASON_COST)
						ct=ct+1
					end
					e:SetLabel(1)
				end
			end
		else
			e:SetLabel(0)
		end
	end
end
function s.costfilter(c)
	return c:IsCode(61517904)
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0xBEE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT|RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT|RESETS_STANDARD)
			tc:RegisterEffect(e2)
			--Cannot Special Summon for the rest of this turn, except Insect monsters
			local e0=Effect.CreateEffect(e:GetHandler())
			e0:SetDescription(aux.Stringid(id,3))
			e0:SetType(EFFECT_TYPE_FIELD)
			e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
			e0:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e0:SetTargetRange(1,0)
			e0:SetTarget(function(_,c) return not c:IsRace(RACE_INSECT) end)
			e0:SetReset(RESET_PHASE|PHASE_END)
			Duel.RegisterEffect(e0,tp)
		end
		Duel.SpecialSummonComplete()
	end
	if e:GetLabel()==1 then
		local g=Duel.GetMatchingGroup(Card.IsNegatable,tp,0,LOCATION_ONFIELD,nil):Filter(Card.IsCanBeDisabledByEffect,nil,e)
		if #g==0 then return end
		--Negate the effects of all opponent's cards
		local c=e:GetHandler()
		for tc in g:Iter() do
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESETS_STANDARD_PHASE_END)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESETS_STANDARD_PHASE_END)
			tc:RegisterEffect(e2)
		end
	end
end
--Negate
function s.ncost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.costfilter,tp,LOCATION_ONFIELD,0,nil,tp)
	if chk==0 then return g:GetFirst():IsCanRemoveCounter(tp,0x1BEE,2,REASON_COST) end
	if #g==1 then
		g:GetFirst():RemoveCounter(tp,0x1BEE,2,REASON_COST)
	else
		local ct=0
		while ct<2 do
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
			local tc=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_ONFIELD,0,1,1,nil,tp):GetFirst()
			tc:RemoveCounter(tp,0x1BEE,1,REASON_COST)
			ct=ct+1
		end
	end
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainDisablable(ev)
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.NegateEffect(ev) then
		if re:GetHandler():IsRelateToEffect(re) then
			Duel.Destroy(eg,REASON_EFFECT)
	    end
    end
end