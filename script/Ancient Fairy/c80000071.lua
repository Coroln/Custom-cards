--Antike Fee, Tethys
function c80000071.initial_effect(c)
	--recover (1)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(80000071,0))
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,80000071)
	e1:SetCost(c80000071.reccost)
	e1:SetTarget(c80000071.rectg)
	e1:SetOperation(c80000071.recop)
	c:RegisterEffect(e1)
	--special summon (2)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(80000071,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,80000071)
	e2:SetCondition(c80000071.spcon)
	e2:SetTarget(c80000071.sptg)
	e2:SetOperation(c80000071.spop)
	c:RegisterEffect(e2)
	--cannot activate (3)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(0,1)
	e3:SetCondition(c80000071.econ)
	e3:SetValue(c80000071.efilter1)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
	e4:SetCondition(c80000071.econ)
	e4:SetTarget(c80000071.etarget)
	e4:SetValue(c80000071.efilter2)
	c:RegisterEffect(e4)
end
--(1)
function c80000071.reccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c80000071.recfilter(c)
	return c:IsSetCard(0x2c9c) and c:GetAttack()>0
end
function c80000071.rectg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c80000071.recfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c80000071.recfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c80000071.recfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,g:GetFirst():GetAttack())
end
function c80000071.recop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:GetAttack()>0 then
		Duel.Recover(tp,tc:GetAttack(),REASON_EFFECT)
	end
end
--(2)
function c80000071.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x2c9c) or c:IsCode(25862681) or c:IsCode(4179255)
end
function c80000071.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)>Duel.GetLP(1-tp) and Duel.IsExistingMatchingCard(c80000071.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c80000071.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c80000071.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x47e0000)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1,true)
	end
end
--(3)
function c80000071.actfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x2c9d)
end
function c80000071.econ(e)
	return Duel.IsExistingMatchingCard(c80000071.actfilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
function c80000071.efilter1(e,re,tp)
	return re:GetHandler():IsType(TYPE_FIELD) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c80000071.etarget(e,c)
	return c:IsType(TYPE_FIELD)
end
function c80000071.efilter2(e,re,tp)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
