Duel.LoadScript("proc_trick2.lua")
local s,id=GetID()

function s.initial_effect(c)
	--Trick Summon procedure
	--"1 monster + 1 Trap"
	Trick.AddProcedure(c,nil,nil,
		{{s.monfilter,1,1}},
		{{s.trapfilter,1,1}}
	)

	--If a monster is Special Summoned from the GY (Quick Effect)
	local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_HANDES+CATEGORY_ATKCHANGE)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(2) --soft twice per turn
    e1:SetCondition(s.atkcon)
    e1:SetCost(s.atkcost)
    e1:SetTarget(s.atktg)
    e1:SetOperation(s.atkop)
    e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E)
    c:RegisterEffect(e1)
--[[
    e2:SetCountLimit(3)
    e2:SetCost(Cost.SoftOncePerChain(id))

    Cost.SoftOncePerChain=Cost.SoftUseLimitPerChain

    Cost.SoftUseLimitPerChain=use_limit_cost(RESET_CHAIN,true)


    local function use_limit_cost(reset,soft)
        return function(flag,ct)
            ct=ct or 1
            return function(e,tp,eg,ep,ev,re,r,rp,chk)
                local c=e:GetHandler()
                if chk==0 then return (soft and not c:HasFlagEffect(flag,ct)) or (not soft and not Duel.HasFlagEffect(tp,flag,ct)) end
                if soft then
                    c:RegisterFlagEffect(flag,RESET_EVENT|RESETS_STANDARD|reset,0,1)
                else
                    Duel.RegisterFlagEffect(tp,flag,reset,0,1)
                end
            end
        end
    end
    ]]
end

function s.monfilter(c)
	return c:IsType(TYPE_MONSTER)
end
function s.trapfilter(c)
	return c:IsType(TYPE_TRAP)
end

function s.cfilter(c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL) and c:IsPreviousLocation(LOCATION_GRAVE) and c:IsFaceup()
end

function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(id)~=0 then return false end
	return eg:IsExists(s.cfilter,1,nil)
end

function s.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,nil)
end

function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) and not c:HasFlagEffect(id) end
        c:RegisterFlagEffect(id,RESET_CHAIN,0,1)

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)

	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,nil,1,0,0)
end

function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(id,RESET_CHAIN,0,1)

	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) or not tc:IsFaceup() then return end
	if not c:IsRelateToEffect(e) or not c:IsFaceup() then return end

	local g=eg:Filter(s.cfilter,nil)
	if #g==0 then return end
	local atk=g:GetMaxGroup(Card.GetAttack):GetFirst():GetAttack()
	if atk<0 then atk=0 end

	--opponent monster loses ATK
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(-atk)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	tc:RegisterEffect(e1)

	--this card gains 800 ATK until end of next turn
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(800)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	c:RegisterEffect(e2)
end
