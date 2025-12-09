--Legendary Champion Teemo
--Coroln
local s,id=GetID()
function s.initial_effect(c)
    --Change itself to face-down
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(s.postg)
	e1:SetOperation(s.posop)
	c:RegisterEffect(e1)
    --Summon: Special Summon up to 2 "Mushroom Tokens"
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_SUMMON_SUCCESS)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetTarget(s.tktg)
    e2:SetOperation(s.tkop)
    c:RegisterEffect(e2)
    local e2a=e2:Clone()
    e2a:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e2a)
    local e2b=e2:Clone()
    e2b:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
    c:RegisterEffect(e2b)
end
s.listed_names={id,91215136}
s.listed_series={0x270}
--Change itself to face-down
function s.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanTurnSet() end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,c,1,0,0)
end
function s.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.ChangePosition(c,POS_FACEDOWN_DEFENSE)
	end
end
--Summon: Special Summon up to 2 "Mushroom Tokens"
function s.thfilter(c)
    return c:IsSetCard(0x270) and c:IsMonster() and not c:IsCode(91215131)
end
function s.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then 
        return Duel.GetLocationCount(tp,LOCATION_MZONE)>=1
            and Duel.IsPlayerCanSpecialSummonMonster(tp,91215136,0,TYPES_TOKEN,1800,500,4,RACE_PLANT,ATTRIBUTE_EARTH) end
    Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,tp,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function s.tkop(e,tp,eg,ep,ev,re,r,rp)
    local freezones = Duel.GetLocationCount(tp,LOCATION_MZONE)
    if freezones <= 0 then return end
    -- choose how many tokens to summon (1 or up to 2 / freezones)
    local maxSummon = math.min(2, freezones)
    local summonCount = 1
    if maxSummon >= 2 then
        -- player chooses 1 or 2
        local opt = Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3))
        -- SelectOption returns 0 or 1; map to 1..2
        summonCount = opt + 1
    end
    summonCount = math.min(summonCount, maxSummon)
    for i=1,summonCount do
        if Duel.IsPlayerCanSpecialSummonMonster(tp,91215136,0,TYPES_TOKEN,1800,500,4,RACE_PLANT,ATTRIBUTE_EARTH) then
            local token = Duel.CreateToken(tp,91215136)
            if Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP) > 0 then
                local watcher=Effect.CreateEffect(e:GetHandler())
                watcher:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
                watcher:SetCode(EVENT_LEAVE_FIELD)
                watcher:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
                watcher:SetLabelObject(token)
                watcher:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
                watcher:SetOperation(function(ef,tp2,eg,ep,ev,re,r,rp)
                    local tk = ef:GetLabelObject()
                    if not tk then return end
                    if not eg or not eg:IsContains(tk) then return end
                    -- capture current chain id (if any)
                    local cc = Duel.GetCurrentChain()
                    local target_chain_id = nil
                    if cc and cc>0 then
                        target_chain_id = Duel.GetChainInfo(cc, CHAININFO_CHAIN_ID)
                    end
                    -- helper: the actual token-leave action (search + 300 damage)
                    local function do_token_leave_action()
                        -- search Legendary Champion (setcode 0x270) except Teemo, add to hand
                        Duel.Hint(HINT_SELECTMSG, tp2, HINTMSG_ATOHAND)
                        local g = Duel.SelectMatchingCard(tp2,
                            function(sc) return sc:IsSetCard(0x270) and not sc:IsCode(91215131) and sc:IsAbleToHand() end,
                            tp2, LOCATION_DECK, 0, 1, 1, nil)
                        if #g>0 then
                            Duel.SendtoHand(g, nil, REASON_EFFECT)
                            Duel.ConfirmCards(1-tp2, g)
                        end
                        Duel.Damage(1-tp2, 300, REASON_EFFECT)
                    end
                    if target_chain_id then
                        -- delay until that chain is solved
                        local de = Effect.CreateEffect(ef:GetHandler())
                        de:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
                        de:SetCode(EVENT_CHAIN_SOLVED)
                        de:SetLabel(target_chain_id)
                        de:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
                        de:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD)
                        de:SetOperation(function(d_e, d_tp, d_eg, d_ep, d_ev, d_re, d_r, d_rp)
                            local solved_chain_id = Duel.GetChainInfo(d_ev, CHAININFO_CHAIN_ID)
                            if solved_chain_id == d_e:GetLabel() then
                                do_token_leave_action()
                                d_e:Reset()
                            end
                        end)
                        Duel.RegisterEffect(de, tp2)
                    else
                        -- no chain: schedule a one-shot at EVENT_ADJUST (fires after any immediate changes)
                        local de = Effect.CreateEffect(ef:GetHandler())
                        de:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
                        de:SetCode(EVENT_ADJUST)
                        de:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
                        de:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD)
                        de:SetOperation(function(d_e, d_tp, d_eg, d_ep, d_ev, d_re, d_r, d_rp)
                            do_token_leave_action()
                            d_e:Reset()
                        end)
                        Duel.RegisterEffect(de, tp2)
                    end
                    -- we remove the original watcher now (it already saw the leave)
                    ef:Reset()
                end)
            Duel.RegisterEffect(watcher,tp)
            end
        end
    end
end