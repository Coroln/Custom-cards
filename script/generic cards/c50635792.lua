--Infinite Dark Storm
--Script by Coroln
local s,id=GetID()
function s.initial_effect(c)
	--Activate(summon)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--absorb
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCondition(s.notlocation)
	e4:SetTarget(s.absorbtg)
	e4:SetOperation(s.absorbop)
	c:RegisterEffect(e4)
	local e4a=e4:Clone()
	e4a:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e4a)
	local e4b=e4:Clone()
	e4b:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e4b)
	--spsummon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,0))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_FZONE)
	e5:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e5:SetCountLimit(1)
	e5:SetTarget(s.target)
	e5:SetOperation(s.operation)
	c:RegisterEffect(e5)
	-- Store material count when leaving the field
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e6:SetCode(EVENT_LEAVE_FIELD_P)
    e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e6:SetOperation(s.regop)
    c:RegisterEffect(e6)
    -- Trigger when destroyed
    local e7=Effect.CreateEffect(c)
    e7:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE)
    e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e7:SetProperty(EFFECT_FLAG_DELAY)
    e7:SetCode(EVENT_DESTROYED)
    e7:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return e:GetHandler():IsPreviousLocation(LOCATION_FZONE) end)
    e7:SetTarget(s.rmtg)
    e7:SetOperation(s.rmop)
    c:RegisterEffect(e7)
    e6:SetLabelObject(e7)
end
--absorb
function s.notlocation(e,tp,eg,ep,ev,re,r,rp)
	return (eg:IsExists(aux.NOT(Card.IsSummonLocation),1,nil,LOCATION_EXTRA) or re:GetHandler())
end
function s.filter(c,tp)
	return c:GetSummonLocation()&(LOCATION_HAND|LOCATION_GRAVE|LOCATION_REMOVED|LOCATION_DECK)~=0
		and c:IsLocation(LOCATION_MZONE)
end
function s.absorbtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(s.filter,nil,tp)
	local ct=#g
	if chk==0 then return ct>0 end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,ct,0,0)
end
function s.absorbop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=eg:Filter(s.filter,nil,e)
	local c=e:GetHandler()
	if #g>0 then
	    Duel.Overlay(c,g)
	end
end
--spsummon
function s.spfilter(c,e,tp)
	return c:IsMonster() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():GetOverlayCount()>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetOverlayGroup():Select(tp,1,1,nil):GetFirst()
	if tc then
	    Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
--banish and damage
-- Save materials before leaving field
function s.regop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local og=c:GetOverlayGroup()
    if #og>0 then
        og:KeepAlive()
        e:GetLabelObject():SetLabelObject(og) -- Save group to second effect
    end
end

-- Target the saved materials
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=e:GetLabelObject()
    if chk==0 then return g and #g>0 end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,0,0)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,#g*300)
end

-- Banish saved materials and apply damage
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
    local g=e:GetLabelObject()
    if g and #g>0 then
        local ct=Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
        if ct>0 then
            Duel.Damage(tp,ct*300,REASON_EFFECT)
            Duel.Damage(1-tp,ct*300,REASON_EFFECT)
        end
    end
end