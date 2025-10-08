local s,id=GetID()
function s.initial_effect(c)
	--Public
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_PUBLIC)
	e0:SetRange(LOCATION_HAND)
	c:RegisterEffect(e0)
	--win
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetRange(LOCATION_HAND)
	e1:SetOperation(s.woperation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1)
	e2:SetCondition(s.condition)
	e2:SetTarget(s.target)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
end
s.listed_names={8124921,44519536,70903634,7902349}
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function s.check(g)
	local a1=false
	local a2=false
	local a3=false
	local a4=false
	local a5=false
	local tc=g:GetFirst()
	for tc in aux.Next(g) do
		local code=tc:GetCode()
		if code==8124921 then a1=true
			elseif code==44519536 then a2=true
			elseif code==70903634 then a3=true
			elseif code==7902349 then a4=true
			elseif code==id then a5=true
		end
	end
	return a1 and a2 and a3 and a4 and a5
end
function s.woperation(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	local g2=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	local wtp=s.check(g1)
	local wntp=s.check(g2)
	if wtp and not wntp then
		Duel.ConfirmCards(1-tp,g1)
		Duel.Win(tp,WIN_REASON_EXODIA)
	elseif not wtp and wntp then
		Duel.ConfirmCards(tp,g2)
		Duel.Win(1-tp,WIN_REASON_EXODIA)
	elseif wtp and wntp then
		Duel.ConfirmCards(1-tp,g1)
		Duel.ConfirmCards(tp,g2)
		Duel.Win(PLAYER_NONE,WIN_REASON_EXODIA)
	end
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,1)
	if chk==0 then return #g>0 and g:GetFirst():IsAbleToHand() end
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
	Duel.ConfirmDecktop(tp,1)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	if tc:IsSetCard(SET_FORBIDDEN_ONE) then
		Duel.DisableShuffleCheck()
		if tc:IsAbleToHand() then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ShuffleHand(tp)
		else
			Duel.SendtoGrave(tc,REASON_RULE)
		end
	else
		Duel.MoveSequence(tc,SEQ_DECKBOTTOM)
	end
end