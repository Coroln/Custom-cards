--Yokai Monster
local s,id=GetID()

function s.initial_effect(c)
	--If Normal Summoned: Special Summon 1 Level 4 or lower Yokai from hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
    --effect gain
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_BE_MATERIAL)
    e3:SetCondition(s.efcon)
    e3:SetOperation(s.efop)
    c:RegisterEffect(e3)

	--GY Quick Effect: move monster
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_POSITION)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,id)
	e4:SetCost(aux.bfgcost)
	e4:SetTarget(s.movetg)
	e4:SetOperation(s.moveop)
	c:RegisterEffect(e4)
end

--Yokai race filter
function s.spfilter(c,e,tp)
	return c:IsRace(0x4000000000000000) and c:IsLevelBelow(4)
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
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end

--● Your opponent cannot target this card with card effects
function s.efcon(e,tp,eg,ep,ev,re,r,rp)
	return (r&REASON_SYNCHRO)~=0
		and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end

function s.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	if not rc:IsNonEffectMonster() then return end
	local e1=Effect.CreateEffect(rc)
	e1:SetDescription(aux.Stringid(id,0))
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_DISABLE)
    e1:SetTargetRange(0,LOCATION_STZONE)
    e1:SetTarget(s.coltg)
    rc:RegisterEffect(e1,true)

	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e2,true)
	end
end

-- Column negate
function s.coltg(e,c)
	local ec=e:GetHandler()
	return c:GetColumnGroup():IsContains(ec)
end

--Move monster target
function s.movetg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:CheckAdjacent() end
	if chk==0 then return Duel.IsExistingTarget(Card.CheckAdjacent,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
	local tc=Duel.SelectTarget(tp,Card.CheckAdjacent,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
	e:SetLabel(tc:SelectAdjacent())
end

--Move monster operation
function s.moveop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local seq=e:GetLabel()
	if tc:IsImmuneToEffect(e) or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or not Duel.CheckLocation(tp,LOCATION_MZONE,seq) then return end
	Duel.MoveSequence(tc,seq)
end
