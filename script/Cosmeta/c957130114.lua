--Cosmeta - Mind Collector
local SET_COSMETA = 0xCFC
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--Link Summon: 1 "Cosmeta" monster
	Link.AddProcedure(c,s.matfilter,1,1)
	--You can only Link Summon "Cosmeta - Mind Collector" once per turn
	c:SetSPSummonOnce(id)
	--If this card is Link Summoned: Discard 1 card, or if you cannot, destroy this card
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_HANDES+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(s.discon)
	e1:SetTarget(s.distg)
	e1:SetOperation(s.disop)
	c:RegisterEffect(e1)
	--This card cannot be used as Link Material during the turn it is Link Summoned
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e2:SetCondition(s.matcon)
	e2:SetValue(1)
	c:RegisterEffect(e2)
end
s.listed_series={SET_COSMETA}
--TODO: SET_COSMETA muss in constant.lua / archetype definiert sein.
--Falls nicht vorhanden, oben ersetzen durch: local SET_COSMETA=0x XXXX (Archetyp-Code eintragen)
function s.matfilter(c,lc,sumtype,tp)
	return c:IsSetCard(SET_COSMETA,lc,sumtype,tp)
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLinkSummoned()
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
	Duel.SetPossibleOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD,nil)==0 then
		if c:IsRelateToEffect(e) then
			Duel.Destroy(c,REASON_EFFECT)
		end
	end
end
function s.matcon(e)
	local c=e:GetHandler()
	return c:IsStatus(STATUS_SPSUMMON_TURN) and c:IsSummonType(SUMMON_TYPE_LINK)
end