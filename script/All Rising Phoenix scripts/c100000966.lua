 --Created and coded by Rising Phoenix
function c100000966.initial_effect(c)
c:EnableCounterPermit(0x51)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c100000966.ctcon)
	e2:SetOperation(c100000966.ctop)
	c:RegisterEffect(e2)
		--extra summon
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_FIELD)
	e11:SetRange(LOCATION_SZONE)
	e11:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e11:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e11:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x768))
	c:RegisterEffect(e11)
		--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100000966,0))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
		e3:SetCountLimit(1)
	e3:SetCost(c100000966.discost)
	e3:SetTarget(c100000966.drtg)
	e3:SetOperation(c100000966.drop)
	c:RegisterEffect(e3)
	end
function c100000966.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x768)
end
function c100000966.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c100000966.cfilter,1,nil)
end
function c100000966.ctop(e,tp,eg,ep,ev,re,r,rp)
		e:GetHandler():AddCounter(0x51,1)
end
function c100000966.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c100000966.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c100000966.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x51,3,REASON_COST) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	e:GetHandler():RemoveCounter(tp,0x51,3,REASON_COST)
end