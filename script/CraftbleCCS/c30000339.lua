local s,id=GetID()
function s.initial_effect(c)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_QUICK_F)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.dmgcon)
	e2:SetTarget(s.target)
	e2:SetOperation(s.dmgop)
	c:RegisterEffect(e2)
end
function s.dmgcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp and re:GetHandler():IsCode(62279055) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	local op=1
	if chkc then if chkc:IsOnField() and chkc:IsControler(1-tp) then op=IsDuel.SelectOption(tp,aux.Stringid(id,0),aux.Stringid(id,1)) end end
	e:SetLabel(op)
	if op==0 then
		e:SetCategory(CATEGORY_DESTROY)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
	else
		e:SetCategory(CATEGORY_DAMAGE)
		Duel.SetTargetPlayer(1-tp)
		Duel.SetTargetParam(1000)
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
	end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==1 then
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Damage(p,d,REASON_EFFECT)
	else local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end end
end