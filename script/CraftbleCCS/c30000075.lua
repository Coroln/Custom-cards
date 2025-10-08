local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	--Alter LP cost for "Archfiend" monsters during the Standby Phase
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EVENT_PAY_LPCOST)
	e2:SetCondition(s.lpcon)
	e2:SetOperation(s.lpop)
	c:RegisterEffect(e2)
end
s.listed_series={0x45}
function s.lpcon(e,tp,eg,ep,ev,re,r,rp)
	if not re then return false end
	local rc=re:GetHandler()
	return Duel.GetCurrentPhase()==PHASE_STANDBY and rc:IsSetCard(0x45) and rc:IsMonster() and rc:GetOwner()==e:GetHandler():GetOwner()
end
function s.lpop(e,tp,eg,ep,ev,re,r,rp)
	local eval = ev+200
	Duel.Recover(ep,eval,REASON_EFFECT)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local archfiend=0
	local dc=Duel.TossDice(tp,1)
	if dc==1 then
	archfiend=30000099
	elseif dc==2 then
	archfiend=72192100
	elseif dc==3 then
	archfiend=9603356
	elseif dc==4 then
	archfiend=30000070
	elseif dc==5 then
	archfiend=8581705
	else
	archfiend=35975813
	end
	local token=Duel.CreateToken(tp,archfiend)
	Duel.SendtoHand(token,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,token)
end