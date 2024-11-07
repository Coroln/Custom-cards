--Forge of Evil
--Script by Coroln
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
    --FIRE Warrior monsters you control gain 500 ATK
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(function(_,c) return c:IsSetCard(0x467) and c:IsSummonLocation(LOCATION_GRAVE) end)
	e2:SetValue(1000)
	c:RegisterEffect(e2)
    --Destruction replacement for an "Evil Smith" monster
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetTarget(s.reptg)
	e3:SetValue(s.repval)
	e3:SetOperation(s.repop)
	c:RegisterEffect(e3)
    --Return itself to the GY
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetCategory(CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_REMOVED)
    e4:SetCountLimit(1,id)
	e4:SetTarget(s.rettg)
	e4:SetOperation(s.retop)
	c:RegisterEffect(e4)
end
s.listed_series={0x467}
--activate
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:IsHasType(EFFECT_TYPE_ACTIVATE) end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		c:CancelToGrave()
		Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
        Duel.ShuffleDeck(tp)
        Duel.Draw(tp,1,REASON_EFFECT)
	end
end
--Destruction replacement for an "Evil Smith" monster
function s.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
		and c:IsSetCard(0x467) and not c:IsReason(REASON_REPLACE)
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemove() and eg:IsExists(s.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function s.repval(e,c)
	return s.repfilter(c,e:GetHandlerPlayer())
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT|REASON_REPLACE)
end
--
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x467) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGrave() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
        if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	    local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	    if #g>0 then
		    Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
        end
	end
end