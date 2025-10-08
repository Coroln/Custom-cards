local s,id=GetID()
function s.initial_effect(c)
local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetLabel(CARD_DESTINY_BOARD)
	e1:SetTarget(s.pltg)
	e1:SetOperation(s.plop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCountLimit(1)
	e2:SetCondition(s.ccon)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(s.drtg)
	e2:SetOperation(s.drop)
	c:RegisterEffect(e2)
end
s.listed_names={CARD_DESTINY_BOARD}
s.listed_series={0x1c}
function s.ccon(e)
	return Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,67287533),e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function s.smfilter(c)
	return c:IsCode(table.unpack(CARDS_SPIRIT_MESSAGE)) and not c:IsForbidden()
end
function s.pltg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if e:GetHandler():GetSequence()<5 then ft=ft+1 end
	if chk==0 then return ft>0 and Duel.IsExistingMatchingCard(s.smfilter,tp,LOCATION_HAND,0,1,nil) end
end
function s.plop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,CARD_DARK_SANCTUARY) then return s.extraop(e,tp,eg,ep,ev,re,r,rp) end
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,2))
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.smfilter),tp,LOCATION_HAND,0,1,1,nil)
	if #g>0 then
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function s.extraop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,2))
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.smfilter),tp,LOCATION_HAND,0,1,1,nil):GetFirst()
	if not tc then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,id,0,0x11,0,0,1,RACE_FIEND,ATTRIBUTE_DARK,POS_FACEUP,tp,181)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and (Duel.GetLocationCount(tp,LOCATION_SZONE)<1
		or Duel.SelectYesNo(tp,aux.Stringid(CARD_DARK_SANCTUARY,0))) then
			tc:AddMonsterAttribute(TYPE_NORMAL,ATTRIBUTE_DARK,RACE_FIEND,1,0,0)
			Duel.SpecialSummonStep(tc,181,tp,tp,true,false,POS_FACEUP)
			tc:AddMonsterAttributeComplete()
			--immune
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetCode(EFFECT_IMMUNE_EFFECT)
			e1:SetValue(s.efilter)
			e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
			tc:RegisterEffect(e1)
			--cannot be target
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_IGNORE_BATTLE_TARGET)
			e2:SetValue(1)
			e2:SetReset(RESET_EVENT+RESETS_REDIRECT)
			tc:RegisterEffect(e2)
			Duel.SpecialSummonComplete()
	elseif Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function s.efilter(e,te)
	local tc=te:GetHandler()
	return not tc:IsCode(CARD_DESTINY_BOARD)
end