local s,id=GetID()
function s.initial_effect(c)
local e1=Effect.CreateEffect(c)
e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
e1:SetCode(EVENT_DRAW)
e1:SetRange(LOCATION_MZONE)
e1:SetOperation(s.cfop)
c:RegisterEffect(e1)
end
function s.cfop(e,tp,eg,ep,ev,re,r,rp)
	if ep==e:GetOwnerPlayer() then return end
	Duel.ConfirmCards(1-ep,eg)
	for ac in eg:Iter() do
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCode(EFFECT_FORBIDDEN)
	e1:SetTargetRange(0,0x7f)
	e1:SetLabel(ac:GetCode())
	e1:SetTarget(s.bantg)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	end
end
function s.bantg(e,c)
	return c:IsCode(e:GetLabel())
end