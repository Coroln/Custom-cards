--Created and scripted by Rising Phoenix
function c100000769.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(aux.FALSE)
	c:RegisterEffect(e2)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100000769,0))
	e1:SetCategory(CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetTarget(c100000769.destg)
	e1:SetOperation(c100000769.desop)
	c:RegisterEffect(e1)
		--spsummon success
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c100000769.sop)
	c:RegisterEffect(e8)
		--seother
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100000769,0))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetTarget(c100000769.remtg)
	e2:SetOperation(c100000769.remop)
	c:RegisterEffect(e2)
end
function c100000769.remtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100000769.filter1,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
end
function c100000769.filter(c)
	return c:IsSetCard(0x759) and c:IsAbleToDeck()
end
function c100000769.remop(e,tp,eg,ep,ev,re,r,rp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATODECK)
	local g=Duel.SelectMatchingCard(tp,c100000769.filter1,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c100000769.sop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,0,e:GetHandler())
	Duel.SendtoGrave(g,REASON_EFFECT)
end
function c100000769.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
end
function c100000769.desop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetFieldGroup(p,0,LOCATION_HAND)
	if g:GetCount()>0 then
		Duel.ConfirmCards(p,g)
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_DISCARD)
		local sg=g:Select(p,1,1,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
		Duel.ShuffleHand(1-p)
	end
end