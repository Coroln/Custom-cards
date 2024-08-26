--Mechasect - Toxic Beetle
function c53790622.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--damage after destroying
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(53790622,0))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCondition(aux.bdocon)
	e2:SetTarget(c53790622.damtg1)
	e2:SetOperation(c53790622.damop1)
	c:RegisterEffect(e2)
	--damage after destruction
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(53790622,1))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCountLimit(1,53790622)
	e3:SetCondition(c53790622.damcon2)
	e3:SetTarget(c53790622.damtg2)
	e3:SetOperation(c53790622.damop2)
	c:RegisterEffect(e3)
	--add code
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EFFECT_ADD_CODE)
	e4:SetValue(53790620)
	c:RegisterEffect(e4)
end
function c53790622.damtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function c53790622.damop1(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function c53790622.damcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (c:IsReason(REASON_BATTLE) or (c:GetReasonPlayer()~=tp and c:IsReason(REASON_EFFECT)))
		and c:IsPreviousPosition(POS_FACEUP)
end
function c53790622.damfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x586)
end
function c53790622.damtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local gc=Duel.GetMatchingGroupCount(c53790622.damfilter,tp,LOCATION_GRAVE,0,nil)
	if chk==0 then return gc>0 end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,gc*700)
end
function c53790622.damop2(e,tp,eg,ep,ev,re,r,rp)
	local gc=Duel.GetMatchingGroupCount(c53790622.damfilter,tp,LOCATION_GRAVE,0,nil)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Damage(p,gc*700,REASON_EFFECT)
end
