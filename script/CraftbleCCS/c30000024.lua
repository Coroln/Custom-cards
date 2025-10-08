local s,id=GetID()
function s.initial_effect(c)
    aux.AddSkillProcedure(c,2,false,nil,nil)
    local e1=Effect.CreateEffect(c)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_STARTUP)
    e1:SetCountLimit(1)
    e1:SetRange(0x5f)
    e1:SetLabel(0)
    e1:SetOperation(s.flipop)
    c:RegisterEffect(e1)
end

function s.flipop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
    Duel.Hint(HINT_CARD,tp,id)
    local c=e:GetHandler()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_PHASE+PHASE_END)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetCountLimit(1)
    e1:SetRange(0x5f)
    e1:SetOperation(s.damop)
    e1:SetTarget(s.damtg)
    Duel.RegisterEffect(e1,tp)
end

function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(1-tp)
    Duel.SetTargetParam(100)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,100)
end

function s.damop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_CARD,0,id)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Damage(p,d,REASON_EFFECT)
end
