--Kagemane Mage King - Ooboshi
--Script by Coroln and ChatGPT
local s,id=GetID()
function s.initial_effect(c)
    -- Xyz summon procedure
    c:EnableReviveLimit()
    Xyz.AddProcedure(c,nil,8,3,nil,nil,nil,nil,false,s.xyzcheck)
    --imune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(s.efilter)
	c:RegisterEffect(e1)
    --multi attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EXTRA_ATTACK)
	e2:SetValue(s.raval)
	c:RegisterEffect(e2)
    --Attach
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,0))
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_CUSTOM+id)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCondition(s.matcon)
    e3:SetTarget(s.mattg)
    e3:SetOperation(s.matop)
    c:RegisterEffect(e3)
    if not s.global_check then
        s.global_check=true
        local ge1=Effect.CreateEffect(c)
        ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        ge1:SetCode(EVENT_CHAIN_SOLVING)
        ge1:SetOperation(s.checkop)
        Duel.RegisterEffect(ge1,0)
    end
    --Destroy all cards on the field
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1,id)
	e4:SetCost(s.eqcost)
	e4:SetTarget(s.target)
	e4:SetOperation(s.operation)
	c:RegisterEffect(e4,false,REGISTER_FLAG_DETACH_XMAT)
end
-- Custom Xyz summon filter (different Attribute for each material)
function s.xyzcheck(g,tp,xyz)
    return g:GetClassCount(Card.GetAttribute)==#g
end
--imune
function s.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
--multi attack
function s.raval(e,c)
	local oc=e:GetHandler():GetOverlayCount()
	return math.max(0,oc-1)
end
--Attach
-- Check for a discarded monster's effect resolution
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
    if re and re:GetHandler():IsLocation(LOCATION_GRAVE) and re:GetHandler():IsReason(REASON_DISCARD) then
        Duel.RaiseEvent(re:GetHandler(),EVENT_CUSTOM+id,re,0,rp,ep,0)
    end
end
-- Condition to check if the monster can be attached
function s.matcon(e,tp,eg,ep,ev,re,r,rp)
    local tc=eg:GetFirst()
    return tc:IsLocation(LOCATION_GRAVE) and tc:IsReason(REASON_DISCARD)
end
-- Target to attach the monster to this card
function s.mattg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
end
-- Attach the monster to this card as Xyz Material
function s.matop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=eg:GetFirst()
    if c:IsRelateToEffect(e) then
        Duel.Overlay(c,tc,true)
    end
end
--Destroy all cards on the field
function s.eqcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	local g=e:GetHandler():GetOverlayGroup()
	Duel.SendtoGrave(g,REASON_COST)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.Destroy(g,REASON_EFFECT)
end