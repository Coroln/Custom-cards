--osiris
local s,id=GetID()
function s.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x758),4,2)
	c:EnableReviveLimit()
	--remove field
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(s.cost)
	e1:SetTarget(s.targetf)
	e1:SetOperation(s.operationf)
	c:RegisterEffect(e1)
	--remove hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(s.cost)
	e2:SetTarget(s.targeth)
	e2:SetOperation(s.operationh)
	c:RegisterEffect(e2)
	--remove hand
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(s.cost)
	e3:SetTarget(s.targetg)
	e3:SetOperation(s.operationg)
	c:RegisterEffect(e3)
	--recover
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_RECOVER)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCondition(s.conditiongr)
	e4:SetTarget(s.targetgr)
	e4:SetOperation(s.operationgr)
	c:RegisterEffect(e4)
	--no damage
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_CHANGE_DAMAGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e7:SetTargetRange(1,0)
	e7:SetValue(s.damval)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	c:RegisterEffect(e8)
end
function s.targetf(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.IsExistingMatchingCard(s.filter3,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(s.filter3,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function s.filter3(c)
	return c:IsAbleToRemove()
end
function s.operationf(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.filter3,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then end
		Duel.HintSelection(g)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
function s.targeth(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,1-tp,LOCATION_HAND)
end
function s.operationh(e,tp,eg,ep,ev,re,r,rp)
		local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetFieldGroup(p,0,LOCATION_HAND)
	if g:GetCount()>0 then end
		Duel.ConfirmCards(p,g)
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_REMOVE)
		local sg=g:Select(p,1,1,nil)
		Duel.Remove(sg,POS_FACEUP,2,REASON_EFFECT)
		Duel.ShuffleHand(1-p)
end
function s.targetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:GetControler()~=tp and chkc:IsLocation(LOCATION_GRAVE) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function s.operationg(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then end
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,2000) and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) and e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
	Duel.PayLPCost(tp,2000)
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function s.targetgr(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
end
function s.operationgr(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
function s.conditiongr(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsReason(REASON_RETURN)
end
function s.damval(e,re,val,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 and rp~=e:GetOwnerPlayer() then return 0 else return val end
	end