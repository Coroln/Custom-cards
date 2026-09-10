local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	--e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=0
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsHasEffect,tp,0x3f,0x3f,1,nil,1082946) end
	local g=Duel.GetMatchingGroup(Card.IsHasEffect,tp,0x3f,0x3f,nil,1082946)
	for tc in g:Iter() do
	--if tc:GetOwner()==e:GetHandler():GetOwner() then
	ct=ct+tc:GetTurnCounter()
	--end
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct*1000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ct*1000)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsHasEffect,tp,0x3f,0x3f,nil,1082946)
	for tc in g:Iter() do
	--if tc:GetOwner()==e:GetHandler():GetOwner() then
	tc:SetTurnCounter(0)
	--end
	end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end