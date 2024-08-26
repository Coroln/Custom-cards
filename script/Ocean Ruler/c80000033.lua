--Possaido, Ozeanherrscher von Atlantis
function c80000033.initial_effect(c)
	--def up
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(80000033,0))
	e1:SetCategory(CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c80000033.defcon)
	e1:SetCost(c80000033.defcost)
	e1:SetTarget(c80000033.deftg)
	e1:SetOperation(c80000033.defop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(80000033,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c80000033.spcon)
	e2:SetCost(c80000033.spcost)
	e2:SetTarget(c80000033.sptg)
	e2:SetOperation(c80000033.spop)
	c:RegisterEffect(e2)
	--defense attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_DEFENSE_ATTACK)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
function c80000033.defcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(Card.IsCode,tp,LOCATION_ONFIELD,0,nil,22702055)
end
function c80000033.defcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c80000033.deffilter(c)
	return c:IsFaceup() and c:IsSetCard(0x1864) and aux.nzdef(c)
end
function c80000033.deftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local a=Duel.GetAttacker()
	local d=a:GetBattleTarget()
	if a:IsControler(1-tp) then a,d=d,a end
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp)
		and c44891812.deffilter(chkc) and chkc~=e:GetLabelObject() end
	if chk==0 then return a:IsDefensePos() and d and d:IsControler(1-tp)
		and Duel.IsExistingTarget(c80000033.deffilter,tp,LOCATION_MZONE,0,1,a) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c80000033.deffilter,tp,LOCATION_MZONE,0,1,1,a)
	e:SetLabelObject(a)
end
function c80000033.defop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local ac=e:GetLabelObject()
	if ac:IsRelateToBattle() and ac:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_DEFENSE)
		e1:SetValue(tc:GetDefense())
		e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
		ac:RegisterEffect(e1)
	end
end
function c80000033.spcon(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return at:GetControler()~=tp and Duel.GetAttackTarget()==nil
end
function c80000033.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c80000033.spfilter(c,e,tp)
	return c:IsSetCard(0x1864) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c80000033.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp)
		and c80000033.spfilter(chkc,e,tp) and chkc~=c end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c80000033.spfilter,tp,LOCATION_GRAVE,0,1,c,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c80000033.spfilter,tp,LOCATION_GRAVE,0,1,1,c,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c80000033.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
