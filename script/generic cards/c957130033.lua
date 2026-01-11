--Script by RikaCPP
--アエアレオス・竜憑きの抑圧者
local s,id=GetID()
function s.initial_effect(c)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)

    --summon with 3 tribute summoned monsters
    local e1=aux.AddNormalSummonProcedure(c,true,false,3,3)
    local e2=aux.AddNormalSetProcedure(c)
    --tribute limit
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_TRIBUTE_LIMIT)
    e3:SetValue(s.tlimit)
    c:RegisterEffect(e3)

	--Place on top of Deck to gain extra Normal Summon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_HAND)
	e4:SetCountLimit(1,id)
	e4:SetOperation(s.nsop)
	c:RegisterEffect(e4)

	--Send to GY if Special Summoned
	local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(id,0))
    e5:SetCategory(CATEGORY_TOGRAVE)
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCountLimit(1)
    e5:SetCode(EVENT_PHASE+PHASE_END)
    e5:SetCondition(s.tgcon)
    e5:SetTarget(s.tgtg)
    e5:SetOperation(s.tgop)
    c:RegisterEffect(e5)

	--Negate monsters in same column
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EFFECT_DISABLE)
	e6:SetTargetRange(0,LOCATION_MZONE)
	e6:SetTarget(s.coltg)
	c:RegisterEffect(e6)

	--Move to adjacent Monster Zone
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetRange(LOCATION_MZONE)
	e7:SetHintTiming(TIMING_MAIN_END)
	e7:SetCondition(aux.AND(aux.seqmovcon,s.movConFlag))
	e7:SetTarget(s.movtg)
	e7:SetOperation(aux.seqmovtgop)
	c:RegisterEffect(e7)

	--Unaffected by Trap Cards in same column
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EFFECT_IMMUNE_EFFECT)
	e8:SetValue(s.immval)
	c:RegisterEffect(e8)
end

-- Tribute Summon condition
s.illegal=true
function s.tlimit(e,c)
	return not c:IsSummonType(SUMMON_TYPE_TRIBUTE)
end

-- Extra Normal Summon
function s.nsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SendtoDeck(c,nil,SEQ_DECKTOP,REASON_EFFECT)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(id, 1))
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
		e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end

-- Send to GY if Special Summoned
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSpecialSummoned()
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.SendtoGrave(c,REASON_EFFECT)
	end
end

-- Column negate
function s.coltg(e,c)
	local ec=e:GetHandler()
	return c:GetColumnGroup():IsContains(ec)
end

--e7 Move
function s.movtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return aux.seqmovtg(e,tp,eg,ep,ev,re,r,rp,chk) end
    local c=e:GetHandler()
    local ph=Duel.GetCurrentPhase()
    c:RegisterFlagEffect(id, RESET_EVENT+RESETS_STANDARD+RESET_PHASE+ph, 0, 1)
    aux.seqmovtg(e,tp,eg,ep,ev,re,r,rp,chk)
end

function s.movConFlag(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
	return Duel.IsTurnPlayer(1-tp) and (Duel.IsMainPhase() or Duel.IsBattlePhase()) and not c:HasFlagEffect(id)
end

-- Trap immunity in same column
function s.immval(e,te)
	c=e:GetHandler()
	return te:IsActiveType(TYPE_TRAP) and c:GetColumnGroup():IsContains(te:GetHandler())
end
