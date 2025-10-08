local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,false,false,CARD_CYBER_DRAGON,91989718)
	aux.GlobalCheck(s,function()
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD)
		ge2:SetCode(EFFECT_EXTRA_FUSION_MATERIAL)
		ge2:SetTargetRange(LOCATION_ALL,LOCATION_ALL)
		ge2:SetTarget(s.mttg)
		ge2:SetValue(s.mtval)
		Duel.RegisterEffect(ge2,0)
	end)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(s.condition)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	--Negate attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(s.discon)
	e2:SetOperation(s.disop)
	c:RegisterEffect(e2)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local cid=Duel.GetChainInfo(ev,CHAININFO_CHAIN_ID)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetValue(s.indval)
	e1:SetReset(RESET_CHAIN)
	e1:SetLabel(cid)
	Duel.RegisterEffect(e1,tp)
end
function s.indval(e,re,rp)
	return Duel.GetChainInfo(0,CHAININFO_CHAIN_ID)==e:GetLabel()
end
function s.mttg(e,c)
	return c:IsCode(66607691) and not c:IsMonster()
end
function s.mtval(e,c)
	if not c then return false end
	return c:IsOriginalCode(id)
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetFirst():IsControler(1-tp)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
end