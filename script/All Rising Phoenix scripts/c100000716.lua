--scripted and created by rising phoenix
function c100000716.initial_effect(c)	
c:EnableReviveLimit()
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetCondition(c100000716.condition)
	e2:SetOperation(c100000716.operation)
	c:RegisterEffect(e2)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(c100000716.spcon)
	e3:SetOperation(c100000716.spop)
	c:RegisterEffect(e3)
		local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(100000716,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
		e4:SetCountLimit(1)
	e4:SetTarget(c100000716.sptg2)
	e4:SetOperation(c100000716.spop2)
	c:RegisterEffect(e4)
		--tohand
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(100000716,0))
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e7:SetCode(EVENT_TO_HAND)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1)
	e7:SetCondition(c100000716.condition22)
	e7:SetTarget(c100000716.target22)
	e7:SetOperation(c100000716.operation22)
	c:RegisterEffect(e7)
	--spsummon success
	local e18=Effect.CreateEffect(c)
	e18:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)	
		e18:SetDescription(aux.Stringid(100000716,0))
	e18:SetCode(EVENT_PHASE+PHASE_END)
		e18:SetCountLimit(1)
	e18:SetRange(LOCATION_MZONE)
	e18:SetOperation(c100000716.sop)
	c:RegisterEffect(e18)
end
function c100000716.filtersend(c)
	return c:IsFaceup() and not c:IsSetCard(0x764)
end
function c100000716.sop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c100000716.filtersend,tp,LOCATION_ONFIELD,0,e:GetHandler())
	Duel.SendtoGrave(g,REASON_EFFECT)
end
function c100000716.filter22(c,tp)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP)
		and c:IsControler(tp) and c:IsSetCard(0x764) and c:IsType(TYPE_TRAP+TYPE_CONTINUOUS)
end
function c100000716.condition22(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c100000716.filter22,1,nil,tp) and Duel.GetTurnPlayer()==tp
end
function c100000716.target22(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c100000716.operation22(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c100000716.filter(c,e,tp)
	return c:IsSetCard(0x764)  and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and not (c:IsCode(100000716) or c:IsType(TYPE_SPELL+TYPE_TRAP))
end
function c100000716.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c100000716.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function c100000716.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c100000716.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then end
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
end	
function c100000716.spcfilter(c)
	return c:IsSetCard(0x764) and c:IsType(TYPE_TRAP+TYPE_CONTINUOUS) and not c:IsPublic()
end
function c100000716.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local hg=Duel.GetMatchingGroup(c100000716.spcfilter,tp,LOCATION_HAND,0,c)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and hg:GetClassCount(Card.GetCode)>=3
end
function c100000716.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local hg=Duel.GetMatchingGroup(c100000716.spcfilter,tp,LOCATION_HAND,0,c)
	local rg=Group.CreateGroup()
	for i=1,3 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local g=hg:Select(tp,1,1,nil)
		local tc=g:GetFirst()
		rg:AddCard(tc)
		hg:Remove(Card.IsCode,nil,tc:GetCode())
	end
	Duel.ConfirmCards(1-tp,rg)
	Duel.ShuffleHand(tp)
end
function c100000716.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_TRAP+TYPE_CONTINUOUS) and re:GetHandler():IsSetCard(0x764)
end
function c100000716.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(100)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	c:RegisterEffect(e1)
end