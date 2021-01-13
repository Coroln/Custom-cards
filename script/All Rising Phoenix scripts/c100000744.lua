	--energy
function c100000744.initial_effect(c)
	--Activate
		local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetDescription(aux.Stringid(100000744,0))
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_REMOVE)
		e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
		e2:SetCountLimit(1)
		e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e2:SetCondition(c100000744.condition)
	e2:SetTarget(c100000744.target3)
	e2:SetOperation(c100000744.activate3)	
	c:RegisterEffect(e2)
end
function c100000744.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x753) and c:IsType(TYPE_MONSTER)
end
function c100000744.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c100000744.cfilter,e:GetHandlerPlayer(),LOCATION_REMOVED,0,1,nil)
end
function c100000744.target3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c100000744.activate3(e,tp,eg,ep,ev,re,r,rp,c)
		if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)==0 then return end
	local g=Duel.GetDecktopGroup(1-tp,1)
	Duel.DisableShuffleCheck()
	Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
end