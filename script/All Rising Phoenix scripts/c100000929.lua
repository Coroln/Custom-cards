function c100000929.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
		--remove
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(100000929,2))
	e5:SetCategory(CATEGORY_DRAW)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetCountLimit(1)
	e5:SetRange(LOCATION_FZONE)
		e5:SetCost(c100000929.cost)
	e5:SetTarget(c100000929.rmtgr)
	e5:SetOperation(c100000929.rmopr)
	c:RegisterEffect(e5)
		--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetValue(c100000929.val)
	c:RegisterEffect(e3)
			--defup
	local e9=e3:Clone()
	e9:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e9)
		--damage
end
function c100000929.filterrgr(c)
	return  c:IsSetCard(0x757) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c100000929.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetLabel()
	if chk==0 then return Duel.IsExistingMatchingCard(c100000929.filterrgr,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c100000929.filterrgr,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
function c100000929.filts(c)
	return c:IsSetCard(0x757) and c:IsFaceup() and not c:IsType(TYPE_SPELL+TYPE_TRAP) 
end
function c100000929.val(e,c)
	return Duel.GetMatchingGroupCount(c100000929.filts,e:GetHandlerPlayer(),LOCATION_REMOVED,0,nil)*-100
end
function c100000929.filt(c)
	return c:IsSetCard(0x757) and not c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemove()
end
function c100000929.rmtgr(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c100000929.rmopr(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end