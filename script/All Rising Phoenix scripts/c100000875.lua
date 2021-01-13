	--energy
function c100000875.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x753))
	e3:SetValue(c100000875.val)
	c:RegisterEffect(e3)
			--defup
	local e9=e3:Clone()
	e9:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e9)
		--damage
	local e10=Effect.CreateEffect(c)
	e10:SetHintTiming(TIMING_STANDBY_PHASE,0)
	e10:SetDescription(aux.Stringid(100000875,0))
	e10:SetCategory(CATEGORY_RECOVER)
	e10:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e10:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e10:SetRange(LOCATION_FZONE)
	e10:SetCountLimit(1)
	e10:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e10:SetCondition(c100000875.damconr)
	e10:SetTarget(c100000875.damtgr)
	e10:SetOperation(c100000875.damopr)
	c:RegisterEffect(e10)
end
function c100000875.filt(c)
	return c:IsSetCard(0x753) and not c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsFaceup()
end
function c100000875.val(e,c)
	return Duel.GetMatchingGroupCount(c100000875.filt,e:GetHandlerPlayer(),LOCATION_REMOVED,0,nil)*100
end
function c100000875.damconr(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function c100000875.damtgr(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,0)
end
function c100000875.damopr(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local d=Duel.GetMatchingGroupCount(c100000875.filt,tp,LOCATION_REMOVED,0,nil)*300
	Duel.Recover(p,d,REASON_EFFECT)
end