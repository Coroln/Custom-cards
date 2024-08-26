--Chrono-Shifters: Chrono Manipulator
--Script by Coroln
local s,id=GetID()
function s.initial_effect(c)
	c:EnableCounterPermit(0x100A,LOCATION_PZONE+LOCATION_MZONE)
	--Enable pendulum summon
	Pendulum.AddProcedure(c)
	--add counter
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetOperation(s.ctop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--Special Summon itself and a monster from the Deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_COUNTER)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCost(s.spcost)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
	--Treat 1 Celestial Warrior monster as a tuner
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCountLimit(1,id)
	e4:SetCondition(s.condition)
	e4:SetTarget(s.target)
	e4:SetOperation(s.operation)
	c:RegisterEffect(e4)
end
s.listed_series={0x1AC0}
s.counter_place_list={0x100A}
s.listed_names={id}
--add counter
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(aux.FaceupFilter(Card.IsSetCard,0x1AC0),1,nil) then
		e:GetHandler():AddCounter(0x100A,1)
	end
end
--Special Summon itself and a monster from the Deck
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanRemoveCounter(tp,0x100A,2,REASON_COST) end
	c:RemoveCounter(tp,0x100A,2,REASON_COST)
end
function s.spfilter(c,e,tp)
	return (c:IsLevel(4) or c:IsLevel(5)) and c:IsRace(RACE_CELESTIALWARRIOR) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>=2 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,2,tp,LOCATION_PZONE+LOCATION_DECK)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (c:IsRelateToEffect(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (Duel.GetLocationCount(tp,LOCATION_MZONE)>=2))
		or Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then return end
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #g>0 then
		g:AddCard(c)
		if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)==2 then
			g:ForEach(Card.AddCounter,0x100A,1)
		end
	end
end
--Treat 1 Celestial Warrior monster as a tuner
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_PENDULUM) or e:GetHandler():IsPreviousLocation(LOCATION_PZONE)
end
function s.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_CELESTIALWARRIOR) and not c:IsType(TYPE_TUNER) and not c:IsCode(id)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(TYPE_TUNER)
		tc:RegisterEffect(e1)
	end
	if c:IsRelateToEffect(e) then
		--Return it to deck if it leaves the field
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(3301)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e2:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e2:SetValue(LOCATION_DECKBOT)
		c:RegisterEffect(e2)
	end
end