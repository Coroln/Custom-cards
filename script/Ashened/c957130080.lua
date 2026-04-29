Duel.LoadScript("proc_trick2.lua")
local s,id=GetID()

function s.initial_effect(c)
	--Trick Summon procedure
	--"2 Effect Monsters that are DARK or Pyro + 1 Trap"
	Trick.AddProcedure(c,nil,nil,
		{{s.monfilter,2,2}},
		{{s.trapfilter,1,1}}
	)

	--If Trick Summoned or Special Summoned from GY: reduce ATK/DEF, gain ATK
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(
		function(e,tp,eg,ep,ev,re,r,rp)
				c= e:GetHandler()
				return (c:IsPreviousLocation(LOCATION_EXTRA) and not c:IsReason(REASON_EFFECT))
						or c:IsPreviousLocation(LOCATION_GRAVE)
		end
		)
	e1:SetTarget(s.atktg)
	e1:SetOperation(s.atkop)
	c:RegisterEffect(e1)

	--If this card attacks a monster: change that monster to Defense Position
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.poscon)
	e2:SetTarget(s.postg)
	e2:SetOperation(s.posop)
	c:RegisterEffect(e2)

	--Piercing battle damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e3)

	--If this card inflicts battle damage: Fusion Summon 1 DARK Pyro Fusion using your monsters
	local fusparam=aux.FilterBoolFunction(function (c) return c:IsRace(RACE_PYRO) or c:IsAttribute(ATTRIBUTE_DARK) end,nil)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLE_DAMAGE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,{id,1})
	e4:SetCondition( function (e,tp,eg,ep,ev,re,r,rp) return ep~=tp end )
	e4:SetTarget(Fusion.SummonEffTG(fusparam))
	e4:SetOperation(Fusion.SummonEffOP(fusparam))
	c:RegisterEffect(e4)

	--If a Fusion Monster is destroyed by card effect while a Field Spell exists: SS this from GY
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,3))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCountLimit(1,{id,2})
	e5:SetCondition(s.spcon)
	e5:SetTarget(s.sptg)
	e5:SetOperation(s.spop)
	c:RegisterEffect(e5)
end

--========================
-- Trick material filters
--========================
function s.monfilter(c)
	return c:IsType(TYPE_EFFECT) and (c:IsAttribute(ATTRIBUTE_DARK) or c:IsRace(RACE_PYRO))
end
function s.trapfilter(c)
	return c:IsType(TYPE_TRAP)
end

--=========================================
-- ATK/DEF reduce + gain ATK on summon
--=========================================
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_TRICK)
		or (c:IsPreviousLocation(LOCATION_GRAVE) and c:IsSummonType(SUMMON_TYPE_SPECIAL))
end

function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,nil,0,tp,0)
end

function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,c)
	if #g==0 then return end
	local totalAtk = 0
	for tc in aux.Next(g) do
		local atkBefore=tc:GetAttack()

		--ATK -200
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-250)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)

		--DEF -200
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)

		local atkAfter=tc:GetAttack()
		totalAtk = totalAtk + (atkBefore - atkAfter)
	end

	if totalAtk>0 and c:IsRelateToEffect(e) and c:IsFaceup() then
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_UPDATE_ATTACK)
		e3:SetValue(totalAtk)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
		c:RegisterEffect(e3)
	end
end

--=========================================
-- Attack announce -> change target to DEF
--=========================================
function s.poscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttackTarget()~=nil
end

function s.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetAttackTarget()
	if chk==0 then
		return tc and tc:IsCanChangePosition()
	end
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,tc,1,0,0)
end

function s.posop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsCanChangePosition() then
		Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE)
	end
end

--=========================================
-- GY revive condition
--=========================================
function s.cfilter(c,tp)
	return c:IsType(TYPE_FUSION) and c:IsPreviousControler(tp)
		and c:IsReason(REASON_EFFECT) and c:IsReason(REASON_DESTROY)
end

function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp)
		and Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsType,TYPE_FIELD),tp,LOCATION_FZONE,LOCATION_FZONE,1,nil)
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,LOCATION_GRAVE)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
