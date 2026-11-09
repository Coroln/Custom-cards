local s,id=GetID()

function s.initial_effect(c)
    -- Link Summon
    c:EnableReviveLimit()
    Link.AddProcedure(c,s.matfilter,2,2)

    -- Battle destruction replacement
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EFFECT_DESTROY_REPLACE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetTarget(s.reptg)
    e1:SetValue(s.repval)
    e1:SetOperation(s.repop)
    c:RegisterEffect(e1)
end

s.listed_series={0xCFC}

-- Materials
function s.matfilter(c,lc,sumtype,tp)
    return c:IsSetCard(0xCFC,lc,sumtype,tp)
end

-- Replacement filter
function s.repfilter(c,tp)
    return c:IsFaceup() and c:IsSetCard(0xCFC)
        and not c:IsType(TYPE_LINK)
        and c:IsLocation(LOCATION_GRAVE)
        and c:IsControler(tp)
        and c:IsAbleToDeck()
end

-- Replacement target
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then
        return c:IsReason(REASON_BATTLE)
            and c:IsAbleToExtra()
            and #eg==1
            and eg:IsContains(c)
            and Duel.IsExistingMatchingCard(
                s.repfilter,tp,LOCATION_GRAVE,0,1,nil,tp
            )
    end
    return Duel.SelectEffectYesNo(tp,c,96)
end

-- Replacement value
function s.repval(e,c)
    return c==e:GetHandler()
        and c:IsReason(REASON_BATTLE)
end

-- Replacement operation
function s.repop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(
        tp,s.repfilter,tp,LOCATION_GRAVE,0,1,1,nil,tp
    )
    if #g>0 then
        Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT|REASON_REPLACE)
    end
end