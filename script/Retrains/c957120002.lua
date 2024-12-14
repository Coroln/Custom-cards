local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--Fusion Materials
	Fusion.AddProcMix(c,true,true,95952802,aux.FilterBoolFunctionEx(Card.IsRace,RACE_BEAST|RACE_PLANT))
    Fusion.AddContactProc(c,s.contactfil,s.contactop,true)

    local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
    --boost
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(1000)
	c:RegisterEffect(e2)
    --To Hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCondition(s.condition)
	e2:SetTarget(s.target)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
end
function s.contactfil(tp)
	return Duel.GetMatchingGroup(Card.IsAbleToDeckOrExtraAsCost,tp,LOCATION_MZONE,0,nil)
end
function s.contactop(g,tp)
	local fu,fd=g:Split(Card.IsFaceup,nil)
	if #fu>0 then Duel.HintSelection(fu,true) end
	if #fd>0 then Duel.ConfirmCards(1-tp,fd) end
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST|REASON_MATERIAL)
end

function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return (e:GetHandler():GetReason()&0x41)==0x41
end
function s.thfilter(c,e,tp)
	local DebugVar = 0
	if(c:IsAttribute(ATTRIBUTE_EARTH)) then
		DebugVar = DebugVar + 1
	end
	if(c:IsLevelBelow(3)) then
		DebugVar = DebugVar + 1
	end
	if(c:IsType(TYPE_NORMAL)) then
		DebugVar = DebugVar + 1
	end
	if(c:IsAbleToHand()) then
		DebugVar = DebugVar + 1
	end
	return DebugVar == 4
	--c:IsAttribute(ATTRIBUTE_EARTH) and c:IsLevelBelow(3) and c:IsType(TYPE_NORMAL) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end