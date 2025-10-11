local s,id=GetID()
function s.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(s.target)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
    local token1=Duel.CreateToken(tp,30000301)
    local token2=Duel.CreateToken(tp,30000302)
    local token3=Duel.CreateToken(tp,30000303)
    local token4=Duel.CreateToken(tp,30000304)
    local token5=Duel.CreateToken(tp,30000305)
    Duel.SendtoDeck(token1,nil,0,REASON_EFFECT)
    Duel.SendtoDeck(token2,nil,0,REASON_EFFECT)
    Duel.SendtoDeck(token3,nil,0,REASON_EFFECT)
    Duel.SendtoDeck(token4,nil,0,REASON_EFFECT)
    Duel.SendtoDeck(token5,nil,0,REASON_EFFECT)
    Duel.ShuffleDeck(tp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        c:CancelToGrave()
        Duel.SendtoDeck(c,nil,-2,REASON_EFFECT)
        Duel.Draw(p,d,REASON_EFFECT)
    end
end