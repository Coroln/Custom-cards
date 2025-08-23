--Cascading Cards
--Script by Coroln
local s,id=GetID()
function s.initial_effect(c)
	--Draw
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.listed_names={id}
--Draw
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 and Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)>0
			and Duel.IsPlayerCanDraw(tp,1) and Duel.IsPlayerCanDraw(1-tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,1)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,PLAYER_ALL,1)
end
local function do_player_flow(p)
	local handct=Duel.GetFieldGroupCount(p,LOCATION_HAND,0)
	if handct==0 then return end
	Duel.Hint(HINT_SELECTMSG,p,HINTMSG_DISCARD)
	local sg=Duel.SelectMatchingCard(p,Card.IsDiscardable,p,LOCATION_HAND,0,1,handct,nil)
	if #sg==0 then return end
	local ct=Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
	if ct<=0 then return end
	if Duel.IsPlayerCanDraw(p,ct) then
		Duel.BreakEffect()
		local drew=Duel.Draw(p,ct,REASON_EFFECT)
		if drew>0 then
			local drawn=Duel.GetOperatedGroup()
			local mons=drawn:Filter(Card.IsType,nil,TYPE_MONSTER)
			if #mons>0 then
				Duel.BreakEffect()
				Duel.SendtoGrave(mons,REASON_EFFECT+REASON_DISCARD)
			end
		end
	end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	do_player_flow(tp)
	do_player_flow(1-tp)
end