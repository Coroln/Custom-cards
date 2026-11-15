--Wind Synchro Monster (Platzhalter-Name)
--1 WIND Tuner + 1 non-Tuner monster
local s,id=GetID()
function s.initial_effect(c)
	--Synchro Summon
	Synchro.AddProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_WIND),1,1,Synchro.NonTuner(nil),1,1)
	c:EnableReviveLimit()
	--If this card is Synchro Summoned: You can return 1 non-Synchro monster each player controls to the hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(s.thcon)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSynchroSummoned()
end
function s.thfilter(c)
	return c:IsMonster() and not c:IsType(TYPE_SYNCHRO) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_MZONE,0,1,nil)
			and Duel.IsExistingMatchingCard(s.thfilter,tp,0,LOCATION_MZONE,1,nil)
	end
	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,2,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	--Your side
	if Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_MZONE,0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g1=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_MZONE,0,1,1,nil)
		g:Merge(g1)
	end
	--Opponent's side
	if Duel.IsExistingMatchingCard(s.thfilter,tp,0,LOCATION_MZONE,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g2=Duel.SelectMatchingCard(tp,s.thfilter,tp,0,LOCATION_MZONE,1,1,nil)
		g:Merge(g2)
	end
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end