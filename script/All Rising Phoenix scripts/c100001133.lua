--MAXIMALE ENERGIE!!!! JAAAAAAA by Tobiz
--MENSCHHEIT! GEBT MIR EURE ENERGIE!!!!! Scripted and created by Rising Phoenix
function c100001133.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
		--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_SELF_DESTROY)
	e2:SetCondition(c100001133.descon)
	c:RegisterEffect(e2)
	local e11=Effect.CreateEffect(c)
	e11:SetCategory(CATEGORY_DESTROY)
	e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e11:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e11:SetCountLimit(1)
			e11:SetCost(c100001133.spcost)
	e11:SetRange(LOCATION_SZONE)
		e11:SetCondition(c100001133.tdcon)
	e11:SetTarget(c100001133.target)
	e11:SetOperation(c100001133.activate)
	c:RegisterEffect(e11)
end
function c100001133.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c100001133.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c100001133.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local dg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,dg:GetCount(),0,0)
end
function c100001133.activate(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	Duel.Destroy(dg,REASON_EFFECT)
end

	function c100001133.filter(c)
	return c:IsFaceup() and (c:IsCode(100001101) or c:IsCode(100001100) or c:IsCode(100001102) or c:IsCode(100001103))
end
function c100001133.descon(e)
	return not Duel.IsExistingMatchingCard(c100001133.filter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end