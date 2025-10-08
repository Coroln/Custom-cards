local s,id=GetID()
function s.initial_effect(c)
	--attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(s.atkval)
	c:RegisterEffect(e1)
end
function s.atkval(e,c)
	local atamount=(Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_DECK,0)-40)*100
	if atamount<0 then atamount=0 end
	return atamount
end