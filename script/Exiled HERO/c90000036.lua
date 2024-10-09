--The True HEROs
--Script by Coroln
local s,id=GetID()
function s.initial_effect(c)
	--Special Summon 4 "HERO" monsters
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.listed_series={0xe6}
--Special Summon 4 "HERO" monsters
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(id,tp,ACTIVITY_SUMMON)==0
		and Duel.GetCustomActivityCount(id,tp,ACTIVITY_SPSUMMON)==0 end
	--Cannot Special Summon from the Extra Deck, except "HERO" monsters
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(id,2))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(function(_,c) return c:IsLocation(LOCATION_EXTRA) and not c:IsSetCard(0x8) end)
	e1:SetReset(RESET_PHASE|PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.filter(c,e,tp)
	return c:IsType(TYPE_NORMAL) and c:IsLevelBelow(4) and c:IsSetCard(0x8) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
	if chk==0 then return ft>3 and not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)
		and g:GetClassCount(Card.GetCode)>=4 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,4,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) or Duel.GetLocationCount(tp,LOCATION_MZONE)<4 then return end
	local g1=aux.SelectUnselectGroup(g,e,tp,4,4,aux.dncheck,1,tp,HINTMSG_SPSUMMON)
	for tc in aux.Next(g1) do
		if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		end
	end
	Duel.SpecialSummonComplete()
end