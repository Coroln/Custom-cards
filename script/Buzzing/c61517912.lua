--Stinger Attack!
--Coroln
local s,id=GetID()
function s.initial_effect(c)
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(s.cost)
	e1:SetTarget(s.damtg)
	e1:SetOperation(s.damop)
	c:RegisterEffect(e1)
	--more damage 100
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(aux.exccon)
	e2:SetCost(Cost.SelfBanish)
	e2:SetTarget(s.destg)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
end
s.listed_names={id,61517904}
s.counter_list={0x1BEE}
--damage
function s.tfilter(c)
	return c:IsRace(RACE_INSECT) and c:IsReleasable()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,e,tp,0)
	local b=Duel.IsExistingMatchingCard(s.tfilter,tp,LOCATION_MZONE,0,1,nil,e,tp,1)
	if chk==0 then return a or b end
	if b then
		if Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
			local g=Duel.SelectReleaseGroupCost(tp,s.tfilter,1,1,false,nil,nil,tp)
			monster=g:GetFirst()
			local atk=monster:GetAttack()
			e:SetLabel(atk)
			e:SetLabelObject(monster)
			Duel.Release(g,REASON_COST)
		end
	end
end
function s.filter(c)
	return c:GetCounter(0x1BEE)>0
end
function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local tc=g:GetFirst()
	local s=0
	while tc do
		local ct=tc:GetCounter(0x1BEE)
		s=s+ct
		tc:RemoveCounter(tp,0x1BEE,ct,REASON_COST)
		tc=g:GetNext()
	end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(s*400)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,s*400)
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
	if e:GetLabelObject() then
		local damage=e:GetLabel()/2
		Duel.Damage(p,damage,REASON_EFFECT)
	end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CHANGE_DAMAGE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e1:SetDescription(aux.Stringid(id,1))
		e1:SetTargetRange(0,1)
		e1:SetValue(s.val)
		e1:SetReset(RESET_PHASE|PHASE_END,1)
		Duel.RegisterEffect(e1,tp)
	end
end
function s.val(e,re,val,r,rp,rc)
	return math.floor(val/2)
end
--more damage 100
function s.desfilter(c)
	return c:IsFaceup() and c:IsCode(61517904) and c:GetCounter(0x1BEE)>0
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and s.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.desfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,s.desfilter,tp,LOCATION_ONFIELD,0,1,1,nil):GetFirst()
	local dam=g:GetCounter(0x1BEE)*100
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end