local s, id = GetID()
function s.initial_effect(c)
    local e0 = Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e0:SetCode(EFFECT_UPDATE_ATTACK)
    e0:SetRange(LOCATION_MZONE)
    e0:SetValue(s.val)
    c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(s.cointg)
	e1:SetOperation(s.coinop)
	c:RegisterEffect(e1)
    --Count coins
    aux.GlobalCheck(s, function()
        local ge1 = Effect.CreateEffect(c)
        ge1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
        ge1:SetCode(EVENT_TOSS_COIN)
        ge1:SetCondition(s.coincon)
        ge1:SetOperation(s.checkop)
        Duel.RegisterEffect(ge1, 0)
    end)
end

function s.val(e)
    local tails = Duel.GetFlagEffectLabel(0, id)
    if not tails then
        return 0
    end
    return tails * 200
end

function s.coincon(e, tp, eg, ep, ev, re, r, rp)
    return re:GetCode()~=EVENT_TOSS_COIN_NEGATE
end

function s.checkop(e, tp, eg, ep, ev, re, r, rp)
    if ev == 65537 then
        if not Duel.GetFlagEffectLabel(0, id) then
            Duel.RegisterFlagEffect(0, id, 0, 0, 0, 1)
        else
            Duel.SetFlagEffectLabel(0, id, Duel.GetFlagEffectLabel(0, id) + 1)
        end
    end
end
function s.cointg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function s.coinop(e,tp,eg,ep,ev,re,r,rp)
	local res=Duel.TossCoin(tp,1)
	if res==COIN_HEADS then Duel.Recover(tp,1000,REASON_EFFECT)
end