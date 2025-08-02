--Dice Deity TWO - Gluttony
--Script by Coroln
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,s.ffilter,s.fdfilter)
	if not s.global_check then
        s.global_check = true
        local ge=Effect.CreateEffect(c)
        ge:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        ge:SetCode(EVENT_TOSS_DICE)
        ge:SetOperation(s.global_dice_op)
        Duel.RegisterEffect(ge,0)
    end
	--lv change
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(s.target)
	e2:SetOperation(s.activate)
	c:RegisterEffect(e2)
	--gain atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(s.value)
	c:RegisterEffect(e3)
	--Burn effect on destruction
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(id,1))
    e4:SetCategory(CATEGORY_DICE+CATEGORY_DAMAGE)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e4:SetCode(EVENT_TO_GRAVE)
    e4:SetCondition(s.damcon)
    e4:SetTarget(s.damtg)
    e4:SetOperation(s.damop)
    c:RegisterEffect(e4)
end
s.roll_dice=true
s.effect_used = false
--fusion material
function s.ffilter(c,fc,sumtype,tp)
	return c:IsMonster()
end
function s.fdfilter(c,fc,sumtype,tp)
	return c.roll_dice
end
--Change die result
-- filter: finds your card face‑down in the Extra Deck
function s.filter_ed(c)
    return c:IsCode(id) and c:IsFacedown() 
end
function s.orgothfilter(c)
	return c:IsCode(15744417) and c:IsFaceup()
end
-- global dice‐listener
function s.global_dice_op(e,tp,eg,ep,ev,re,r,rp)
    if s.effect_used then return end
    -- only if at least one face‑down copy is in your ED
    if Duel.GetMatchingGroupCount(s.filter_ed,tp,LOCATION_EXTRA,0,nil)==0 then return end
	if Duel.GetMatchingGroupCount(s.orgothfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)>0 then return end
    -- prevent multiple uses in the same chain
    local cc = Duel.GetCurrentChain()
    local cid = Duel.GetChainInfo(cc, CHAININFO_CHAIN_ID)
    if s.last_chain == cid then
        return
    end
    -- offer the player
    if Duel.SelectYesNo(tp, aux.Stringid(id,0)) then
        local dice_count = ev
        local results = {}
        results[1] = 2  -- set the first die to 2
        for i=2, dice_count do
            results[i] = 0 -- set others to 0
        end
        Duel.SetDiceResult(table.unpack(results))
        Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(id,3))
        s.last_chain = cid
        s.effect_used = true
        local e_reset = Effect.CreateEffect(e:GetHandler())
        e_reset:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e_reset:SetCode(EVENT_PHASE+PHASE_END)
        e_reset:SetCountLimit(1)
        e_reset:SetOperation(function() s.effect_used=false end)
        e_reset:SetReset(RESET_PHASE+PHASE_END)
        Duel.RegisterEffect(e_reset, 0)
    end
end
--lv change
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local d1,d2=Duel.TossDice(tp,2)
	local sum=d1+d2
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(sum)
		c:RegisterEffect(e1)
	end
end
--gain atk
function s.value(e,c)
	return c:GetLevel()*500
end
--Burn effect on destruction
function s.damcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsReason(REASON_DESTROY)
end
function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
    local dice=Duel.TossDice(tp,1)
    Duel.Damage(1-tp,dice*200,REASON_EFFECT)
end