--Legendary Champion Warwick
--Coroln
local s,id=GetID()
function s.initial_effect(c)
    --Special summon itself from the hand
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_HAND)
	e0:SetCondition(s.spcon)
	c:RegisterEffect(e0)
    --Gain LP
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_RECOVER)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EVENT_BATTLE_DAMAGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCondition(s.reccon1)
    e1:SetOperation(s.recop1)
    c:RegisterEffect(e1)
end
--Special summon itself from the hand
function s.cfilter(c)
	return c:IsFacedown() or not (c:IsBaseAttack(1800) and c:IsBaseDefense(500))
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	if c==nil then return true end
	local tp=c:GetControler()
	return (Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0 
		or not Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil))
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
--Gain LP
function s.reccon1(e,tp,eg,ep,ev,re,r,rp)
    return ep~=tp
end
function s.recop1(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_CARD,0,id)
    Duel.Recover(tp,ev,REASON_EFFECT)
end