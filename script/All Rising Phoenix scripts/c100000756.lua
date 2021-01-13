--gate
function c100000756.initial_effect(c)
c:SetUniqueOnField(1,0,100000756)
	--Special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100000756,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetTarget(c100000756.sptg)
	e1:SetOperation(c100000756.spop)
	c:RegisterEffect(e1)
	--seother
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100000756,1))
		e2:SetCountLimit(1,100000756)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCondition(c100000756.remcon)
	e2:SetTarget(c100000756.remtg)
	e2:SetOperation(c100000756.remop)
	c:RegisterEffect(e2)
	--remove grave
	local e3=Effect.CreateEffect(c)
		e3:SetCountLimit(1,100000756)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetDescription(aux.Stringid(100000756,2))
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(c100000756.operationg)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetOperation(c100000756.regop)
	c:RegisterEffect(e4)
	--dam
		local e21=Effect.CreateEffect(c)
	e21:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e21:SetDescription(aux.Stringid(100000756,1))
	e21:SetCategory(CATEGORY_DAMAGE)
	e21:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e21:SetRange(LOCATION_MZONE)
	e21:SetCountLimit(1)
	e21:SetCondition(c100000756.damcon7)
	e21:SetTarget(c100000756.damtg7)
	e21:SetOperation(c100000756.damop7)
	c:RegisterEffect(e21)
end
function c100000756.damcon7(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c100000756.damtg7(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(800)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,tp,800)
end
function c100000756.damop7(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function c100000756.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(100000756)~=0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0)
end
function c100000756.spop(e,tp,eg,ep,ev,re,r,rp)
		if e:GetHandler():IsRelateToEffect(e) then end
		Duel.Remove(e:GetHandler(),nil,nil,REASON_EFFECT)
end
function c100000756.remcon(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
	return bit.band(r,REASON_EFFECT) and re:GetHandler():IsSetCard(0x753)
end
function c100000756.remtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100000756.filter,tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_HAND)
end
function c100000756.filter(c)
	return c:IsCode(100000868) and c:IsAbleToRemove()
end
function c100000756.remop(e,tp,eg,ep,ev,re,r,rp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100000756.filter,tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function c100000756.regop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsFaceup() then
		e:GetHandler():RegisterFlagEffect(100000756,RESET_EVENT+0x1fe0000,0,1)
	end
end
function c100000756.targetg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) end
	local sg=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c100000756.operationg(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
		e1:SetValue(4)
		c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CHANGE_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	e2:SetValue(0)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
	end