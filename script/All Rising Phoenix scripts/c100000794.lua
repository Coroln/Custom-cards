function c100000794.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCost(c100000794.cost)
	e1:SetTarget(c100000794.target)
	e1:SetOperation(c100000794.activate)
	c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c100000794.targete)
	e2:SetOperation(c100000794.operatione)
	c:RegisterEffect(e2)
		--Equip limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EQUIP_LIMIT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetValue(c100000794.eqlimit)
	c:RegisterEffect(e3)
		local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_REMOVE)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_TO_GRAVE)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e6:SetCondition(c100000794.thcon)
	e6:SetTarget(c100000794.thtg)
	e6:SetOperation(c100000794.thop)
	c:RegisterEffect(e6)
end
function c100000794.filter3(c)
	return c:IsAbleToRemove() and c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)
end
function c100000794.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return e:GetHandler():IsPreviousPosition(POS_FACEUP) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c100000794.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100000794.filter3,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c100000794.filter3,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c100000794.thop(e,tp,eg,ep,ev,re,r,rp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c100000794.filter3,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then end
		Duel.HintSelection(g)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
function c100000794.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and c:GetControler()==c:GetEquipTarget():GetControler()
		and c:GetEquipTarget():IsAbleToGraveAsCost() end
	local g=Group.FromCards(c,c:GetEquipTarget())
	Duel.SendtoGrave(g,REASON_COST)
end
function c100000794.eqlimit(e,c)
	return c:IsCode(100000796)
end
function c100000794.filtere(c)
	return c:IsFaceup() and c:IsCode(100000796)
end
function c100000794.targete(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c100000794.filtere(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100000794.filtere,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c100000794.filtere,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c100000794.operatione(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function c100000794.filter(c,e,tp)
	return  c:IsCode(100000792) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,true,false) 
end
function c100000794.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c100000794.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_EXTRA)
end
function c100000794.activate(e,tp,eg,ep,ev,re,r,rp)
		if  Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c100000794.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then end
	Duel.SpecialSummon(g,SUMMON_TYPE_FUSION,tp,tp,true,false,POS_FACEUP)
end
