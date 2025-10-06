--Theiyra, The Demon Mistress of Hell
Duel.LoadScript("proc_trick2.lua")
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	Trick.AddProcedure(c,nil,nil,{{s.tfilter_fiend,1,1}},{{s.tfilter_trap,1,1}})
	c:SetUniqueOnField(1,0,id)

    --Alternative Summon Procedure
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(s.hspcon)
	e0:SetTarget(s.hsptg)
	e0:SetOperation(s.hspop)
	c:RegisterEffect(e0)

	-- inc. ATK for each monster in ST Zone
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(s.atkval)
	c:RegisterEffect(e1)

	-- Set 1 monster from both sides in owners ST Zone as Continuous Spell
	local e2A=Effect.CreateEffect(c)
	e2A:SetDescription(aux.Stringid(id,0))
	e2A:SetType(EFFECT_TYPE_IGNITION)
	e2A:SetRange(LOCATION_MZONE)
	e2A:SetCountLimit(1,id)
	e2A:SetTarget(s.sztg)
	e2A:SetOperation(s.szop)
	c:RegisterEffect(e2A)

	-- SP monster from ST Zone
	local e2B=Effect.CreateEffect(c)
	e2B:SetDescription(aux.Stringid(id,1))
	e2B:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2B:SetType(EFFECT_TYPE_IGNITION)
	e2B:SetRange(LOCATION_MZONE)
	e2B:SetCountLimit(1,id)
	e2B:SetTarget(s.sstg)
	e2B:SetOperation(s.ssop)
	c:RegisterEffect(e2B)

	-- Increase Fiend monster ATK while in ST Zone
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(function(e,tc) return tc:IsRace(RACE_FIEND) end)
	e3:SetValue(500)
	c:RegisterEffect(e3)

	-- SP self from ST Zone
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(function(e,tp) return Duel.GetTurnPlayer()==tp end)
	e4:SetCost(s.zonespcost)
	e4:SetTarget(s.zonesptg)
	e4:SetOperation(s.zonespop)
	c:RegisterEffect(e4)
end

--Trick summon filters
function s.tfilter_fiend(c)
	return c:IsMonster() and c:IsRace(RACE_FIEND) and c:IsLevelAbove(6)
end
function s.tfilter_trap(c)
	return c:IsTrap()
end

--e0 Alternative Summoning Procedure
function s.hspfilter(c)
	return c:IsMonsterCard() and c:IsFaceup() and c:IsAbleToGraveAsCost()
end
function s.hspcon(e,c)
	if not c then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
		and Duel.IsExistingMatchingCard(s.hspfilter,tp,LOCATION_STZONE,0,2,nil)
end
function s.hsptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.hspfilter,tp,LOCATION_STZONE,0,2,2,true,nil)
	if not g then return false end
	g:KeepAlive()
	e:SetLabelObject(g)
	return true
end
function s.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	if not g then return end
	Duel.SendtoGrave(g,REASON_COST|REASON_MATERIAL)
	g:DeleteGroup()
end

--e1 
function s.szone_monsterfilter(c)
	return c:IsFaceup() and c:IsLocation(LOCATION_SZONE) and c:IsOriginalType(TYPE_MONSTER)
end
function s.atkval(e,c)
	local tp=c:GetControler()
	local ct=Duel.GetMatchingGroupCount(s.szone_monsterfilter,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
	return ct*100
end

--e2A
function s.faceup_mon(c,p)
	return c:IsFaceup() and c:IsMonster() and c:IsControler(p)
end
function s.sztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.faceup_mon,tp,LOCATION_MZONE,0,1,nil,tp)
			and Duel.IsExistingMatchingCard(s.faceup_mon,tp,0,LOCATION_MZONE,1,nil,1-tp)
			and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
			and Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g1=Duel.SelectMatchingCard(tp,s.faceup_mon,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g2=Duel.SelectMatchingCard(tp,s.faceup_mon,tp,0,LOCATION_MZONE,1,1,nil,1-tp)
	g1:Merge(g2)
	Duel.SetTargetCard(g1)
end
function s.szop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetTargetCards(e)
	if #tg==0 then return end
	for tc in aux.Next(tg) do
		if tc:IsRelateToEffect(e) and tc:IsFaceup() and Duel.GetLocationCount(tc:GetControler(),LOCATION_SZONE)>0 then
			if Duel.MoveToField(tc,tc:GetControler(),tc:GetControler(),LOCATION_SZONE,POS_FACEUP,true) then
				local e0=Effect.CreateEffect(c)
				e0:SetType(EFFECT_TYPE_SINGLE)
				e0:SetCode(EFFECT_CHANGE_TYPE)
				e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e0:SetReset(RESET_EVENT|RESETS_STANDARD-RESET_TURN_SET)
				e0:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
				tc:RegisterEffect(e0)
			end
		end
	end
end

-- e2B
function s.sszfilter(c,e,tp)
	return c:IsFaceup() and c:IsLocation(LOCATION_SZONE) and c:IsOriginalType(TYPE_MONSTER)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp)
end
function s.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(s.sszfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,s.sszfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function s.ssop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end

-- e4 SP self from S/T-Zone
function s.costfilter(c)
	return c:IsFaceup() and c:IsLevel(6) and c:IsRace(RACE_FIEND) and c:IsReleasable()
end
function s.zonespcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,s.costfilter,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,s.costfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function s.zonesptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.zonespop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end