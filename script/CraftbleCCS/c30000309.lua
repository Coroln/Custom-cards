local s,id=GetID()
function s.initial_effect(c)
	--hand adjust
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(s.handcon)
	e1:SetOperation(s.handop)
	c:RegisterEffect(e1)
end
function s.handcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsControler,1,nil,1-tp) and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>=5
end
function s.handop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	local ht2=Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)
	if ht2>=5 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
		local sg=Duel.SelectMatchingCard(1-tp,aux.TRUE,1-tp,LOCATION_HAND,0,ht2-5,ht2-5,nil)
		g:Merge(sg)
	end
	Duel.SendtoGrave(g,REASON_DISCARD+REASON_EFFECT)
end
