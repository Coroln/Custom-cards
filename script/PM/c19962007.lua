--PM Gluraknit x
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	Ritual.AddProcEqual{handler=c,filter=s.ritualfil,matfilter=s.matfilter,nil}
	--Special Summon 1 non-Ritual "PM" from your Deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE|PHASE_STANDBY)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1)
	e1:SetCondition(s.spcond)
	e1:SetCost(Cost.SelfBanish)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
end
s.listed_names={19962006}
s.listed_series={0x7CC}
s.fit_monster={19962006}
--Ritual Summon
function s.ritualfil(c)
	return c:IsCode(19962006) and c:IsRitualMonster()
end
function s.matfilter(c)
	return c:IsCode(19962005)
end
function s.extrafil(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.GetMatchingGroup(s.mfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
end
--Special Summon 1 non-Ritual "PM" from your Deck
function s.cfilter(c)
	return c:IsMonster() and c:IsType(TYPE_RITUAL) and c:IsSetCard(0x7CC)
end
function s.spcond(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x7CC) and not c:IsRitualMonster() and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		Duel.ConfirmCards(1-tp,g)
	end
end
