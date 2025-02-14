--Life Energy Overflow!
--Script by Coroln
local s,id=GetID()
function s.initial_effect(c)
    --win
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetCondition(s.wincon)
    e1:SetOperation(s.winop)
    c:RegisterEffect(e1)
    --recover and draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_RECOVER)
    e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_HAND)
	e2:SetTarget(s.rectg)
	e2:SetOperation(s.recop)
	c:RegisterEffect(e2)
end
--win
function s.wincon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetLP(1-tp)>=100000
end
function s.winop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Win(tp,0x60)
end
--recover and draw
function s.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanSendtoDeck(tp,e:GetHandler()) end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(2000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,1-tp,2000)
end
function s.recop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.SendtoDeck(e:GetHandler(),tp,0,REASON_EFFECT)>0 then
        Duel.ShuffleDeck(tp)
        local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
        Duel.Recover(p,d,REASON_EFFECT)
        Duel.Draw(tp,1,REASON_EFFECT)
    end
end
