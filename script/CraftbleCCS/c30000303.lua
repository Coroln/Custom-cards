local s,id=GetID()
function s.initial_effect(c)
	--Public
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_PUBLIC)
	e0:SetRange(LOCATION_HAND)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1)
	e1:SetCondition(s.reccon)
	e1:SetOperation(s.recop)
	c:RegisterEffect(e1)
end
function s.atkfilter(c)
	return c:IsMonster() and c:IsSetCard(SET_FORBIDDEN_ONE)
end
function s.reccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function s.recop(e,tp,eg,ep,ev,re,r,rp)
	local d = Duel.GetMatchingGroupCount(s.atkfilter,tp,LOCATION_HAND,0,nil)*100
	Duel.Damage(1-tp,d,REASON_EFFECT)
end
