local s,id=GetID()
function s.initial_effect(c)
	--Change the effect of 1 "Arcana Force" monster
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.listed_series={SET_ARCANA_FORCE}
function s.filter(c)
	return c:IsSetCard(SET_ARCANA_FORCE) and c:GetFlagEffect(CARD_REVERSAL_OF_FATE)>0
end
function s.rfilter(c)
	return c:IsSetCard(SET_ARCANA_FORCE) and c:IsMonster() and c:IsAbleToRemove() and aux.SpElimFilter(c,true)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(s.rfilter,tp,LOCATION_MZONE|LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,s.rfilter,tp,LOCATION_MZONE|LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	e:SetLabelObject(g:GetFirst())
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local regc=e:GetLabelObject()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=g:GetFirst()
	if tc==regc then tc=g:GetNext() end
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() and s.filter(tc) and regc:IsRelateToEffect(e) then
		Duel.Remove(regc,POS_FACEUP,REASON_EFFECT)
		local regfun=regc.arcanareg
		if not regfun then return end
		local val=Arcana.GetCoinResult(tc)
		tc:ResetEffect(RESET_DISABLE,RESET_EVENT)
		regfun(tc,val)
	end
end