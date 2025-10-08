local s,id=GetID()
function s.initial_effect(c)
	--pendulum summon
	Pendulum.AddProcedure(c)
	c:EnableCounterPermit(0x2f,LOCATION_PZONE)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e0:SetRange(LOCATION_MZONE)
	e0:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetTargetRange(LOCATION_ONFIELD,0)
	e0:SetTarget(s.tgtg)
	e0:SetValue(aux.tgoval)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(s.cfilter)
	e1:SetValue(s.efilter)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EVENT_PHASE|PHASE_STANDBY)
	e2:SetCountLimit(1)
	e2:SetOperation(s.addc)
	c:RegisterEffect(e2)
	--addown
	local e3=Effect.CreateEffect(c)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_PZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetValue(s.adval)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
end
s.counter_place_list={0x2f}
function s.addc(e,tp,eg,ep,ev,re,r,rp)
		e:GetHandler():AddCounter(0x2f,1)
end
function s.adval(e,c)
	return e:GetHandler():GetCounter(0x2f)*-100
end
function s.cfilter(c,tp)
	return c:IsLevelAbove(6) and c:IsRace(RACE_ZOMBIE) and c:IsControler(tp)
end
function s.efilter(e,re,tc)
	if not (re:IsActivated() and e:GetOwnerPlayer()==1-re:GetOwnerPlayer()) then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return true end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return not g or not g:IsContains(tc)
end
function s.tgtg(e,c)
	return c:IsCode(29155212)
end