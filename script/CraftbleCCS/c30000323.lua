local s,id=GetID()
function s.initial_effect(c)
	--Make this card untargetable for attacks
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(aux.IceBarrierDiscardCost(nil,true))
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
s.listed_series={0x2f}
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local attr=Duel.AnnounceAttribute(tp,1,ATTRIBUTE_ALL)
	e:SetLabel(attr)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local attr=e:GetLabel()
	c:SetHint(CHINT_ATTRIBUTE,attr)
	--Cannot be targeted for attacks
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e1:SetLabel(attr)
	e1:SetTarget(s.immlimit)
	e1:SetValue(s.tgval)
	e1:SetReset(RESET_EVENT|RESETS_STANDARD)
	c:RegisterEffect(e1)
end
function s.immlimit(e,c,tp,sumtp)
	return c:IsFaceup() and c:IsSetCard(0x2f)
end
function s.tgval(e,c)
	return c:IsAttribute(e:GetLabel()) and not c:IsImmuneToEffect(e)
end