-- Wurm Überaschung
function c80000067.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c80000067.target1)
	e1:SetOperation(c80000067.operation)
	c:RegisterEffect(e1)
	--pos
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(80000067,0))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c80000067.condition)
	e2:SetTarget(c80000067.target2)
	e2:SetOperation(c80000067.operation)
	c:RegisterEffect(e2)
end
function c80000067.condition(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE)
end
function c80000067.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0x3e) and c:IsRace(RACE_REPTILE) and c:IsCanTurnSet()
end
function c80000067.filter2(c)
	return c:IsPosition(POS_FACEDOWN_DEFENSE)
end
function c80000067.filter3(c)
	return c:IsPosition(POS_FACEDOWN_DEFENSE)
end
function c80000067.filter4(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c80000067.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		if e:GetLabel()==0 then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c80000067.filter1(chkc)
		else return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c80000067.filter3(chkc) end
	end
	if chk==0 then return true end
	local b1=Duel.IsExistingTarget(c80000067.filter1,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c80000067.filter2,tp,0,LOCATION_MZONE,1,nil)
	local b2=Duel.IsExistingTarget(c80000067.filter3,tp,LOCATION_MZONE,0,1,nil)
	if (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE)
		and (b1 or b2) and Duel.SelectYesNo(tp,aux.Stringid(80000067,3)) then
		local op=0
		if b1 and b2 then
			op=Duel.SelectOption(tp,aux.Stringid(80000067,1),aux.Stringid(80000067,2))
		elseif b1 then
			op=Duel.SelectOption(tp,aux.Stringid(80000067,1))
		else
			op=Duel.SelectOption(tp,aux.Stringid(80000067,2))+1
		end
		e:SetLabel(op)
		if op==0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
			local g=Duel.SelectTarget(tp,c80000067.filter1,tp,LOCATION_MZONE,0,1,1,nil)
			Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEDOWNDEFENSE)
			local g=Duel.SelectTarget(tp,c80000067.filter3,tp,LOCATION_MZONE,0,1,1,nil)
			Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
		end
		e:GetHandler():RegisterFlagEffect(80000067,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
		e:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	else
		e:SetProperty(0)
	end
end
function c80000067.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		if e:GetLabel()==0 then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c80000067.filter1(chkc)
		else return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c80000067.filter3(chkc) end
	end
	local b1=Duel.IsExistingTarget(c80000067.filter1,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c80000067.filter2,tp,0,LOCATION_MZONE,1,nil)
	local b2=Duel.IsExistingTarget(c80000067.filter3,tp,LOCATION_MZONE,0,1,nil)
	if chk==0 then return (b1 or b2) and e:GetHandler():GetFlagEffect(80000067)==0 end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(80000067,1),aux.Stringid(80000067,2))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(80000067,1))
	else
		op=Duel.SelectOption(tp,aux.Stringid(80000067,2))+1
	end
	e:SetLabel(op)
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g=Duel.SelectTarget(tp,c80000067.filter1,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEDOWNDEFENSE)
		local g=Duel.SelectTarget(tp,c80000067.filter3,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
	end
	e:GetHandler():RegisterFlagEffect(80000067,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c80000067.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(80000067)==0 or not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if e:GetLabel()==0 then
		if not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
		if Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)==0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEDOWNDEFENSE)
		local g=Duel.SelectMatchingCard(tp,c80000067.filter2,tp,0,LOCATION_MZONE,1,1,nil)
		if g:GetCount()>0 then
			Duel.ChangePosition(g,POS_FACEUP_ATTACK)
		end
	else
		if not tc:IsRelateToEffect(e) or tc:IsPosition(POS_FACEUP_ATTACK) then return end
		if Duel.ChangePosition(tc,POS_FACEUP_ATTACK)==0 or not tc:IsSetCard(0x3e) and tc:IsRace(RACE_REPTILE) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g=Duel.SelectMatchingCard(tp,c80000067.filter4,tp,0,LOCATION_MZONE,1,1,nil)
		if g:GetCount()>0 then
			Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
		end
	end
end