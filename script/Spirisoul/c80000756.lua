--Spirisoul Vampire, Spirit Hunter
--Script by Coroln
local s,id=GetID()
function s.initial_effect(c)
	--Must be properly summoned before reviving
	c:EnableReviveLimit()
	--Synchro summon procedure
	Synchro.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsRace,RACE_ZOMBIE),1,1,Synchro.NonTuner(s.sfilter),1,99)
    --destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
    --draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_START)
    --e2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.dcon)
	e2:SetCost(s.dcost)
	e2:SetTarget(s.dtg)
	e2:SetOperation(s.dop)
	c:RegisterEffect(e2)
end
--synchro
function s.sfilter(c)
    return (c:IsSetCard(0x356) or c:IsSetCard(SET_VAMPIRE))
end
--destroy
function s.filter(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP)
		and c:IsType(TYPE_SPIRIT)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.filter,1,nil,tp) and e:GetHandler():IsStatus(STATUS_EFFECT_ENABLED)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
    local ct=eg:FilterCount(s.filter,nil,LOCATION_ONFIELD)
    local ct=Duel.GetTargetCards(e)
	if not e:GetHandler():IsRelateToEffect(e) then return end
		Duel.Destroy(ct,REASON_EFFECT)
end
--draw
function s.dcon(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetAttackTarget()
	return d and d:IsControler(tp) and d:IsFaceup() and d:IsType(TYPE_SPIRIT)
end
function s.dcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local d=Duel.GetAttackTarget()
	if chk==0 then return d:IsDestructable() end
	Duel.Destroy(d,REASON_COST)
end
function s.dtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.dop(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end