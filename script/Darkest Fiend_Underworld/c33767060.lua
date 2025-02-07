--Witch from Darkest Wunderworld
--Script by Coroln
local s,id=GetID()
function s.initial_effect(c)
	--Special Summon procedure
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
    --cannot target (Synchro)
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,0))
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_TO_GRAVE)
    e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
    e2:SetCondition(s.condition)
    e2:SetTarget(s.target)
    e2:SetOperation(s.operation)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EVENT_REMOVE)
    e3:SetCondition(s.condition2)
    c:RegisterEffect(e3)
    --A ritual monster using this card cannot be destroyed by card effects
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCondition(s.indcon)
	e2:SetOperation(s.indop)
	c:RegisterEffect(e2)
end
--Special Summon procedure
function s.spfilter(c,tp)
	return c:IsRace(RACE_FIEND) and c:IsAbleToRemoveAsCost() and Duel.GetMZoneCount(tp,c)>0
		and aux.SpElimFilter(c,true)
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,tp)
	return aux.SelectUnselectGroup(g,e,tp,1,1,nil,0)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,tp)
	local rg=aux.SelectUnselectGroup(g,e,tp,1,1,nil,1,tp,HINTMSG_REMOVE,nil,nil,true)
	if #rg>0 then
		rg:KeepAlive()
		e:SetLabelObject(rg)
		return true
	end
	return false
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local rg=e:GetLabelObject()
	if not rg then return end
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
	rg:DeleteGroup()
end
--cannot target (Synchro)
function s.condition(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	return c:IsLocation(LOCATION_GRAVE) and (r&REASON_SYNCHRO)==REASON_SYNCHRO and c:GetReasonCard():IsRace(RACE_FIEND)
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsPreviousLocation(LOCATION_GRAVE) and re:GetHandler():IsType(TYPE_FIELD)
end
-- Target Synchro monster you control
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) end
    if chk==0 then return Duel.IsExistingTarget(Card.IsType,tp,LOCATION_MZONE,0,1,nil,TYPE_SYNCHRO) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    local g=Duel.SelectTarget(tp,Card.IsType,tp,LOCATION_MZONE,0,1,1,nil,TYPE_SYNCHRO)
end

-- Apply the effect to make the Synchro monster untargetable
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetDescription(aux.Stringid(id,1))
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
        e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
        e1:SetRange(LOCATION_MZONE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        e1:SetValue(1)
        tc:RegisterEffect(e1)
    end
end
--A ritual monster using this card cannot be destroyed by card effects
function s.indcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_RITUAL
end
function s.indop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	--Cannot be destroyed by card effects
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(3001)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1)
end