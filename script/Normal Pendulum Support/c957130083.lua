local s, id = GetID()
Duel.LoadScript("proc_trick2.lua")
function s.initial_effect(c)
    Trick.AddProcedure(c,nil,nil,{{s.tfilter,1,1}},{{s.tfilter2,1,1}})

    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCondition(function(e) return e:GetHandler():IsPreviousLocation(LOCATION_EXTRA) and not e:GetHandler():IsReason(REASON_EFFECT) end)
    e1:SetOperation(s.addc)
    c:RegisterEffect(e1)

    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_BATTLE_DESTROYING)
    e2:SetCountLimit(1)
    e2:SetTarget(s.target)
    e2:SetOperation(s.activate)
    c:RegisterEffect(e2)
end
--Trick Summon
--Monster filter
function s.tfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsType(TYPE_NORMAL)
end
--Trap filter
function s.tfilter2(c)
	return c:IsTrap()
end

function s.addc(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
        local seq=math.log(Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0),2)
		Duel.MoveSequence(c,seq)
	end
end

--e2

function s.thfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsType(TYPE_NORMAL) and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
