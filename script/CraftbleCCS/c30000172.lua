local s,id=GetID()
function s.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetRange(LOCATION_MZONE)
	e0:SetTargetRange(LOCATION_MZONE,0)
	e0:SetCode(EFFECT_UPDATE_ATTACK)
	e0:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_DINOSAUR))
	e0:SetValue(200)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_MSET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_CHANGE_POS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetTarget(s.target2)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function s.filter(c,e,tp)
	return c:IsPosition(POS_FACEDOWN_DEFENSE) and c:GetReasonPlayer()==tp
end
function s.filter3(c,e,tp)
	return c:IsPosition(POS_FACEDOWN_DEFENSE) and c:IsSummonPlayer(tp) and c:IsCanBeEffectTarget(e)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then
		local sg=eg:Filter(s.filter,nil,e,1-tp)
		return #sg==1
	end
	local sg1=eg:Filter(s.filter,nil,e,1-tp)
	e:SetLabelObject(sg1:GetFirst())
	Duel.SetTargetCard(sg1)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then
		local sg=eg:Filter(s.filter3,nil,e,1-tp)
		return #sg==1
	end
	local sg1=eg:Filter(s.filter,nil,e,1-tp)
	e:SetLabelObject(sg1:GetFirst())
	Duel.SetTargetCard(sg1)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc1=g:GetFirst()
	local tc2=e:GetHandler()
	local sc=e:GetLabelObject()
	if tc1 and tc1:IsRelateToEffect(e) and tc2 and sc:IsFacedown() then
		Duel.CalculateDamage(tc2, tc1)
	end
end