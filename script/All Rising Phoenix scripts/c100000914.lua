 --Created and coded by Rising Phoenix
function c100000914.initial_effect(c)	
	--to deck
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(100000914,0))
	e6:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetCountLimit(1)
	e6:SetRange(LOCATION_MZONE)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetTarget(c100000914.target)
	e6:SetOperation(c100000914.operation)
	c:RegisterEffect(e6)
		local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(100000914,1))
	e7:SetCategory(CATEGORY_ATKCHANGE)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EVENT_SPSUMMON_SUCCESS)
	e7:SetCondition(c100000914.condition2)
	e7:SetTarget(c100000914.target2)
	e7:SetOperation(c100000914.operation2)
	c:RegisterEffect(e7)
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(100000914,1))
	e8:SetCategory(CATEGORY_ATKCHANGE)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EVENT_SUMMON_SUCCESS)
	e8:SetCondition(c100000914.condition2)
	e8:SetTarget(c100000914.target2)
	e8:SetOperation(c100000914.operation2)
	c:RegisterEffect(e8)
		local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(100000914,1))
	e9:SetCategory(CATEGORY_ATKCHANGE)
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	e9:SetCondition(c100000914.condition2)
	e9:SetTarget(c100000914.target2)
	e9:SetOperation(c100000914.operation2)
	c:RegisterEffect(e9)
		--special summon
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_FIELD)
	e10:SetCode(EFFECT_SPSUMMON_PROC)
	e10:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e10:SetRange(LOCATION_HAND)
	e10:SetCondition(c100000914.spconm)
	c:RegisterEffect(e10)
		--atk
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_FIELD)
	e11:SetRange(LOCATION_MZONE)
	e11:SetTargetRange(LOCATION_MZONE,0)
	e11:SetCode(EFFECT_UPDATE_ATTACK)
	e11:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x75D))
	e11:SetValue(500)
	c:RegisterEffect(e11)
		--shuffle
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_IGNITION)
	e13:SetRange(LOCATION_GRAVE)
	e13:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e13:SetCountLimit(1,100000914)
	e13:SetOperation(c100000914.ctops)
	c:RegisterEffect(e13)
end
function c100000914.ctops(e,tp,eg,ep,ev,re,r,rp)
		Duel.ShuffleDeck(1-tp)
	end
function c100000914.operation(e,tp,eg,ep,ev,re,r,rp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100000914.filtersf,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c100000914.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100000914.filtersf,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c100000914.spfilterm(c)
	return c:IsFaceup() and c:IsSetCard(0x75D) and c:IsType(TYPE_MONSTER)
end
function c100000914.spconm(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c100000914.spfilterm,tp,0,LOCATION_MZONE,1,nil)
end
function c100000914.condition2(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(c100000914.cfilter,1,nil,tp)
end
function c100000914.cfilter(c,tp)
	return c:IsSetCard(0x75D) and c:IsFaceup()
end
function c100000914.target2(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then return e:GetHandler():IsRelateToEffect(e) and e:GetHandler():IsFaceup() end
end
function c100000914.operation2(e,tp,eg,ep,ev,re,r,rp)
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

function c100000914.filtersf(c)
	return c:IsSetCard(0x75D) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end