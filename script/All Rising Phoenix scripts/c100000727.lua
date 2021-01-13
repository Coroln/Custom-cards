--scripted and created by rising phoenix
function c100000727.initial_effect(c)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetCondition(c100000727.condition)
	e2:SetOperation(c100000727.operation)
	c:RegisterEffect(e2)
		--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100000727,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetTarget(c100000727.thtg)
	e1:SetOperation(c100000727.thop)
	c:RegisterEffect(e1)
		local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(100000727,0))
	e11:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e11:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e11:SetCode(EVENT_SUMMON_SUCCESS)
	e11:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e11:SetTarget(c100000727.target)
	e11:SetOperation(c100000727.operation2)
	c:RegisterEffect(e11)
	local e3=e11:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e5=e11:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
		--cannot special summon
	local e15=Effect.CreateEffect(c)
	e15:SetType(EFFECT_TYPE_SINGLE)
	e15:SetCode(EFFECT_SPSUMMON_CONDITION)
		e15:SetValue(aux.FALSE)
	e15:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e15)
		--spsummon success
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)	
		e8:SetDescription(aux.Stringid(100000727,0))
	e8:SetCode(EVENT_PHASE+PHASE_END)
		e8:SetCountLimit(1)
	e8:SetRange(LOCATION_MZONE)
	e8:SetOperation(c100000727.sop)
	c:RegisterEffect(e8)
end
function c100000727.sop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c100000727.filtersend,tp,LOCATION_ONFIELD,0,e:GetHandler())
	Duel.SendtoGrave(g,REASON_EFFECT)
end
function c100000727.filtersend(c)
	return c:IsFaceup() and not c:IsSetCard(0x764)
end
function c100000727.filter(c)
	return c:IsCode(100000722) and c:IsAbleToHand()
end
function c100000727.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100000727.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c100000727.operation2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100000727.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c100000727.tdfilter2(c)
	return c:IsFaceup() and c:IsAbleToHand() and c:IsSetCard(0x764) and c:IsType(TYPE_TRAP+TYPE_CONTINUOUS) and not c:IsType(TYPE_SPELL)
end
function c100000727.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c100000727.tdfilter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100000727.tdfilter2,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c100000727.tdfilter2,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c100000727.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end

function c100000727.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_TRAP+TYPE_CONTINUOUS) and re:GetHandler():IsSetCard(0x764)
end
function c100000727.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(100)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	c:RegisterEffect(e1)
end
