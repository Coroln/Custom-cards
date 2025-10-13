--Vile Germs (CSTM)
--Coroln
local s,id=GetID()
function s.initial_effect(c)
	aux.AddEquipProcedure(c,nil,aux.FilterBoolFunction(Card.IsRace,RACE_PLANT))
	--send to GY
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_SZONE)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
--send to GY
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetEquipTarget(c)
	local g=Group.CreateGroup()
	for i=1,2 do
		local token=Duel.CreateToken(tp,tc:GetOriginalCode())
		g:AddCard(token)
	end
	Duel.SendtoGrave(g,REASON_EFFECT)
end
