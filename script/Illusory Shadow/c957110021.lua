local s,id=GetID()
function s.initial_effect(c)
    --Neither monster can be destroyed by battle
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(s.indestg)
	e1:SetValue(1)
	c:RegisterEffect(e1)
    --search
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,0))
    e2:SetCategory(CATEGORY_REMOVE+CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCondition(s.rmcon)
    e2:SetCost(s.rmcost)
    e2:SetTarget(s.rmtg)
    e2:SetOperation(s.rmop)
    c:RegisterEffect(e2)
end

function s.indestg(e,c)
	local handler=e:GetHandler()
	return c==handler or c==handler:GetBattleTarget()
end

--e2
function s.rmcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_NORMAL)
end
function s.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsFaceup() and c:IsAbleToRemoveAsCost() end
    if Duel.Remove(c,POS_FACEUP,REASON_COST|REASON_TEMPORARY)~=0 then
        local return_turn = Duel.GetTurnCount() + 2
        c:RegisterFlagEffect(id,RESET_PHASE+PHASE_END,0,3)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e1:SetCode(EVENT_PHASE+PHASE_END)
        e1:SetCountLimit(1)
        e1:SetReset(RESET_PHASE+PHASE_END,3)
        e1:SetLabel(return_turn)
        e1:SetLabelObject(c)
        e1:SetCondition(s.retcon)
        e1:SetOperation(s.retop)
        Duel.RegisterEffect(e1,tp)
    end
end

function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function s.thfilter(c)
    return c:IsCode(957110008) and c:IsAbleToHand()
end

function s.rmop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    local tc=g:GetFirst()
    if tc then
        Duel.SendtoHand(tc,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,tc)
    end
end

function s.retcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetLabelObject()
    return Duel.GetTurnPlayer()==tp
        and Duel.GetTurnCount()==e:GetLabel()
        and c and c:IsLocation(LOCATION_REMOVED)
end

function s.retop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetLabelObject()
    if c and c:IsLocation(LOCATION_REMOVED) then
        Duel.ReturnToField(c)
    end
end