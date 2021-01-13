--Created and scripted by Rising Phoenix
local s,id=GetID()
function s.initial_effect(c)
c:EnableUnsummonable()
	--xyz summon
	Xyz.AddProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x75A),1,2,nil,nil,5)
	c:EnableReviveLimit()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(s.atkval)
	c:RegisterEffect(e1)
	--Return to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id)
	e3:SetCost(s.cost2)
	e3:SetTarget(s.target2)
	e3:SetOperation(s.operation2)
	c:RegisterEffect(e3)
	--Destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,id)
	e4:SetCost(s.cost1)
	e4:SetTarget(s.target1)
	e4:SetOperation(s.operation1)
	c:RegisterEffect(e4)
	--Shuffle to Deck
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,3))
	e5:SetCategory(CATEGORY_TODECK)
	e5:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,id)
	e5:SetCost(s.cost3)
	e5:SetOperation(s.operation3)
	c:RegisterEffect(e5)
	--Banish
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,4))
	e6:SetCategory(CATEGORY_REMOVE)
	e6:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1,id)
	e6:SetCost(s.cost4)
	e6:SetTarget(s.target4)
	e6:SetOperation(s.operation4)
	c:RegisterEffect(e6)
end
function s.target4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function s.operation4(e,tp,eg,ep,ev,re,r,rp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,e:GetHandler())
	if g:GetCount()>0 then end
		Duel.HintSelection(g)
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
			local g=e:GetHandler():GetOverlayGroup()
		Duel.SendtoGrave(g,REASON_EFFECT)
end
function s.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,5,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,5,5,REASON_COST)
end
function s.operation3(e,tp,eg,ep,ev,re,r,rp)
		local g2=Duel.SelectMatchingCard(tp,s.filter3,tp,0,LOCATION_ONFIELD,1,1,nil)
		if g2:GetCount()>0 then Duel.SendtoDeck(g2,nil,2,REASON_EFFECT) end
			local g=e:GetHandler():GetOverlayGroup()
		Duel.SendtoGrave(g,REASON_EFFECT)
end
function s.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,4,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,4,4,REASON_COST)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
			local g=e:GetHandler():GetOverlayGroup()
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,3,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,3,3,REASON_COST)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
			local g=e:GetHandler():GetOverlayGroup()
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function s.atkval(e,c)
	return c:GetOverlayCount()*500
end