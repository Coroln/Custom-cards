--Needlebug Nest
local s,id=GetID()
function s.initial_effect(c)
	--discard deck
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_DECKDES)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTarget(s.distarget)
	e1:SetOperation(s.disop)
	c:RegisterEffect(e1)
	--Hatch
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetDescription(aux.Stringid(id,0))
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetCondition(s.condtion)
	e5:SetOperation(s.op)
	c:RegisterEffect(e5)
end
s.listed_names={81843628}
function s.distarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,5) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(5)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,5)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local p,val=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.DiscardDeck(p,val,REASON_EFFECT)
end
function s.condtion(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetPreviousLocation()==LOCATION_DECK
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local token=Duel.CreateToken(tp,30000396)
	Duel.SendtoHand(token,nil,REASON_EFFECT)
end