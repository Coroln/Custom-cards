--Alcdragon Jonas the Jäger
--Script by creasycat
local s,id=GetID()
function s.initial_effect(c)
	--Add 1 "Alcdragon" monsters from the Deck or GY to the hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end

function s.rf(c) --returnfilter
	return c:IsSetCard(0x14ec) and c:IsMonster() and c:IsAbleToDeck()
end
function s.sf(c) --sendfilter
	return c:IsSetCard(0x14ec) and c:IsMonster() and c:IsAbleToGrave()
end
function s.filter(c)
	return c:IsSetCard(0x14ec) and c:IsLevelBelow(4) and c:IsMonster() and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		if Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
			Duel.ConfirmCards(1-tp,g)
			local b1=Duel.IsExistingMatchingCard(s.rf,tp,LOCATION_GRAVE,0,1,nil)
			local b2=Duel.IsExistingMatchingCard(s.sf,tp,LOCATION_DECK,0,1,nil)
			if not ((b1 or b2) and Duel.SelectYesNo(tp,aux.Stringid(id,1))) then return end
			local op=Duel.SelectEffect(tp,
				{b1,aux.Stringid(id,2)},
				{b2,aux.Stringid(id,3)})
			if op==1 then
				-- Target 1 "Alcdragon" monster in your GY; return that target to the Deck.
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
				local g=Duel.SelectMatchingCard(tp,s.rf,tp,LOCATION_GRAVE,0,1,1,nil)
				if #g>0 then
					Duel.BreakEffect()
					Duel.SendtoDeck(g,nil,2,REASON_EFFECT) --2 = Deck+Shuffle
				end
			elseif op==2 then
				-- Send 1 "Alcdragon" monster from your Deck to the GY.
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local sc=Duel.SelectMatchingCard(tp,s.sf,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
				if not sc then return end
				Duel.BreakEffect()
				Duel.SendtoGrave(sc,REASON_EFFECT,tp)
			end
		end
	end
end
