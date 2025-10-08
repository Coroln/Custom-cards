local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--summon with 1 tribute
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_HAND,0)
	e2:SetCode(EFFECT_SUMMON_PROC)
	e2:SetCondition(s.otcon)
	e2:SetTarget(aux.FieldSummonProcTg(s.ottg,s.ottgsum))
	e2:SetOperation(s.otop)
	e2:SetValue(SUMMON_TYPE_TRIBUTE)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_SET_PROC)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(s.condition)
	e4:SetOperation(s.operation)
	c:RegisterEffect(e4)
end
function s.cfilter(c)
	return (c:GetPreviousTypeOnField()&TYPE_MONSTER)==TYPE_MONSTER
end
function s.otfilter(c,tp)
	return c:IsLevelAbove(5) and (c:IsControler(tp) or c:IsFaceup())
end
function s.otcon(e,c,minc)
	if c==nil then return true end
	if minc>1 then return false end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(s.otfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
	return Duel.CheckTribute(c,1,1,mg)
end
function s.ottg(e,c)
	return c:IsLevelAbove(7)
end
function s.ottgsum(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local mg=Duel.GetMatchingGroup(s.otfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then
		mg:Match(Card.IsControler,nil,tp)
	end
	local sg=Duel.SelectTribute(tp,c,1,1,mg,nil,nil,true)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	end
	return false
end
function s.otop(e,tp,eg,ep,ev,re,r,rp,c)
	local sg=e:GetLabelObject()
	if not sg then return end
	c:SetMaterial(sg)
	Duel.Release(sg,REASON_SUMMON|REASON_MATERIAL)
	sg:DeleteGroup()
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local mg=tc:GetMaterial()
	return tc:IsTributeSummoned() and tc:IsSummonPlayer(tp) and mg 
		and mg:FilterCount(s.cfilter,nil)==1
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local mc=tc:GetMaterial():GetFirst()
	tc:CopyEffect(mc:GetOriginalCode(),RESET_EVENT+RESETS_STANDARD,1)
	if not tc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(tc)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e2,true)
	end
end