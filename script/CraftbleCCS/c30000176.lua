local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--Add counter
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_FZONE)
	e2:SetOperation(s.acop)
	c:RegisterEffect(e2)
	--atk down
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetValue(s.atkval)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_ADJUST)
	e4:SetRange(LOCATION_FZONE)
	e4:SetOperation(s.desop)
	c:RegisterEffect(e4)
end
s.listed_series={0x50}
s.counter_place_list={0x1009}
function s.filter(c)
	return c:IsSetCard(0x50) and c:IsMonster() and c:IsAbleToHand()
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_DECK,0,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function s.atkval(e,c)
	return c:GetCounter(0x1009)*-500
end
function s.acop(e,tp,eg,ep,ev,re,r,rp)
	--if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Group.CreateGroup()
	local tg=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	local tc=tg:GetFirst()
	for tc in aux.Next(tg) do
		if tc:IsCanAddCounter(0x1009,1) and tc:GetCounter(0x1009)~=0 then
			local atk=tc:GetAttack()
			tc:AddCounter(0x1009,1)
			if atk>0 and tc:GetAttack()==0 then
				g:AddCard(tc)
			end
		end
	end
end
function s.desfilter(c,e)
	return c:GetAttack()==0 and c:IsPosition(POS_FACEUP) and c:IsDestructable(e) and not c:IsImmuneToEffect(e) and c:GetCounter(0x1009)~=0
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.desfilter,tp,0,LOCATION_MZONE,nil,e)
	if #g>0 then
		Duel.Hint(HINT_CARD,1-tp,id)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
