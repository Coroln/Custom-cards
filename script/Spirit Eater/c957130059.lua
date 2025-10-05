local id, s = GetID()

-- CHANGE THIS to your actual SetCode for "Spirit Eater"
local SET_SPIRIT_EATER = 0xAAA -- <<--- TODO: set your real setcode here

---------------------------------------------------------------
-- Basic data
---------------------------------------------------------------
local s,id=GetID()
function s.initial_effect(c)
	-- Link Summon
	c:EnableReviveLimit()
	Link.AddProcedure(c, s.matfilter, 3, 99, s.lcheck)

	-- Always treated as "Spirit Eater"
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND+LOCATION_DECK+LOCATION_REMOVED+LOCATION_EXTRA)
	e0:SetCode(EFFECT_ADD_SETCODE)
	e0:SetValue(SET_SPIRIT_EATER)
	c:RegisterEffect(e0)

	-- Linked monsters gain 1000 ATK
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(s.atktg)
	e1:SetValue(1500)
	c:RegisterEffect(e1)

	-- Cannot be destroyed by battle by monsters it points to
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(s.indbval)
	c:RegisterEffect(e2)

	-- Cannot be destroyed by effects of monsters it points to
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetValue(s.indeval)
	c:RegisterEffect(e3)

	-- Draw on opponent summon(s) to linked zone (first 2 times per turn)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetCountLimit(2,id) -- shared with clones (normal/flip/special)
	e4:SetCondition(s.drcon)
	e4:SetTarget(s.drtg)
	e4:SetOperation(s.drop)
	c:RegisterEffect(e4)
	local e4b=e4:Clone()
	e4b:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4b)
	local e4c=e4:Clone()
	e4c:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e4c)

	-- Destroy 1 Special Summoned monster this card does not point to (Ignition)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,1))
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,id+100)
	e5:SetCondition(s.descon_ign)
	e5:SetTarget(s.destg)
	e5:SetOperation(s.desop)
	c:RegisterEffect(e5)
	-- same, but Quick Effect if you control another "Spirit Eater" monster
	local e6=e5:Clone()
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e6:SetCondition(s.descon_quick)
	c:RegisterEffect(e6)
end

---------------------------------------------------------------
-- Link materials
---------------------------------------------------------------
function s.matfilter(c, lc, st, tp)
	return c:IsRace(RACE_FIEND, lc, st, tp)
end
function s.sefilter(c)
	return c:IsSetCard(SET_SPIRIT_EATER)
end
-- At least 1 "Spirit Eater" among materials
function s.lcheck(g, lc, st, tp)
	return g:IsExists(s.sefilter,1,nil)
end

---------------------------------------------------------------
-- ATK target: monsters this card points to
---------------------------------------------------------------
function s.atktg(e,c)
	local lc=e:GetHandler()
	return lc:GetLinkedGroup():IsContains(c)
end

---------------------------------------------------------------
-- Indestructible by battle vs monsters it points to
---------------------------------------------------------------
function s.indbval(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c)
end
-- Indestructible by effects of monsters it points to
function s.indeval(e,te)
	local c=e:GetHandler()
	local rc=te:GetHandler()
	return te:IsActiveType(TYPE_MONSTER)
		and rc:IsLocation(LOCATION_MZONE)
		and c:GetLinkedGroup():IsContains(rc)
end

---------------------------------------------------------------
-- Draw effect on opponent's Summon to linked zone
---------------------------------------------------------------
-- checks if any of the summoned monsters are in zones this card points to and are controlled by opponent
function s.drcon(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp then return false end
	local c=e:GetHandler()
	return eg:IsExists(function(tc)
		return tc:IsFaceup() and c:GetLinkedGroup():IsContains(tc)
	end,1,nil)
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=eg:Filter(function(tc)
		return tc:IsFaceup() and c:GetLinkedGroup():IsContains(tc) and tc:IsControler(1-tp)
	end,nil)
	local ct=#g
	if chk==0 then return ct>0 and Duel.IsPlayerCanDraw(tp,ct) end
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=eg:Filter(function(tc)
		return tc:IsRelateToEffect(e) and tc:IsFaceup() and c:GetLinkedGroup():IsContains(tc) and tc:IsControler(1-tp)
	end,nil)
	local ct=#g
	if ct<=0 then return end
	local d=Duel.Draw(tp,ct,REASON_EFFECT)
	if d>1 then
		Duel.BreakEffect()
		Duel.DiscardHand(tp,aux.TRUE, d-1, d-1, REASON_EFFECT+REASON_DISCARD)
	end
end

---------------------------------------------------------------
-- Destroy target not pointed to; Special Summoned only
---------------------------------------------------------------
function s.desfilter(c, lc)
	return c:IsFaceup() and c:IsSummonType(SUMMON_TYPE_SPECIAL) and not lc:GetLinkedGroup():IsContains(c)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() and s.desfilter(chkc,c) end
	if chk==0 then return Duel.IsExistingTarget(s.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,s.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
-- Conditions for ignition vs quick
function s.has_other_se(tp, c)
	return Duel.IsExistingMatchingCard(function(x)
		return x:IsFaceup() and x:IsSetCard(SET_SPIRIT_EATER) and x~=c
	end, tp, LOCATION_MZONE, 0, 1, nil)
end
function s.descon_ign(e,tp,eg,ep,ev,re,r,rp)
	return not s.has_other_se(tp, e:GetHandler())
end
function s.descon_quick(e,tp,eg,ep,ev,re,r,rp)
	return s.has_other_se(tp, e:GetHandler())
end

---------------------------------------------------------------
-- Hints (optional): add strings in your .cdb texts for description indexes
---------------------------------------------------------------
-- 0: "Draw when opponent Summons to a zone this card points to"
-- 1: "Target 1 Special Summoned monster this card does not point to; destroy it"
