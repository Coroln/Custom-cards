 --Created and coded by Rising Phoenix
function c100000729.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
		e1:SetDescription(aux.Stringid(100000729,0))
		e1:SetCondition(c100000729.condition)
	e1:SetTarget(c100000729.target)
	e1:SetOperation(c100000729.activate)
	c:RegisterEffect(e1)
	--lp
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100000729,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
		e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCountLimit(1)
	e2:SetTarget(c100000729.htg)
	e2:SetOperation(c100000729.hop)
	c:RegisterEffect(e2)	
	--act limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_SZONE)
	e4:SetOperation(c100000729.chainop)
	c:RegisterEffect(e4)
end
function c100000729.chainop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsSetCard(0x75C) then
		Duel.SetChainLimit(c100000729.chainlm)
	end
end
function c100000729.chainlm(e,rp,tp)
	return tp==rp
end
function c100000729.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x75C) and c:IsType(TYPE_MONSTER)
end
function c100000729.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c100000729.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c100000729.mfilter(c)
	return c:IsSetCard(0x75C)
end
function c100000729.synlimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x75C)
end
function c100000729.htg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,100000955,0,0x4011,500,1000,3,RACE_FAIRY,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c100000729.hop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,100000955,0,0x4011,500,1000,3,RACE_FAIRY,ATTRIBUTE_LIGHT) then return end
	local token=Duel.CreateToken(tp,100000955)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)	
		local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c100000729.synlimit)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	token:RegisterEffect(e2)
		local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetValue(c100000729.synlimit)
	e3:SetReset(RESET_EVENT+0x1fe0000)
	token:RegisterEffect(e3)
end
function c100000729.filter(c)
	return c:IsAbleToDeck() or c:IsAbleToExtra()
end
function c100000729.target(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.IsExistingMatchingCard(c100000729.filter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) end
	local g=Duel.GetMatchingGroup(c100000729.filter,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c100000729.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
		local g=Duel.GetMatchingGroup(c100000729.filter,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	local og=Duel.GetOperatedGroup()
			local ct=og:FilterCount(c100000729.filter,nil)
			if ct>0 then end
				Duel.Recover(tp,ct*100,REASON_EFFECT)
	end