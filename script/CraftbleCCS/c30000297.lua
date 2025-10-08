local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.cfilter(c)
	local p=c:GetOwner()
	local ft=Duel.GetLocationCount(p,LOCATION_SZONE)
	return c:IsCode(62420419) and ft>0
		and not c:IsForbidden() and c:CheckUniqueOnField(p)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
		local token1=Duel.CreateToken(tp,10000000)
		local token2=Duel.CreateToken(tp,10000010)
		local token3=Duel.CreateToken(tp,10000020)
		Duel.SendtoDeck(token1,nil,0,REASON_EFFECT)
		Duel.SendtoDeck(token2,nil,0,REASON_EFFECT)
		Duel.SendtoDeck(token3,nil,0,REASON_EFFECT)
		Duel.ShuffleDeck(tp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.cfilter),tp,LOCATION_HAND|LOCATION_GRAVE,0,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		if tc and Duel.MoveToField(tc,tp,tc:GetOwner(),LOCATION_SZONE,POS_FACEUP,true) then
			--Treat it as a Continuous Spell
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetValue(TYPE_SPELL|TYPE_CONTINUOUS)
			e1:SetReset(RESET_EVENT|(RESETS_STANDARD&~RESET_TURN_SET))
			tc:RegisterEffect(e1)
		end
	end
end