--Created and scripted by Rising Phoenix
function c100000773.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100000773+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c100000773.cost)
	e1:SetTarget(c100000773.target)
	e1:SetOperation(c100000773.activate)
	c:RegisterEffect(e1)
		--damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100000773,0))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c100000773.atkcon)
		e2:SetCost(c100000773.spcost)
	e2:SetCountLimit(1,100000773+EFFECT_COUNT_CODE_OATH)
	e2:SetTarget(c100000773.damtg)
	e2:SetOperation(c100000773.damop)
	c:RegisterEffect(e2)
end
function c100000773.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1
end
function c100000773.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c100000773.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100000773.filterb,tp,LOCATION_MZONE,0,1,nil,nil) end
	local dam=Duel.GetMatchingGroupCount(c100000773.filterb,tp,LOCATION_MZONE,0,nil,nil)*800
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c100000773.damop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then end
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local d=Duel.GetMatchingGroupCount(c100000773.filterb,tp,LOCATION_MZONE,0,nil,nil)*800
	Duel.Damage(p,d,REASON_EFFECT)
		local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CHANGE_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(0,1)
	e3:SetValue(0)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e4:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e4,tp)
end
function c100000773.filterb(c)
	return c:IsSetCard(0x753) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c100000773.filter(c)
	return c:IsSetCard(0x753) and c:IsAbleToRemoveAsCost()
end
function c100000773.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100000773.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c100000773.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c100000773.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c100000773.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
