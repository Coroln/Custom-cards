local s,id=GetID()

function s.initial_effect(c)
	-- Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end

-- Pay 2000 LP
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.CheckLPCost(tp,2000)
	end
	Duel.PayLPCost(tp,2000)
end

-- Target all face-up monsters your opponent currently controls
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil)
	end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,1-tp,LOCATION_MZONE)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local opp=1-tp

	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)

	if #g==0 then return end

	local rg=Group.CreateGroup()

	for tc in aux.Next(g) do
		if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)~=0 then
			rg:AddCard(tc)
		end
	end

	if #rg==0 then return end

	rg:KeepAlive()

	-- Return the banished monsters during the opponent's next Standby Phase
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetLabelObject(rg)
	e1:SetCondition(function (e,tp) return Duel.GetTurnPlayer()==1-tp end)
	e1:SetOperation(s.retop)
	Duel.RegisterEffect(e1,tp)

	-- Opponent takes no battle damage until their next Standby Phase
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	e2:SetReset(RESET_PHASE+PHASE_STANDBY)
	Duel.RegisterEffect(e2,tp)
end


-- Return the monsters to the field
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if g then
		local rg=g:Filter(Card.IsLocation,nil,LOCATION_REMOVED)
		for tc in aux.Next(rg) do
			if Duel.GetLocationCount(tc:GetPreviousControler(),LOCATION_MZONE)>0 then
				Duel.ReturnToField(tc)
			end
		end
		g:DeleteGroup()
	end
	e:Reset()
end
