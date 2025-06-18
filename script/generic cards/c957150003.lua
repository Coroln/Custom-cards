-- Mind MilliSent
local s,id=GetID()
function s.initial_effect(c)
    -- Special Summon itself (Quick Effect)
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(0,TIMING_END_PHASE+TIMINGS_CHECK_MONSTER)
    e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1,id)
    e1:SetCost(s.spcost)
    e1:SetTarget(s.sptg)
    e1:SetOperation(s.spop)
    c:RegisterEffect(e1)

    -- On Summon: Pay 1000 LP, shuffle 1 card from GY into Deck
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_TODECK)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_SUMMON_SUCCESS)
    e2:SetCountLimit(1,{id,1})
    e2:SetCost(s.tdcost)
    e2:SetTarget(s.tdtg)
    e2:SetOperation(s.tdop)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
    local e4=e2:Clone()
    e4:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e4)

    -- If used as Synchro Material: Banish the other materials
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e5:SetCode(EVENT_BE_MATERIAL)
    e5:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return r==REASON_SYNCHRO end)
    e5:SetOperation(
        function(e,tp,eg,ep,ev,re,r,rp)
            local c=e:GetHandler()
            local rc=c:GetReasonCard()
            local mg=rc:GetMaterial()
            for mc in aux.Next(mg) do
                if mc~=c then
                    Duel.Remove(mc,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL)
                end
            end
        end
    )
    c:RegisterEffect(e5)

end

-- Special Summon cost: return 1 other monster to hand
function s.costfilter(c)
    return c:IsAbleToHandAsCost() and c:IsFaceup() and not c:IsCode(id)
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
    local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_MZONE,0,1,1,nil)
    Duel.SendtoHand(g,nil,REASON_COST)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
    end
end

--e2
function s.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLPCost(tp,1000) end
    Duel.PayLPCost(tp,1000)
end
function s.tdfilter(c)
    return c:IsAbleToDeck()
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.tdfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,PLAYER_ALL,LOCATION_GRAVE)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(tp,s.tdfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
    if #g>0 then
        Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
    end
end

