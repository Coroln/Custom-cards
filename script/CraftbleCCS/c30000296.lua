local s,id=GetID()
function s.initial_effect(c)
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCondition(s.damcon)
	e1:SetTarget(s.damtg)
	e1:SetOperation(s.damop)
	c:RegisterEffect(e1)
end
function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>40
end
function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local damount=(Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)-40)*100
	if damount<0 then damount=0 end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(damount)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,damount)
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local damount=(Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)-40)*100
	if damount<0 then damount=0 end
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Recover(p,damount,REASON_EFFECT)
end