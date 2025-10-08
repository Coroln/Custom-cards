local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(s.drawop)
	c:RegisterEffect(e2)
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
		--rc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)
	end
	for _,te in ipairs(s[0][rc]) do
		if te==re then return end
	end
	table.insert(s[0][rc],re)
end
function s.drawop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetCode()==4098 and re:GetHandler():GetFlagEffect(id)==0 then
		for _,te in ipairs(s[0][re:GetHandler()]) do
			local _,ctmax,ctcode,ctflag,hopt=te:GetCountLimit()
			te:SetCountLimit(ctmax,{ctcode,hopt},ctflag)
		end
		re:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)
	end
end