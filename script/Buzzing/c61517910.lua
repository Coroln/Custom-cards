--Buzzing Melifera
--Coroln
local s,id=GetID()
function s.initial_effect(c)
	--synchro summon
	Synchro.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsRace,RACE_INSECT),1,1,Synchro.NonTuner(nil),1,99)
	c:EnableReviveLimit()
	--Add 1 Spell/Trap that mentions "Insect Production Queen" from your Deck to your hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCost(s.cost)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	--Your "Buzzing" monsters cannot be destroyed by battle
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(function(e,c) return c:IsSetCard(0xBEE) end)
	e2:SetValue(1)
	c:RegisterEffect(e2)
end
s.listed_series={0xBEE}
s.listed_names={61517904}
s.counter_list={0x1BEE}
--Add 1 Spell/Trap that mentions "Insect Production Queen" from your Deck to your hand
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil,e,tp,0)
	local b=Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_HAND,1,nil,e,tp,1)
	local g=Duel.GetMatchingGroup(s.costfilter,tp,LOCATION_ONFIELD,0,nil,tp)
	if chk==0 then return a or b end
	if #g==0 then
		e:SetLabel(0)
	else
		if b and g:GetFirst():IsCanRemoveCounter(tp,0x1BEE,1,REASON_COST) then
			if Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
				if #g==1 then
					g:GetFirst():RemoveCounter(tp,0x1BEE,1,REASON_COST)
					e:SetLabel(1)
				else
					local ct=0
					while ct<1 do
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
function s.thfilter(c)
	return c:IsSpellTrap() and c:ListsCode(61517904) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	if e:GetLabel()==1 then
		local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
		if #g<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local tc=g:RandomSelect(tp,1)
		Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end