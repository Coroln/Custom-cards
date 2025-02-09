local s,id=GetID()
function s.initial_effect(c)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLED)
    e1:SetCountLimit(1,id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
    --Banish itself
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMING_MAIN_END+TIMING_BATTLE_START+TIMING_BATTLE_END)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.bancon)
	e2:SetTarget(s.bantg)
	e2:SetOperation(s.banop)
	c:RegisterEffect(e2)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local a=Duel.GetAttacker()
	local t=Duel.GetAttackTarget()
	if chk==0 then
		return (t==c and a:IsAbleToRemove())
			or (a==c and t~=nil and t:IsAbleToRemove())
	end
	local g=Group.CreateGroup()
	if a:IsRelateToBattle() then g:AddCard(a) end
	if t~=nil and t:IsRelateToBattle() then g:AddCard(t) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	local g=Group.FromCards(a,d)
	local rg=g:Filter(Card.IsRelateToBattle,nil)
	Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
end

--e2
function s.bancon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsAbleToRemove()
end
function s.bantg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return e:GetHandler():IsAbleToRemove() end
end
function s.banop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.Remove(c,c:GetPosition(),REASON_EFFECT+REASON_TEMPORARY)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetRange(LOCATION_REMOVED)
		e1:SetCountLimit(1)
		if Duel.GetTurnPlayer()==tp then
			if Duel.GetCurrentPhase()==PHASE_DRAW then
				e1:SetLabel(Duel.GetTurnCount())
			else
				e1:SetLabel(Duel.GetTurnCount()+2)
			end
		else
			e1:SetLabel(Duel.GetTurnCount()+1)
		end
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetCondition(s.retcon)
		e1:SetOperation(s.retop)
		c:RegisterEffect(e1)
	end
end
function s.retcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()==e:GetLabel()
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetHandler())
	e:Reset()
end