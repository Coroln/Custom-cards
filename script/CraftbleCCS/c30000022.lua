local s,id=GetID()
function s.initial_effect(c)
	c:EnableCounterPermit(0x42)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,70138455,94119974)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(s.atkval)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_DAMAGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.ctcon)
	e2:SetOperation(s.ctop)
	c:RegisterEffect(e2)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(s.damtg2)
	e3:SetOperation(s.damop2)
	c:RegisterEffect(e3)
end
function s.atkval(e,c)
	return c:GetCounter(0x42)*100
end
function s.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and (r&REASON_EFFECT)~=0
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x42,1)
end
function s.damtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct=e:GetHandler():GetCounter(0x42)
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(ct)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct)
end
function s.damop2(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	local c=e:GetHandler()
	local ct=c:GetCounter(0x42)
	Duel.Damage(p,ct*100,REASON_EFFECT)
end