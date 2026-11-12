--Needle Worm
local s,id=GetID()
function s.initial_effect(c)
	--flip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	--discard deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(s.discon)
	e2:SetTarget(s.distg)
	e2:SetOperation(s.disop)
	c:RegisterEffect(e2)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local rg=Duel.GetDecktopGroup(1-tp,5)
	if chk==0 then return rg:FilterCount(Card.IsAbleToRemove,nil,tp,POS_FACEDOWN,REASON_EFFECT)==5 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,rg,3,1-tp,LOCATION_DECK)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetDecktopGroup(1-tp,5)
	if #g==0 then return end
	Duel.DisableShuffleCheck()
	Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_DECK)
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,2)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.DiscardDeck(p,d,REASON_EFFECT)
end