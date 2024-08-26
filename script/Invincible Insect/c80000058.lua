--Unschlagbares Insekt Käfertyrann
function c80000058.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsRace,RACE_INSECT),12,3)
	c:EnableReviveLimit()
	--pos
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetDescription(aux.Stringid(80000058,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c80000058.cost)
	e1:SetTarget(c80000058.target)
	e1:SetOperation(c80000058.operation)
	c:RegisterEffect(e1,false,1)
	--actlimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(c80000058.aclimit)
	e2:SetCondition(c80000058.actcon)
	c:RegisterEffect(e2)
	--(5) Pierceing 
  	local e3=Effect.CreateEffect(c)
  	e3:SetType(EFFECT_TYPE_SINGLE)
  	e3:SetCode(EFFECT_PIERCE)
  	c:RegisterEffect(e3)
  	local e4=Effect.CreateEffect(c)
  	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
  	e4:SetCode(EVENT_PRE_BATTLE_DAMAGE)
  	e4:SetCondition(c80000058.damcon)
  	e4:SetOperation(c80000058.damop)
  	c:RegisterEffect(e4)
end
function c80000058.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c80000058.filter(c)
	return c:IsPosition(POS_FACEUP_ATTACK) and c:IsCanChangePosition()
end
function c80000058.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c80000058.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c80000058.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c80000058.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c80000058.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)
		tc:RegisterFlagEffect(80000058,RESET_EVENT+0x1fc0000+RESET_PHASE+PHASE_END,0,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetCondition(c80000058.flipcon)
		e1:SetOperation(c80000058.flipop)
		e1:SetLabelObject(tc)
		Duel.RegisterEffect(e1,tp)
	end
end
function c80000058.flipcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return tc:IsFacedown() and tc:GetFlagEffect(80000058)~=0
end
function c80000058.flipop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.ChangePosition(tc,POS_FACEUP_ATTACK)
end
function c80000058.aclimit(e,re,tp)
	return (re:IsHasType(EFFECT_TYPE_ACTIVATE) or re:IsActiveType(TYPE_MONSTER)) and not re:GetHandler():IsImmuneToEffect(e)
end
function c80000058.actcon(e)
	local tp=e:GetHandlerPlayer()
	local a=Duel.GetAttacker()
	return a and a:IsSetCard(0x2328) and a:IsControler(tp)
end
--(5) Pierceing
function c80000058.damcon(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  return ep~=tp and c==Duel.GetAttacker() and Duel.GetAttackTarget() and Duel.GetAttackTarget():IsDefensePos()
end
function c80000058.damop(e,tp,eg,ep,ev,re,r,rp)
  Duel.ChangeBattleDamage(ep,ev*3)
end