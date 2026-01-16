--Pineapple Dragonling
--Coroln
local s,id=GetID()
function s.initial_effect(c)
	Synchro.AddProcedure(c,nil,1,1,Synchro.NonTunerEx(Card.IsRace,RACE_PLANT),1,99)
	c:EnableReviveLimit()
	--Inflict 100 damage per card send to gy from your deck
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.damcon)
	e1:SetOperation(s.damop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(s.chainsolvedop)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DECKDES)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.condition)
	e3:SetTarget(s.target)
	e3:SetOperation(s.operation)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_MATERIAL_CHECK)
	e4:SetValue(s.valcheck)
	e4:SetLabelObject(e3)
	c:RegisterEffect(e4)
end
--Inflict 100 damage per card send to gy from your deck
function s.filter(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.filter,1,nil,tp)
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:FilterCount(Card.IsControler,nil,tp)
	if Duel.IsChainSolving() then
		--If a chain link is resolving, register a flag to deal the damage after it
		for i=1,ct do
			e:GetHandler():RegisterFlagEffect(id+1,RESET_CHAIN,0,1)
		end
	else
		--If a chain is not resolving, deal the damage right away
		Duel.Hint(HINT_CARD,1-tp,id)
		Duel.Damage(1-tp,ct*100,REASON_EFFECT)
	end
end
function s.chainsolvedop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetHandler():GetFlagEffect(id+1)
	if ct>0 then
		Duel.Hint(HINT_CARD,1-tp,id)
		Duel.Damage(1-tp,ct*100,REASON_EFFECT)
		e:GetHandler():ResetFlagEffect(id+1)
	end
end
--destroy
function s.sfilter(c)
	return c:IsRace(RACE_PLANT) and c:IsType(TYPE_SYNCHRO)
end
function s.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(s.sfilter,1,nil) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO and e:GetLabel()==1
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,1)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.DiscardDeck(tp,1,REASON_EFFECT) then
		local dg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		if #dg>0 then
			Duel.Destroy(dg,REASON_EFFECT)
		end
	end
end
