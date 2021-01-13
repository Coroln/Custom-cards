function c100000857.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
		--return
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(100000857,0))
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetCategory(CATEGORY_TODECK)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetTarget(c100000857.rettg)
	e5:SetOperation(c100000857.retop)
	c:RegisterEffect(e5)
	--destroy
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(100000856,0))
	e6:SetCategory(CATEGORY_DESTROY)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_BATTLE_CONFIRM)
	e6:SetTarget(c100000857.destg)
	e6:SetOperation(c100000857.desop)
	e6:SetCondition(c100000857.descon)
	c:RegisterEffect(e6)
		--dest
	local e7=Effect.CreateEffect(c)
		e7:SetDescription(aux.Stringid(100000856,0))
			e7:SetCountLimit(1)
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetCode(EVENT_FREE_CHAIN)
		e7:SetRange(LOCATION_MZONE)
	e7:SetOperation(c100000857.sop)
	e7:SetCost(c100000857.cost)
	c:RegisterEffect(e7)
	--spsummon success
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c100000857.sop2)
	c:RegisterEffect(e8)
		--cannot act
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD)
	e9:SetCode(EFFECT_CANNOT_ACTIVATE)
	e9:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e9:SetRange(LOCATION_MZONE)
	e9:SetTargetRange(1,1)
	e9:SetValue(c100000857.actset)
	c:RegisterEffect(e9)
	--cannot set
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_FIELD)
	e10:SetCode(EFFECT_CANNOT_MSET)
	e10:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e10:SetRange(LOCATION_MZONE)
	e10:SetValue(c100000857.actset)
	e10:SetTargetRange(1,1)
	e10:SetTarget(aux.TRUE)
	c:RegisterEffect(e10)
	local e11=e10:Clone()
	e11:SetCode(EFFECT_CANNOT_SSET)
	e11:SetValue(c100000857.actset)
	c:RegisterEffect(e11)
	local e12=e10:Clone()
	e12:SetValue(c100000857.actset)
	e12:SetCode(EFFECT_CANNOT_TURN_SET)
	c:RegisterEffect(e12)
	local e13=e10:Clone()
	e13:SetValue(c100000857.actset)
	e13:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e13:SetTarget(c100000857.sumlimit)
	c:RegisterEffect(e13)
	--cannot sp
	local e14=Effect.CreateEffect(c)
	e14:SetType(EFFECT_TYPE_FIELD)
	e14:SetRange(LOCATION_MZONE)
	e14:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e14:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e14:SetTargetRange(1,1)
	e14:SetTarget(c100000857.spslimit)
	c:RegisterEffect(e14)
		--cannot ns
	local e15=Effect.CreateEffect(c)
	e15:SetType(EFFECT_TYPE_FIELD)
	e15:SetRange(LOCATION_MZONE)
	e15:SetCode(EFFECT_CANNOT_SUMMON)
	e15:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e15:SetTargetRange(1,1)
	e15:SetTarget(c100000857.spslimit)
	c:RegisterEffect(e15)
		--negate
	local e16=Effect.CreateEffect(c)
	e16:SetType(EFFECT_TYPE_FIELD)
	e16:SetRange(LOCATION_MZONE)
	e16:SetCode(EFFECT_CANNOT_SUMMON)
	e16:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e16:SetTargetRange(1,1)
	e16:SetTarget(c100000857.spslimit)
	c:RegisterEffect(e16)
		--disable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DISABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
	e3:SetTarget(c100000857.distgf)
	c:RegisterEffect(e3)
	--disable effect
	local e17=Effect.CreateEffect(c)
	e17:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e17:SetCode(EVENT_CHAIN_SOLVING)
	e17:SetRange(LOCATION_MZONE)
	e17:SetOperation(c100000857.disopf)
	c:RegisterEffect(e17)
	--disable trap monster
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_DISABLE_TRAPMONSTER)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetTarget(c100000857.distgf)
	c:RegisterEffect(e4)
		--disable
	local e18=Effect.CreateEffect(c)
	e18:SetType(EFFECT_TYPE_FIELD)
	e18:SetCode(EFFECT_DISABLE)
	e18:SetRange(LOCATION_MZONE)
	e18:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
	e18:SetTarget(c100000857.distgz)
	c:RegisterEffect(e18)
	--disable effect
	local e19=Effect.CreateEffect(c)
	e19:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e19:SetCode(EVENT_CHAIN_SOLVING)
	e19:SetRange(LOCATION_MZONE)
	e19:SetOperation(c100000857.disopz)
	c:RegisterEffect(e19)
		--disable
	local e23=Effect.CreateEffect(c)
	e23:SetType(EFFECT_TYPE_FIELD)
	e23:SetCode(EFFECT_DISABLE)
	e23:SetRange(LOCATION_MZONE)
	e23:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e23:SetTarget(c100000857.distgm)
	c:RegisterEffect(e23)
	--disable effect
	local e24=Effect.CreateEffect(c)
	e24:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e24:SetCode(EVENT_CHAIN_SOLVING)
	e24:SetRange(LOCATION_MZONE)
	e24:SetOperation(c100000857.disopm)
	c:RegisterEffect(e24)
