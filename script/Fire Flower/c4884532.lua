--Fractal Bloom Flare
--Script by Coroln
local s,id=GetID()
function s.initial_effect(c)
    --damage
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,id)
	e1:SetTarget(s.damtg)
	e1:SetOperation(s.damop)
	c:RegisterEffect(e1)
end
--damage
function s.firefilter(c)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsMonster()
end
function s.plantfilter(c)
	return c:IsRace(RACE_PLANT) and c:IsMonster()
end
function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	local val=Duel.GetMatchingGroupCount(s.firefilter,c:GetControler(),LOCATION_REMOVED,0,nil)*200
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(val)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,val)
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local val=Duel.GetMatchingGroupCount(s.plantfilter,c:GetControler(),LOCATION_REMOVED,0,nil)*200
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
    Duel.Damage(p,val,REASON_EFFECT)
end