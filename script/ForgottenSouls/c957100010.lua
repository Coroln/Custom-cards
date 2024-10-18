local s,id=GetID()
function s.initial_effect(c)
	
    --Activate
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCost(s.cost)
    e1:SetTarget(s.target)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)

	--Draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_HANDES+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	--e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCost(s.cost2)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.activate2)
	c:RegisterEffect(e2)
end

-- Cost: Banish 1 LIGHT Beast and 1 DARK Beast from GY
function s.cfilter(c,attr)
    return c:IsAttribute(attr) and c:IsRace(RACE_BEAST) and c:IsAbleToRemoveAsCost()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_GRAVE,0,1,nil,ATTRIBUTE_LIGHT)
            and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_GRAVE,0,1,nil,ATTRIBUTE_DARK)
    end
    local g1=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_GRAVE,0,1,1,nil,ATTRIBUTE_LIGHT)
    local g2=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_GRAVE,0,1,1,nil,ATTRIBUTE_DARK)
    g1:Merge(g2)
    Duel.Remove(g1,POS_FACEUP,REASON_COST)
end

-- Target: Special Summon 1 Level 8 "Chaos Soul" monster from Deck
function s.filter(c,e,tp)
    return c:IsSetCard(0x20CF) and c:IsLevel(8) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
            and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil,e,tp)
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end

-- Operation: Special Summon the selected monster
function s.activate(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    if #g>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end


--e2
-- Cost: Discard 1 "Chaos Soul" monster
function s.cfilter2(c)
    return c:IsSetCard(0x20CF) and c:IsMonster() and c:IsDiscardable()
end
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter2,tp,LOCATION_HAND,0,1,nil) end
    Duel.DiscardHand(tp,s.cfilter2,1,1,REASON_COST+REASON_DISCARD)
end

-- Target: Draw 2 cards
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end

-- Operation: Draw 2 cards
function s.activate2(e,tp,eg,ep,ev,re,r,rp)
    Duel.Draw(tp,2,REASON_EFFECT)
end