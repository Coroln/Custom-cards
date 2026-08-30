--Master Clown
local s,id=GetID()
Duel.LoadScript("proc_trick2.lua")
function s.initial_effect(c)
    Trick.AddProcedure(c,nil,nil,{{s.tfilter,2,2}},{{s.tfilter2,1,1}})
	-- Change the battle position of all face-up monsters
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetOperation(s.posop)
	c:RegisterEffect(e1)

	-- If this Defense Position card is changed to Attack Position: increase ATK
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_CHANGE_POS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(s.atkcon)
	e2:SetOperation(s.atkop)
	c:RegisterEffect(e2)

	-- If this Attack Position card is changed to face-up Defense Position:
	-- Special Summon 1 Level 4 or lower monster from the hand face-down Defense Position
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_CHANGE_POS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,id)
	e3:SetCondition(s.spcon)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
end

--Trick Summon
--Monster filter
function s.tfilter(c)
	return not c:IsType(TYPE_TOKEN)
end
--Trap filter
function s.tfilter2(c)
	return c:IsTrap()
end

function s.posfilter(c)
	return c:IsFaceup()
end

function s.posop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	for tc in aux.Next(g) do
		if tc:IsAttackPos() then
			Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)
		elseif tc:IsDefensePos() then
			Duel.ChangePosition(tc,POS_FACEUP_ATTACK)
		end
	end
end

function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsFaceup() and c:IsAttackPos()
		and c:IsPreviousPosition(POS_FACEUP_DEFENSE)
end

function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(200)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end

function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsFaceup() and c:IsDefensePos()
		and c:IsPreviousPosition(POS_FACEUP_ATTACK)
end

function s.spfilter(c,e,tp)
	return c:IsLevelBelow(4)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
	end
end
