--Earthbound Spirit
local s,id=GetID()
function s.initial_effect(c)
	--add from outside the duel
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetCode(EVENT_FLIP)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--burn for 1000
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(s.spcon)
	e3:SetTarget(s.tg)
	e3:SetOperation(s.op)
	c:RegisterEffect(e3)
	
end
--add from outside the duel
function s.filter(c)
	return (c:IsSetCard(0x1c) or c:IsCode(CARD_DESTINY_BOARD))
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	s.announce_filter={0x1c,OPCODE_ISSETCARD,CARD_DESTINY_BOARD,OPCODE_ISCODE,OPCODE_OR}
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac=Duel.AnnounceCard(tp,table.unpack(s.announce_filter))
	local token=Duel.CreateToken(tp,ac)
	Duel.SendtoHand(token,nil,REASON_EFFECT)
end
--burn for 1000
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,31893528),tp,LOCATION_ONFIELD,0,1,nil)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end