--Tyrant Skull Archfiend
local s,id=GetID()
function s.initial_effect(c)
	--pendulum summon
	Pendulum.AddProcedure(c)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	c:RegisterEffect(e1)
	--pierce
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_PIERCE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(s.target)
	c:RegisterEffect(e2)
	--disable and destroy
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.condition)
	e3:SetOperation(s.disop)
	c:RegisterEffect(e3)
end
s.roll_dice=true
s.listed_series={0x9F1}
s.listed_series={0x45}
s.listed_names={id}
function s.splimit(e,c,sump,sumtype,sumpos,targetp)
	return not c:IsSetCard(0x45) and (sumtype&SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function s.target(e,c)
	return c:IsSetCard(0x45)
end
function s.filter(c)
	return c:IsSetCard(0x45)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	if not re:IsActiveType(TYPE_SPELL+TYPE_TRAP) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or #g~=1 then return false end
	local tg=g:GetFirst()
	local c=e:GetHandler()
	return tg~=c and tg:IsFaceup() and tg:IsSetCard(0x45)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local dc=Duel.TossDice(tp,1)
	if dc==1 or dc==3 or dc==2 then
		if Duel.NegateEffect(ev) then
			Duel.Destroy(re:GetHandler(),REASON_EFFECT)
		end
	end
end
