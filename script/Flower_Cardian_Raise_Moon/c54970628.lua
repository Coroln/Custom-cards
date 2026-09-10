--Flower Cardian with Raise Moon
--Coroln
local s,id=GetID()
Duel.LoadScript("proc_trick2.lua")
function s.initial_effect(c)
	Trick.AddProcedure(c,nil,nil,{{s.tfilter,1,1}},{{s.tfilter2,1,1}})
	c:EnableReviveLimit()
	--If this card is Trick Summoned from the hand: You can draw 1 card, also you cannot Special Summon from the Extra Deck for the rest of this turn, except LIGHT Xyz Monsters. You cannot add cards from the Deck to the hand the turn you activate this effect, except by drawing them
	local e2a=Effect.CreateEffect(c)
	e2a:SetDescription(aux.Stringid(id,0))
	e2a:SetCategory(CATEGORY_DRAW)
	e2a:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2a:SetProperty(EFFECT_FLAG_DELAY)
	e2a:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2a:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return e:GetHandler():IsSummonLocation(LOCATION_EXTRA) and not e:GetHandler():IsReason(REASON_EFFECT) end)
	e2a:SetCost(s.drcost)
	e2a:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk) if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1) end)
	e2a:SetOperation(s.drop)
	c:RegisterEffect(e2a)
	--Keep track of cards being added to a player's hand, except by drawing them
	aux.GlobalCheck(s,function()
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_HAND)
		ge1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
			for ec in eg:Iter() do
				if ec:IsPreviousLocation(LOCATION_DECK) and not ec:IsReason(REASON_DRAW) then
					Duel.RegisterFlagEffect(ec:GetReasonPlayer(),id,RESET_PHASE|PHASE_END,0,1)
				end
			end
		end)
		Duel.RegisterEffect(ge1,0)
	end)
	--shuffle 1 continuouse Spell/Trap to Draw 1
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(s.cost)
	e3:SetTarget(s.tg)
	e3:SetOperation(s.op)
	c:RegisterEffect(e3)
	--Draw 1 card, and if you do, show it, then you can Special Summon it if it is a "Flower Cardian" monster
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,3))
	e4:SetCategory(CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,id)
	e4:SetCondition(s.drspcon)
	e4:SetTarget(s.drsptg)
	e4:SetOperation(s.drspop)
	c:RegisterEffect(e4)
end
s.listed_series={SET_FLOWER_CARDIAN}
s.listed_names={id}
--Trick Summon
--Monster filter
function s.tfilter(c)
	return c:IsMonster() and (c:IsLevelAbove(7) or c:IsRankAbove(7))
end
--Trap filter
function s.tfilter2(c)
	return c:IsTrap()
end
--If this card is Trick Summoned from the hand: You can draw 1 card, also you cannot Special Summon from the Extra Deck for the rest of this turn, except LIGHT Xyz Monsters. You cannot add cards from the Deck to the hand the turn you activate this effect, except by drawing them
function s.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.HasFlagEffect(tp,id) end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH+EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_CANNOT_TO_HAND)
	e1:SetTargetRange(1,0)
	e1:SetTarget(function(e,c,tp,re)
		return c:IsLocation(LOCATION_DECK)
	end)
	e1:SetReset(RESET_PHASE|PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(function(e,c)
		return c:IsLocation(LOCATION_EXTRA) and not (c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsXyzMonster())
	end)
	e1:SetReset(RESET_PHASE|PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
--shuffle 1 continuouse Spell/Trap to Draw 1
function s.drawfilter(c)
	return c:IsSpellTrap() and c:IsType(TYPE_CONTINUOUS)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.drawfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,s.drawfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoDeck(g,tp,SEQ_DECKSHUFFLE,REASON_COST)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Draw(p,d,REASON_EFFECT)
end
--Draw 1 card, and if you do, show it, then you can Special Summon it if it is a "Flower Cardian" monster
function s.cdfilter(c)
	return c:IsFaceup() and c:IsSetCard(SET_FLOWER_CARDIAN)
end
function s.drspcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cdfilter,1,e:GetHandler())
end
function s.drsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
end
function s.drspop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)>0 then
		local dc=Duel.GetOperatedGroup():GetFirst()
		Duel.ConfirmCards(1-tp,dc)
		if dc:IsSetCard(SET_FLOWER_CARDIAN) and dc:IsMonster() then
			if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and dc:IsCanBeSpecialSummoned(e,0,tp,false,false)
				and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
				Duel.BreakEffect()
				Duel.SpecialSummon(dc,0,tp,tp,false,false,POS_FACEUP)
			end
		else
			Duel.BreakEffect()
			Duel.SendtoGrave(dc,REASON_EFFECT)
		end
		Duel.ShuffleHand(tp)
	end
end