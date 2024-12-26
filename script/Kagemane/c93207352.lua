--Kuransain of Weakness
--Script by Coroln and ChatGPT
local s,id=GetID()
function s.initial_effect(c)
    c:SetUniqueOnField(1,0,id)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
    --add counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(s.accon)
	e2:SetOperation(s.acop)
	c:RegisterEffect(e2)
    --increase ATK
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_MONSTER))
	e3:SetValue(s.atkval)
	c:RegisterEffect(e3)
    --summon limit
    local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(0,1) -- Affects opponent
	e4:SetCondition(s.splimitcon)
	c:RegisterEffect(e4)
	--Track Opponent's Special Summons
	local et=Effect.CreateEffect(c)
	et:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	et:SetCode(EVENT_SPSUMMON_SUCCESS)
	et:SetRange(LOCATION_SZONE)
	et:SetCondition(s.trackcon)
	et:SetOperation(s.trackop)
	c:RegisterEffect(et)
    --Reset Special Summon Count at the start of the opponent's turn
	local et1=Effect.CreateEffect(c)
	et1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	et1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
	et1:SetRange(LOCATION_SZONE)
	et1:SetOperation(s.resetop)
	c:RegisterEffect(et1)
    --Special Summon left count
	local et2=Effect.CreateEffect(c)
	et2:SetType(EFFECT_TYPE_FIELD)
	et2:SetCode(EFFECT_LEFT_SPSUMMON_COUNT)
	et2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	et2:SetRange(LOCATION_SZONE)
	et2:SetTargetRange(0,1)
	et2:SetValue(s.countval)
	c:RegisterEffect(et2)
    --selfdes
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCode(EFFECT_SELF_DESTROY)
	e5:SetCondition(s.sdcon)
	c:RegisterEffect(e5)
    --draw
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,1))
	e6:SetCategory(CATEGORY_DRAW)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetCode(EVENT_DESTROYED)
    e6:SetCondition(s.Descon)
	e6:SetTarget(s.drtg)
	e6:SetOperation(s.drop)
    e6:SetLabelObject(e5)
	c:RegisterEffect(e6)
end
s.listed_series={0x759F}
--add Weak Counter
function s.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_HAND) and c:IsReason(REASON_DISCARD)
end
function s.accon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp)
end
function s.acop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x1023,1)
end
--increase ATK
function s.atkval(e,c)
	return e:GetHandler():GetCounter(0x1023)*-100
end
--summon limit
-- Track opponent's Special Summon count
function s.trackcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp -- Only track opponent
end
function s.trackop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if ep~=tp then
		c:RegisterFlagEffect(id,RESET_PHASE+PHASE_END,0,1) -- Register summon count
	end
end
-- Reset Special Summon count
function s.resetop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:ResetFlagEffect(id)
end

-- Special Summon restriction condition
function s.splimitcon(e)
	local c=e:GetHandler()
	return c:GetFlagEffect(id)>=3 -- Restrict after 3 special summons
end

-- Special Summon left count
function s.countval(e,re,sump)
	local c=e:GetHandler()
	local ct=c:GetFlagEffect(id)
	if ct>=3 then
		return 0
	else
		return 3-ct
	end
end
--self destroy draw
function s.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x759F)
end
function s.sdcon(e)
	return not Duel.IsExistingMatchingCard(s.filter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function s.Descon(e,tp,eg,ep,ev,re,r,rp)
	return re and re==e:GetLabelObject()
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,1)
    Duel.SetChainLimit(aux.FALSE)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
    Duel.Draw(1-tp,d,REASON_EFFECT)
end
