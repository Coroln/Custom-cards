--D.D. Demonic Beast
--Script by Coroln
Duel.LoadScript ("customutility2.lua")
local s,id=GetID()
function s.initial_effect(c)
    --Drop off
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_HANDES)
	e1:SetCode(EVENT_TO_HAND)
    e1:SetRange(LOCATION_GRAVE|LOCATION_HAND|LOCATION_MZONE)
    e1:SetCountLimit(1,id)
	e1:SetCondition(s.condition)
    e1:SetCost(s.combined_costs(s.spcost,aux.bfgcost))
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.cfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,1-tp)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
end
function s.filter(c,e,tp)
	return c:IsRelateToEffect(e) and c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=eg:Filter(s.filter,nil,e,1-tp)
	if #sg==0 then
	elseif #sg==1 then
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
        Duel.Damage(1-tp,200,REASON_EFFECT)
        Duel.Damage(tp,200,REASON_EFFECT)
	else
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
		local dg=sg:Select(1-tp,1,1,nil)
		Duel.Remove(dg,POS_FACEUP,REASON_EFFECT)
        Duel.Damage(1-tp,200,REASON_EFFECT)
        Duel.Damage(tp,200,REASON_EFFECT)
	end
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(id,tp,ACTIVITY_CHAIN)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetDescription(aux.Stringid(id,2))
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(s.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.aclimit(e,re,tp)
	return not re:GetHandler():IsDD()
end
function s.combined_costs(cost1,cost2)
	return	function(...)
			local b1,b2=cost1(...),cost2(...)
			return b1 and b2
		end
end