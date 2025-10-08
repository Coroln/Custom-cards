local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetRange(LOCATION_SZONE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetDecktopGroup(1-tp,1)+e:GetHandler():GetColumnGroup()
	if g and #g>0 then
			for ccc in g:Iter() do if ccc:GetFlagEffect(id)==0 and ccc:GetOwner()~=e:GetHandler():GetOwner() and ccc:IsFacedown() then Duel.ConfirmCards(tp,ccc) end
			ccc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
			end
	end
end