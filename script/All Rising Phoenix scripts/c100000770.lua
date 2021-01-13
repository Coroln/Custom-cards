--Created and scripted by Rising Phoenix
function c100000770.initial_effect(c)
		--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100000770,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c100000770.spcon)
	e2:SetTarget(c100000770.sptg)
	e2:SetOperation(c100000770.spop)
	c:RegisterEffect(e2)
end
function c100000770.spcon(e,tp,eg,ep,ev,re,r,rp)
	return (e:GetHandler():IsReason(REASON_EFFECT) or e:GetHandler():IsReason(REASON_DISCARD)) and re and re:GetHandler():IsSetCard(0x759)
end
function c100000770.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c100000770.spop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
