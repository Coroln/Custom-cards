--PM Gluraknit x
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	Ritual.AddProcEqual{handler=c,filter=s.ritualfil,matfilter=s.matfilter,nil}
	--Material Return
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(s.ritual_summon_condition)
	e2:SetCost(aux.SelfBanishCost)
	e2:SetTarget(s.ritual_summon_target)
	e2:SetOperation(s.ritual_summon_operation)
	c:RegisterEffect(e2)
end
s.fit_monster={19962006}
--Ritual Summon
function s.ritualfil(c)
	return c:IsCode(19962006) and c:IsRitualMonster()
end
function s.matfilter(c)
	return c:IsCode(19962005)
end
function s.extrafil(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.GetMatchingGroup(s.mfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
end
--Material Return
-- Condition to check if this card is in the GY
function s.ritual_summon_condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_SZONE)
end
-- Targeting a monster tributed for the Ritual Summon
function s.ritual_summon_target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.tributed_filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.tributed_filter,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.SelectTarget(tp,s.tributed_filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
-- Filter for tributed monsters
function s.tributed_filter(c)
	return c:IsReason(REASON_RITUAL) and c:IsAbleToHand()
end
-- Returning the target to the hand
function s.ritual_summon_operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
