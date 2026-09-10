--Bleeding Darkness
--rika
local s,id=GetID()
function s.initial_effect(c)
    --xyz summon
	Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_DARK),10,3)
	c:EnableReviveLimit()
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCondition(function (e,tp,eg,ep,ev,re,r,rp)return Duel.IsTurnPlayer(tp) end)
	e1:SetCountLimit(1)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)

    aux.GlobalCheck(s,function()
    local ge1=Effect.CreateEffect(c)
    ge1:SetType(EFFECT_TYPE_FIELD)
    ge1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    ge1:SetTarget(s.cttg)
    ge1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    ge1:SetValue(1)
    Duel.RegisterEffect(ge1,0)
    end)

    --Special summon itself from GY
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1,{id,1})
    e2:SetCost(s.gyspcost)
    e2:SetTarget(s.gysptg)
    e2:SetOperation(s.gyspop)
    c:RegisterEffect(e2)

end

function s.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=c:GetOverlayGroup():Filter(s.spfilter,nil,e,tp)
	if chk==0 then return #g>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	local g=c:GetOverlayGroup():Filter(s.spfilter,nil,e,tp)
	if #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=g:Select(tp,1,1,nil):GetFirst()
	if sc then
		if Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP) then
            if sc:IsOnField() then
                sc:AddCounter(0x10A0,1)
            end
        end
	end
end

function s.filter(c)
	return c:GetCounter(0x10A0)>0
end

function s.cttg(e,c)
	return s.filter(c)
end
--Revive + Field Wipe
function s.cfilter2(c,tp)
    return (c:GetCounter(0x10A0)>0) and Duel.GetMZoneCount(tp,c)>0
end
function s.gyspcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupCost(tp,s.cfilter2,3,false,nil,nil,tp) end
	local g=Duel.SelectReleaseGroupCost(tp,s.cfilter2,3,3,false,nil,nil,tp)
	Duel.Release(g,tp,REASON_COST)
end
function s.gysptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.gyspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
        local dt=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_ONFIELD,nil)
        if #dt > 0 then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
            Duel.Destroy(dt,REASON_EFFECT)
        end
	end
end
