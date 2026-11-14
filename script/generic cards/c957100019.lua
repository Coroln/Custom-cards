--Pyro/Spellcaster Fusion (Name einsetzen)
--Scripted for Project Ignis / EDOPro
local s,id=GetID()
function s.initial_effect(c)
	--Fusion Materials: 1 Pyro monster + 1 Spellcaster monster
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,aux.FilterBoolFunctionEx(Card.IsRace,RACE_PYRO),aux.FilterBoolFunctionEx(Card.IsRace,RACE_SPELLCASTER))
	--If this card is Fusion Summoned: Shuffle up to 3 Pyro monsters from your GY into the Deck, and if you do, this card gains 300 ATK for each card shuffled
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(s.atkcon)
	e1:SetTarget(s.atktg)
	e1:SetOperation(s.atkop)
	c:RegisterEffect(e1)
	--Cannot be destroyed by Spell/Trap effects the turn it is Special Summoned
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetCondition(s.indcon)
	e2:SetValue(s.indval)
	c:RegisterEffect(e2)
end
s.material_race={RACE_PYRO,RACE_SPELLCASTER}
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsFusionSummoned()
end
function s.tdfilter(c)
	return c:IsRace(RACE_PYRO) and c:IsMonster() and c:IsAbleToDeck()
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tdfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.tdfilter),tp,LOCATION_GRAVE,0,1,3,nil)
	if #g==0 then return end
	Duel.HintSelection(g,true)
	if Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 then
		local ct=Duel.GetOperatedGroup():FilterCount(Card.IsLocation,nil,LOCATION_DECK|LOCATION_EXTRA)
		if ct>0 and c:IsRelateToEffect(e) and c:IsFaceup() then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(ct*300)
			e1:SetReset(RESET_EVENT|RESETS_STANDARD_DISABLE)
			c:RegisterEffect(e1)
		end
	end
end
function s.indcon(e)
	return e:GetHandler():IsStatus(STATUS_SPSUMMON_TURN)
end
function s.indval(e,re)
	return re:IsActiveType(TYPE_SPELL|TYPE_TRAP)
end