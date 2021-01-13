--created and scripted by rising phoenix
function c100000750.initial_effect(c)
	--handes
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100000750,0))
	e1:SetCategory(CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c100000750.target1)
	e1:SetOperation(c100000750.operation)
	c:RegisterEffect(e1)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_LEAVE_FIELD)
		e1:SetRange(LOCATION_GRAVE)
			e1:SetCost(c100000750.descost)
	e1:SetTarget(c100000750.target)
	e1:SetOperation(c100000750.activate)
	c:RegisterEffect(e1)
end
function c100000750.filter1(c)
	return c:IsSetCard(0x765) and c:IsType(TYPE_MONSTER)
end
function c100000750.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100000750.filter1,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
end
function c100000750.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c100000750.filter1,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then end
Duel.SendtoGrave(g,REASON_EFFECT)
	end
function c100000750.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() and Duel.CheckLPCost(tp,2000) end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	Duel.PayLPCost(tp,2000)
end
function c100000750.filter(c,e,tp)
	return c:IsCanBeEffectTarget(e)
		and c:GetPreviousControler()==tp and c:IsSetCard(0x765)
		and c:IsType(TYPE_SYNCHRO) and Duel.IsExistingMatchingCard(c100000750.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c)
end
function c100000750.spfilter(c,e,tp,tc)
	return c:IsType(TYPE_SYNCHRO)and c:IsSetCard(0x765) and c:GetCode()~=tc:GetCode()
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100000750.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) and c100000750.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and eg:IsExists(c100000750.filter,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=eg:FilterSelect(tp,c100000750.filter,1,1,nil,e,tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c100000750.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c100000750.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc)
	if sg:GetCount()>0 then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end