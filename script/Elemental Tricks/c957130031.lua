Duel.LoadScript("proc_trick2.lua")
local s,id=GetID()
function s.initial_effect(c)
--Send 1 trap from deck to GY
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCost(s.sgcost)
    e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
    e1:SetCountLimit(1,id)
    e1:SetHintTiming(0,TIMING_END_PHASE)
    c:RegisterEffect(e1)
    --ATK200
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,0))
    e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_BE_MATERIAL)
    e2:SetCondition(s.conEffGain)
    e2:SetOperation(s.opEffGain)
    c:RegisterEffect(e2)
end
s.listed_names={82999629}
function s.costfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsDiscardable()
end
function s.sgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,s.costfilter,1,1,REASON_COST|REASON_DISCARD)
end

function s.filter(c)
	return c:IsCode(82999629) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
        c=e:GetHandler()
        if not c:IsRelateToEffect(e) then return end
        if c:IsSSetable(true) then
        Duel.BreakEffect()
        c:CancelToGrave()
        Duel.ChangePosition(c,POS_FACEDOWN)
        Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
        end
        
	end
end

function s.conEffGain(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (r&REASON_TRICK) and not c:IsSummonType(SUMMON_TYPE_MAXIMUM) and c:GetReasonCard():IsAttribute(ATTRIBUTE_WATER)
end

function s.opEffGain(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local trickmon=c:GetReasonCard()

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1)) -- Neue Beschreibung
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(s.reptg_new)
	e1:SetOperation(s.repop_new)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	trickmon:RegisterEffect(e1)
end

function s.reptg_new(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return not c:IsReason(REASON_REPLACE)
			and Duel.IsExistingMatchingCard(s.repfilter,tp,LOCATION_HAND,0,1,nil)
			and c:GetFlagEffect(id)==0
	end
	if Duel.SelectEffectYesNo(tp,c,aux.Stringid(id,1)) then
		c:RegisterFlagEffect(id,RESET_PHASE+PHASE_END,0,1) -- Soft once per turn
		return true
	end
	return false
end

function s.repop_new(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	Duel.DiscardHand(tp,s.repfilter,1,1,REASON_EFFECT+REASON_DISCARD)
end