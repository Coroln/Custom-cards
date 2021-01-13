 --Created and coded by Rising Phoenix
function c100000905.initial_effect(c)
	c:EnableReviveLimit()
	c:EnableCounterPermit(0x50)
			--counter
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c100000905.ctcon)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(c100000905.ctop)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c100000905.atkval)
	c:RegisterEffect(e2)
		local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
		--search
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(100000905,0))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_HAND)
	e4:SetCost(c100000905.costh)
	e4:SetTarget(c100000905.targeth)
	e4:SetOperation(c100000905.operationh)
	c:RegisterEffect(e4)
	--noxyz
		local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e10:SetValue(1)
	c:RegisterEffect(e10)
	--ce
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(100000905,1))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCost(c100000905.cost1)
	e4:SetOperation(c100000905.operationcou1)
	c:RegisterEffect(e4)
		--ce2
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(100000905,2))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCost(c100000905.cost2)
	e5:SetCondition(c100000905.condition2)
	e5:SetOperation(c100000905.operationcou2)
	c:RegisterEffect(e5)
end
function c100000905.condition2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	return e:GetHandler():GetEffectCount(EFFECT_DIRECT_ATTACK)==0
end
function c100000905.operationcou2(e,tp,eg,ep,ev,re,r,rp)
		local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end	
function c100000905.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x50,2,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x50,2,REASON_COST)
end
function c100000905.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x50,1,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x50,1,REASON_COST)
end

function c100000905.con(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
    return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function c100000905.operationcou1(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetCondition(c100000905.con)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c100000905.aclimitb)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function c100000905.aclimitb(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c100000905.costh(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c100000905.filterh(c)
	return c:IsSetCard(0x763) and c:IsAbleToHand()
end
function c100000905.targeth(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c100000905.filterh,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c100000905.operationh(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100000905.filterh,tp,LOCATION_DECK,0,1,2,nil)
	if g:GetCount()>0 then end
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_TO_HAND)
	e1:SetTargetRange(LOCATION_DECK,0)	
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN)
	Duel.RegisterEffect(e1,tp)
end
function c100000905.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x763)
end
function c100000905.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c100000905.cfilter,1,nil)
end
function c100000905.atkval(e,c)
	return Duel.GetCounter(0,1,1,0x50)*100
end
function c100000905.ctop(e,tp,eg,ep,ev,re,r,rp)
	if eg:GetFirst()~=e:GetHandler() then
	e:GetHandler():AddCounter(0x50,1)
end
end