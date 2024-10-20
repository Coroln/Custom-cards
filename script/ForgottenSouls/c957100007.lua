--require "Xyz.AddProcedureEx.lua"

local s,id=GetID()
function s.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	Xyz.AddProcedure(c,nil,2,2,nil,nil,2,nil,false,s.xyzcheck)

	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--Protect Face-up Monsters, while controling face-down Monsters
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetValue(s.atlimit)
	c:RegisterEffect(e2)
	--Banish "Chaos Soul" for detaching material
	
	local e3= Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,{id,1})
	e3:SetCost(aux.dxmcostgen(1,1,nil))
	e3:SetTarget(s.rmtg)
	e3:SetOperation(s.rmop)
	c:RegisterEffect(e3)
	
end
function s.xyzcheck(g,tp,xyz)
	local mg1=g:Filter(Card.IsAttribute,nil,ATTRIBUTE_LIGHT)
    local mg2=g:Filter(Card.IsAttribute,nil,ATTRIBUTE_DARK)
	return ((#mg1>0)and(#mg2>0)) --and g:GetClassCount()
end

--e1
function s.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and c:IsRace(RACE_BEAST) and c:IsLevelBelow(2)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,s.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
	end
end
--e2
function s.filter(c)
	return c:IsFacedown()
end
function s.atlimit(e,c)
	return  c:IsFaceup() and Duel.IsExistingMatchingCard(s.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end

function s.conditione2(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(s.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end

--e3
function s.dfilter(c)
	return c:IsSetCard(0x20CF) and c:IsAbleToRemove()
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.dfilter,tp,LOCATION_DECK,0,1,1,nil,nil)
	local tg=g:GetFirst()
	if tg==nil then return end
	Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
end


--[[
Adds an Xyz Procedure where (function f) is the required Xyz Material,
and (int lv) is the required level, but it can also be nil if there is no required Level.
(int ct) is the required number of materials.
(function alterf) is the alternate material, e.g. Number C39: Utopia Ray.
(int desc) is the description shown when attempting to Xyz Summon using (function alterf).
(int maxct) is the maximum number of materials, which defaults to (int ct).
(function op) is used by some monsters do something else in addition to using an Xyz Material (e.g. Digital Bug Corebage (detach 2 materials) or Number 99: Utopic Dragon (discard 1 "Rank-Up-Magic"))
(bool mustbemat) is used if you can only use the listed materials during the Xyz Summon, this disallows Anime effects such as Orichalcum Chain (minus 1 material) or Triangle Evolution (triple material).
(function exchk) is an additional check at the end of selecting materials (e.g. Number F0: Utopic Future (checks if the materials have the same Rank)

Xyz.AddProcedure(c,f,lv,ct,alterf,desc,maxct,op,mustbemat,exchk)
]]