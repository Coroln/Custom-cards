local s,id=GetID()
function s.initial_effect(c)
	aux.AddEquipProcedure(c)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetCondition(s.valcon)
	e2:SetValue(700)
	c:RegisterEffect(e2)
	local e1=e2:Clone()
	e1:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e1)
	--Change die result
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_TOSS_DICE_NEGATE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetOperation(s.diceop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(s.rmcon)
	e4:SetOperation(s.rmop)
	c:RegisterEffect(e4)
end
function s.valcon(e,re,r,rp)
	local c=e:GetHandler():GetEquipTarget()
	return c:IsRace(RACE_MACHINE)
end
function s.diceop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetOwner()==e:GetHandler():GetEquipTarget() then
	local cc=Duel.GetCurrentChain()
	local cid=Duel.GetChainInfo(cc,CHAININFO_CHAIN_ID)
	if s[0]~=cid  and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
			local dc={Duel.GetDiceResult()}
			local ac=1
			local ct=(ev&0xff)+(ev>>16)
			Duel.Hint(HINT_CARD,0,id)
			if ct>1 then
				local val,idx=Duel.AnnounceNumber(tp,table.unpack(dc,1,ct))
				ac=idx+1
			end
			dc[ac]=7
		Duel.SetDiceResult(table.unpack(dc))
		s[0]=cid
	end
	end
end
function s.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local prev=c:GetPreviousControler()
	local ec=c:GetPreviousEquipTarget()
	return prev==c:GetControler() and ((rp==1-prev and r&REASON_EFFECT~=0 and r&REASON_RETURN==0) or (c:IsReason(REASON_LOST_TARGET) and ec and ec:IsLocation(LOCATION_GRAVE) and ec:IsReason(REASON_EFFECT) and ec:IsReasonPlayer(1-prev)))
end
function s.filter(c)
	return c:IsCode(id) and c:HasFlagEffect(id)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then local token=Duel.CreateToken(tp,81171949)
	Duel.SendtoHand(token,nil,REASON_EFFECT) end
end
