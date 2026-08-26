--Dreadroller Scarab
--Coroln
local s,id=GetID()
function s.initial_effect(c)
	--If this card is sent to the GY: You can add 1 Level 5 or lower non-Ritual Insect monster from your Deck to your hand, then if you control no monsters, you can special summon this card
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,id)
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)
end
s.listed_names={id}
--If this card is sent to the GY: You can add 1 Level 5 or lower non-Ritual Insect monster from your Deck to your hand, then if you control no monsters, you can special summon this card
function s.thfilter(c)
	return c:IsLevelBelow(5) and c:IsRace(RACE_INSECT) and c:IsAbleToHand() and not c:IsRitualMonster() and not c:IsCode(id)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sc=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if sc and Duel.SendtoHand(sc,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,sc)
		Duel.ShuffleHand(tp)
		if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			Duel.BreakEffect()
			if Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
				--Banish it when it leaves the field
				local e1=Effect.CreateEffect(c)
				e1:SetDescription(3300)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
				e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
				e1:SetValue(LOCATION_REMOVED)
				e1:SetReset(RESET_EVENT|RESETS_REDIRECT)
				c:RegisterEffect(e1)
			end
		end
	end
end