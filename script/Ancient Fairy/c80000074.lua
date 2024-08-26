--Antikes Feendorf
function c80000074.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--lp recover (1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(80000074,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTarget(c80000074.lptg)
	e2:SetOperation(c80000074.lpop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--cannot attack (2)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_ATTACK)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetCondition(c80000074.atkcon)
	c:RegisterEffect(e4)
	--token (3)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(80000074,0))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetCondition(c80000074.thcon)
	e5:SetTarget(c80000074.target)
	e5:SetOperation(c80000074.operation)
	c:RegisterEffect(e5)
end
--(1)
function c80000074.lpfilter(c)
	return c:IsSetCard(0x2c9c)
end
function c80000074.lptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c80000074.lpfilter,1,nil) end
end
function c80000074.lpop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,e:GetHandler():GetCode())
	Duel.Recover(tp,500,REASON_EFFECT)
end
--(2)
function c80000074.atkfilter(c)
	return c:IsFaceup() and c:IsCode(25862681) or c:IsCode(4179255)
end
function c80000074.atkcon(e)
	return Duel.IsExistingMatchingCard(c80000074.atkfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
--(3)
function c80000074.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_SZONE) and c:GetPreviousSequence()==5 and c:IsPreviousPosition(POS_FACEUP)
end
function c80000074.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c80000074.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,80000076,0,0x4011,0,0,2,RACE_FAIRY,ATTRIBUTE_LIGHT) then return end
	for i=1,2 do
		local token=Duel.CreateToken(tp,80000074+i)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UNRELEASABLE_SUM)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(1)
		token:RegisterEffect(e1,true)
	end
	Duel.SpecialSummonComplete()
end
