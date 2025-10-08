local s,id=GetID()
function s.initial_effect(c)
	aux.AddEquipProcedure(c,nil,aux.FilterBoolFunction(Card.IsCode,10992251))
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(600)
	c:RegisterEffect(e2)
	--pierce
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e3)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetOperation(s.damop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_ADJUST)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return e:GetHandler():GetEquipTarget():GetFlagEffect(id)>0 end)
	e4:SetOperation(s.tptop)
	c:RegisterEffect(e4)
	aux.GlobalCheck(s,function()
		s[0]={}
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetOperation(s.clear)
		Duel.RegisterEffect(ge2,0)
	end)
end
s.listed_names={10992251}
function s.filter2(c,e,tp)
	return e:GetHandler():GetEquipTarget()==c or (c:GetCode()==14291024 and c:GetFirstCardTarget()==e:GetHandler():GetEquipTarget())
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_MZONE,0,nil,e)
	local directhit=#g
	while directhit>0 do
	local token=Duel.CreateToken(tp,76103675)
	Duel.SendtoHand(token,nil,REASON_EFFECT)
	directhit=directhit-1
	end
end
function s.clear(e,tp,eg,ep,ev,re,r,rp)
	s[0]={}
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if re:IsHasProperty(EFFECT_FLAG_NO_TURN_RESET) then return end
	local _,ctmax,_,ctflag=re:GetCountLimit()
	if ctflag&(EFFECT_COUNT_CODE_OATH+EFFECT_COUNT_CODE_DUEL)>0 or ctmax~=1 then return end
	if rc:GetFlagEffect(id)==0 then
		s[0][rc]={}
		rc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)
	end
	for _,te in ipairs(s[0][rc]) do
		if te==re then return end
	end
	table.insert(s[0][rc],re)
end
function s.filter(c,tp)
	if c:GetFlagEffect(id)==0 or c:IsHasEffect(EFFECT_CANNOT_TRIGGER) then return false end
	local effs={Duel.GetPlayerEffect(tp,EFFECT_CANNOT_ACTIVATE)}
	for _,te in ipairs(s[0][c]) do
		for _,eff in ipairs(effs) do
			if type(eff:GetValue())=='function' then
				if eff:GetValue()(eff,te,tp) then return false end
			else return false end
		end
		return true
	end
	return false
end
function s.tptop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_MZONE,0,nil,e)
	local eqc=e:GetHandler():GetEquipTarget()
	for _,te in ipairs(s[0][eqc]) do
		local chk=true
		if chk then
			local _,ctmax,ctcode,ctflag,hopt=te:GetCountLimit()
				te:SetCountLimit(ctmax+1,{ctcode,hopt},ctflag)
		end
	end
end