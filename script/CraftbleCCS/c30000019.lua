local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,5901497,64501875)
	--Toss a coin and negate an effect when it resolves
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EVENT_CHAINING)
	e0:SetRange(LOCATION_MZONE)
	e0:SetOperation(aux.chainreg)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.discon)
	e1:SetOperation(s.disop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e2)
end
s.toss_coin=true
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and Duel.IsChainDisablable(ev) and e:GetHandler():GetFlagEffect(1)>0
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.CountHeads(Duel.TossCoin(tp,1))==1 then
		if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then Duel.Destroy(re:GetHandler(),REASON_EFFECT)
	end
	end
end
