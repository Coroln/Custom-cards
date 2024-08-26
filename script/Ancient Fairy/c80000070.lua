--Antike Fee, Athena
function c80000070.initial_effect(c)
	--special summon (1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c80000070.spcon)
	c:RegisterEffect(e1)
	--recover (2)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(80000070,0))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTarget(c80000070.rectg)
	e2:SetOperation(c80000070.recop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--send to grave (3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(80000070,0))
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCost(c80000070.cost)
	e4:SetTarget(c80000070.target)
	e4:SetOperation(c80000070.operation)
	c:RegisterEffect(e4)
end
--(1)
function c80000070.cfilter(tc)
	return tc and tc:IsFaceup()
end
function c80000070.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and (c80000070.cfilter(Duel.GetFieldCard(tp,LOCATION_SZONE,5)) or c80000070.cfilter(Duel.GetFieldCard(1-tp,LOCATION_SZONE,5)))
end
--(2)
function c80000070.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local val=Duel.GetMatchingGroupCount(Card.IsRace,tp,LOCATION_GRAVE,0,nil,RACE_FAIRY)*500
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(val)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,val)
end
function c80000070.recop(e,tp,eg,ep,ev,re,r,rp)
	local val=Duel.GetMatchingGroupCount(Card.IsRace,tp,LOCATION_GRAVE,0,nil,RACE_FAIRY)*500
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Recover(p,val,REASON_EFFECT)
end
--(3)
function c80000070.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x2c9d) and c:IsAbleToGraveAsCost()
end
function c80000070.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80000070.filter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c80000070.filter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c80000070.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() and chkc:IsAbleToGrave() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function c80000070.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.SendtoGrave(g,REASON_EFFECT)
end
