local COSMETA_CONSTRUCTED = 957130108
local COSMETA_CONSTRUCTED_HOME = 957130111
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()

    -- Special Summon procedure
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
    e1:SetCondition(s.spcon)
    e1:SetOperation(s.spop)
    c:RegisterEffect(e1)
    --disable
	local e2a=Effect.CreateEffect(c)
	e2a:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2a:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2a:SetRange(LOCATION_MZONE)
	e2a:SetCondition(s.con)
	e2a:SetOperation(s.disop)
	c:RegisterEffect(e2a)
	local e2b=e2a:Clone()
	e2b:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	c:RegisterEffect(e2b)
	local e2c=Effect.CreateEffect(c)
	e2c:SetType(EFFECT_TYPE_FIELD)
	e2c:SetCode(EFFECT_DISABLE)
	e2c:SetRange(LOCATION_MZONE)
	e2c:SetTargetRange(0,LOCATION_MZONE)
	e2c:SetTarget(s.distg)
	c:RegisterEffect(e2c)

	-- If this card is discarded: Add 1 "Cosmeta - Constructed Home" from your Deck to your hand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,id)
	e3:SetCondition(s.thcon)
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)
end
s.listed_names={COSMETA_CONSTRUCTED,COSMETA_CONSTRUCTED_HOME}
function s.spcostfilter(c)
    return c:IsCode(COSMETA_CONSTRUCTED) and c:IsAbleToDeckAsCost()
end

function s.spcon(e,c)
    if c==nil then return true end
    local tp=e:GetHandlerPlayer()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(
            s.spcostfilter,tp,
            LOCATION_GRAVE+LOCATION_ONFIELD,0,2,nil
        )
end

function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(
        tp,s.spcostfilter,tp,
        LOCATION_GRAVE+LOCATION_ONFIELD,0,2,2,nil
    )
    Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST)
end
--e2
function s.con(e)
	local c=e:GetHandler()
	return (Duel.GetAttacker()==c and c:GetBattleTarget()) or Duel.GetAttackTarget()==c
end
function s.distg(e,c)
	return c==e:GetHandler():GetBattleTarget()
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttackTarget()
	if not tc then return end
	if tc:IsControler(tp) then tc=Duel.GetAttacker() end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_BATTLE)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetReset(RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_BATTLE)
	tc:RegisterEffect(e2)
end

--e3
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsReason(REASON_DISCARD)
end

function s.thfilter(c)
    return c:IsCode(COSMETA_CONSTRUCTED_HOME) and c:IsAbleToHand()
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil)
    end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if #g>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end