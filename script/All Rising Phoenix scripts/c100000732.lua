--Hellcreature quickplay
function c100000732.initial_effect(c)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100000732,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
		e1:SetCondition(c100000732.condition)
	e1:SetTarget(c100000732.target1)
	e1:SetOperation(c100000732.activate1)
	c:RegisterEffect(e1)
		--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetValue(c100000732.val)
	c:RegisterEffect(e3)
end
function c100000732.sfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x75B) and c:IsType(TYPE_MONSTER)
end
function c100000732.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c100000732.sfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c100000732.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_DECK)
		if chk==0 then return Duel.IsExistingMatchingCard(c100000732.filter,tp,0,LOCATION_MZONE,1,nil) end
end
function c100000732.activate1(e,tp,eg,ep,ev,re,r,rp,chk)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local ct1=Duel.GetMatchingGroupCount(c100000732.sfilter,tp,LOCATION_MZONE,0,nil)
	local ct2=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)
	if ct1>ct2 then ct1=ct2 end
	if ct1==0 then return end
	local t={}
	for i=1,ct1 do t[i]=i end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(100000732,2))
	local ac=Duel.AnnounceNumber(tp,table.unpack(t))
	local g=Duel.GetDecktopGroup(1-tp,ac)
	Duel.DisableShuffleCheck()
	Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	end
function c100000732.filt(c)
	return c:IsSetCard(0x75B) and c:IsFaceup() and not c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c100000732.val(e,c)
	return Duel.GetMatchingGroupCount(c100000732.filt,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil)*-200
end