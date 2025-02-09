--Soul Reaper from the Darkest Underworld
--Script by Coroln
local s,id=GetID()
function s.initial_effect(c)
    --Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
    local e1a=e1:Clone()
    e1a:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e1a)
    local e1b=e1:Clone()
    e1b:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
    c:RegisterEffect(e1b)
    --Add 1 banished monster
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_REMOVE)
    e2:SetCountLimit(1,{id,1})
    e2:SetCondition(s.thcon)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end
s.listed_names={id}
s.listed_series={0xDA19}
--Special Summon
function s.cfilter(c)
	return c:IsSetCard(0xDA19) and c:IsSpell() and not c:IsPublic()
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function s.spfilter(c,e,tp)
	return c:IsLevel(4) and c:IsRace(RACE_FIEND) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,tc):GetFirst()
    if sc and Duel.SpecialSummonStep(sc,0,tp,tp,false,false,POS_FACEUP) then
        --Cannot Be Material
        local e1=Effect.CreateEffect(c)
        e1:SetDescription(aux.Stringid(id,1))
        e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
        e1:SetValue(1)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        sc:RegisterEffect(e1,true)
        local e2=Effect.CreateEffect(c)
        e2:SetDescription(aux.Stringid(id,1))
        e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
        e2:SetValue(1)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD)
        sc:RegisterEffect(e2,true)
        local e3=Effect.CreateEffect(c)
        e3:SetDescription(aux.Stringid(id,1))
        e3:SetProperty(EFFECT_FLAG_CLIENT_HINT)
        e3:SetType(EFFECT_TYPE_SINGLE)
        e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
        e3:SetValue(1)
        e3:SetReset(RESET_EVENT+RESETS_STANDARD)
        sc:RegisterEffect(e3,true)
        local e4=Effect.CreateEffect(c)
        e4:SetDescription(aux.Stringid(id,1))
        e4:SetProperty(EFFECT_FLAG_CLIENT_HINT)
        e4:SetType(EFFECT_TYPE_SINGLE)
        e4:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
        e4:SetValue(1)
        e4:SetReset(RESET_EVENT+RESETS_STANDARD)
        sc:RegisterEffect(e4,true)
    end
    Duel.SpecialSummonComplete()
end
--Add 1 banished monster
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsPreviousLocation(LOCATION_GRAVE)
end
function s.thfilter(c)
	return c:IsMonster() and not c:IsCode(id) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end