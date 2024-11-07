--Evil Smith's Blast Furnace
--Script by Coroln
local s,id=GetID()
function s.initial_effect(c)
	--Activate send to GY
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
    e1:SetCondition(s.condition)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
    --Activate Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetCountLimit(1,id)
    e2:SetCondition(s.con)
	e2:SetTarget(s.target)
	e2:SetOperation(s.op)
	c:RegisterEffect(e2)
end
s.listed_series={0x467}
--Activate send to GY
function s.envfilter(c)
	return c:IsCode(7581560)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(s.envfilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,1,nil)
end
function s.cfilter(c)
	return (c:IsCode(7581560) or (c:IsSetCard(0x467) and c:IsMonster())) and c:IsAbleToGrave()
end
function s.rescon(sg,e,tp,mg)
	return sg:IsExists(Card.IsCode,1,nil,7581560)
		and sg:IsExists(aux.AND(Card.IsSetCard,Card.IsMonster),1,nil,0x467)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_DECK,0,nil)
	if chk==0 then return aux.SelectUnselectGroup(g,e,tp,2,2,s.rescon,0) end
	local sg=aux.SelectUnselectGroup(g,e,tp,2,2,s.rescon,1,tp,HINTMSG_TOGRAVE,s.rescon)
	Duel.SendtoGrave(sg,REASON_EFFECT)
end
--Activate Special Summon
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.envfilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,1,nil)
end
function s.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and s.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(s.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
	local b2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
	local op=0
	Duel.Hint(HINT_SELECTMSG,tp,0)
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(id,1))
	elseif b2 then
		op=Duel.SelectOption(tp,aux.Stringid(id,2))+1
	else return end
	if op==0 then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	else
		Duel.SpecialSummon(tc,0,tp,1-tp,false,false,POS_FACEUP)
	end
end