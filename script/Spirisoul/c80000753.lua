--Spirisoul Mansion
--Script by Coroln
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCondition(s.con)
	e2:SetValue(s.atlimit)
	c:RegisterEffect(e2)
    --mill
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCode(EVENT_TO_HAND)
	e3:SetCountLimit(1)
	e3:SetCondition(s.condition)
	e3:SetTarget(s.target)
	e3:SetOperation(s.operation)
	c:RegisterEffect(e3)
end
s.listed_names={0x356}
function s.cfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_ZOMBIE) and c:IsSetCard(0x356)
end
function s.con(e)
	return Duel.IsExistingMatchingCard(s.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function s.atlimit(e,c)
	return c:IsFacedown() or (c:GetRace()~=RACE_ZOMBIE and c:GetSetCard()~=0x356)
end
--mill
function s.cfilter(c,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_MZONE)
		and (c:GetSetCard())~=0x356
		and c:IsPreviousPosition(POS_FACEUP)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) and Duel.IsPlayerCanDiscardDeck(tp,1)
		and not e:GetHandler():IsStatus(STATUS_CHAINING) end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardDeck(tp,1,REASON_EFFECT)
end