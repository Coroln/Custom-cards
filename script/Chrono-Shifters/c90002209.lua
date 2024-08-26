--Chrono-Shifters: Temporal Guardian
--Script by Coroln
local s,id=GetID()
function s.initial_effect(c)
	c:EnableCounterPermit(0x100A,LOCATION_PZONE+LOCATION_MZONE)
	--Enable pendulum summon
	Pendulum.AddProcedure(c)
	c:EnableReviveLimit()
	--Special Summon procedure
	Fusion.AddProcMixN(c,true,true,aux.FilterBoolFunctionEx(s.ffilter),3)
	Fusion.AddContactProc(c,s.contactfil,s.contactop,s.splimit)
	--increase ATK
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_CELESTIALWARRIOR))
	e1:SetValue(s.atkval)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(s.addct)
	e2:SetOperation(s.addc)
	c:RegisterEffect(e2)
	--attribute
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_ADD_ATTRIBUTE)
	e3:SetValue(ATTRIBUTE_LIGHT)
	c:RegisterEffect(e3)
	--to deck
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_BATTLE_DESTROY_REDIRECT)
	e4:SetValue(LOCATION_DECKBOT)
	c:RegisterEffect(e4)
	--atkup
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,0))
	e5:SetCategory(CATEGORY_ATKCHANGE)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_BATTLE_DESTROYING)
	e5:SetCondition(s.atkcon)
	e5:SetOperation(s.atkop)
	c:RegisterEffect(e5)
	--Spell Counter check
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_DESTROY)
	e6:SetOperation(s.ctchk)
	e6:SetLabel(0)
	c:RegisterEffect(e6)
	--Place itself in the Pendulum Zone
	local e6b=Effect.CreateEffect(c)
	e6b:SetDescription(aux.Stringid(id,2))
	e6b:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6b:SetProperty(EFFECT_FLAG_DELAY)
	e6b:SetCode(EVENT_DESTROYED)
	e6b:SetLabelObject(e6)
	e6b:SetCondition(s.pencon)
	e6b:SetTarget(s.pentg)
	e6b:SetOperation(s.penop)
	c:RegisterEffect(e6b)
end
s.listed_series={0x1AC0}
s.counter_place_list={0x100A}
s.listed_names={id}
--Special Summon procedure
function s.ffilter(c,fc,sumtype,tp)
	return c:IsRace(RACE_CELESTIALWARRIOR,fc,sumtype,tp)
end
function s.contactfil(tp)
	return Duel.GetReleaseGroup(tp)
end
function s.contactop(g)
	Duel.SendtoGrave(g,REASON_COST|REASON_MATERIAL)
end
function s.splimit(e,se,sp,st)
	local c=e:GetHandler()
	return not (c:IsLocation(LOCATION_EXTRA) and c:IsFacedown())
end
--increase ATK
function s.atkval(e,c)
	return e:GetHandler():GetCounter(0x100A)*100
end
--counter
function s.addct(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,3,0,0x100A)
end
function s.addc(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0x100A,3)
	end
end
--atkup
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsFaceup() and e:GetHandler():IsRelateToBattle()
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToBattle() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(200)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
		c:RegisterEffect(e1)
	end
end
--Spell Counter check
function s.ctchk(e,tp,eg,ep,ev,re,r,rp)
	e:SetLabel(e:GetHandler():GetCounter(0x100A))
end
--Place itself in the Pendulum Zone
function s.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return r&REASON_EFFECT+REASON_BATTLE~=0 and c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function s.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetLabelObject():GetLabel()
	if chk==0 then return Duel.CheckPendulumZones(tp)
		and (ct==0 or e:GetHandler():IsCanAddCounter(0x100A,ct,false,LOCATION_PZONE)) end
end
function s.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckPendulumZones(tp) then return false end
	local c=e:GetHandler()
	local ct=e:GetLabelObject():GetLabel()
	if c:IsRelateToEffect(e) and Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true) then
		Duel.BreakEffect()
		c:AddCounter(0x100A,ct)
	end
end