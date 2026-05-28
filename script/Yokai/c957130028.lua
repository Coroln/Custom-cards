--Soul Guide
local s,id=GetID()
function s.initial_effect(c)
	--If this card is Summoned: Both players can send 1 monster from their Deck to the GY.
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_DUEL)
	e1:SetOperation(s.tgop)
	c:RegisterEffect(e1)
	local e1b=e1:Clone()
	e1b:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e1b)

	--If this card is sent to the GY: Add 1 monster from your GY to your hand.
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,{id,1},EFFECT_COUNT_CODE_DUEL)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)

	--All monsters you control lose 400 ATK while this card is in your GY.
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetValue(-400)
	c:RegisterEffect(e3)

	--While this card is in your GY: Discard 1 card; banish this card from your GY.
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,{id,3})
	e4:SetCost(Cost.Discard())
	e4:SetOperation(s.rmop)
	c:RegisterEffect(e4)

	--All monsters you control lose 400 DEF while this card is banished.
	local e5=e3:Clone()
	e5:SetCode(EFFECT_UPDATE_DEFENSE)
	e5:SetRange(LOCATION_REMOVED)
	e5:SetValue(-400)
	c:RegisterEffect(e5)
end

--e1

function s.tgfilter(c)
	return c:IsMonster() and c:IsAbleToGrave()
end

function s.send(player)
	if Duel.IsExistingMatchingCard(s.tgfilter,player,LOCATION_DECK,0,1,nil)
		and Duel.SelectYesNo(player,aux.Stringid(id,3)) then
		Duel.Hint(HINT_SELECTMSG,player,HINTMSG_TOGRAVE)
		local g1=Duel.SelectMatchingCard(player,s.tgfilter,player,LOCATION_DECK,0,1,1,nil)
		if #g1>0 then
			Duel.SendtoGrave(g1,REASON_EFFECT)
		end
	end
end

function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	s.send(tp)
	s.send(1-tp)
end

--e2

function s.thfilter(c)
	return c:IsMonster() and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

--e4
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Remove(c,POS_FACEUP,REASON_EFFECT)
	end
end
