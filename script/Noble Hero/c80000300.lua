--Nobel Hero Master Solomon
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--synchro summon
	Synchro.AddProcedure(c,nil,2,2,Synchro.NonTunerEx(Card.IsSetCard,0xBDF),1,99)
	--apply effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	--change atk
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,5))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCondition(s.atkcon)
	e2:SetOperation(s.atkop)
	c:RegisterEffect(e2)
	--battle
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--destroy
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,0))
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(s.dircon)
	e5:SetCost(s.cost)
	e5:SetTarget(s.target)
	e5:SetOperation(s.operation)
	c:RegisterEffect(e5)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupCost(tp,s.cfilter,1,false,nil,e:GetHandler()) end
	local g=Duel.SelectReleaseGroupCost(tp,s.cfilter,1,1,false,nil,e:GetHandler())
	Duel.Release(g,REASON_COST)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=not e:GetHandler():IsHasEffect(EFFECT_DIRECT_ATTACK)
	local b2=Duel.GetFlagEffect(1-tp,id+1)==0
	local b3=Duel.GetFlagEffect(1-tp,id+2)==0
	if chk==0 then return b1 or b2 or b3 end
	local stab={}
	local dtab={}
	if b1 then
		table.insert(stab,0x1)
		table.insert(dtab,aux.Stringid(id,2))
	end
	if b2 then
		table.insert(stab,0x2)
		table.insert(dtab,aux.Stringid(id,3))
	end
	if b3 then
		table.insert(stab,0x4)
		table.insert(dtab,aux.Stringid(id,4))
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	local op=Duel.SelectOption(tp,table.unpack(dtab))+1
	e:SetLabel(stab[op])
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=e:GetLabel()
	if op==0x1 then
		if not c:IsRelateToEffect(e) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(id,2))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DIRECT_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	elseif op==0x2 then
		Duel.RegisterFlagEffect(1-tp,id+1,RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,aux.Stringid(id,3))
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetCode(EFFECT_CANNOT_ACTIVATE)
		e2:SetTargetRange(0,1)
		e2:SetValue(s.aclimit1)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	else
		Duel.RegisterFlagEffect(1-tp,id+2,RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,aux.Stringid(id,4))
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3:SetCode(EFFECT_CANNOT_ACTIVATE)
		e3:SetTargetRange(0,1)
		e3:SetValue(s.aclimit2)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
	end
end
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(1-tp)<=4000
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local lp=Duel.GetLP(1-tp)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetValue(lp)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end
function s.aclimit1(e,re,tp)
	local rc=re:GetHandler()
	return rc and rc:IsLocation(LOCATION_SZONE)
end
function s.aclimit2(e,re,tp)
	local rc=re:GetHandler()
	return rc and rc:IsLocation(LOCATION_HAND+LOCATION_GRAVE)
end
--destroy
function s.dircon(e)
	return Duel.IsEnvironment(80000315)
end
function s.ccfilter(c)
	return c:IsFaceup() and c:IsCode(id) and c:IsAbleToGraveAsCost()
end
function s.ccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.ccfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.ccfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function s.ctarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function s.coperation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,e:GetHandler())
	Duel.Destroy(g,REASON_EFFECT)
end
