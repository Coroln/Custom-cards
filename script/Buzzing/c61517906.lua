--Buzzing Andre
--Coroln
local s,id=GetID()
function s.initial_effect(c)
	--Destroy 1 monster/ 1 Spell Trap
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCost(s.cost)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--counter
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetCategory(CATEGORY_COUNTER)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_XMATERIAL)
	e4:SetCode(EVENT_PHASE|PHASE_STANDBY)
	e4:SetCountLimit(1)
	e4:SetTarget(s.addct)
	e4:SetOperation(s.addc)
	c:RegisterEffect(e4)
end
s.listed_names={id,61517904}
s.counter_list={0x1BEE}
--Destroy 1 monster/ 1 Spell Trap
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil,e,tp,0)
	local b=Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_SZONE,1,nil,e,tp,1)
	local g=Duel.GetMatchingGroup(s.costfilter,tp,LOCATION_ONFIELD,0,nil,tp)
	if chk==0 then return a or b end
	if #g==0 then
		e:SetLabel(0)
	else
		if b and g:GetFirst():IsCanRemoveCounter(tp,0x1BEE,1,REASON_COST) then
			if Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
				if #g==1 then
					g:GetFirst():RemoveCounter(tp,0x1BEE,1,REASON_COST)
					e:SetLabel(1)
				else
					local ct=0
					while ct<1 do
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
						local tc=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_ONFIELD,0,1,1,nil,tp):GetFirst()
						tc:RemoveCounter(tp,0x1BEE,1,REASON_COST)
						ct=ct+1
					end
					e:SetLabel(1)
				end
			end
		else
			e:SetLabel(0)
		end
	end
end
function s.costfilter(c)
	return c:IsCode(61517904)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,tp,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
	if e:GetLabel()==1 and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_SZONE,1,nil) then
		local gg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_SZONE,1,1,nil)
		if #gg>0 then
			Duel.HintSelection(gg)
			Duel.Destroy(gg,REASON_EFFECT)
		end
	end
end
--counter
function s.addct(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x1BEE)
end
function s.addc(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_SZONE,0,1,nil,e,tp,1) then
		local tc=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_SZONE,0,1,1,nil):GetFirst()
		tc:AddCounter(0x1BEE,1)
	end
end