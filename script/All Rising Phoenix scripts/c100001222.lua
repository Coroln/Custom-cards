--Created and scripted by Rising Phoenix
function c100001222.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--extra summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e2:SetTarget(c100001222.extg)
	c:RegisterEffect(e2)
		--code
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_CHANGE_CODE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetValue(56433456)
	c:RegisterEffect(e3)
		--to hand
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(100001222,0))
	e11:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e11:SetType(EFFECT_TYPE_IGNITION)
	e11:SetRange(LOCATION_FZONE)
	e11:SetCountLimit(1)
	e11:SetTarget(c100001222.thtg)
	e11:SetOperation(c100001222.thop)
	e11:SetCondition(c100001222.spcon)
	c:RegisterEffect(e11)
		--avoid battle damage
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_FIELD)
	e13:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e13:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e13:SetRange(LOCATION_FZONE)
	e13:SetTargetRange(LOCATION_MZONE,0)
	e13:SetTarget(c100001222.extg)
	e13:SetCondition(c100001222.con)
	e13:SetValue(1)
	c:RegisterEffect(e13)
		--no damage
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CHANGE_DAMAGE)
	e5:SetRange(LOCATION_FZONE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTargetRange(1,0)
	e5:SetCondition(c100001222.con)
	e5:SetValue(c100001222.damval)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	c:RegisterEffect(e6)
		--indes
	local e21=Effect.CreateEffect(c)
	e21:SetType(EFFECT_TYPE_FIELD)
	e21:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e21:SetRange(LOCATION_FZONE)
	e21:SetTargetRange(LOCATION_MZONE,0)
	e21:SetTarget(c100001222.indtg)
	e21:SetValue(1)
	e21:SetCondition(c100001222.con)
	c:RegisterEffect(e21)
	local e22=e21:Clone()
	e22:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e22)
end
function c100001222.filter22(c)
	return c:IsFaceup() and c:IsCode(56433456)
end
function c100001222.con(e)
	return Duel.IsExistingMatchingCard(c100001222.filter22,e:GetHandler():GetControler(),LOCATION_GRAVE,0,1,nil)
end
function c100001222.indtg(e,c)
	return c:IsRace(RACE_FAIRY) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsLevelBelow(4)
end
function c100001222.damval(e,re,val,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 and rp~=e:GetOwnerPlayer() then return 0 else return val end
end
function c100001222.extg(e,c)
	return c:IsRace(RACE_FAIRY) and c:IsAttribute(ATTRIBUTE_LIGHT) 
end
function c100001222.cfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_FAIRY) and c:IsAttribute(ATTRIBUTE_LIGHT) 
end
function c100001222.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c100001222.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c100001222.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>2 end
end
function c100001222.thfilter(c)
	return (c:IsRace(RACE_FAIRY) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsAbleToHand()) or (c:IsType(TYPE_COUNTER) and c:IsAbleToHand())
end
function c100001222.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<3 then return end
	Duel.ConfirmDecktop(tp,3)
	local g=Duel.GetDecktopGroup(tp,3)
	if g:IsExists(c100001222.thfilter,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:FilterSelect(tp,c100001222.thfilter,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
		Duel.ShuffleHand(tp)
	end
	Duel.ShuffleDeck(tp)
end