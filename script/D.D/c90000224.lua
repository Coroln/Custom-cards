--D.D. Power Hungry Beast
--Script by Coroln
local s,id=GetID()
function s.initial_effect(c)
    --Negate Attack
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e1:SetRange(LOCATION_GRAVE|LOCATION_HAND|LOCATION_MZONE)
    e1:SetCode(EVENT_ATTACK_ANNOUNCE)
    e1:SetCondition(s.negcon)
    e1:SetCost(aux.bfgcost)
    e1:SetOperation(s.negop)
    c:RegisterEffect(e1)
end
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return at:IsControler(1-tp)
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
    Duel.Damage(1-tp,200,REASON_EFFECT)
    Duel.Damage(tp,200,REASON_EFFECT)
end
