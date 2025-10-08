local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsHasEffect,tp,0x3f,0x3f,1,nil,1082946) end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsHasEffect,tp,0x3f,0x3f,nil,1082946)
	for tc in g:Iter() do if tc:GetOwner()==e:GetHandler():GetOwner() then
	--tc:SetTurnCounter(tc:GetTurnCounter()+1)
	local eff={tc:GetCardEffect(1082946)}
	local sel={}
	local seld={}
	local turne
	for _,te in ipairs(eff) do
		table.insert(sel,te)
		table.insert(seld,te:GetDescription())
	end
	if #sel==1 then turne=sel[1] elseif #sel>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
		local op=Duel.SelectOption(tp,table.unpack(seld))+1
		turne=sel[op]
	end
	if not turne then return end
	local op=turne:GetOperation()
	op(turne,turne:GetOwnerPlayer(),nil,0,1082946,nil,0,0)
	end
	end
end