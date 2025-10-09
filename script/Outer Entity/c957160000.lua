local s,id=GetID()
function s.initial_effect(c)
    --xyz summon
	c:EnableReviveLimit()
	Xyz.AddProcedure(c,s.xyzfilter,nil,3,nil,nil,nil,nil,false,s.xyzcheck)

    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(Cost.DetachFromSelf(1,1,nil))
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)

    --e2: Unaffected by Spell/Trap effects in the same column
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetCode(EFFECT_IMMUNE_EFFECT)
    e2:SetRange(LOCATION_MZONE)
    e2:SetValue(s.CheckColumn)
    c:RegisterEffect(e2)

    --Destroy cards after moved
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.mvcon)
	e3:SetTarget(s.mvtg)
	e3:SetOperation(s.mvop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
end
--xyz summon
function s.xyzfilter(c,tp)
 	return c:IsLevelAbove(3)
end
function s.xyzcheck(g,tp)
  	local mg=g:Filter(function(c) return not c:IsHasEffect(511001175) end,nil)
  	return mg:GetClassCount(Card.GetLevel)==1 
end

--e1
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
        return Duel.IsExistingMatchingCard(function(tc) return tc:IsFaceup() and tc~=c end,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(function(tc) return tc:IsFaceup() and tc~=c end,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	local c=e:GetHandler()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESETS_STANDARD_PHASE_END,2)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESETS_STANDARD_PHASE_END,2)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
end
--e2
function s.CheckColumn(e,te)
    local c=e:GetHandler()
    local tc=te:GetOwner()
    return te:IsActiveType(TYPE_SPELL+TYPE_TRAP) and c:GetColumnGroup():IsContains(tc)
end
--e3/4
function s.mvcon(e,tp,eg,ep,ev,re,r,rp)
	return #eg==1 and eg:GetFirst():IsControler(1-tp)
end
function s.mvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local tc=eg:GetFirst()
	if tc:IsLocation(LOCATION_MZONE) then tc:CreateEffectRelation(e) end
end
function s.mvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=eg:GetFirst()
	if not c:IsRelateToEffect(e) or c:IsControler(1-tp)
		or not tc:IsRelateToEffect(e) or tc:IsControler(tp) then return end
	local seq1=c:GetSequence()
	local seq2=tc:GetSequence()
	if seq1>4 then return end
	if seq2<5 then seq2=4-seq2
	elseif seq2==5 then seq2=3
	elseif seq2==6 then seq2=1 end
	local nseq=seq1+(seq2>seq1 and 1 or -1)
	if seq1~=seq2 and (Duel.CheckLocation(tp,LOCATION_MZONE,nseq)) then
		Duel.MoveSequence(c,nseq)
		local cg=c:GetColumnGroup()
		if #cg>0 then
			Duel.BreakEffect()
            Duel.Overlay(c,cg,true)
		end
	end
end