end
function c100000857.distgm(e,c)
	return c:IsType(TYPE_MONSTER) and not c:IsSetCard(0x759) and not c:IsImmuneToEffect(e)
end
function c100000857.disopm(e,tp,eg,ep,ev,re,r,rp)
	local tl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	local rc=re:GetHandler()
	if tl==LOCATION_MZONE and re:IsActiveType(TYPE_MONSTER) and not rc:IsSetCard(0x759) and not rc:IsImmuneToEffect(e) then
		Duel.NegateEffect(ev)
	end
end
function c100000857.distgz(e,c)
	return c:IsType(TYPE_SPELL) and not c:IsSetCard(0x759) and not c:IsImmuneToEffect(e)
end
function c100000857.disopz(e,tp,eg,ep,ev,re,r,rp)
	local tl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	local rc=re:GetHandler()
	if tl==LOCATION_SZONE and re:IsActiveType(TYPE_SPELL) and not rc:IsSetCard(0x759) and not rc:IsImmuneToEffect(e) then
		Duel.NegateEffect(ev)
	end
end
function c100000857.distgf(e,c)
	return c:IsType(TYPE_TRAP) and not c:IsSetCard(0x759) and not c:IsImmuneToEffect(e)
end
function c100000857.disopf(e,tp,eg,ep,ev,re,r,rp)
	local tl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	local rc=re:GetHandler()
	if tl==LOCATION_SZONE and re:IsActiveType(TYPE_TRAP) and not rc:IsSetCard(0x759) and not rc:IsImmuneToEffect(e) then
		Duel.NegateEffect(ev)
	end
end
function c100000857.descon(e,tp,eg,ep,ev,re,r,rp)
	local t=Duel.GetAttackTarget()
	if ev==1 then t=Duel.GetAttacker() end
	e:SetLabelObject(t)
	return t 
end
function c100000857.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetLabelObject():IsDestructable() end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetLabelObject(),1,0,0)
end
function c100000857.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:IsRelateToBattle() then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c100000857.spslimit(e,c)
	return not c:IsSetCard(0x759)
end
function c100000857.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return bit.band(sumpos,POS_FACEDOWN)~=0
end
function c100000857.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c100000857.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
	end
end
function c100000857.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,nil,1,1,REASON_DISCARD+REASON_COST)
end
function c100000857.sop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,0,e:GetHandler())
	Duel.SendtoGrave(g,REASON_EFFECT)
end
function c100000857.sop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,e:GetHandler())
	Duel.SendtoGrave(g,REASON_EFFECT)
end
function c100000857.actset(e,re,tp)
	local rc=re:GetHandler()
	return not rc:IsSetCard(0x759) and not rc:IsImmuneToEffect(e)
end