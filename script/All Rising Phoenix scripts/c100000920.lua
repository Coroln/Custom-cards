--寄生虫パラサイド
function c100000920.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_DECK_REVERSE_CHECK)
	--atk
		local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_ATKCHANGE)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EVENT_SPSUMMON_SUCCESS)
	e7:SetCondition(c100000920.condition2)
	e7:SetTarget(c100000920.target2)
	e7:SetOperation(c100000920.operation2)
	c:RegisterEffect(e7)
	local e8=Effect.CreateEffect(c)
	e8:SetCategory(CATEGORY_ATKCHANGE)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EVENT_SUMMON_SUCCESS)
	e8:SetCondition(c100000920.condition2)
	e8:SetTarget(c100000920.target2)
	e8:SetOperation(c100000920.operation2)
	c:RegisterEffect(e8)
		local e9=Effect.CreateEffect(c)
	e9:SetCategory(CATEGORY_ATKCHANGE)
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	e9:SetCondition(c100000920.condition2)
	e9:SetTarget(c100000920.target2)
	e9:SetOperation(c100000920.operation2)
	c:RegisterEffect(e9)
		--special summon
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_FIELD)
	e10:SetCode(EFFECT_SPSUMMON_PROC)
	e10:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e10:SetRange(LOCATION_HAND)
	e10:SetCondition(c100000920.spconm)
	c:RegisterEffect(e10)
		local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(100000920,0))
	e11:SetCategory(CATEGORY_TOHAND)
	e11:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e11:SetType(EFFECT_TYPE_IGNITION)
	e11:SetCountLimit(1,100000920)
	e11:SetRange(LOCATION_MZONE)
	e11:SetTarget(c100000920.thtghh)
	e11:SetOperation(c100000920.thophh)
	c:RegisterEffect(e11)
		--shu
	local e12=Effect.CreateEffect(c)
	e12:SetCategory(CATEGORY_EQUIP)
	e12:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e12:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e12:SetCode(EVENT_TO_GRAVE)
	e12:SetTarget(c100000920.eqtga)
	e12:SetOperation(c100000920.eqopa)
	c:RegisterEffect(e12)
end
function c100000920.eqtga(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0 end
end
function c100000920.eqopa(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(100000920,0))
	local g=Duel.SelectMatchingCard(1-tp,c100000920.shu,1-tp,LOCATION_DECK,0,1,1,nil,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.ShuffleDeck(1-tp)
		Duel.MoveSequence(tc,0)
		Duel.ConfirmDecktop(1-tp,1)
	else
		local g=Duel.GetFieldGroup(tp,0,LOCATION_DECK)
		Duel.ConfirmCards(tp,g)
		Duel.ShuffleDeck(1-tp)
	end
end
function c100000920.shu(c)
	return c:IsSetCard(0x75D) and not c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c100000920.hfilterh(c)
	return c:IsSetCard(0x75D) and c:IsAbleToHand() and not c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsCode(100000920)
end
function c100000920.thtghh(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_GRAVE and chkc:GetControler()==tp and c100000920.hfilterh(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100000920.hfilterh,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c100000920.hfilterh,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c100000920.thophh(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then end
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
end
function c100000920.spfilterm(c)
	return c:IsFaceup() and c:IsSetCard(0x75D) and c:IsType(TYPE_MONSTER)
end
function c100000920.spconm(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c100000920.spfilterm,tp,LOCATION_MZONE,0,1,nil)
end
function c100000920.condition2(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(c100000920.cfilter,1,nil,tp)
end
function c100000920.cfilter(c,tp)
	return c:IsSetCard(0x75D) and c:IsFaceup()
end
function c100000920.target2(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then return e:GetHandler():IsRelateToEffect(e) and e:GetHandler():IsFaceup() end
end
function c100000920.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(500)
		c:RegisterEffect(e1)
	end
end