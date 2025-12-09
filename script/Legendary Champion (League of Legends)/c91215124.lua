--Legendary Minions
--Coroln
local s,id=GetID()
function s.initial_effect(c)
    --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCountLimit(1)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end
--spsummon
function s.cansstoken(sum_p,targ_p)
	return Duel.GetLocationCount(targ_p,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(sum_p,91215135,0,TYPES_TOKEN,0,0,4,RACE_SPELLCASTER,ATTRIBUTE_DARK,POS_FACEUP,targ_p)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return s.cansstoken(tp,tp) or s.cansstoken(tp,1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,tp,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
    local b1=s.cansstoken(tp,tp)
	local b2=s.cansstoken(tp,1-tp)
	if not (b1 or b2) then return end
    local op=nil
    if b1 and b2 then
        op=Duel.SelectEffect(tp,
            {b1,aux.Stringid(id,2)},
            {b2,aux.Stringid(id,3)})
    else
        op=(b1 and 1) or (b2 and 2)
    end
    local targ_p=op==1 and tp or 1-tp
    local token=Duel.CreateToken(tp,91215135)
    Duel.SpecialSummonStep(token,0,tp,targ_p,false,false,POS_FACEUP)
    b1=s.cansstoken(tp,tp)
    b2=s.cansstoken(tp,1-tp)
    local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(s.synlimit)
	e1:SetReset(RESET_EVENT|RESETS_STANDARD_DISABLE&~RESET_TOFIELD)
	token:RegisterEffect(e1)
    --Any battle damage a player takes is halved
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,1)
	e2:SetValue(DOUBLE_DAMAGE)
	token:RegisterEffect(e2)
end
function s.synlimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x270)
end