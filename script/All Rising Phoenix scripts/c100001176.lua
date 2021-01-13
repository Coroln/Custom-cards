--created and scripted by rising phoenix
function c100001176.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
		e1:SetRange(LOCATION_REMOVED)
		e1:SetTargetRange(0x7f,0x7f)
	e1:SetTarget(c100001176.target)
	e1:SetOperation(c100001176.activate)
	c:RegisterEffect(e1)
		--immune
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_REMOVED)
	e4:SetValue(c100001176.efilter)
	c:RegisterEffect(e4)
			--act
	local e10=Effect.CreateEffect(c)
	e10:SetOperation(c100001176.actb)
	e10:SetCost(c100001176.descost)
	e10:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e10:SetCode(EVENT_PREDRAW)
	e10:SetRange(LOCATION_DECK)
	e10:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	c:RegisterEffect(e10)
	--acthand
	local e20=Effect.CreateEffect(c)
	e20:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e20:SetRange(LOCATION_HAND)
	e20:SetCode(EVENT_DRAW)
	e20:SetOperation(c100001176.actb)
	e20:SetCost(c100001176.descost)
	e20:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	c:RegisterEffect(e20)
	--actgrave
	local e30=Effect.CreateEffect(c)
	e30:SetOperation(c100001176.actb)
	e30:SetCost(c100001176.descost)
	e30:SetRange(LOCATION_GRAVE)
	e30:SetCode(EVENT_DRAW)
	e30:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e30:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	c:RegisterEffect(e30)
end
function c100001176.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c100001176.actb(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
function c100001176.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,100001176)==0 end
	Duel.RegisterFlagEffect(tp,100001176,0,0,0)
end
function c100001176.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,564)
	local ac=Duel.AnnounceCard(tp)
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,ANNOUNCE_CARD)
end
function c100001176.activate(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
		local token=Duel.CreateToken(tp,ac)
		Duel.SendtoHand(token,nil,1,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,token)
	end
