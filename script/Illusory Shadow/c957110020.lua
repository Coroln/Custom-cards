--Illusory Dream Land
local s,id=GetID()
function s.initial_effect(c)
	--Activate and optional Archtype Foolish
	local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)

    --spsummon
	local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)

    -- Opponent can´t banish your cards
    local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_REMOVE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(0,1)
	e3:SetTarget(s.rmlimit)
	c:RegisterEffect(e3)

    --Add counter if card is shuffled
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e4:SetCode(EVENT_TO_DECK)
    e4:SetRange(LOCATION_FZONE)
    e4:SetCondition(s.ctcon)
    e4:SetOperation(s.ctop)
    c:RegisterEffect(e4)

    --Boost ATK
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetRange(LOCATION_FZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetValue(function (e,c) return Duel.GetCounter(0,1,1,0x1BBB)*100 end)
	c:RegisterEffect(e5)

    --Destruction Replacement (move 3 counters instead)
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e6:SetCode(EFFECT_DESTROY_REPLACE)
    e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e6:SetRange(LOCATION_ONFIELD)
    e6:SetCountLimit(1)
    e6:SetTarget(s.desreptg)
    e6:SetValue(s.desrepval)
    e6:SetOperation(s.desrepop)
    c:RegisterEffect(e6)
end


s.listed_series={0xBBB}

function s.tgfilter(c)
	return c:IsMonster() and c:IsSetCard(0xBBB) and c:IsAbleToGrave()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(s.tgfilter,tp,LOCATION_DECK,0,nil,e,tp)
    if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
        local sg=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
        if #sg>0 then
            Duel.SendtoGrave(sg,REASON_EFFECT)
        end
    end
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0xBBB) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

--e3

function s.rmlimit(e,c,tp,r)
	return c:IsControler(e:GetHandlerPlayer()) and not c:IsImmuneToEffect(e) and r&REASON_EFFECT>0
end

--e4
function s.ctfilter(c,tp)
    return c:IsLocation(LOCATION_DECK)
        and c:IsControler(tp)
        and c:IsPreviousLocation(LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA)
end

function s.ctcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(s.ctfilter,1,nil,tp)
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsFaceup() then return end
    local g=eg:Filter(Card.IsPreviousLocation,nil,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA)
    if #g>0 then
        c:AddCounter(0x1BBB,1)
    end
end

--e6

function s.kfilter(c)
    return c:IsFaceup() and c:IsCode(957110005)
end

function s.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then
        return c:IsOnField()
            and bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0
            and c:IsCanRemoveCounter(tp,0x1BBB,3,REASON_EFFECT)
            and Duel.IsExistingMatchingCard(s.kfilter,tp,LOCATION_MZONE+LOCATION_SZONE+LOCATION_FZONE,0,1,c)
    end
    if not Duel.SelectEffectYesNo(tp,c,aux.Stringid(id,3)) then return false end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    local g=Duel.SelectMatchingCard(tp,s.kfilter,tp,LOCATION_MZONE+LOCATION_SZONE+LOCATION_FZONE,0,1,1,c)
    if #g>0 then
        e:SetLabelObject(g:GetFirst())
        return true
    end
    return false
end

function s.desrepval(e,c)
    return c==e:GetHandler()
end

function s.desrepop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=e:GetLabelObject()
    if not (tc and tc:IsOnField() and tc:IsFaceup()) then return end
    if c:RemoveCounter(tp,0x1BBB,3,REASON_EFFECT) then
        tc:AddCounter(0x1BBB,3)
    end
    e:SetLabelObject(nil)
end
