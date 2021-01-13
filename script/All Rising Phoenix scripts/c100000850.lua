function c100000850.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--hint
	local e4=Effect.CreateEffect(c)
	e4:SetHintTiming(TIMING_STANDBY_PHASE,0)
	e4:SetTarget(c100000850.tgtg1)
	e4:SetOperation(c100000850.tgop)
	c:RegisterEffect(e4)
	--tograve
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_FZONE)
		e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCountLimit(1)
	e2:SetCondition(c100000850.tgcon)
	e2:SetCost(c100000850.tgcost)
	e2:SetTarget(c100000850.tgtg2)
	e2:SetOperation(c100000850.tgop)
	c:RegisterEffect(e2)
--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x75B))
	e3:SetValue(c100000850.val)
	c:RegisterEffect(e3)
end
function c100000850.filt(c)
	return c:IsSetCard(0x75B) and not c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c100000850.val(e,c)
	return Duel.GetMatchingGroupCount(c100000850.filt,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil)*100
end
function c100000850.tgtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_STANDBY
		and Duel.IsExistingMatchingCard(c100000850.filter,tp,LOCATION_DECK,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(100000850,0)) then
		e:SetCategory(CATEGORY_TOGRAVE)
		e:GetHandler():RegisterFlagEffect(100000850,RESET_EVENT+0x1fe0000+RESET_PHASE+RESET_END,0,1)
		e:GetHandler():RegisterFlagEffect(0,RESET_CHAIN,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(100000850,1))
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	else
		e:SetCategory(0)
	end
end
function c100000850.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c100000850.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(100000850)==0 end
	e:GetHandler():RegisterFlagEffect(100000850,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c100000850.filter(c)
	return c:IsSetCard(0x75B) and not c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGrave()
end
function c100000850.tgtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100000850.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c100000850.tgop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if e:GetHandler():GetFlagEffect(100000850)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c100000850.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then end
		Duel.SendtoGrave(g,REASON_EFFECT)
end